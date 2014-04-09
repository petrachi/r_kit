class Sprockets::Base
  alias :original_digest :digest
  def digest
    original_digest.update(RKit::Css.digest)
  end
end
