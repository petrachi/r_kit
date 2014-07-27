module RKit::ActiveRecordUtility::ActiveRecordExtend

  def acts_as_taggables
    if table_exists? and column_names.include? "tag"
      include RKit::ActiveRecordUtility::Utilities::Tag
    else
      # TODO: Put a link to the doc
      warn %Q{
WARNING - You tried to use the 'acts_as_taggables' DSL on '#{ self }',
  You may want to create a 'tag' column first.
  To do so, please refer to the 'RKit::ActiveRecordUtlity' documentation.
      }
    end
  end


  ActiveRecord::Base.extend self
end
