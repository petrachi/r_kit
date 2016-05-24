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

    me = self

    RKit::Core::Helper::Man.new.inspect do
      title me.base.name
    end
  end

  def method_names
    @methods#.map(&:inspect).map{ |str| "# " + str }.join('\n')
  end

  delegate :print, to: 'RKit::Core::Helper::Printer'

  def inspect
    print self do
      title base.name
      list method_names.map(&:name)
    end
  end

end
