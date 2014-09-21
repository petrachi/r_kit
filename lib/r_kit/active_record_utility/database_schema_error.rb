class DatabaseSchemaError < StandardError
  def initialize base, method_name:;
    super %Q{
WARNING - You tried to use the '#{ method_name }' DSL on '#{ base }',
  Your database is not ready for it yet,
  You can refer to the 'RKit::ActiveRecordUtlity' documentation.
    }
  end
end
