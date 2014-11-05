module RKit::Decoration::ActionViewBaseExtend

  def assign new_assigns
    decorate_assigns new_assigns

    super
  end


  protected def decorate_assigns assigns
    assigns.dup.each do |key, value|
      binding.pry if value.is_a?(Screencast)

      assigns[key] = decorate value
    end
  end

  protected def decorate assign
    if assign.respond_to? :decorate
      assign.decorate view_context: self
    else
      assign
    end
  end


  ActionView::Base.prepend self
end
