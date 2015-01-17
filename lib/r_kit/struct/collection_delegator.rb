class CollectionDelegator < SimpleDelegator

  alias :collection :__getobj__
  alias :collection= :__setobj__

  def method_missing method_name, *args, &block
    closure = super

    case closure
    when collection.class
      self.collection = closure
      self
    else
      closure
    end
  end

end
