module Enumerable

  # TODO: absolutely not definitive !!!
  def to_container_tag &block

    block = caller_binding.eval("->{}") if block.blank?

    RKit::Grid::Base.new self, &block
  end
end
