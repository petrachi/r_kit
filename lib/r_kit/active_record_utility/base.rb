class RKit::ActiveRecordUtility::Base

  attr_accessor :base, :method_name

  def initialize base, method_name:;
    @base = base
    @method_name = method_name
  end

  def to_s
    __class__.demodulize.underscore
  end


  def interfere *args
    if can_interfere?
      interfere! *args
      interfered!
    else
      raise DatabaseSchemaError.new(base, method_name: method_name) unless running_script? /^rake db:/
    end
  end


  # TODO: private/protected ?
  def can_interfere?
    raise NotImplementedError, 'Subclasses must implement this method'
  end

  def interfere! **options
    base.interferences_options_set self, **options

    base.instance_eval &instance_interferences
    base.class_eval &class_interferences
    base.decorator_klass.class_eval &decorator_interferences if base.decorator_klass
  end

  interferences = %i{instance class decorator}
  interferences.each do |interference|
    define_method "#{ interference }_interferences" do
      __class__.send "#{ interference }_interferences_proc"
    end

    singleton_class.send :attr_reader, "#{ interference }_interferences_proc", default: proc{ Proc.new }

    define_singleton_method "#{ interference }_interferences", ->(&block) do
      instance_variable_set "@#{ interference }_interferences_proc", block
    end
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
