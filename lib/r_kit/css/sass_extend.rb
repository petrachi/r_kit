module Sass::Script::Functions

  RKit::Css.config.colors.each do |name, value|
    color = Sass::Script::Value::Color.from_hex(value)
    define_method "#{ name }_color" do
      color
    end
  end
end
