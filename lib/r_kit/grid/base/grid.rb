class RKit::Grid::Base
  class Grid < self
    attr_accessor :collection

    def initialize collection, &block
      @collection = collection

      @_binding = RKit::Grid::Binding.new
      @_binding.block = block

      super @_binding
    end

    def required_bindings
      {
        attributes: {
          class: :grid
        }
      }
    end

    def _attributes
      _binding.attributes
    end

    def capture
      GridRow.new(collection, binding: _binding).to_s
    end
  end
end
