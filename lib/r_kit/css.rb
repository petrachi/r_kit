class RKit::Css < RKit::Core

  with_engine __FILE__

  load_path __FILE__, 'sass_extend.rb'
  load_path __FILE__, 'sprockets_extend.rb'
  # TODO: les sprocket doivent être share sur plusieurs services qui auront du css, voir s'il est possible de faire qqchose de bien à ce niveau, puis voir si on peut faire une dsl 'with_sprockets'

  config :colors, :primary_color, '#b62b2b'
  config :colors, :text_color, '#888'
  config :colors, :background_color, '#111'


  alias_config :colors, :link_color, :background_color

  #config :colors, :link_color, @_config[:colors][:background_color]
  #config :colors, :link_background_color, @_config[:colors][:primary_color]
  # TODO: alias_config :nested_namespace:, :newname, :oldname


  # unused colors
  # config :colors, :secondary_color, 'cornflowerblue'
  # config :colors, :background_alt_color, '#181818'

  preset :light_colors,
    colors: {
      text_color: '#444',
      background_color: '#f9f9f9'

# $background-alt-color: #e6e6e6;
# border color #eee
# code color (grey on grey) #a0a0a0
# title color: #666
# btn : #ededed 38% #dedede

    }


#  preset :dark_theme, colors: {primary_color: '#456', secondary_color: '#123', youpi_color: "#012"}
  # this dark theme is beatifull with youpi in bg and primary for links

end
