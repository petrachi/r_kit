class RKit::ActiveRecordUtility::Utility

  attr_accessor :base, :method

  def initialize base, method:;
    @base = base
    @method = method
  end


  def interfere *args
    if can_interfere?
      interfere! *args
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


  class << self
    def interfered? base
      @interfered.include? base
    end

    def interfered base
      @interfered << base
    end

    def inherited subclass
      subclass.instance_variable_set :@interfered, []
      super
    end
  end
end
