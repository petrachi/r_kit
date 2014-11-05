class RKit::Decoration::Collection < CollectionDelegator
  include RKit::Decoration::Base

  singleton_attr_reader :decorated_class


  attr_accessor :safe_mode

  def safe() tap{ @safe_mode = true } end
  def unsafe() tap{ @safe_mode = false } end


  def each &block
    collection.each do |object|
      if safe_mode && object.dont_respond_to?(:decorate)
        block.call object
      else
        block.call object.decorate(view_context: view)
      end
    end
  end
end
