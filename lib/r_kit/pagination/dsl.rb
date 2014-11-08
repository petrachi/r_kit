module RKit::Pagination::Dsl
  act_as_a_dsl

  name :pagination_dsl
  method :acts_as_paginables
  domain ActiveRecord::Base

  params ->(per_page: nil){}

  methods :class do

    # TODO: to move in 'before_acts_as_paginables' callback, once this is available in 'dsl'
    if pagination_dsl.params.per_page
      RKit::Pagination.config.per_page[self] = pagination_dsl.params.per_page
    end


    def paginate page: nil, per_page: nil
      RKit::Pagination::Base.new(all, page: page, per_page: per_page)
    end

    def paginated?() false end

  end
end
