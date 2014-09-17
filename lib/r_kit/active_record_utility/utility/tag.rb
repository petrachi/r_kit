class RKit::ActiveRecordUtility::Utility::Tag < RKit::ActiveRecordUtility::Utility

  def can_interfere?
    base.table_exists? && base.column_names.include?("tag")
  end

  def interfere!
    base.validates_presence_of :tag
    base.validates_uniqueness_of :tag

    base.send :define_method, :to_param, ->{ tag }
    base.send :define_singleton_method, :tagged, ->(tag){ find_by tag: tag }
  end
end
