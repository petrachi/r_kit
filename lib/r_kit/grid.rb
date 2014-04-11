class RKit::Grid < RKit::Core

  with_engine __FILE__

  load_path __FILE__, 'sass_extend.rb'


  load_path __FILE__, 'tags.rb' # TODO: full rework of this


  load_path __FILE__, 'sprockets_extend.rb'
  # will need sprocket extend too, this file should be shared somewhere
  # but if I have two services with the same shared file, this one should not be loaded two times
  # and should not be loaded if not service use it

  config :base_width, [0.75, ["rem"]]


  # TODO: must be something like "view_dsl / controller_dsl / model_dsl / ..." - ???
  # TODO: will must diferentiate include / extend dsl
  # load_path __FILE__, 'action_view_extension.rb'
end
