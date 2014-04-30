class RKit::Grid::Base
  attr_accessor :_binding

  # ho no, binding is doing all that I don't want it to do
  # binding should only be a stackage class
  # all the calculation should happen here (get the vienw context, setting the attributes/col_size)
  # then, add delegation methods to access the bindings

  # the bindings will maybe handle some logic, like dasherize attributes
  # that's all

  def initialize binding
    @_binding = binding
    _binding.defaults defaults
  end

  def _h
    _binding._view_context
  end

  delegate :_col_size, :_attributes,
    to: :_binding

  def to_s
    _h.content_tag :div, _attributes, &method(:capture)
  end


  def col_size col_size, &block
    _binding.col_size col_size, &block
    self
  end


  class Grid < self
    attr_accessor :_collection

    def initialize collection, view_context = nil, &block
      @_collection = collection
      super(RKit::Grid::Binding.new(view_context, &block))
    end

    def defaults
      {
        attributes: {
          class: :grid
        }
      }
    end

    def capture
      GridRow.new(_collection, _binding).to_s
    end
  end

  class GridRow < self
    attr_accessor :_collection

    def initialize collection, binding
      @_collection = collection
      super(binding)
    end

    def defaults
      {
        attributes: {
          class: 'grid-row'
        }
      }
    end

    def capture
      @_collection.map do |object|
        GridCol.new(object, _binding).to_s
      end
      .reduce(:safe_concat)
    end
  end

  class GridCol < self
    attr_accessor :_object

    def initialize object, binding
      @_object = object
      super(binding)
    end

    def defaults
      {
        attributes: {
          class: ->{ "grid-col-#{ _col_size }" }
        }
      }
    end

    def capture
      _binding._block.call _object
    end
  end

#
#
# # base have all
# # in base initalize, we must transform "attributes" (with info : stack_level + col_size)
# # and we must set the "capture_block" (this is next stack level creation)
#
# # the transformation will be set by the "*_binding" classes
# # who can inherit (or mixin) from "binding" if necessary
#
# # in base, the to_s method should look like :
# # @view_context.content_tag @tag, @attributes, &@capture_block
#
#
#   # either, refactoring
#   # a module / superclass, in "base", that do the initialization etc part
#   # all variables thing could be handled in subclasses
#   # or a mixin, but i'm less fan, but I this should be the right use case
#
#   # or, a "binding" object, that have all the args, and I just call for it
# attr_accessor :_obj
#
#
#   def initialize obj, view_context = nil, &block
#     @_obj = obj
#
#     @_view_context = if view_context
#       view_context
#     else
#       find_view_context block
#     end
#
#     @_block = block
#   end
#
#
#   def find_view_context block
#     view_context = if block
#       block.binding.eval("self")
#     else
#       caller_binding(4).eval("self")
#     end
#
#     case view_context
#     when ::ActionView::Base then view_context
#     when ::ActionController::Base then view_context.view_context
#     end
#   end
#
#   def to_s
#     @_view_context.content_tag :div, attributes, &capture_block
#   end
#
#
#   class SingleObject < self
#
#     def initialize obj, view_context = nil, &block
#       super
#       @_block = block || ->(obj){ obj.to_s }
#     end
#
#
#
#     def attributes
#       {class: "grid-col-3"}
#     end
#
#     def capture_block
#       ->{ @_block.call(@_obj) }
#     end
#
#
#   end
#
#   class CollectionObject < self
#
# def initialize obj, view_context = nil, &block
#   super
# end
#
# def attributes
#   {class: "grid-row"}
# end
#
# def capture_block
#   ->{ @_obj.map do |obj|
#     SingleObject.new(obj, @_view_context, &@_block).to_s
#   end.reduce(&:safe_concat) }
# end
#
#   end
#
#   class GridLevelObject < self
#
#
# def initialize obj, view_context = nil, &block
#   super
# end
#
#
# def attributes
#   {class: "grid"}
# end
#
# def capture_block
#   ->{ CollectionObject.new(@_obj, @_view_context, &@_block).to_s }
# end
#
#   end
#
#


  #
  #
  #
  # # class "binding" will get every options (curently col_size + attributes(id, class, ...) + block)
  # # class "binding wil have a stack level ("grid/row/col")
  # # class binding will allow to get current options for current level
  # # and binding for next level -> this will be a block
  # # class binding will have a to_s method ?
  #
  # class Binding
  #   def initalize object, stack_level:, attributes:, col_size:, block:
  #     @_object = object
  #     @_stack_level = stack_level
  #     @_attributes = attributes
  #     @_col_size = col_size
  #     @_block = block
  #
  #     @_view_context = find_view_context
  #   end
  #
  #   def find_view_context block
  #     view_context = if block
  #       block.binding.eval("self")
  #     else
  #       caller_binding(3).eval("self")
  #     end
  #
  #     if view_context.kind_of? ::ActionView::Base
  #       view_context
  #     elsif view_context.respond_to? :view_context
  #       view_context.view_context
  #     end
  #   end
  #
  #   # methods to possibly implement :
  #   # tag (:div, ...)
  #
  #   def view_context
  #     @_view_context
  #   end
  #
  #   def next_stack
  #     @_stack = case @_stack_level
  #     when "grid"
  #       Proc.new do
  #         __class__.new @_object,
  #           stack_level: "grid-row",
  #           attributes: @_attributes,
  #           col_size: @_col_size,
  #           block: @_block
  #       end
  #
  #     when "grid-row"
  #       Proc.new do
  #         @_object.map do |object|
  #           __class__.new @_object,
  #             stack_level: "grid-col-_",
  #             attributes: @_attributes,
  #             col_size: @_col_size,
  #             block: @_block
  #         end
  #         .reduce(:safe_concat)
  #       end
  #
  #     when "grid-col-_"
  #       @_block && @_block.call(@_object) || @_object.to_s
  #
  #     end
  #     # to refactor using classes and constantize
  #   end
  #
  #   def to_s
  #
  #   end
  # end



  # base will have all attr/colsize/view_context/stacklevel etc
  # and a "binding" class
  # for the render method this will be like this :
=begin
def to_s
binding.view_context.content_tag :div, @binding.attributes, &binding.next_level
end
=end
  # binding will be set at the initialize like this
  # "#{stack_level}".constantize.new(attributes, col_size, block, view_context)










  # base will call the right class with all options, and the class can be manually set via "stack_level"
  # there will be 3 level : grid - row - col / collection - subcollection - object(instance) / top - collection - object
  # are we gonna create new rows or just trust the flex ? is this will be configrable ?
  # new rows are more usefull to create functions like "odd/even/cycle ..." throug I'm not sure of how this will be presented from the caller perspective - are we gonna do it ?


  # en plus, une classe "binding" qui va prendre toutes les options possibles du monde, et les tranformer - doit prendre un level actuel, pouvoir renvoyer les infos pour son level, et pouvoir envoyer les bindings pour le level suivant (du coup, 3 autres classes ? juste pour les différents levels ?)
  # genre (pour col level), col_size: 4, html_class: [:btn_primary, align_left]
  # devient "grid-col-4 btn-primary align-left"








  # attr_accessor :_collection, :_block
  #
  # def initialize collection, &block
  #   @_block = block if block_given?
  #   @_collection = collection
  #
  #   defaults!
  # end
  #
  # def defaults!
  #   view_context caller_binding(3).eval("self")
  #   col_size 3
  # end
  #
  #
  # class << self
  #   def define_attribute attr_name
  #     attr_accessor "_#{ attr_name }"
  #
  #     define_method attr_name do |value, &block|
  #       instance_variable_set "@_block", block if block
  #       instance_variable_set "@_#{ attr_name }", value
  #       self
  #     end
  #
  #   end
  # end
  #
  # define_attribute :view_context
  # define_attribute :col_size
  #
  #
  # #
  # # def view_context view_context
  # #   @_view_context = view_context
  # #   self
  # # end
  # #
  # # def col_size col_size
  # #   @_col_size = col_size
  # #   self
  # # end
  #
  #
  # def _h
  #   @_view_context
  # end
  #
  #
  # def to_s
  #   if _block
  #     _h.capture &_block
  #   else
  #     "grid"
  #   end
  # end




=begin
#roadmap from the caller persepective

intance.to_grid do
#code
end
=> col tag


collection.to_grid do
#code
end
=> row tag
==> col_tag

then
=> container
==> row
===> col


instance.to_grid #use the to_s from instance
=> col

collection.to_grid
=> sam



<%= collection.to_grid %>


=end



















  #
  #
  # attr_accessor :obj, :options, :block
  #
  # # TODO: for now, this logic remains here, but we shoud think to move it from a different independant service, and add it to the depencies for Grid.
  # # TODO: what if there is no block ???
  # def initialize obj, options = {}, &block
  #   # TODO: instead of options, use the named args from ruby 2
  #   @obj = obj
  #   @options = options
  #   @block = block
  #
  #
  #   if block_given?
  #     @view_context = block.binding.eval("self")
  #   else
  #     @view_context = caller_binding.eval("self")
  #   end
  # end
  #
  # def _h
  #   @view_context
  # end
  #
  # def to_s
  #   # TODO: create a grid, and rows, and cols, iterate over the col_size, etc
  #   # if this is not a collection, just create a col tag
  #   # type on tag, col size, html classes id, etc can be passe through options, just get your old grid code
  #   # and maybe, handle the nested part once again ?
  #   if block.present?
  #     _h.capture(&block)
  #   else
  #     _h.link_to "salut toto", "slt"
  #   end
  # end
  #
  #
  #
  # # TODO: from the caller, 3 ways to call the grid
  # # 1 - collection.to_grid{#block} - this passed by enumerable, will be an option to load or not core extends
  # # 2 - Grid(collection){#block} - this is kernel extend global conversion - I guess this could be choose to be loaded or not, and the name of the conversion method could be choosed
  # # 3 - RKit::Grid::Base.new(collection){#block} - you can't choose to not load this one, but you can choose an alias constant (like Grid, GRID) from top namespace (I don't know if I must use object or kernel)

end
