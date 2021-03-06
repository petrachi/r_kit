class RKit::Dsl::Base::Readonly < SimpleDelegator

  def dsls
    __getobj__.class.dsls
  end

  attr_accessor :base
  getobj_attr_reader :name, :method, :domain, :params, :methods

  alias :basic_params :params
  delegate :try_parameters, :extract_parameters,
    to: :basic_params

  def params() basic_params.params[base] end
  def extract_local_variables() basic_params.extract_local_variables(base) end
end
