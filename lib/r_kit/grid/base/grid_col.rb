class RKit::Grid::Base
  class GridCol < self
    attr_accessor :object

    def initialize object, binding:;
      @object = object
      super binding
    end

    def required_bindings
      {
        col_attributes: {
          class: proc{ :"grid-col-#{ _binding.col_size }" }.call
        }
      }
    end

    def _attributes
      _binding.col_attributes object
    end

    def capture
      _binding.capture object
    end
  end
end
