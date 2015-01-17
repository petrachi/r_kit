class Grid < RKit::Grid::Base

  def self.try_convert object, &block
    if object.kind_of? RKit::Grid::Base
      object

    elsif object.respond_to? :to_grid
      object.to_grid &block

    else
      RKit::Grid::Base::Grid.new Array.wrap(object), &block
    end
  end


  attr_accessor :collection

  def initialize collection, &block
    @collection = collection

    @_binding = RKit::Grid::Binding.new
    @_binding.block = block

    super @_binding
  end

  def required_bindings
    # TODO: change config to min-col-size
    # TODO: col size adapts to collection size, but not below min-col-size
    {
      col_size: RKit::Grid.config.col_size,
      attributes: {
        class: :grid
      }
    }
  end


  class << self
    def binding_accessor name
      define_method name do |value, &block|
        _binding.block = block if block
        _binding.send "#{ name }=", value

        self
      end
    end
  end

  binding_accessor :col_size
  binding_accessor :attributes
  binding_accessor :col_attributes



  def flex &block
    attributes class: 'grid-flex', &block
  end

  def items value, &block
    attributes class: "grid-items-#{ value }", &block
  end



  def _tag
    :div
  end

  def _attributes
    _binding.attributes
  end

  def capture
    collection.map do |object|
      GridCol.new(object, binding: _binding).to_s
    end
    .reduce(:safe_concat)
  end

end
