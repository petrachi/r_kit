class RKit::ActiveRecordUtility

  dependency :dsl,
    :frame,
    :override,
    :utility

  load_path __FILE__,
    'active_record_extend',
    'database_schema_error'


  UTILITIES = Dir[File.join(File.dirname(__FILE__), "active_record_utility/utilities", "*.rb")].map do |file|
    File.basename file, ".rb"
  end

  config :all, true

  UTILITIES.each do |utility|


    alias_config utility, :all
    load_path __FILE__, "utilities/#{ utility }", if: utility
  end
end
