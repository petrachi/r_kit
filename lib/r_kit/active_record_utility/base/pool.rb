class RKit::ActiveRecordUtility::Base::Pool < RKit::ActiveRecordUtility::Base

  act_as_a_dsl

  name :pool_dsl
  method :acts_as_poolables
  domain ActiveRecord::Base

  allowed? do
    table_exists? &&
      column_names.include?("pool") &&
      columns_hash["pool"].type == :string
  end

  restricted do
    raise DatabaseSchemaError.new(self, method_name: pool_dsl.method)
  end

  params ->(**options){}

  methods :class do

    validates_presence_of :pool

    pool_dsl.params.options[:in].then do |inclusion_in|
      validates_inclusion_of :pool, in: inclusion_in
    end

    scope :pool, ->(pool){ pool && where(pool: pool) }
    scope :pools, ->{ group(:pool).pluck(:pool) }
  end

  methods :decorator do
    def pool_url
      view.url_for [__class__, pool: pool]
    end

    def link_to_pool
      view.link_to pool, pool_url, class: :btn
    end
  end
end
