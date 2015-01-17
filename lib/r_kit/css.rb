class RKit::Css

  with_engine __FILE__
  with_sprockets __FILE__

  config :colors, :black, '#111'
  config :colors, :dark_black, '#000'
  config :colors, :grey, '#888'
  config :colors, :light_black, '#181818'
  config :colors, :red, '#b62b2b'
  config :colors, :goldenrod, '#daa520'
  config :colors, :white, '#fbfbfb'

  alias_config :colors, :primary, :red
  alias_config :colors, :link, :goldenrod
  alias_config :colors, :text, :grey
  alias_config :colors, :text_alt, :dark_black
  alias_config :colors, :background, :black
  alias_config :colors, :background_alt, :light_black

  alias_config :colors, :btn, :background
  alias_config :colors, :btn_background, :primary
  alias_config :colors, :btn_disabled, :text_alt
  alias_config :colors, :btn_disabled_background, :background_alt


  # unused colors
  # config :colors, :secondary_color, 'cornflowerblue'
  # config :colors, :background_alt_color, '#181818'

  preset :light_colors,
    colors: {
      text: '#444',
      background: '#f9f9f9'

# $background-alt-color: #e6e6e6;
# border color #eee
# code color (grey on grey) #a0a0a0
# title color: #666
# btn : #ededed 38% #dedede

    }


#  preset :dark_theme, colors: {primary_color: '#456', secondary_color: '#123', youpi_color: "#012"}
  # this dark theme is beatifull with youpi in bg and primary for links

end
