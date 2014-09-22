class RKit::Decoration

  # TODO: backtrace is not really a dependency,
  # as we, most of the time, get the view context from the block
  # and if not, we do not require the "view_context" (well, we could not, I think)
  # (the only case is if the user define a block elswhere than in the view or in the controller, and use it)
  # (but this case will fail today as well, I think)
  dependency :backtrace


  load_path __FILE__, 'base.rb'
  load_path __FILE__, 'class.rb'

  load_path __FILE__, 'action_view_base_extend.rb'
  load_path __FILE__, 'active_record_extend.rb'


  config :auto_decoration, true
end
