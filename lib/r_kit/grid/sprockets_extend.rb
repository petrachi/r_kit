class Sprockets::Base
  alias :original_digest_2 :digest
  def digest
    original_digest_2.update(RKit::Grid.digest)
  end
end
