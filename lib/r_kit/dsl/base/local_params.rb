module RKit::Dsl::Base::LocalParams

  def persisting_binding
    @persiting_binding ||= binding
  end

  def method_missing method_name, *args, &block
    case method_name
    when *persisting_binding.eval("local_variables")
      persisting_binding.eval method_name.to_s
    else
      super
    end
  end

end
