class RKit::Frame::CollectionDsl

  act_as_a_dsl

  name :framed_collection_dsl
  method :acts_as_frameable_collection
  domain Enumerable


  methods :instance do

    override_method :each do |&block|
      __olddef__ &->(obj) do

        obj.shadow sy_frame: self do |obj|
          block.call(obj)
        end

      end
    end

  end

end
