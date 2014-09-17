class RKit::Core

  class << self
    def init!
      @_config = Configurer.new self
      @_engine = Engineer.new self
      @_load = Loader.new self
    end

    def inherited subclass
      subclass.init!
      super
    end


    def with_engine file
      @_engine.pathname = Pathname.new(File.dirname(file)) + name.demodulize.underscore
    end

    def with_sprockets file
      @_engine.sprockets = true
      load_path file, 'sass_extend.rb'
    end


    delegate :config, :alias_config, :preset,
      to: :@_config


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


    def inspect
      "#{ name } config_w/#{ @_config.inspect } loaded/#{ loaded? }"
      # TODO: add link to doc
    end

    def digest
      Digest::MD5.hexdigest @_config.fingerprint
    end
  end


  require 'r_kit/core/configurer.rb'
  require 'r_kit/core/engineer.rb'
  require 'r_kit/core/loader.rb'

end
