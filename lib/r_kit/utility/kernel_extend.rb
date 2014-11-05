module Kernel

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

  # TODO: check for ".present?/.presence" when 'send(method_name)', in case of non nil but empty
  # TODO: also, allow to send objects in 'if/unless', and only send if symbol, or exec if proc
  def conditionnal_statement **options
    options.slice(:if, :unless).reduce(true) do |continue, (statement, method_name)|
      continue && send(method_name).tap do |closure|
        case statement
        when :if
          !!closure
        when :unless
          !closure
        end
      end
    end
  end



  def shadow *names, &block
    saved_state = names.reduce({}) do |saved_state, name|
      saved_state[name] = instance_variable_get name.ivar
      saved_state
    end

    closure = block.call(self)

    names.each do |name|
      instance_variable_set name.ivar, saved_state[name]
    end

    closure
  end



  def dont_respond_to? *args, &block
    !respond_to? *args, &block
  end

end
