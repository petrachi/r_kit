class RKit::ActiveRecordUtility::Utility::Pool < RKit::ActiveRecordUtility::Utility

  def can_interfere?
    base.table_exists? && base.column_names.include?("pool")
  end

  def interfere! **options
    inclusion_in = options.fetch :in

    base.validates_presence_of :pool
    base.validates_inclusion_of :pool, in: inclusion_in if inclusion_in

    base.send :define_singleton_method, :pool, ->(pool){ pool && where(pool: pool) || all } # TODO: this should be a scope, but with a scope, I got a "undefined method 'where' for RKit::ActiveRecordUtility::Utility::Pool"
    base.send :define_singleton_method, :pools, ->{ group(:pool).pluck(:pool) }

    if base.decorator_klass
      base.decorator_klass.send :define_method, :pool_url, -> do
        view.url_for [__class__, pool: pool]
      end
    end
  end

end
