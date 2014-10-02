class RKit::Dsl::Base::Params
  attr_reader :params_lambda

  def initialize params_lambda
    raise NoLambdaError unless params_lambda.lambda?

    @params_lambda = params_lambda
    @params = params_struct.new
  end


  def params= value
    @params = params_struct.new value
  end

  def params
    @params
  end


  def try_parameters *args, &block
    @params_lambda.call *args, &block
  end

  def extract_parameters *args, &block
    self.params = @params_lambda.extract_parameters(*args, &block)
  end


  private def params_names
    @params_names ||= @params_lambda.parameters.map{ |(_, name)| name }
  end

  private def params_struct
    @params_struct ||= StrongStruct.new allowed: params_names
  end

end
