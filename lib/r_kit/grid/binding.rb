class RKit::Grid::Binding
  attr_accessor :view_context, :block,
    :col_size, :attributes, :row_attributes, :col_attributes

  def initialize
    @view_context = ActionView::Base.new
    @block = ->(object){ object.to_s }

    @attributes = Attributes.new
    @row_attributes = Attributes.new
    @col_attributes = Attributes.new
  end


  def block= block
    if block
      @view_context = block.binding.eval("self")
      @block = block
    end
  end

  delegate :attributes=, :attributes,
    to: :@attributes

  delegate :attributes=, :attributes,
    to: :@row_attributes, prefix: :row

  delegate :attributes=, :attributes,
    to: :@col_attributes, prefix: :col

  def mass_assign assigns
    assigns.each do |binding, value|
      if respond_to? "#{ binding }="
        send "#{ binding }=", value
      end
    end
  end


  def capture object
    block.call object
  end



  class Attributes
    attr_accessor :attributes

    def initialize
      @attributes = Hash.new{ |hash, key| hash[key] = Array.new }
    end


    def attributes= attributes
      @attributes.merge!(attributes) do |key, old_value, new_value|
        Array.wrap(old_value) + Array.wrap(new_value)
      end
    end

    def attributes
      @computed ||= @attributes.each_with_object({}) do |(key, value), public_attributes|
        public_attributes[process(key)] = process(value)
      end
    end


    def process value
      case value
      when Proc
        process(value.call)
      when Array
        value.map{ |unique_value| process(unique_value) }.join(" ")
      when String, Symbol
        value.to_s.dasherize
      else
        raise ArgumentError, "Must be Array, Proc or String/Symbol"
      end
    end
  end
end
