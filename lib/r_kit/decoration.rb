class RKit::Decoration

  dependency :backtrace,
    :dsl,
    :utility


  load_path __FILE__,
    'base',
    'base/collection',
    'base/object',
    'class',
    'dsl',
    'enumerable_extend',
    'object_extend'

  load_path __FILE__, 'action_view_base_extend', if: :implicit_decoration


  config :implicit_decoration, true
  config :recursive_decoration, true

end
