module RKit
  module Decorable
    def decorate(view_context)
      @view_context = view_context
    
      class << self 
        include DecoratorMethods
      end
    
      self
    end
  
    def h
      @view_context
    end
  end
  
  module DecorableHelper
    def decorate obj, &block
      capture do
        block.call obj.decorate(self)
      end
    end
  end
  
end
