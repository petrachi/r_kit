module Sass::Script::Functions

  RKit::Css.config.colors.each do |name, value|
    define_method name do
      Sass::Script::String.new value
    end
  end
end
