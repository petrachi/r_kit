class DslStandardError < StandardError
  def initialize base, method_name:;
    super %Q{
WARNING - You tried to use the '#{ method_name }' DSL on '#{ base }',
  Sadly, something went wrong, it seems that you can't use that DSL on your Class
  Please, refer to the corresponding documentation
    }
  end
end
