class Method

  def simple_override &block
    name = self.name
    receiver.singleton_class.prepend Module.new{ define_method name, &block }
  end

end
