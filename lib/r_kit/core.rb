module RKit::Core
  def self.init!
    require "r_kit/core/object_extension"
    Object.extend ObjectExtension
    
    require "r_kit/core/object"
  end
end
