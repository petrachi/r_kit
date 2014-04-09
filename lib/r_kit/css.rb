class RKit::Css < RKit::Core
  load_path __FILE__, 'engine.rb'
  load_path __FILE__, 'sass_extend.rb'
  load_path __FILE__, 'sprockets_extend.rb'

  config :primary_color, '#b62b76'
  config :secondary_color, 'cornflowerblue'

  # TODO: config_nested, allow to have one level deeper
  # TODO: config_preset -> allow to switch defaults values for the configuration
end
