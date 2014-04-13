class RKit::Core

  class << self
    def init!
      @_config = Configurer.new self
      @_engine = Engineer.new self
      @_load_paths = []
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

    def with_sprockets
      @_engine.sprockets = true
    end


    delegate :config, :alias_config, :preset,
      to: :@_config


    def load_path file, path
      file.chomp! File.extname(file)
      @_load_paths << File.expand_path(path, file)
    end

    def load!
      @_load_paths.each{ |path| require path }

      # TODO: save loaded services for the dependency method
    end

    def load config = {}
      @_config.load! config
      @_engine.load!
      load!
      # TODO: the load_path loading logic will move someday in a "loader" core-class, smthng like that - and the same will probably goes for dependencies as well
    end



    def inspect
      "#{ name } config_w/#{ @_config.inspect }"
      # TODO: add link to doc
    end

    def digest
      Digest::MD5.hexdigest @_config.fingerprint
    end
  end

  #init!
  #load_path __FILE__, 'engineer.rb'
  #load!

  #extend Engineer

  require 'r_kit/core/configurer.rb'
  require 'r_kit/core/engineer.rb'

  require 'r_kit/css.rb'
  require 'r_kit/grid.rb'

end
