module RKit::Decorator::ActionViewBaseExtend

  def assign new_assigns
    _decorate_assigns new_assigns if RKit::Decorator.config.auto_decoration

    super
  end


  def _decorate_assigns assigns
    assigns.dup.each do |key, value|
      assigns[key] = _decorate value
    end
  end

  def _decorate assign
    if assign.respond_to? :decorate
      assign.decorate view_context: self
    else
      assign
    end
  end


  ActionView::Base.prepend self
end
