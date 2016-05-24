class RKit::Core::Helper::Printer < SimpleDelegator

  def self.print object, &block
    new(object).instance_eval &block
  end

  def initialize object
    super object
    @_str = ""
  end



  def title value
    @_str << "+" << "-" * (value.size + 2) << "+\n"
    @_str << "I " << value << " I\n"
    @_str << "+" << "-" * (value.size + 2) << "+\n"
  end

  def list values
    @_str << values.map{ |value| "* " << value << "\n" }.join("")
  end

end
