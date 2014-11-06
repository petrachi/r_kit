class RKit::Decoration::Collection < CollectionDelegator
  include RKit::Decoration::Base


  attr_accessor :safe_mode

  def safe() tap{ @safe_mode = true } end
  def unsafe() tap{ @safe_mode = false } end


  def initialize *args
    safe_mode = self.safe_mode

    super

    class << __getobj__
      alias :basic_each :each
      define_method :each, ->(&block) do
        decorated.each &block
      end
    end
  end

  def each &block
    collection.basic_each do |object|
      if safe_mode && object.dont_respond_to?(:decorate)
        block.call object
      else
        block.call object.decorate(view_context: view)
      end
    end
  end
end
