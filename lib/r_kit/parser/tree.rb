class RKit::Parser::Tree

  attr_accessor :raw, :tag, :frame

  def initialize raw, tag: :document, frame:;
    @raw = raw
    @tag = tag

    @frame = frame
  end

  def branches
    raw.split(/\n{2,}/).map do |raw_block|
      RKit::Parser::Leaf.new(raw_block, frame: frame)
    end
  end

  def parsed
    branches.map(&:parsed).join("")
  end

end
