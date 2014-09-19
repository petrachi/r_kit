class Array

  def include_all? values
    (self & Array(values)).size == Array(values).size
  end

end
