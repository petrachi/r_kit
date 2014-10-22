class Module

  def override_method method_name, &block
    instance_method(method_name).override receiver: self, &block
  end

  def override_singleton_method method_name, &block
    method(method_name).override &block
  end

end
