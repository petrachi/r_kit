def Grid object, &block

  if object.kind_of? RKit::Grid::Base
    object
  elsif object.respond_to? :to_grid
    object.to_grid &block
  else
    RKit::Grid::Base::Grid.new Array.wrap(object), &block
  end

end
