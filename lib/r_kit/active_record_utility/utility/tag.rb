class RKit::ActiveRecordUtility::Utility::Tag < RKit::ActiveRecordUtility::Utility

  instance_interferences do
    validates_presence_of :tag
    validates_uniqueness_of :tag

    def tagged(tag) find_by tag: tag end
  end

  class_interferences{ def to_param() tag end }

  def can_interfere?
    base.table_exists? &&
      base.column_names.include?("tag") &&
      base.columns_hash["tag"].type == :string
  end
end
