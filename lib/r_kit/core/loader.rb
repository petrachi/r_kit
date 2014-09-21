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


  def load_path file, path, options = {}
    load_path = LoadPath.new _base, file: file, path: path
    load_path.conditions = options.slice :if, :unless

    load_paths << load_path
  end

  def load_paths!
    load_paths.each &:load!
  end


  def loaded!
    @@loaded << _base.name
  end


  def load!
    dependencies!
    load_paths!
    loaded!
  end


  class LoadPath
    attr_accessor :_base,
      :file, :path, :conditions

    def initialize base, file:, path:;
      @_base = base

      @file = file
      @path = path
    end


    def extname
      File.extname(file)
    end

    def fullpath
      file.chomp! File.extname(file)
      File.expand_path(path, file)
    end


    def should_load?
      conditions.inject(true) do |should_load, (statement, condition)|
        should_load && exec_condition(statement, condition)
      end
    end

    def load_path!
      require fullpath
    end

    def load!
      load_path! if should_load?
    end


    def exec_condition statement, condition
      condition = case condition
      when Proc
        condition.call _base::CONFIG
      when Symbol, String
        _base::CONFIG.send condition
      end

      exec_statement statement, condition
    end

    def exec_statement statement, condition
      case statement
      when :if
        !!condition
      when :unless
        !condition
      end
    end
  end


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

end
