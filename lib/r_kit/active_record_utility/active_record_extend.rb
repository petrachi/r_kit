class ActiveRecord::Base

  override_singleton_method :scope do |name, body, &block|
    __olddef__(name, body, &block).tap do |scope_name|

      override_singleton_method scope_name do |*args, &block|
        __olddef__(*args, &block).tap do |collection|
          collection.scopes << scope_name
        end
      end

    end
  end


  depend on: :frame do
    def scoped? *args
      frame.scoped? *args
    end
  end

end


class ActiveRecord::Relation

  attr_reader :scopes, default: proc{ [] }

  def scoped? name
    scopes.include? name
  end

  RKit::Frame::CollectionDsl.domain self
  acts_as_frameable_collection

end
