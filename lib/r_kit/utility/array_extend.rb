class Array

  def include_all? values
    (self & Array(values)).size == Array(values).size
  end

  def include_one? values
    (self & Array(values)).size > 0
  end

end
