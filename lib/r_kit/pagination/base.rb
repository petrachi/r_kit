class RKit::Pagination::Base < CollectionDelegator

  attr_accessor :page, :per_page

  # TODO: should raise (todo custom error) an error if has "limit" or "offset" values
  def initialize collection, **options
    raise if collection.values.keys.include_one? [:limit, :offset]

    super collection

    @page = options[:page] || 1
    @per_page = options[:per_page] || RKit::Pagination.config.per_page[collection.klass]
  end

  def paginated?() true end


  tap_attr_accessor :page, :per_page, typecast: :to_i

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
    @limited_collection ||= collection
      .limit(per_page)
      .offset((page-1) * per_page)
  end

  include Enumerable

  def each &block
    limited_collection.each(&block)
  end

  delegate :inspect, to: :limited_collection

  def reverse
    reversed = limited_collection.reverse
    @limited_collection.clear.concat(reversed)
    
    self
  end


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
    after_initialize do
      # TODO: I need this definition here
      # Otherwise, the base definition in enumerable_extend is found first

      define_singleton_method :paginated?, ->{ true }
    end


    depend on: :pages do
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
  end

end
