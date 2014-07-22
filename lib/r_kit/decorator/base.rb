require 'delegate'

class RKit::Decorator::Base < SimpleDelegator
  def self.decorator_name
    name.demodulize.sub(/Decorator$/, '').underscore
  end

  def self.inherited subclass
    subclass.class_eval do
      alias :"#{ decorator_name }" :__getobj__
    end
  end


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
