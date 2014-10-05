class RKit::Dsl::Base
  module Thrust

    protected def thrust_dsl!
      readonly = self.readonly
      name = @name

      @domain.send :define_singleton_method, @name do
        (instance_variable_get(name.ivar) ||
          instance_variable_set(name.ivar, readonly))
            .tap{ |readonly| readonly.base = self }
      end
    end

    protected def thrust_dsl_interface!
      name = @name

      @domain.send :define_singleton_method, "can_#{ @method }?" do
        instance_eval &send(name).methods[:allowance]
      end

      @domain.send :define_singleton_method, "#{ @method }?" do
        send(name).dsls[name].include? self
      end

      @base.send :define_singleton_method, @method do
        RKit::Dsl::Base.dsls[name]
      end
    end

    protected def thrust_dsl_options!
      name = @name

      @domain.send :define_singleton_method, "#{ @name }_params=" do |*args, &block|
        send(name).try_parameters(*args, &block)
        send(name).extract_parameters self, *args, &block
      end

      @domain.send :define_singleton_method, "#{ @name }_params" do
        instance_variable_get("@#{ name }_params") ||
          instance_variable_set("@#{ name }_params", send(name).params)
      end
    end

    protected def thrust_dsl_extend!
      name = @name

      @domain.send :define_singleton_method, "try_to_#{ @method }" do |*args, &block|
        send "#{ name }_params=", *args, &block

        if send "can_#{ send(name).method }?"
          send(name).dsls[name] << self

          instance_eval &send(name).methods[:class]
          class_eval &send(name).methods[:instance]
          decorator_klass.class_eval &send(name).methods[:decorator] if respond_to? :decorator_klass

          true
        end
      end

      @domain.send :define_singleton_method, @method do |*args, &block|
        instance_eval &send(name).methods[:restriction] unless send "try_to_#{ send(name).method }", *args, &block
      end
    end
  end
end
