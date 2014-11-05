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


  # TODO: including ennumerable could cause some method to not be delegated, because they are defined in ennumerable
  # we want to prevent that behavior
  include Enumerable

  def each &block
    collection.each &block
  end
end
