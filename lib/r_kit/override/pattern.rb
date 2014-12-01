class RKit::Override::Pattern

  def self.build *args
    new(*args).build
  end


  attr_accessor :pattern, :args

  def initialize pattern, *args
    @pattern = pattern
    @args = args
  end

  def build
    send "build_from_#{ pattern.class.name.underscore }"
  end


  protected def build_from_proc
    pattern
  end

  protected def build_from_string
    self.class.const_get("#{ pattern.upcase }_PATTERN").call(*args)
  end
  alias :build_from_symbol :build_from_string


  STANDARD_PATTERN = -> *_ do
    ->(*args, &block){ __newdef__(*args, &block) }
  end

  DEPEND_PATTERN = -> on: do
    -> *args, &block do
      if send(on).present?
        __newdef__(*args, &block)
      else
        nil
      end
    end
  end

  IF_PATTERN = -> on: do
    -> *args, &block do
      if send(on).present?
        __newdef__(*args, &block)
      else
        __olddef__(*args, &block)
      end
    end
  end
end
