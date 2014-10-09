class RKit::Core::Loader
  attr_accessor :_base, :load_paths, :dependencies

  @loaded = []

  def self.loaded
    @loaded.map{ |name| name.demodulize.underscore }
  end

  def self.loaded? name
    @loaded.include? name
  end


  def initialize base
    @_base = base
    @load_paths = []
    @dependencies = []
  end


  # TODO: when a dependency is added, we must define in the opposite service a "dependency forbidden"
  # TODO: in order to avoid recursive dependency
  def dependency *services
    services.each do |service|
      dependencies << Dependency.new(_base, service: service)
    end
  end

  def dependencies!
    dependencies.each &:load!
  end


  def load_path file, *paths, **options
    paths.each do |path|
      load_paths << LoadPath.new(_base, file: file, path: path, **options.slice(:priority, :if, :unless))
    end
  end

  def load_paths!
    load_paths.sort{ |a, b| a.priority <=> b.priority }.each &:load!
  end


  def loaded!
    __class__.instance_variable_get("@loaded") << _base.name
  end


  def load!
    dependencies!
    load_paths!
    loaded!
  end

end
