module RKit::Decoration::Base

  def initialize object, view_context: nil
    @view_context = view_context
    super object
  end

  alias :decorator_class :class
  delegate :class, to: :__getobj__


  def decorate *args
    self
  end

  def decorated?() true end

  def raw
    __getobj__
  end


  private def view_context
    backtrace{ |obj| obj.is_a? ActionView::Base } || backtrace{ |obj| obj.respond_to? :view_context }.view_context
  end

  def view
    @view_context ||= view_context
  end

end
