class RKit::ActiveRecordUtility::Base::Publisher < RKit::ActiveRecordUtility::Base

  act_as_a_dsl

  name :publisher_dsl
  method :acts_as_publishables
  domain ActiveRecord::Base

  allowed? do
    table_exists? &&
      column_names.include_all?(["published", "published_at"]) &&
      columns_hash["published"].type == :boolean &&
      columns_hash["published_at"].type == :datetime
  end

  restricted do
    raise DatabaseSchemaError.new(self, method_name: publisher_dsl.method)
  end


  methods :class do
    before_validation do
      self.published_at = Time.now if !published_at && published
    end

    validates_presence_of :published_at, if: :published

    scope :published, ->{ where(published: true) }
    scope :publication_asc, ->{ order("published_at ASC") }
    scope :publication_desc, ->{ order("published_at DESC") }
  end

  methods :decorator do
    def published_at
      super().strftime "%a %e %b %Y"
    end
  end

end
