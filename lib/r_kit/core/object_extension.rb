module RKit::Core::ObjectExtension
  def core_extend method_name, *args, &block
    unless method_defined? method_name
      define_method method_name, *args, &block
    end
  end
end
