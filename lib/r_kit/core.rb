class RKit::Core

  class << self
    def defaults
      @_load_paths = []
      @_config = {}
      @_config_info = {}
    end

    def inherited base
      base.defaults
      super
    end



    def dependency
      # TODO: if there is a depndency an it is not already loaded, load it and put a warning message
    end



    def config name, default
      @_config[name] = default
    end

    def configure! config
      @_config.merge! config
      const_set :CONFIG, OpenStruct.new(@_config)
    end



    def load_path file, path
      file.chomp! File.extname(file)
      @_load_paths << File.expand_path(path, file)
    end

    def load!
      @_load_paths.each{ |path| require path }

      # TODO: save loaded services for the dependency method
    end

    def load config = {}
      configure! config
      load!
    end



    def inspect
      "#{ name } config_w/:#{ @_config.inspect }"
      # TODO: add link to doc
    end

    def digest
      Digest::MD5.hexdigest @_config.sort.join
    end

  end

  require 'r_kit/css.rb'
  require 'r_kit/grid.rb'

end
