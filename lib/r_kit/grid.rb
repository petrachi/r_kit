class RKit::Grid

  with_engine __FILE__
  with_sprockets __FILE__

  load_path __FILE__,
    'base',
    'base/grid',
    'base/grid_col',
    'binding'

  load_path __FILE__, 'enumerable_extend', if: :enumerable_extend


  config :extends, true
  alias_config :enumerable_extend, :extends


  config :base_width, [0.75, ['rem']]
  config :col_size, 3

  alias_config :grid_base_width, :base_width

end
