class Symbol
  delegate :classify, :ivar, to: :to_s
end
