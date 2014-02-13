module RKit::Decorator
  def self.init!
    require "r_kit/decorator/active_record_extension"
    require "r_kit/decorator/base"
  
    ActiveRecord::Base.extend ActiveRecordExtension
  end
end
