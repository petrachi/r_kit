class Symbol
  delegate :classify, :ivar, :lvar, to: :to_s
end
