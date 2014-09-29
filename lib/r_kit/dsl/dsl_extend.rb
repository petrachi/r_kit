module RKit::Dsl::DslExtend

  def self.extended subclass
    subclass.instance_variable_set "@_dsl", RKit::Dsl::Base.new(subclass)
  end

  delegate :name, :method, :domain, :allowed?, :restricted, :options, :methods,
    to: :@_dsl

end
