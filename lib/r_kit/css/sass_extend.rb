module Sass::Script::Functions
  [
    :primary_color,
    :secondary_color
  ].each do |variable_name|
    define_method variable_name do
      Sass::Script::String.new RKit::Css::CONFIG.send(variable_name)
    end
  end
end
