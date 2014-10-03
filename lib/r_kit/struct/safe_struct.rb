class SafeStruct

  def self.new allowed:, defaults: {}
    Class.new do
      @allowed = allowed.map(&:ivar)
      @defaults = defaults

      def self.allowed() @allowed end
      def self.defaults() @defaults end


      attr_reader *allowed, default: proc{ |_, name| defaults[name] }
      attr_writer *allowed

      def initialize **options
        options.keys.each do |name|
          instance_variable_set "@#{ name }", options[name]
        end
      end

      def instance_variable_set name, value
        super if __class__.allowed.include? name
      end


      def to_hash
        instance_variables.reduce({}) do |options, name|
          options[name.lvar] = instance_variable_get name
          options
        end
      end
    end
  end

end
