class RKit::Grid::Binding


  # TODO: binding will only receive values
  # col_size, attributes, view_context and block
  # it will not have any logic except storage

  # it will accept a "defaults" method

  # the attribute part will be a little different
  # this class will handle the logic initiated by 'process_attribute' for the reader accesor
  # but hey, I will need to have acces to the "object" for procs
  # so no, no logic here
  # do we need this class at all ? (or do I just so want it because I find this so cool)
  # it is usefull to not have too mush in the initializers of grid/row/col classes


  # will need private attribute & attributes
  # attributes are user settings
  # private are classes for grid

  attr_accessor :_view_context, :_block, :_attributes, :_col_size

  def initialize view_context = nil, &block
    @_view_context = view_context || block && block.binding.eval("self")
    @_block = block
  end

  def defaults defaults
    attributes defaults[:attributes]
    col_size defaults.fetch(:col_size, (_col_size || 3))

    self
  end

  def attributes attributes, &block
    if block
      @_view_context ||= block.binding.eval("self")
      @_block = block
    end

    @_attributes = attributes
  end

  def _attributes
    @_attributes.each do |key, value|
      @_attributes[key] = process_attribute(value)
    end

    @_attributes
  end

  def process_attribute value
    case value
    when Proc
      value.call
    when Array
      value.map{ |unique_value| process_attribute(unique_value) }.join(" ")
    when String, Symbol
      value.to_s.dasherize
    end
  end

  def col_size col_size, &block
    if block
      @_view_context ||= block.binding.eval("self")
      @_block = block
    end

    @_col_size = col_size
  end
end



# class RKit::Grid::Binding
#
#   class Grid
#     def initialize base
#       @_base = base
#     end
#
#     def attributes
#       {class: :grid}
#     end
#
#     def bind_up
#       @_base.instance_varible_set "@_binding", GridRow.new(@_base)
#     end
#
#     def capture_block
#       Proc.new do
#         @_base.to_s
#       end
#     end
#   end
#
#   class GridRow
#     def initialize base
#       @_base = base
#     end
#
#     def attributes
#       {class: :'grid-row'}
#     end
#
#     def bind_up
#       @_base.instance_varible_set "@_binding", GridCol.new(@_base)
#     end
#
#     def capture_block
#       Proc.new do
#         @_base.instance_varible_get("@_object").map do |object|
#           @_base.to_s
#         end.reduce(&:safe_concat)
#       end
#     end
#   end
#
#   class Grid
#     def initialize base
#       @_base = base
#     end
#
#     def attributes
#       {class: :'grid-col-3'}
#     end
#
#     def bind_up
#       @_base.instance_varible_set "@_binding", nil
#     end
#
#     def capture_block
#       Proc.new do
#         @_base.to_s
#       end
#     end
#   end
#
#
#
#   #   def to_s
#   #     @_view_context.content_tag :div, class: "grid-col-3" do
#   #       @_block.call(@_obj)
#   #     end
#   #   end
#
#   #   def to_s
#   #     @_view_context.content_tag :div, class: "grid-row" do
#   #       @_obj.map do |obj|
#   #         SingleObject.new(obj, @_view_context, &@_block).to_s
#   #       end.reduce(&:safe_concat)
#   #     end
#   #   end
#
#   #   def to_s
#   #     @_view_context.content_tag :div, class: "grid" do
#   #       CollectionObject.new(@_obj, @_view_context, &@_block).to_s
#   #     end
#   #   end
#
#
#
#
#
#
#   # class Binding
#   #   def initialize object, view_context = nil, &block
#   #     @_object = object
#   #
#   #     @_view_context = if view_context
#   #       view_context
#   #     else
#   #       find_view_context block
#   #     end
#   #
#   #     @_block = block
#   #   end
#   #
#   #   def find_view_context block
#   #     view_context = if block
#   #       block.binding.eval("self")
#   #     else
#   #       caller_binding(4).eval("self")
#   #     end
#   #
#   #     if view_context.kind_of? ::ActionView::Base
#   #       view_context
#   #     elsif view_context.respond_to? :view_context
#   #       view_context.view_context
#   #     end
#   #   end
#   # end
#   #
#   # class Binding::TopLvl < Binding
#   #   def attributes
#   #     {
#   #       class: :grid
#   #     }
#   #   end
#   #
#   #   def next_binding
#   #     RoxLvl.new(@_object, @_view_context)
#   #   end
#   #
#   #   def capture_block
#   #     Proc.new do
#   #       Base.new(@_object, next_binding)
#   #     end
#   #   end
#   # end
# end
