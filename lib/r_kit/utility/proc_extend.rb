class Proc

  def extract_parameters *args, **options, &block
    parameters.inject({}) do |params, (type, name)|
      value = case type
      when :opt
        args.shift # default_value? -> this will be set to nil
      when :req
        args.shift # I don't handle :req args that are AFTER the :rest param
      when :rest
        args
      when :key
        options.delete name # default_value? -> this will be set to nil
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
