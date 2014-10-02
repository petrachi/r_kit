class Dependency
  attr_accessor :base, :service

  def initialize base, service:;
    @base = base
    @service = RKit.const_get(service.to_s.classify)
  end

  def should_load?
    !service.loaded?
  end

  # TODO: The dependency warning msg should be in service object
  def dependency!
    warn %Q{
WARNING - #{ service.name } was implicitly loaded,
As a dependency for #{ base }.
You may want to load it explicitly.
    }
    service.load
  end

  def load!
    dependency! if should_load?
  end
end
