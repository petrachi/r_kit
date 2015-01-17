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
      @view_context = block.binding.eval('self')
      @block = block
    end
  end

  delegate :attributes=, :attributes,
    to: :@attributes

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


    # TODO: Allow to take only a proc (so not a hash)
    # TODO: OR a single symbol (and we use that to send a method on the object)
    # TODO: Tha last one can be replaced (or duplicated) by a "respond_to?" automatically triggered from here
    def attributes= attributes
      @attributes.merge!(attributes) do |key, old_value, new_value|
        Array.wrap(old_value) | Array.wrap(new_value)
      end
    end

    # TODO: @computed need to be back, we compute what can be, the procs or methods will be calc each time
    def attributes object = nil
      #@computed ||=
      @attributes.each_with_object({}) do |(key, value), public_attributes|
        public_attributes[process(key, object)] = process(value, object)
      end
    end


    def process value, object = nil
      case value
      when Proc
        process(value.call(object), object)
      when Array
        value.map{ |unique_value| process(unique_value, object) }.join(' ')
      when String, Symbol
        value.dasherize
      else
        raise ArgumentError, 'Must be Array, Proc or String/Symbol'
      end
    end
  end
end
