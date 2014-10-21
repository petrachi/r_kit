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

  # TODO: in decorator or in all(utility then), add a "conditionnal" keyword for ruby
  # that you declare either by "conditionnal do; def m; end; end"
  # or "conditionnal :m"
  # and this, will check a proc used passed as a param, or a symbol (and check for nil)
  # and basically, change the bahovior of the defnied method to use "then"
  # -> ex: conditionnal :serie_page, on: :serie
  # -> def serie_page; "prev >"; end
  # -> modified will be: alias :olsdef, :serie_page; def serie_page(*args, &block); serie.then{ old_def(*args, &block) }; end
  # --
  # can use the not done yet 'ovverride' method
end
