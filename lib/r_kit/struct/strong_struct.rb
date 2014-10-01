class StrongStruct < SafeStruct

  def self.new allowed:, defaults: {}
    super.tap do |klass|

      klass.send :define_method, :instance_variable_set, ->(name, value) do
        if __class__.allowed.include? name
          super(name, value)
        else
          raise NameError.new("unsafe key `#{ name }' for #{ __class__ }")
        end
      end

    end
  end

end
