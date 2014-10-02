class RKit::Core::Loader
  attr_accessor :_base, :load_paths, :dependencies

  @@loaded = []

  def self.loaded
    @@loaded.map{ |name| name.demodulize.underscore }
  end

  def self.loaded? name
    @@loaded.include? name
  end


  def initialize base
    @_base = base
    @load_paths = []
    @dependencies = []
  end


  def dependency dependency
    dependencies << Dependency.new(_base, service: dependency)
  end

  def dependencies!
    dependencies.each &:load!
  end


  def load_path file, path, **options
    load_path = LoadPath.new _base, file: file, path: path, **options.slice(:priority)
    load_path.conditions = options.slice :if, :unless

    load_paths << load_path
  end

  def load_paths!
    load_paths.sort{ |a, b| a.priority <=> b.priority }.each &:load!
  end


  def loaded!
    @@loaded << _base.name
  end


  def load!
    dependencies!
    load_paths!
    loaded!
  end

end
