class RKit::Core::Loader
  attr_accessor :_base, :load_paths

  def initialize base
    @_base = base
    @load_paths = []
  end


  def load_path file, path, options = {}
    load_path = LoadPath.new _base, file: file, path: path
    load_path.conditions = options.slice :if, :unless

    load_paths << load_path
  end

  def load!
    load_paths.each{ |path| path.load! }
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

end
