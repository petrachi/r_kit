class DatabaseSchemaError < StandardError
  # TODO: does that class already exists ???
  # TODO: allow to send a custom message, that will replace 2° & 3° lines
  def initialize base, method_name:;
    super %Q{
DatabaseSchemaError: You tried to use the '#{ method_name }' DSL on '#{ base }',
  Your database is not ready for it yet,
  You can refer to the 'RKit::ActiveRecordUtlity' documentation.
    }
  end
end
