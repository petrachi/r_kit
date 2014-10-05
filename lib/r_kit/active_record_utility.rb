class RKit::ActiveRecordUtility

  dependency :dsl,
    :utility

  load_path __FILE__,
    'base.rb',
    'database_schema_error.rb'

  load_path __FILE__, 'active_record_extend.rb'



  UTILITIES = Dir[File.join(File.dirname(__FILE__), "active_record_utility/base", "*.rb")].map do |file|
    File.basename file, ".rb"
  end

  config :all, true

  UTILITIES.each do |utility|


    alias_config utility, :all
    load_path __FILE__, "base/#{ utility }.rb", if: utility
  end
end
