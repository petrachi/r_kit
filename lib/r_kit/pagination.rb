class RKit::Pagination

  dependency :decoration,
    :dsl,
    :struct,
    :utility


  load_path __FILE__,
    'base.rb',
    'base/page.rb'

  load_path __FILE__, 'active_record_extend.rb'

  # TODO: add a "wrap" option to the config method, that will be used like this
  # config :per_page, 16, wrap: ->(value){ Hash.new(value) }
  # in this case: this allow the user to only set a default number
  # but we, in the code, need a hash with that default value
  # so, in our use, the value "16" will be wrapped in a hash, as the default value of this hash
  # and to the user, he only see a default "per_page" number. (he does not want to know that we use a hash in fact)
  # --
  # To do this, I think that we will need a serious rework of the "configurer" core class
  # and consider each config value to be an instance of a "config_value" class (under the configurer namespace)
  # (we did it once for "loader", we can do it again!)
  config :per_page, Hash.new(16)
end
