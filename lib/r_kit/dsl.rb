class RKit::Dsl

  dependency :struct

  load_path __FILE__, 'base.rb'
  load_path __FILE__, 'base/local_params.rb'
  load_path __FILE__, 'base/params.rb'
  load_path __FILE__, 'base/readonly.rb'
  load_path __FILE__, 'base/thrust.rb', priority: 1

  load_path __FILE__, 'dsl_definition_error.rb'
  load_path __FILE__, 'dsl_standard_error.rb'
  load_path __FILE__, 'no_lambda_error.rb'

  load_path __FILE__, 'dsl_extend.rb'
  load_path __FILE__, 'module_extend.rb'


  load_path __FILE__, 'test.rb'

end
