class RKit::Decorator

  dependency :backtrace


  load_path __FILE__, 'base.rb'
  load_path __FILE__, 'class.rb'

  load_path __FILE__, 'action_view_base_extend.rb'
  load_path __FILE__, 'active_record_extend.rb'


  config :auto_decoration, true
end
