class RKit::Pagination::Base < CollectionDelegator

  attr_accessor :page, :per_page

  # TODO: should raise (todo custom error) an error if has "limit" or "offset" values
  def initialize collection, **options
    raise if collection.values.keys.include_one? [:limit, :offset]

    super collection

    @page = options[:page] || 1
    @per_page = options[:per_page] || RKit::Pagination.config.per_page[collection.klass]
  end

  tap_attr_accessor :page
  tap_attr_accessor :per_page

  def total_pages
    (collection.count / per_page.to_f).ceil
  end


  # TODO: limit & offset should raise a custom made error
  def limit
    raise
  end

  def offset
    raise
  end


  def limited_collection
    collection
      .limit(per_page)
      .offset((page-1) * per_page)
  end

  def each &block
    limited_collection.each &block
  end

  delegate :inspect, to: :limited_collection



  def pages
    (1..total_pages).map do |page|
      RKit::Pagination::Base::Page.new self, page: page
    end
  end

  def previous_page
    pages.find{ |page| page.page == (self.page - 1) } || pages.first
  end

  def next_page
    pages.find{ |page| page.page == (self.page + 1) } || pages.last
  end



  RKit::Decoration::Dsl.domain self
  acts_as_decorables do

    include Enumerable

    def each &block
      limited_collection.decorate.each &block
    end


    def pagination_tag
      view.content_tag :nav, class: :pagination do
        [previous_page_tag, pages_tag, next_page_tag].reduce(:safe_concat)
      end
    end

    def previous_page_tag
      previous_page.decorate.page_tag "<"
    end

    def pages_tag
      pages.map(&:decorate).map(&:page_tag).reduce(:safe_concat)
    end

    def next_page_tag
      next_page.decorate.page_tag ">"
    end
  end




  # TODO: limited_collection, total_pages & pages can change, based on scopes or "page & per_page" config
  # So we need a "@loaded" instance_variable
  # that will have the same role as in AR::Relation
  # -> either, can't scope if loaded
  # -> either, empty the 3 "based on scope/config" variables
  # --
  # or, we don't memoize the 3 problematic vars
  # wich will be my choice right now




  # I need
  # collection, records/instances/results/paginated_collection/limited_collection(as we use SQL 'limit')
  # current page, total nb items, total pages

  # calling could be : Articles.paginate(page: 2, per_page: 15).published
  # note that published is _after_, but we still want to display 15 records
  # Alternative call Articles.paginate.page(2).per_page(15)
  # --
  # the "per_page" will be settable either by an arg in the method,
  # or by an option, per model, in the dsl (access by Article.all.instance_variable_get "@klass")
  # or in the "pagination" config
  # the "current page" will be 1 by default

  # Raise an error if the collection has a "limit" or an "offset" (before or after pagination initialization)
  # here is the pagination method scope : Paginator::Collection.new(scoped).limit(per).offset((page-1) * per)


  # We also need a method "pagination_tag", in the view
  # maybe use a decorator to do so.

  # Define an option to use pagination based on instance, in this case, the "per_page" is set to one
  # and the "pagination_tag" accept a block to display the "page number"


  # Idea, the "current_page" info (to disable the current page link) could be an instance of a class (pagination::Page)
  # so in that class, (or in her decorator), we could define the "link_to_page" method
  # (and the "disabled_link_to", wich we will alias on self)
end
