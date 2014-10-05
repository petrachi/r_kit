class RKit::Dsl

  dependency :struct

  load_path __FILE__,
    'base.rb',
    'base/local_params.rb',
    'base/params.rb',
    'base/readonly.rb'

  load_path __FILE__, 'base/thrust.rb', priority: 1

  load_path __FILE__,
    'dsl_definition_error.rb',
    'dsl_standard_error.rb',
    'no_lambda_error.rb'

  load_path __FILE__,
    'dsl_extend.rb',
    'module_extend.rb'



  # TODO: Handle dsl inheritance
  # class X; acts_as_a_dsl; restricted do ... end; end
  # class Y < X; name+method+domain end
  # and allow to use 'super'
  # ->
  # this can be achieved defining 'inerited' on dsl_extend (not 'self.inherited')
  # at this point, we create the @_dsl with a copy of the previous one, except 'name' 'method'
  # pb is for 'domain', wich is normally the trigger to thrust
  # ->
  # and we need to also handle the 'domain' on the parent class
  # on that, it need not trigger the 'thrust'

  load_path __FILE__, 'test.rb'

end
