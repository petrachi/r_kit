class DatabaseSchemaError < StandardError
  def initialize base, method:;
    super %Q{
WARNING - You tried to use the '#{ method }' DSL on '#{ base }',
  You may want to create a 'tag' column first.
  To do so, please refer to the 'RKit::ActiveRecordUtlity' documentation.
    }
  end
end
