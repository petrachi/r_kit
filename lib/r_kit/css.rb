class RKit::Css

  with_engine __FILE__
  with_sprockets __FILE__

  config :colors, :white, '#fbfbfb'

  config :colors, :primary_color, '#b62b2b'
  config :colors, :text_color, '#888'
  config :colors, :background_color, '#111'


  alias_config :colors, :btn_color, :background_color
  alias_config :colors, :btn_background_color, :primary_color

  alias_config :colors, :link_color, :primary_color

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
