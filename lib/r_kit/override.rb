class RKit::Override

  load_path __FILE__,
    'method_extend',
    'module_extend',
    'unbound_method_extend'


  # TODO: description
  # note for docs
  # this service provide 'override method' method, that allow you to use 'super' when overriding a method defined in the same class
  # ex :
  # I don't want
  # class A;
  #   def toto; "toto"; end;
  #
  #   alias :basic_toto, :toto
  #   def toto; basic_toto << "overrided"; end
  # end
  # --
  # I want
  # class A;
  #   def toto; "toto"; end;
  #
  #   override_method :toto do; super() << "overrided"; end
  # end
  # <<<<<<<<<<<<<<<<<
  # There is 'override_method', 'override_singleton_method', which delegates to: UnboundMethod.override (instance_meth) & Method.override (class meth)


  # TODO: use that in a lot of 'utility' override, search for 'alias'

  # TODO: create a dsl around that, to do some classic override.
  # First one will be 'depend_on :x', wich exec the method only if send(:x) is not nil, else, will return nil
  # --> will be used in series (and maybe pagination?)

end
