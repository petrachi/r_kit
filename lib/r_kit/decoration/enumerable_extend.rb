module Enumerable

  def decorate **options
    RKit::Decoration::Collection.new(self, **options)
  end

  def decorated?() false end

  def need_decoration?
    any?(&:need_decoration?)
  end

end
