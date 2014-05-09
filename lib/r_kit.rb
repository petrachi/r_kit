require "r_kit/core"
require "r_kit/version"

module RKit

  def inspect
    "#{ name }"
    # TODO: add a brief, link to the doc, list of all services, and demo of inspect method for services
    # some kind of "--help" of unix commands
  end


  # TODO: this should be split in 2 different methods
  # cause we can get a hash, or an array here
  # and the array can contain string, symbols, hash
  # - please, cast hash into arrays, so you don't need to care
  def load *services
    services.each do |service|
      send "load_service_from_#{ service.class.name.underscore }", service
    end
  end

  def load_service_from_symbol service, config: {}
    RKit.const_get(service.to_s.classify).load config
  end
  alias :load_service_from_string :load_service_from_symbol

  def load_service_from_hash services
    services.each do |service, config|
      load_service_from_symbol service, config: config
    end
  end
  alias :load_service_from_array :load_service_from_hash


  extend self
end
