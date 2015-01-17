module Sass::Script::Functions

  RKit::Css.config.colors.each do |name, value|
    color = Sass::Script.parse value, 0, 0
    define_method "#{ name }_color" do
      color
    end
  end
end
