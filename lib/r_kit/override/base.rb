class RKit::Override::Base

  def self.override *args
    new(*args).override
  end


  attr_accessor :method_name, :method, :pattern, :receiver

  def initialize method_name, method:, pattern:, pattern_args:, receiver:;
    @method_name = method_name
    @method = method
    @pattern = RKit::Override::Pattern.build(pattern, *pattern_args)
    @receiver = receiver
  end

  def override
    override_method
    # TODO: hook_method
  end


  module Nodef

    def self.__nodef__ method_name
      define_method :__olddef__ do |*args, &block|

        if respond_to?(:__getobj__) && __getobj__.respond_to?(method_name)
          __getobj__.send(method_name, *args, &block)

        else
          owner = self.class.instance_method(method_name).owner
          __newdef__ = owner.instance_method(method_name)
          owner.send :remove_method, method_name

          closure = if respond_to?(method_name)
            send(method_name, *args, &block)
          end

          owner.send(:define_method, method_name, __newdef__)
          closure
        end
      end

      instance_method :__olddef__
    end

  end


  def __olddef__
    __olddef__ = receiver.instance_method(method_name)

    proc do |*args, &block|
      __olddef__.bind(self).call(*args, &block)
    end
  rescue NameError
    Nodef.__nodef__(method_name)
  end

  def __newdef__
    method
  end








  protected def override_method
    oneself = self
    # override_binding = Module.new{
    #   define_method :__olddef__, oneself.__olddef__
    #   define_method :__newdef__, oneself.__newdef__
    #   define_method :override, oneself.pattern
    # }

    old_m = oneself.__olddef__
    new_m = oneself.__newdef__
    ove_m = oneself.pattern

    override_binding = proc{
      define_method :__olddef__, old_m
      define_method :__newdef__, new_m
      define_method :override, ove_m
    }

    # forget_binding = proc{
    #     remove_method :__olddef__
    #     remove_method :__newdef__
    #     remove_method :override
    #   }


    receiver.send :define_method, method_name do |*args, &block|

      #p self.singleton_class.included_modules
      #p

#      self.extend override_binding #unless self.singleton_class.include?(override_binding)
#  p "add"



      (class << self; self; end).instance_eval &override_binding


      closure = self.override *args, &block
      #closure = instance_eval(&ove_m)


#      p "delete"
#      (class << self; self; end).class_eval &forget_binding rescue nil
       closure

    end
  end

  protected def override_hook

  end

end
