class RKit::Pagination::Base::Page

  attr_accessor :base, :page

  def initialize base, page: page
    @base = base
    @page = page
  end


  RKit::Decoration::Dsl.domain self
  acts_as_decorables do

    # TODO: we tried to cancel the underscored alias of __getobj__
    # cause the class name is also an attr_name
    # -> Page underscored will become 'page', wich is an attribute,
    # -> so here, we don't want 'page' to refer to the whole object
    # but this doesn't work, cause when you use a block, the decorator class creation will be processed after
    # so, in decoration, we might whant to alias only if method not already defined
    def page # this doesn't work, it has no effect
      __getobj__.page
    end


    # TODO: this doesn not need to be an 'after_initialize', it could just override the default initializer
    after_initialize do
      if __getobj__.page == base.page
        alias :page_tag :disabled_link_to_page
      end
    end


    def page_tag name = __getobj__.page
      link_to_page name
    end


    def link_to_page name = __getobj__.page
      view.link_to name, view.url_for(page: __getobj__.page), class: :btn
    end

    def disabled_link_to_page name = __getobj__.page
      view.content_tag :span, name, class: :'btn-disabled'
    end

  end




  # this need
  # current_page

  # and a decorator

end
