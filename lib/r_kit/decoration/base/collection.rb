class RKit::Decoration::Collection < CollectionDelegator
  include RKit::Decoration::Base

  def initialize *args
    super

    self.singleton_class.send :override_method, :each do |&block|
      __olddef__ do |object|
        if object.need_decoration?
          block.call object.decorate(view_context: view)
        else
          block.call object
        end

      end
    end

    self.extend Enumerable
  end
end
