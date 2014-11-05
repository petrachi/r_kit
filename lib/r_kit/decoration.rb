class RKit::Decoration

  # TODO: backtrace is not really a dependency,
  # as we, most of the time, get the view context from the block
  # and if not, we do not require the "view_context" (well, we could not, I think)
  # (the only case is if the user define a block elswhere than in the view or in the controller, and use it)
  # (but this case will fail today as well, I think)
  # -> pb w/ backtrace in console (Screencast.limit(5).decorate.map{|x|x} -> infinite loop)
  dependency :backtrace,
    :dsl,
    :utility


  load_path __FILE__,
    'base',
    'base/collection',
    'base/object',
    'class',
    'dsl',
    'enumerable_extend'

  load_path __FILE__, 'action_view_base_extend', if: :implicit_decoration


  config :implicit_decoration, true

  # TODO: read a todo in 'dsl' called 'waiting for decoration'

  # TODO: decoration needs to be recursive
  # I think this can be done by overrding the method missing method from simple delegator
  # a little like what we've done for the 'each' method in collection delegator

end
