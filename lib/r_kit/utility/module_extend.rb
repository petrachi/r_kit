class Module

  delegate :underscore, :demodulize,
    to: :name


  alias :basic_attr_reader :attr_reader
  def attr_reader *names, default: nil
    if default_proc || default
      names.each do |name|
        define_method name do
          instance_variable_get("@#{ name }") ||
            instance_variable_set("@#{ name }", default.is_a?(Proc) ? default.call(self, name) : default)
        end
      end
    else
      basic_attr_reader *names
    end
  end


  # TODO: these writter are called like ".name(value)" to set and return self
  # or like ".name" to read
  # TODO: to be used in 'pagination', these need an "after" callback (to set @limited_collection to nil)
  # TODO: and to be used in 'grid (base.rb, binding_accessor)', these need an "to" delegation object
  def tap_attr_accessor *names
    names.each do |name|
      define_method name, ->(value = nil) do
        if value
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
end
