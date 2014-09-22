class RKit::Backtrace

  # TODO: continuation is problematic with views
  # we may want to put a warning if the gem 'binding_of_caller' is not included
  # or we could directly include the C enxtention, with permission of the owner of the gem

  load_path __FILE__, 'kernel_extend.rb'

end
