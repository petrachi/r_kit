class RKit::Grid::Base
  attr_accessor :_binding

  def initialize binding
    @_binding = binding
    _binding.mass_assign required_bindings
  end

  def required_bindings
    raise NotImplementedError, 'Subclasses must implement this method'
  end


  def _h
    _binding.view_context
  end

  def _attributes
    raise NotImplementedError, 'Subclasses must implement this method'
  end





  def capture
    raise NotImplementedError, 'Subclasses must implement this method'
  end

  def to_s
    _h.content_tag _tag, _attributes, &method(:capture)
  end

end
