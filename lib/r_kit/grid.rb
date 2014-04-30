class RKit::Grid < RKit::Core

  with_engine __FILE__
  with_sprockets

  load_path __FILE__, 'sass_extend.rb'


  load_path __FILE__, 'base.rb'
  load_path __FILE__, 'base/grid.rb'
  load_path __FILE__, 'base/grid_col.rb'
  load_path __FILE__, 'base/grid_row.rb'
  load_path __FILE__, 'binding.rb'

  #load_path __FILE__, 'enumerable_extend.rb'
  #load_path __FILE__, 'kernel_extend.rb'
  #load_path __FILE__, 'tags.rb'
  # TODO: full rework of this

  config :base_width, [0.75, ["rem"]]


  # TODO: ??? - must be something like "view_dsl / controller_dsl / model_dsl / ..." - ???
  # TODO: will must diferentiate include / extend dsl
  # load_path __FILE__, 'action_view_extension.rb'
end
