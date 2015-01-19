class LoadPath
  attr_accessor :_base,
    :file, :path, :priority, :conditions

  def initialize base, file:, path:, **options
    @_base = base

    @file = file
    @path = path

    @priority = options.fetch :priority, 1/0.0
    @conditions = options.slice :if, :unless
  end


  def extname
    File.extname(file)
  end

  def fullpath
    file.chomp! File.extname(file)
    File.expand_path(path, file) << ".rb"
  end


  def should_load?
    conditions.inject(true) do |should_load, (statement, condition)|
      should_load && exec_condition(statement, condition)
    end
  end

  def load_path!
    require fullpath
  rescue NameError => e
    warn %Q{
WARNING - An error occur during `RKit' initialization
  The file #{ fullpath } could not be loaded.
  Ruby stack says: #{ e.message }.
    }
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
