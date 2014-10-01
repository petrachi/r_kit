class Symbol
  delegate :classify, :to_ivar, to: :to_s
end
