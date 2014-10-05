module Kernel

  def __class__
    self.class
  end

  def __namespace__
    (__class__.name.deconstantize.presence || 'Object').constantize
  end


  def running_script
    "#{ File.basename($0) } #{ ARGV.join " " }"
  end

  def running_script? script
    Regexp.new(script) =~ running_script
  end


  # TODO: think about a 'else' method => x.then{}.else{}
  # it could be done, when the 'then' return 'nil', we define an instance var in the singleton (possible on nil ?)
  # then reuse that into the else, as an arg to the block
  def then **options, &block
    if self && conditionnal_statement(options)
      block.call(self)
    else
      self
    end
  end

  def conditionnal_statement **options
    options.slice(:if, :unless).reduce(true) do |continue, (statement, condition)|
      continue && send(condition).tap do |closure|
        case statement
        when :if
          !!closure
        when :unless
          !closure
        end
      end
    end
  end

end
