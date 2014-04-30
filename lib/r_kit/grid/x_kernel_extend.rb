require 'continuation' if RUBY_VERSION >= '1.9.0'

# every this will need to move in "extends" service
# this service will require ":if" option on load path
# the :if option will take a proc, with one arg, the "config"

# now, even in the class, this could be a "basic" and "advanced" extends
# maybe
# and th "dependencie" could include the service, but also a minimal config

module Kernel

  def __class__
    self.class
  end

  def caller_binding stop = 2
    cc = nil
    count = 0

    set_trace_func lambda { |event, file, lineno, id, binding, klass|
      if count == stop
        set_trace_func nil
        cc.call binding
      elsif event == "return"
        count += 1
      end
    }
    return callcc { |cont| cc = cont }
  end

  
end
