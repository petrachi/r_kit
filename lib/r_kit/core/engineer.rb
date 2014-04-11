class RKit::Core::Engineer
  attr_accessor :base, :pathname

  def initialize base
    @base = base
  end

  def load!
    if permit_load?
      pathname = @pathname
      base.const_set "Engine", Class.new(Rails::Engine){ paths.path = pathname }
    end
  end

  def permit_load?
    @pathname.present?
  end
end
