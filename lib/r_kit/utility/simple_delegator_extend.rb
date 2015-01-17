class SimpleDelegator

  # TODO: add delegation for "inspect" to getobj

  # TODO: allow singleton methods to be delegated (note, can not override them)
  # TODO: by defining a method missing on singleton_class
  # TODO: or better (?), defining a delegator for the singleton_class


  def self.getobj_attr_reader *names
    names.each do |name|
      define_method name, ->(){ __getobj__.instance_variable_get(name.ivar) }
    end
  end


  def === object
    self == object || __getobj__ == object || __getobj__ == object.try(:__getobj__)
  end

end
