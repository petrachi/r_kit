module RKit::Dsl::DslExtend

  def self.extended subclass
    subclass.instance_variable_set "@_dsl", RKit::Dsl::Base.new(subclass)
  end

  delegate :name, :method, :domain, :before, :params, :methods, :allowed?, :restricted,
    to: :@_dsl

end
