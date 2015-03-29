class RKit::Core::Helper
  attr_accessor :description, :methods
  attr_reader :base

  def initialize base
    @base = base
    @methods = []
  end



  def description value = nil
    if value
      @description = value
    else
      @description
    end
  end

  def method name, &block
    @methods << Method.new(name).tap do |method|
      method.instance_eval &block
    end
  end



  def inspect
    %Q{
      #{ base }

      #{ description }

      Methods
      #{ methods }
    }
  end

  def methods
    @methods.map(&:inspect).map{ |str| "# " + str }.join('\n')
  end
end
