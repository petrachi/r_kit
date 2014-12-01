class RKit::Pagination

  dependency :decoration,
    :dsl,
    :override,
    :struct,
    :utility


  load_path __FILE__,
    'base',
    'base/page',
    'dsl',
    'enumerable_extend'


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


  # TODO: we need to be hable to paginate any kind of collection

  # TODO: limited_collection, total_pages & pages can change, based on scopes or "page & per_page" config
  # So we need a "@loaded" instance_variable
  # that will have the same role as in AR::Relation
  # -> either, can't scope if loaded
  # -> either, empty the 3 "based on scope/config" variables
  # --
  # or, we don't memoize the 3 problematic vars
  # wich will be my choice right now


  # TODO: the "per_page" will be settable either by an arg in the method,
  # or by an option, per model, in the dsl (access by Article.all.instance_variable_get "@klass")
  # or in the "pagination" config
  # the "current page" will be 1 by default

  # TODO: Raise an error if the collection has a "limit" or an "offset" (before or after pagination initialization)
  # here is the pagination method scope : Paginator::Collection.new(scoped).limit(per).offset((page-1) * per)

  # TODO: Define an option to use pagination based on instance, in this case, the "per_page" is set to one
  # and the "pagination_tag" accept a block to display the "page number"

end
