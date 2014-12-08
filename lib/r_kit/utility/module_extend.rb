class Module

  delegate :deconstantize, :demodulize, :tableize, :underscore,
    to: :name

  def namespace
    (deconstantize.presence || 'Object').constantize
  end



  override_method :attr_reader do |*names, default: nil|
    if default
      names.each do |name|
        define_method name do
          instance_variable_get("@#{ name }") ||
            instance_variable_set("@#{ name }", default.is_a?(Proc) ? default.call(self, name) : default)
        end
      end
    else
      __olddef__ *names
    end
  end

  override_method :attr_accessor do |*names, default: nil|
    if default
      attr_writer *names
      attr_reader *names, default: default
    else
      __olddef__ *names
    end
  end


  # TODO: these writter are called like ".name(value)" to set and return self
  # or like ".name" to read
  # TODO: to be used in 'pagination', these need an "after" callback (to set @limited_collection to nil)
  # TODO: and to be used in 'grid (base.rb, binding_accessor)', these need an "to" delegation object
  def tap_attr_accessor *names, typecast: nil
    names.each do |name|
      define_method name, ->(value = Nothing) do
        if value.thing?
          value = value.send typecast if typecast
          instance_variable_set "@#{ name }", value
          self
        else
          instance_variable_get "@#{ name }"
        end
      end
    end
  end


  def singleton_attr_reader *args, **options
    singleton_class.send :attr_reader, *args, **options
  end

  override_method :const_get do |name, *args, default: nil|
    if default && !const_defined?(name)
      name.safe_constantize ||
        const_set(name, default)
    else
      __olddef__ name, *args
    end
  end

  def const_replace name, value
    remove_const name
    const_set name, value
  end
end
