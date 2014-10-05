module RKit::Pagination::ActiveRecordExtend
  act_as_a_dsl

  name :pagination_dsl
  method :acts_as_paginables
  domain ActiveRecord::Base

  methods :class do

    def paginate page: nil, per_page: nil
      RKit::Pagination::Base.new(all, page: page, per_page: per_page)
    end

  end
end
