class RKit::Decorator::Base < SimpleDelegator
  def initialize base, view_context
    @view_context = view_context
    
    super(base)
  end

  def _h
    @view_context
  end
  
  def === object
    self == object || __getobj__ == object
  end
end
