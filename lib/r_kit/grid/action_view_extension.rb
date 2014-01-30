module RKit::Grid::ActionViewExtension
  def proc_options instance, options = {}
    (options[:proc_options] || []).each do |key, proc|
      options[key] = proc.call(instance)
    end
  end
  
  def html_options options = {}, defaults = {}
    id = options[:id]
    classes = "#{ defaults[:class] } #{ options[:class] }"
    classes += " off-#{ options[:offset] }" if options[:offset]
    
    {
      :id => id,
      :class => classes
    }
  end
  
  
  def container_tag options = {}, &block
    html_options = html_options(options, {class: :container})
    content_tag options[:tag] || :div, html_options, &block
  end
  
  def row_tag options = {}, &block
    html_options = html_options(options, {class: :row})
    content_tag options[:tag] || :div, html_options, &block
  end
  
  def col_tag options = {}, &block
    proc_options options[:instance], options
    html_options = html_options(options, {class: "col-#{ options[:col_size] }"})
    
    content_tag(options[:tag] || :div, html_options){ block.call(options[:instance]) }
  end
  
  
  def col__tag col_size, options = {}, &block
    col_tag options.merge(col_size: col_size), &block
  end
  
  def row__tag col_size, collection, options = {}, &block
    col_options = options[:cols] || {}
    
    cols_buffer = collection.inject ActiveSupport::SafeBuffer.new do |safe_buffer, instance|
      safe_buffer.safe_concat send("col_#{ col_size }_tag", col_options.merge(instance: instance), &block)
    end
    
    row_tag(options){ cols_buffer }
  end
  
  def rows__tag col_size, collection, options = {}, &block
    rows_buffer = collection
      .in_groups_of(12 / col_size, false)
      .inject ActiveSupport::SafeBuffer.new do |safe_buffer, collection|
        safe_buffer.safe_concat send("row_#{ col_size }_tag", collection, options, &block)
    end
  end
  
  def container__tag col_size, collection, options = {}, &block
    row_options = options.delete(:rows) || {}
    container_tag(options){ send("rows_#{ col_size}_tag", collection, row_options, &block) }
  end
  
  1.upto 12 do |col_size|
    define_method "col_#{ col_size }_tag" do |options = {}, &block|
      col__tag col_size, options, &block
    end
  
    define_method "row_#{ col_size }_tag" do |collection, options = {}, &block|
      row__tag col_size, collection, options, &block
    end
    
    define_method "rows_#{ col_size }_tag" do |collection, options = {}, &block| 
      rows__tag col_size, collection, options, &block
    end
    
    define_method "container_#{ col_size }_tag" do |collection, options = {}, &block|
      container__tag col_size, collection, options, &block
    end
  end
end