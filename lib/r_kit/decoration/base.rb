module RKit::Decoration::Base

  def self.included base
    base.singleton_attr_reader :decorated_class
    base.singleton_attr_reader :after_initialize_procs, default: proc{ [] }

    base.define_singleton_method :after_initialize, ->(&block) do
      after_initialize_procs << block
    end
  end


  def initialize object, view_context: nil
    @view_context = view_context

    super(object)
    after_initialize!
  end

  def after_initialize!
    decorated = self
    __getobj__.define_singleton_method(:decorated){ decorated }

    decorator_class.after_initialize_procs.each{ |after_initialize_proc| self.instance_eval &after_initialize_proc }
  end


  alias :decorator_class :class
  delegate :class, to: :__getobj__


  def decorate *args
    self
  end

  def decorated?() true end

  def need_decoration?() false end

  def raw
    __getobj__
  end


  private def view_context
    backtrace{ |obj| obj.is_a? ActionView::Base } || backtrace{ |obj| obj.respond_to? :view_context }.view_context
  end

  def view
    (@@mutex ||= Mutex.new).synchronize do
      @view_context ||= view_context
    end
  rescue ThreadError
    nil
  end


  def method_missing method_name, *args, &block
    closure = super

    if RKit::Decoration.config.recursive_decoration && closure.need_decoration?
      closure.decorate(view_context: view)
    else
      closure
    end
  end

end
