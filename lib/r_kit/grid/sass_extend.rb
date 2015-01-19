module Sass::Script::Functions

  grid_base_width = if RKit::Grid.config.full_width
    value, unit = RKit::Grid.config.full_width
    Sass::Script::Number.new value / 94, unit
  else
    Sass::Script::Number.new *RKit::Grid.config.base_width
  end

  define_method 'grid_base_width' do
    grid_base_width
  end
end
