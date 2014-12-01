class RKit::Frame

  dependency :dsl,
    :utility


  load_path __FILE__,
    'empty_frame'

  load_path __FILE__,
    'collection_dsl',
    'instance_dsl'

end
