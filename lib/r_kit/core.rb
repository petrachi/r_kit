class RKit::Core

  class << self
    def init!
      @_config = Configurer.new self
      @_engine = Engineer.new self
      @_load = Loader.new self
    end

    def inherited base
      base.init!
      super
    end



    #def dependency
      # TODO: if there is a depndency an it is not already loaded, load it and put a warning message
    #end



    def with_engine file
      @_engine.pathname = Pathname.new(File.dirname(file)) + name.demodulize.underscore
    end

    def with_sprockets file
      @_engine.sprockets = true
      load_path file, 'sass_extend.rb'
    end


    delegate :config, :alias_config, :preset,
      to: :@_config


    delegate :load_path,
      to: :@_load


    def load config = {}
      @_config.load! config
      @_engine.load!
      @_load.load!
    end



    def inspect
      "#{ name } config_w/#{ @_config.inspect }"
      # TODO: add link to doc
    end

    def digest
      Digest::MD5.hexdigest @_config.fingerprint
    end
  end


  require 'r_kit/core/configurer.rb'
  require 'r_kit/core/engineer.rb'
  require 'r_kit/core/loader.rb'

  require 'r_kit/css.rb'
  require 'r_kit/grid.rb'

end
