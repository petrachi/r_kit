class SimpleDelegator

  # TODO: get some methods from decorator, like "class", "==="
  # TODO: and add some custom like "inspect"

  def self.getobj_attr_reader *names
    names.each do |name|
      define_method name, ->(){ __getobj__.instance_variable_get(name.ivar) }
    end
  end

end
