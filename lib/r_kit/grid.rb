class RKit::Grid

  with_engine __FILE__
  with_sprockets __FILE__

  load_path __FILE__,
    'base',
    'base/grid',
    'base/grid_col',
    'base/grid_row',
    'binding'

  load_path __FILE__, 'enumerable_extend', if: :enumerable_extend
  load_path __FILE__, 'main_extend', if: :main_extend


  config :extends, true
  alias_config :enumerable_extend, :extends
  alias_config :main_extend, :extends


  config :base_width, [0.75, ['rem']]
  config :col_size, 3

end
