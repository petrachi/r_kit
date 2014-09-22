class RKit::ActiveRecordUtility::Base::Pool < RKit::ActiveRecordUtility::Base

  instance_interferences do
    inclusion_in = interferences_options_get.fetch :in

    validates_presence_of :pool
    validates_inclusion_of :pool, in: inclusion_in if inclusion_in

    scope :pool, ->(pool){ pool && where(pool: pool) }
    scope :pools, ->{ group(:pool).pluck(:pool) }
  end

  decorator_interferences do
    def pool_url
      view.url_for [__class__, pool: pool]
    end

    def link_to_pool
      view.link_to pool, pool_url, class: :btn
    end
  end


  def can_interfere?
    base.table_exists? &&
      base.column_names.include?("pool") &&
      base.columns_hash["pool"].type == :string
  end
end
