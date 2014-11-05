class Symbol
  delegate :classify, :constantize, :safe_constantize, :ivar, :lvar, to: :to_s
end
