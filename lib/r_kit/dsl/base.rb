class RKit::Dsl::Base

  @@dsls = Hash.new{ |hash, key| hash[key] = Array.new }


  attr_accessor :base

  def initialize base
    @base = base
    @methods = Hash.new{ |hash, key| hash[key] = proc{} }

    @methods[:allowance] = proc{ true }
    @methods[:restriction] = proc{ raise DslStandardError.new(self, method_name: __method__) }
    # TODO: the __method__ return 'initialize', and not the "acts_as_..." that it shoul

    @methods[:options] = ->(){}
  end


  def name name
    @name = name
  end

  def method method
    @method = method
  end


  def domain domain
    @domain = domain

    can_domain
    extend_domain
    ask_domain
    ask_base
  end

  def can_domain
    methods = @methods

    @domain.send :define_singleton_method, "can_#{ @method }?" do
      instance_eval &methods[:allowance]
    end
  end

  def extend_domain
    dsls = @@dsls
    name = @name
    method = @method
    methods = @methods
    error = @error


    @domain.send :define_singleton_method, @method do |*args, **options, &block|

      methods[:options].call(*args, **options, &block)
      methods[:options].parameters.each do |(type, name)|
        value = case type
        when :opt
          args.shift # default_value? -> this will be set to nil
        when :req
          args.shift # I don't handle :req args that are AFTER the :rest param
        when :rest
          args
        when :key
          options.delete name # default_value? -> this will be set to nil
        when :keyreq
          options.delete name
        when :keyrest
          options
        when :block
          block
        end

        instance_variable_set "@#{ name }", value
      end


      if send "can_#{ method }?"
        dsls[name] << self

        instance_eval &methods[:class]
        class_eval &methods[:instance]

        if respond_to? :decorator_klass
          decorator_klass.class_eval &methods[:decorator]
        end
      else
        instance_eval &methods[:restriction] 
      end
    end
  end

  def ask_domain
    dsls = @@dsls
    name = @name

    @domain.send :define_singleton_method, "#{ @method }?" do
      dsls[name].include? self
    end
  end

  def ask_base
    dsls = @@dsls
    name = @name

    @base.send :define_singleton_method, @method do
      dsls[name]
    end
  end


  def allowed? &block
    methods :allowance, &block
  end

  def restricted &block
    methods :restriction, &block
  end

  # TODO: raise if lambda? == false
  def options lambda_options
    @methods[:options] = lambda_options
  end

  def methods context, &block
    @methods[context] = block
  end

end
