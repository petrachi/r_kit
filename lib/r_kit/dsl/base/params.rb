class RKit::Dsl::Base::Params
  attr_reader :params, :params_lambda

  def initialize params_lambda
    raise NoLambdaError unless params_lambda.lambda?

    @params_lambda = params_lambda
    @params = Hash.new{ |hash, key| hash[key] = params_struct.new }
  end


  def try_parameters *args, &block
    @params_lambda.call *args, &block
  end

  def extract_parameters base, *args, &block
    @params[base] = params_struct.new @params_lambda.extract_parameters(*args, &block)
  end


  # TODO: extract local variables may be an independant service of rkit
  def extract_local_variables base
    base.singleton_class.send :prepend, RKit::Dsl::Base::LocalParams
    base.persisting_binding.eval(
      @params[base].to_hash.map{ |name, value| "#{ name }=#{ value.inspect }" }.join(";")
    )
  end


  private def params_names
    @params_names ||= @params_lambda.parameters.map{ |(_, name)| name }
  end

  private def params_struct
    @params_struct ||= StrongStruct.new allowed: params_names
  end

end
