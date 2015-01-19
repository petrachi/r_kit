class Symbol
  delegate :classify,
    :constantize,
    :dasherize,
    :titleize,
    :safe_constantize,
    :ivar,
    :lvar,
    to: :to_s
end
