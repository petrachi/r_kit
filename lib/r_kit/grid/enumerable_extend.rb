module Enumerable
  def to_grid &block
    RKit::Grid::Base::Grid.new self, &block
  end
end
