class RKit::Frame::EmptyFrame
  include Singleton

  def !() true end
  def empty?() true end
  def method_missing(*_) nil end
end
