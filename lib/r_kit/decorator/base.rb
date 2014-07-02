require 'delegate'

class RKit::Decorator::Base < SimpleDelegator
  alias :_obj :__getobj__

  def initialize obj, view_context: nil
    @_view_context = view_context
    super obj
  end


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
