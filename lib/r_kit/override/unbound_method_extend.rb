class UnboundMethod

  def simple_override receiver:, &block
    name = self.name
    receiver.prepend Module.new{ define_method name, &block }
  end

end
