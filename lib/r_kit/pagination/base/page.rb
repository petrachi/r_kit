class RKit::Pagination::Base::Page

  attr_accessor :base, :page

  def initialize base, page: page
    @base = base
    @page = page
  end


  RKit::Decoration::Dsl.domain self
  acts_as_decorables do

    after_initialize do
      if page == base.page
        alias :page_tag :disabled_link_to_page
      end
    end


    def page_tag name = page
      link_to_page name
    end


    def link_to_page name = page
      view.link_to name, view.url_for(page: page), class: :btn
    end

    def disabled_link_to_page name = page
      view.content_tag :span, name, class: :'btn-disabled'
    end
  end

end
