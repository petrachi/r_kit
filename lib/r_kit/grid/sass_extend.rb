module Sass::Script::Functions

  base_width = if RKit::Grid.config.full_width
    value, unit = RKit::Grid.config.full_width
    Sass::Script::Number.new value / 94, unit
  else
    Sass::Script::Number.new *RKit::Grid.config.base_width
  end

  define_method 'base_width' do
    base_width
  end
end
