class RKit::Override

  load_path __FILE__,
    'base',
    'method_extend',
    'module_extend',
    'pattern',
    'unbound_method_extend'

  # load_path __FILE__, 'test'
  # load_path __FILE__, 'perfs'

  # TODO: config for 'simple_override' -> active or not ?

  # TODO: allow to explicitly set the 'olddef', so U can use patterns w/ more flexibility
  # like: def try_to_x; ...; end
  # define :x, depend: :x_allowed, olddef: :try_to_x do; raise; end
  # so the final code is like
  # def x; if x_allowed; trye_to_x; else; raise; end; end


  description %q{
    `RKit::Override` define a single way to override methods in ruby. By defining a keyword named `__olddef__`, the same code can be used to override a method, wether its current behavior is found though inheritance, delagation or previous 'in-class' definition (usually when working with modules or DSLs).
  }

  method "Module#override_method" do
    description %q{
      This method allows to use the keyword `__olddef__` when redefining a method. It can take a `pattern` as an argument, usefull when defining many methods based on the same construction.
    }

    parameter :method_name, "Identify the method to override"
    parameter :method, "Can be used instead of a block to define the overriding code"
    parameter :pattern, "Can be used to wrap the overriding code inside the pattern strcuture"
    parameter :pattern_args, "Can be used in addiation to `pattern`, to send params to it"
    parameter :block, "Define the overriding code, can be ommited if `method` is send"

    example %q{
      class Spacecraft
        def speed
          150_000
        end
      end

      class Spacecraft3000 < Spacecraft
        override_method :speed do
          __olddef__ + 300_000
        end
      end

      ?> Spacecraft3000.new.speed
      => 450000
    }

    example %q{
      class Spacecraft
        def speed
          150_000
        end
      end

      require 'delegate'
      class Spacecraft3000 < SimpleDelegator
        override_method :speed do
          __olddef__ + 300_000
        end
      end

      ?> Spacecraft3000.new(Spacecraft.new).speed
      => 450000
    }

    example %q{
      module NASA
        def acts_as_spacecrafts
          define_method("speed"){ 150_000 }
        end

        Object.extend self
      end

      class Spacecraft3000
        acts_as_spacecrafts

        override_method :speed do
          __olddef__ + 300_000
        end
      end

      ?> Spacecraft3000.new.speed
      => 450000
    }
  end
end
