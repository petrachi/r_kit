class RKit::Grid::Base
  class GridRow < self
    attr_accessor :collection

    def initialize collection, binding:;
      @collection = collection
      super binding
    end

    def required_bindings
      {
        row_attributes: {
          class: :'grid-row'
        }
      }
    end

    def _attributes
      _binding.row_attributes
    end

    def capture
      collection.map do |object|
        GridCol.new(object, binding: _binding).to_s
      end
      .reduce(:safe_concat)
    end
  end
end
