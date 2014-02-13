require "r_kit/version"
require "r_kit/engine"

require "r_kit/decorator"
require "r_kit/grid"

module RKit
  class << self
    def services_names
      constants - [:VERSION, :Engine]
    end
    
    def services
      services_names.map do |const_name|
        const_get const_name
      end
    end
  
    def init_all!
      services.each do |service|
        if service.respond_to? :init!
          service.init!
        end
      end
    end
  end
end
