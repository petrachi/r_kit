class RKit::Core

  # TODO: add a "warn" method, with a required 'if', that will display a warning msg if the condition is not fullfiled

  # TODO: add a "description" method, wich will contain a descriptive text about the service

  class << self
    def init!
      @_config = Configurer.new self
      @_engine = Engineer.new self
      @_helper = Helper.new self
      @_load = Loader.new self
    end

    def inherited subclass
      subclass.init!
      super
    end


    # TODO: define a method "config_get" that retreive the rkit config
    # to do so, we will iterate throug the namespaces until we find somthing that inherit from RKit::Core
    delegate :config, :alias_config, :preset,
      to: :@_config


    delegate :with_sprockets,
      to: :@_engine


    delegate :load_path, :dependency,
      to: :@_load


    def loaded?
      RKit::Core::Loader.loaded? name
    end

    def load! config
      require "#{ name.underscore }.rb"

      @_config.load! config
      @_engine.load!
      @_load.load!
    end

    def load config = {}
      load! config if !loaded?
    end


    delegate :description, :method,
      to: :@_helper

    def man
      print @_helper.inspect
    end

    def inspect
      "#{ name } config_w/#{ @_config.inspect } loaded/#{ loaded? }"
      # TODO: add link to doc
    end

    def digest
      Digest::MD5.hexdigest @_config.fingerprint
    end
  end


  # TODO: configurer need some sort of wrapper & things, this needs to be largely improved
  require 'r_kit/core/configurer.rb'

  # TODO: make engine mountable AFTER rails initialization
  require 'r_kit/core/engineer.rb'

  require 'r_kit/core/helper.rb'
  require 'r_kit/core/helper/method.rb'
  require 'r_kit/core/helper/printer.rb'

  require 'r_kit/core/loader.rb'
  require 'r_kit/core/loader/dependency.rb'
  require 'r_kit/core/loader/load_path.rb'

end
