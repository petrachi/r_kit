class RKit::Dsl::Base

  @dsls = Hash.new{ |hash, key| hash[key] = Array.new }
  def self.dsls
    @dsls
  end
  ::DSLS = @dsls


  attr_accessor :base

  def initialize base
    @base = base
    @methods = Hash.new{ |hash, key| hash[key] = proc{} }

    @methods[:allowance] = proc{ true }
    @methods[:restriction] = proc{ raise DslStandardError.new(self, method_name: __method__) }
    # TODO: the __method__ return 'initialize', and not the "acts_as_..." that it shoul

    @params = RKit::Dsl::Base::Params.new(->(){})
  end


  # TODO: vérifier l'unicité du "name"
  def name name
    @name = name
  end

  def method method
    @method = method
  end


  def domain domain
    raise DslDefinitionError.new(@base) if [@name, @method].none?

    @domain ||= domain

    shadow domain: domain do |shadow_self|
      thrust_dsl!
      thrust_dsl_callback! if @methods[:before]
      thrust_dsl_interface!
      thrust_dsl_options!
      thrust_dsl_extend!
    end
  end


  def before &block
    methods :before, &block

    thrust_dsl_callback!
  end


  def params params_lambda
    @params = RKit::Dsl::Base::Params.new(params_lambda)
  end


  def allowed? &block
    methods :allowance, &block
  end

  def restricted &block
    methods :restriction, &block
  end

  def methods context, &block
    @methods[context] = block
  end


  include RKit::Dsl::Base::Thrust


  protected def readonly
    RKit::Dsl::Base::Readonly.new(self)
  end

end
