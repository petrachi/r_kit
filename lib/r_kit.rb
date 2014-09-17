module RKit

  def inspect
    "#{ name }"
    # TODO: add a brief, link to the doc, list of all services, and demo of inspect method for services
    # some kind of "--help" of unix commands
  end

  delegate :loaded, to: 'RKit::Core::Loader'


  
  def load *services
    load_service_from Array.wrap(services)
  end


  def load_service_from service
    send "load_service_from_#{ service.class.name.underscore }", service
  end

  def load_service_from_array services
    services.each do |service|
      load_service_from service
    end
  end

  def load_service_from_symbol service, config: {}
    RKit.const_get(service.to_s.classify).load config
  end
  alias :load_service_from_string :load_service_from_symbol

  def load_service_from_hash services
    services.each do |service, config = {}|
      load_service_from_symbol service, config: config
    end
  end


  extend self


  require 'r_kit/core'
  require 'r_kit/version'


  Dir[File.join(File.dirname(__FILE__), "r_kit", "*.rb")].each do |file|
    basename = File.basename file, ".rb"

    if ["core", "version"].exclude? basename
      const_set basename.classify, Class.new(RKit::Core){}
    end
  end
end
