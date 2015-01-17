class Symbol
  delegate :classify, :constantize, :dasherize, :safe_constantize, :ivar, :lvar, to: :to_s
end
