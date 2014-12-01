class RKit::Frame::InstanceDsl

  act_as_a_dsl

  name :framed_instance_dsl
  method :acts_as_frameable
  domain Object

  before do
    def frame
      @sy_frame || RKit::Frame::EmptyFrame.instance
    end

    def frame= value
      @sy_frame = value
    end


    def framed &block
      shadow sy_frame: block.binding.eval('self') do |obj|
        block.call obj
      end
    end

    def framed?
      !!frame
    end
  end

end
