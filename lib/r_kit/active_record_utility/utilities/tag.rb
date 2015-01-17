class RKit::ActiveRecordUtility::Tag
  act_as_a_dsl

  name :tag_dsl
  method :acts_as_taggables
  domain ActiveRecord::Base

  allowed? do
    table_exists? &&
      column_names.include?("tag") &&
      columns_hash["tag"].type == :string
  end

  restricted do
    raise DatabaseSchemaError.new(self, method_name: tag_dsl.method)
  end


  methods :class do
    validates_presence_of :tag
    validates_uniqueness_of :tag

    def tagged(tag) find_by tag: tag.underscore end
  end

  methods :instance do
    def to_param() tag.dasherize end
  end

  methods :decorator do
    delegate :to_param, to: :__getobj__
  end

end
