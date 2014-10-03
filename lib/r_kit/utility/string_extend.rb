class String

  def to_boolean
    !!(self =~ /^(true|t|yes|y|1)$/i)
  end


  def ivar
    "@#{ self }"
  end

  def lvar
    if self =~ /^@/
      self[1..-1]
    else
      self
    end
  end

end
