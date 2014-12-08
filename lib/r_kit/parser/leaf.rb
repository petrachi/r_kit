class RKit::Parser::Leaf

  attr_accessor :raw, :tag, :attributes, :content, :frame

  def initialize raw, frame:;
    @raw = raw
    @frame = frame
    @tag, @attributes, @content = parse_blocks
    @attributes ||= {}
  end

  def parsed
    if content && tag
      "<#{ tag } #{ attributes.map{|k,v| "#{k}='#{v}'"}.join }>#{ parsed_content }</#{ tag }>"
    elsif tag
      "<#{ tag } #{ attributes.map{|k,v| "#{k}='#{v}'"}.join }/>"
    elsif content
      content
    end
  end

  def parsed_content
    Array(content)
      .map{ |c|
        case c
        when String
          parse_inlines
        when RKit::Parser::Leaf
          c.parsed
        end
      }
      .join("")
  end

  protected def parse_blocks
    case raw
    when /(\#{1,6}) (.*)\z/
      [:"h#{ $1.size }", nil, $2]
    when /\A\* (.*)\z/
      [:li, nil, $1]
    when /\* .*/
      [:ul, nil, raw.lines.map{|s| RKit::Parser::Leaf.new(s.gsub(/\n\z/, ""), frame: frame)}]
    when /\A\+?(~{1,12})\n([^+]*)\z/
      [:div, {class: :"grid-col-#{ 12 / $1.size }"}, RKit::Parser::Leaf.new($2.gsub(/\n\z/, ""), frame: frame)]
    when /\A\+~{1,12}.*\+\z/m
      [:div, {class: :'grid-row'}, raw.split(/\n\+/).map{|s| RKit::Parser::Leaf.new(s.gsub(/\n\z/, ""), frame: frame)}]
    when /\A`{3}(\S*)\n(.*)`{3}\z/m
      [nil, nil, CodeRay.scan($2, $1).div(:css => :class, :tab_width => 2)]
    when /\A%{1}\n(.*)%{1}\z/m
      [nil, nil, ActionView::Base.new.render(inline: "<%= #{ $1 }%>")]
    when /\A--\z/
      [:hr, nil, nil]
    else
      [:p, nil, raw]
    end
  end

  protected def parse_inlines
    parsed_content = String.new(content)

    parsed_content.gsub!(/\n{1}/, '<br/>')
    parsed_content.gsub!(/\[([^\]]*)\]\(([^\)]*)\)/, '<a href="\2">\1</a>')
    parsed_content.gsub!(/\*\*([^\*]*)\*\*/, '<em>\1</em>')
    parsed_content.gsub!(/\*([^\*]*)\*/, '<strong>\1</strong>')
    parsed_content.gsub!(/\_([^\_]*)\_/, '<u>\1</u>')
    parsed_content.gsub!(/`{1}([^`\n]*)`{1}/){ CodeRay.scan($1, :ruby).span(:css => :class) }
    parsed_content.gsub!(/%{1}([^%\n]*)%{1}/){ frame[$1] }

    parsed_content
  end

end
