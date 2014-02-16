class Object
  core_extend :__class__ do
    self.class
  end
  
  # should be able to use the method from "super"
  #core_extend :super_method do |method_name|
  #  __class__.superclass.instance_method(method_name).bind(self).call
  #end
  # no working in prod context (seriable decarator, :title method)
  
  core_extend :to_boolean do
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean self
  end
end
