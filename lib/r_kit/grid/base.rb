class RKit::Grid::Base
  attr_accessor :_binding

  def initialize binding
    @_binding = binding
    _binding.mass_assign required_bindings
  end

  def required_bindings
    raise NotImplemented, 'Subclasses must implement this method'
  end


  def _h
    _binding.view_context
  end

  def _attributes
    raise NotImplemented, 'Subclasses must implement this method'
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
  binding_accessor :row_attributes
  binding_accessor :col_attributes


  def capture
    raise NotImplemented, 'Subclasses must implement this method'
  end

  def to_s
    _h.content_tag :div, _attributes, &method(:capture)
  end

end
