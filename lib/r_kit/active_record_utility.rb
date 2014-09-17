class RKit::ActiveRecordUtility
  dependency :utilities

  load_path __FILE__, 'active_record_extend.rb'
  load_path __FILE__, 'database_schema_error.rb'
  load_path __FILE__, 'utility.rb'

  UTILITIES = {
    pool: :acts_as_poolables,
    tag: :acts_as_taggables,
  }


  config :all, true

  UTILITIES.each do |utility, _|
    alias_config utility, :all
    load_path __FILE__, "utility/#{ utility }.rb", if: utility
  end
end
