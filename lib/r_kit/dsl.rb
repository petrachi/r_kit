class RKit::Dsl

  dependency :struct

  load_path __FILE__,
    'base',
    'base/local_params',
    'base/params',
    'base/readonly'

  load_path __FILE__, 'base/thrust', priority: 1

  load_path __FILE__,
    'dsl_definition_error',
    'dsl_standard_error',
    'no_lambda_error'

  load_path __FILE__,
    'dsl_extend',
    'module_extend'



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

  # TODO: semi-linked to inheritance, allow to define methods via multiple blocks
  # so if a block is already define, just add the new one to the old one
  # TODO: also allow to 'override' completely the old block declaration
  # (maybe 'methods instance: :override do ... end')

  # TODO: Handle correctly the possibility to add the dsl in other domains
  # today, it's done via "shadowing" the @domain

  # TODO: The "readonly" mode should be the default mode for everyone,
  # except (of course) the dsl_declaration class (the class that used 'act_as_dsl')
  # -> to do that, either, interchage all the methods (painfull)
  # -> or, try to replace the const_name when 'act_as_dsl' is used (pb when re-opening the class ?)

  # TODO: rkit: on dsl, I lac of a callback when dsl is put in another class
  # (like a 'def self.decorated(decorator)' for example).
  # I know I can put the code in 'class methods',
  # but I may also want a specific callback from the calling class ?
  # (maybe smthng like "before_acts_as_X + after_act_as_X") ("self.yanked" "self.X-ed")

  # TODO: make smthing to define methods on the "domain" level
  # for example, in the series dsl, I could define a method "per_page" in all the domain, that would return '[]'
  # and when dsl is added, that would return an array with all the series
  # --> before doing that, find a real use case, it may be a duplication of 'can_as_as_X?'

  # TODO: this service could be totaly rework
  # instead of actually adding behavior in classes
  # it only create a Delegator object, with the behavior inside it
  # then, it delegates all methods defined by the 'dsl' to this Delegator object
  # --> maybe this is the idea behind the 'context/puppet' service
  # --> and may be not good for DSL
  # acts_as_dsl -> will add 'sinpleDelegator' to the ancestors -> then -> name(?)+method+domain
  # then -> def self.clas_method, -> def instance_method
  # then, in host class -> act_as_x -> define "@X", X_delegator(self), delegate *X.methods, to: @X


  # TODO: waiting for decoration
  # there is a "decorator" methods you can define. but the object must already be decorable.
  # I want to eager load this behavior
  # if the object is not decorable, save the decorator methods somewhere
  # then, when the object becomes decorables, add these methods to the decorator!

  # load_path __FILE__, 'test'

end
