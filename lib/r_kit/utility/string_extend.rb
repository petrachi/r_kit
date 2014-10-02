class String

  def to_boolean
    !!(self =~ /^(true|t|yes|y|1)$/i)
  end


  def ivar
    "@#{ self }"
  end

end
