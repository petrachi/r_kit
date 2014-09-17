class RKit::Utility
  UTILITIES = %i{array hash kernel symbol}


  config :extends, true

  UTILITIES.each do |utility|
    alias_config "#{ utility }_extend", :extends
    load_path __FILE__, "#{ utility }_extend.rb", if: "#{ utility }_extend"
  end

  # TODO: class_extend: to_module, ancestor=
  # TODO: module_extend: to_class
  # TODO: enumerable_extend/or-array_extend: with_indifferent_access
  # TODO: get back some code from hash_extend && array_extend gems
end
