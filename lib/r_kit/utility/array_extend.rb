class Array

  def include_all? values
    (self & Array(values)).size == size
  end

end
