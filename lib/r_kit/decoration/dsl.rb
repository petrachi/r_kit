class RKit::Decoration::Dsl
  act_as_a_dsl

  name :decoration_dsl
  method :acts_as_decorables
  domain ActiveRecord::Base

  before do
    def self.decorator_class() @decorator_class ||= Module.new end
    def decorated?() false end
  end


  params ->(from = nil, &block){}

  methods :class do

    @decorator_class = RKit::Decoration::Class.new self,
      from: decoration_dsl.params.from,
      sleeping: decorator_class,
      &decoration_dsl.params.block

    def decorator_class
      @decorator_class
    end

    def decorate **options
      RKit::Decoration::Collection.new all, **options
    end

    def decorated?() false end

    def need_decoration?() true end

  end


  methods :instance do

    delegate :decorator_class, to: :__class__


    def decorate **options
      decorator_class.new self, **options
    end

    def decorated?() false end

    def need_decoration?() true end

  end
end
