class RKit::Grid

  with_engine __FILE__
  with_sprockets __FILE__

  load_path __FILE__,
    'base.rb',
    'base/grid.rb',
    'base/grid_col.rb',
    'base/grid_row.rb',
    'binding.rb'

  load_path __FILE__, 'enumerable_extend.rb', if: :enumerable_extend
  load_path __FILE__, 'kernel_extend.rb', if: :kernel_extend


  config :extends, true
  alias_config :enumerable_extend, :extends
  alias_config :kernel_extend, :extends


  config :base_width, [0.75, ['rem']]
  config :col_size, 3

end
