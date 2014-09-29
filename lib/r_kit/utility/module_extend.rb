class Module

  delegate :underscore, :demodulize,
    to: :name


  alias :basic_attr_reader :attr_reader
  def attr_reader *instance_variables_names, default_proc: nil, default: nil
    if default_proc || default
      instance_variables_names.each do |instance_variable_name|
        define_method instance_variable_name do
          instance_variable_get("@#{ instance_variable_name }") ||
            instance_variable_set("@#{ instance_variable_name }", default_proc.try(:call, self) || default)
        end
      end
    else
      basic_attr_reader *instance_variables_names
    end
  end


  # TODO: these writter are called like ".name(value)" to set and return self
  # or like ".name" to read
  # TODO: to be used in 'pagination', these need an "after" callback (to set @limited_collection to nil)
  # TODO: and to be used in 'grid (base.rb, binding_accessor)', these need an "to" delegation object
  def tap_attr_accessor *instance_variables_names
    instance_variables_names.each do |instance_variable_name|
      define_method instance_variable_name, ->(value = nil) do
        if value
          instance_variable_set "@#{ instance_variable_name }", value
          self
        else
          instance_variable_get "@#{ instance_variable_name }"
        end
      end
    end
  end


  def singleton_attr_reader *args, **options
    singleton_class.send :attr_reader, *args, **options
  end
end
