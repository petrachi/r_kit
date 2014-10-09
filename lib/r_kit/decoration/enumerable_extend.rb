module Enumerable

  def decorate **options
    RKit::Decoration::Collection.new(self, **options).safe
  end

  def decorated?() false end

end
