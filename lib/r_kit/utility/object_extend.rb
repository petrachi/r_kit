class Object

  # TODO: I do not know is this is a good idea or a terrible idea
  # But in either cases, the method names are probably bad, cause too generic (I know it's the hole point)
  # And may collapse with subclasses

  # TODO: And btw, it is not even used in rkit, as it doens not fullfiled our needs

  # TODO: return self if statement (or block), else, return "value"
  def fetch statement = nil, value = nil, &block
    state(statement, &block) ? self : value
  end

  def reverse_fetch statement = nil, value = nil, &block
    !state(statement, &block) ? self : value
  end

  def state statement = nil, &block
    if statement
      case self
      when statement
        true
      else
        false
      end
    elsif block_given?
      !!block.call(self)
    else
      raise ArgumentError, 'Must send either "statement" or "&block" argument.'
    end
  end

end
