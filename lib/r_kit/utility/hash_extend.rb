class Hash

  # TODO: for doc - this is usefull to fill an hash wich have a default proc
  def keys= keys
    Array(keys).each &method(:[])
  end

end
