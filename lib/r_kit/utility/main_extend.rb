NothingClass = Class.new do
  include Singleton

  def thing?
    false
  end

  def nothing?
    true
  end

  def method_missing *args
    self
  end
end

Nothing = NothingClass.instance


def Nothing(value)
  value || Nothing
end
