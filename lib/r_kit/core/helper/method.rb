class RKit::Core::Helper::Method
  attr_accessor :name, :description, :parameters, :examples

  def initialize name
    @name = name
    @parameters = []
    @examples = []
  end


  def description value = nil
    if value
      @description = value
    else
      @description
    end
  end

  def parameter name, description
    @parameters << OpenStruct.new({name: name, description: description})
  end

  def example value
    @examples << value
  end



  def inspect
    %Q{
      #{ name }
      --
      #{ description }

      #{ parameters }

      #{ examples }
    }
  end

  def parameters
    @parameters.map{ |parameter| "# #{ parameter.name } - #{ parameter.description }" }.join("\n")
  end

  def examples
    @examples.map{ |example| "```ruby\n#{ example }\n```" }.join("\n")
  end
end
