class RKit::ActiveRecordUtility::Utility

  attr_accessor :base, :method

  def initialize base, method:;
    @base = base
    @method = method
  end


  def interfere
    if can_interfere?
      interfere!
      interfered!
    else
      raise DatabaseSchemaError.new(base, method: method) unless running_script? /^rake db:/
    end
  end


  # TODO: private/protected ?
  def can_interfere?
    raise NotImplementedError, 'Subclasses must implement this method'
  end

  def interfere!
    raise NotImplementedError, 'Subclasses must implement this method'
  end

  def interfered!
    __class__.interfered base
  end


  module SingletonInheritance
    def self.extended base
      base.instance_variable_set :@extended, []
    end

    def interfered? base
      @extended.include? base
    end

    def interfered base
      @extended << base
    end
  end

  def self.inherited(subclass)
    subclass.extend SingletonInheritance
    super
  end
end
