module RKit::Decoration::ActionViewBaseExtend

  def assign new_assigns
    decorate_assigns new_assigns

    super
  end


  protected def decorate_assigns assigns
    assigns.dup.each do |key, value|
      assigns[key] = decorate value
    end
  end

  protected def decorate assign
    if assign.need_decoration?
      assign.decorate view_context: self
    else
      assign
    end
  end


  ActionView::Base.prepend self
end
