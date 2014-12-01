class RKit::Override

  load_path __FILE__,
    'base',
    'method_extend',
    'module_extend',
    'pattern',
    'unbound_method_extend'

  # load_path __FILE__, 'test'
  # load_path __FILE__, 'perfs'

  # TODO: config for 'simple_override' -> active or not ?

end
