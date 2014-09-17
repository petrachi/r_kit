module Kernel

  def __class__
    self.class
  end

  def __namespace__
    (__class__.name.deconstantize.presence || 'Object').constantize
  end


  def running_script
    "#{ File.basename($0) } #{ ARGV.join " " }"
  end

  def running_script? script
    Regexp.new(script) =~ running_script
  end
end
