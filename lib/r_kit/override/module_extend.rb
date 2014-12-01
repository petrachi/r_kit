class Module

  protected def override_method method_name, method: nil, pattern: :standard, pattern_args: [], &block

    RKit::Override::Base.override method_name,
      method: (method || block),
      pattern: pattern,
      pattern_args: pattern_args,
      receiver: self

  end

  protected def override_methods **options, &block

    carrier = Module.new(&block)

    carrier.instance_methods(false).each do |method_name|
      override_method method_name, method: carrier.instance_method(method_name), **options
    end

    carrier.methods(false).each do |method_name|
      singleton_carrier ||= Module.new{ include refine(carrier.singleton_class){} }
      override_singleton_method method_name, method: singleton_carrier.instance_method(method_name), **options
    end
  end



  protected def override_singleton_method *args, &block
    singleton_class.override_method *args, &block
  end

  protected def override_singleton_methods *args, &block
    singleton_class.override_methods *args, &block
  end



  protected def depend *args, strict: true, **options, &block
    override_methods pattern: (strict && :depend || :if), pattern_args: (args << options), &block
  end



  protected def simple_override_method method_name, &block
    instance_method(method_name).simple_override receiver: self, &block
  end

  protected def simple_override_singleton_method method_name, &block
    method(method_name).simple_override &block
  end

end
