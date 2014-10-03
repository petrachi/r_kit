class Proc

  def extract_parameters *args, **options, &block
    before_rest = true

    parameters.reduce({}) do |params, (type, name)|
      value = case type
      when :opt
        # TODO: default_value? -> this will be set to nil, must define a warning, or raise an error
        # TODO: this is a problem with declaration like: (arg1, arg2 = nil, *args, arg4)
        # we can do smthng like:
        # first proccess 'block'
        # then process 'options'
        # then process 'args'
        # -> first process all req at the begining
        # -> then process all req at the end
        # -> then process all opt at the begining
        # -> then process rest
        # TODO: or, find thehow to access the default value
        before_rest ? args.shift : args.pop
      when :req
        before_rest ? args.shift : args.pop
      when :rest
        before_rest = false
        args
      when :key
        options.delete name # TODO: default_value? -> this will be set to nil
      when :keyreq
        options.delete name
      when :keyrest
        options
      when :block
        block
      end

      params[name] = value
      params
    end
  end

end
