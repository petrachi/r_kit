class RKit::Parser::Base

  def self.parse md_path, frame:;
    new(md_path, frame: frame).parse
  end

  attr_accessor :raw, :frame

  def initialize md_path, frame:;
    @raw = File.open(md_path).read
    @frame = frame
  end


  def parse
    RKit::Parser::Tree.new(raw, tag: :document, frame: frame).parsed
  end

end
