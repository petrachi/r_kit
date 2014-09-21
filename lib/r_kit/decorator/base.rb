require 'delegate'

class RKit::Decorator::Base < SimpleDelegator

  singleton_attr_reader :decorated_klass
  singleton_attr_reader :after_initialize_procs, default_proc: proc{ [] }

  def self.after_initialize &block
    after_initialize_procs << block
  end

  def initialize obj, view_context: nil
    @_view_context = view_context
    super obj

    decorator_klass.after_initialize_procs.each{ |after_initialize_proc| self.instance_eval &after_initialize_proc }
  end

  alias :decorator_klass :class
  delegate :class, to: :__getobj__


  def _view_context
    backtrace{ |obj| obj.is_a? ActionView::Base } || backtrace{ |obj| obj.respond_to? :view_context }.view_context
  end

  def view
    @_view_context ||= _view_context
  end


  def === object
    self == object || __getobj__ == object
  end
end
