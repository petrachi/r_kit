class RKit::Decorator < RKit::Core

  dependency :backtrace


  load_path __FILE__, 'base.rb'

  load_path __FILE__, 'active_record_extend.rb'
  
end
