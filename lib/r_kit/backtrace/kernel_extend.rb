module Kernel

  def _backtrace_from_ruby_vm &block
    stack_level = 0
    block ||= ->(obj){ obj != self }

    RubyVM::DebugInspector.open do |inspector|
      loop do
        stack_binding = begin
          inspector.frame_binding(stack_level += 1)
        rescue ArgumentError
          nil
        end

        obj = stack_binding.try :eval, 'self'
        return obj if obj != self && block.call(obj)
      end
    end
  end

  def _backtrace_from_continuation &block
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


  if RubyVM.const_defined? 'DebugInspector'
    alias :backtrace :_backtrace_from_ruby_vm
  else
    require 'continuation'
    alias :backtrace :_backtrace_from_continuation
  end
end
