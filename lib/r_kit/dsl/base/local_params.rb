module RKit::Dsl::Base::LocalParams

  def persisting_binding
    @persiting_binding ||= binding
  end

  def method_missing method_name, *args, &block
    persisting_binding.eval method_name.to_s
  rescue
    super
  end

end
