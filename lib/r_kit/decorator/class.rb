class RKit::Decorator::Class

  module OpenClass
    refine Class do
      def new super_class = Object, **options, &block
        super(super_class, &block).tap do |klass|
          options.each{ |key, value| klass.instance_variable_set "@#{ key }", value }
        end
      end
    end
  end
  using OpenClass

  # TODO: improve this "new" method, in order to move the creation of the decoraor klass for ARextend to here
  # ot should be able to accept a proc, a module, a class, or nil(autodetect)
  # -- While doing so, U could move the logic of Class.to_module && Module.to_class && Proc.to_class in "utilities" (or new rkit service)
  def self.new decorated_klass, &block
    Class.new(RKit::Decorator::Base, decorated_klass: decorated_klass, &block).tap do |klass|
      klass.class_eval{ alias :"#{ decorated_klass.demodulize.underscore }" :__getobj__ }
    end
  end
end
