class RKit::ActiveRecordUtility
  dependency :utilities

  load_path __FILE__, 'active_record_extend.rb'
  load_path __FILE__, 'database_schema_error.rb'
  load_path __FILE__, 'utility.rb'

  UTILITIES = {
    tag: :acts_as_taggables,
  }

  UTILITIES.each do |utility, _|
    load_path __FILE__, "utility/#{ utility }.rb"
  end
end
