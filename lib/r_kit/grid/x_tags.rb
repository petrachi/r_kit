class RKit::Grid::Tags

  def initialize
    @col_size = 12

  end

  def _h
    @view_context
  end


  def attributes attributes
    @attributes = attributes
    # TODO: html classes, id
  end

  def col_size col_size
    @col_size = 12
  end

  def render view_context, &block
    @view_context = view_context
    @block = block
  end

  class Container < self

    def render view_context, &block
      super
      _h.content_tag :div, class: :container, &@block
    end

  end

  module ::Enumerable
    def to_container_tag
      RKit::Grid::Tags::Container.new
    end
  end

  # def render view_context, &block
  #  @_h = view_context

  #  Container.new self
  #end


  # TODO: extend array / hash / arel
  # with "to_container_x_tag"
  # then, render the actual tags with a "render(view_context)" method
  # this method could be provided by the "partializer" service

end
