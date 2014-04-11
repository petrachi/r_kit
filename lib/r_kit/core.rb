class RKit::Core

  class << self
    def init!
      @_config = {}
      @_engine = RKit::Core::Engineer.new(self)
      @_load_paths = []
      @_preset = Hash.new{ |hash, key| hash[key] = Hash.new(&hash.default_proc) }
    end

    def inherited base
      base.init!
      super
    end



    def dependency
      # TODO: if there is a depndency an it is not already loaded, load it and put a warning message
    end



    def with_engine file
      @_engine.pathname = Pathname.new(File.dirname(file)) + name.demodulize.underscore
    end



    def config *name, default
      @_config.deep_merge! [*name, default].reverse.inject{ |nested, key| Hash[key, nested] }
    end

    def alias_config *name, old_name
      p @_config

      new_name = name.pop
      config = name.inject(@_config){ |config, nested| config = config[nested] }

      config[new_name] = config[old_name]

      # TODO: fail, this is cool of we keep default config, but if we change config in remote app "load", the alias value don't follow. we need to either, create a more real alias, or define alias in the "configure!" method

      p config
      p @_config
    end

    def configure! config
      @_config.deep_merge! config
      const_set :CONFIG, OpenStruct.new(@_config)
    end


    def preset name, config
      @_preset[name] = config
    end

    def preset! name
      @_config.deep_merge! @_preset[name]
      # TODO permettre de passer plusieurs preset (potentiellement complémentaires)
    end



    def load_path file, path
      file.chomp! File.extname(file)
      @_load_paths << File.expand_path(path, file)
    end

    def load!
      @_engine.load!
      @_load_paths.each{ |path| require path }

      # TODO: save loaded services for the dependency method
    end

    def load config = {}
      preset! config.delete(:preset)
      configure! config
      load!
    end



    def inspect
      "#{ name } config_w/#{ @_config.inspect }"
      # TODO: add link to doc
    end

    def digest
      Digest::MD5.hexdigest @_config.sort.join
    end
  end

  #init!
  #load_path __FILE__, 'engineer.rb'
  #load!

  #extend Engineer

  require 'r_kit/core/engineer.rb'

  require 'r_kit/css.rb'
  require 'r_kit/grid.rb'

end
