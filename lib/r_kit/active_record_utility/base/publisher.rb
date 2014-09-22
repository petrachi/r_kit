class RKit::ActiveRecordUtility::Base::Publisher < RKit::ActiveRecordUtility::Base

  instance_interferences do
    before_validation do
      self.published_at = Time.now if !published_at && published
    end

    validates_presence_of :published_at, if: :published

    scope :published, ->{ where(published: true) }
    scope :publication_asc, ->{ order("published_at ASC") }
    scope :publication_desc, ->{ order("published_at DESC") }
  end

  decorator_interferences do
    def published_at
      super().strftime "%a %e %b %Y"
    end
  end


  def can_interfere?
    base.table_exists? &&
      base.column_names.include_all?(["published", "published_at"]) &&
      base.columns_hash["published"].type == :boolean &&
      base.columns_hash["published_at"].type == :datetime
  end
end
