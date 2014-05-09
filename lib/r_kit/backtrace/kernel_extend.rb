require 'continuation'

module Kernel

  def backtrace &block
    cc = nil
    block ||= ->(obj){ obj != self }

    tracer = TracePoint.trace(:return) do |tp|
      if tp.self != self && block.call(tp.self)
        tracer.disable
        cc.call tp.self
      end
    end

    backtrace = callcc { |cont| cc = cont }
    backtrace unless backtrace.is_a? Continuation
  end

end
