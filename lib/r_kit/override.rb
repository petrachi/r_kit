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

  # TODO: allow to explicitly set the 'olddef', so U can use patterns w/ more flexibility
  # like: def try_to_x; ...; end
  # define :x, depend: :x_allowed, olddef: :try_to_x do; raise; end
  # so the final code is like
  # def x; if x_allowed; trye_to_x; else; raise; end; end

end
