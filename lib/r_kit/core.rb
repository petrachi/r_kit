class RKit::Core

  class << self
    def defaults
      @_load_paths = []
    end

    def inherited base
      base.defaults
      super
    end



    def load_path file, path
      file.chomp! File.extname(file)
      @_load_paths << File.expand_path(path, file)
    end

    def dependency
      # TODO: if there is a depndency an it is not already loaded, load it and put a warning message
    end

    def load
      @_load_paths.each{ |path| require path }

      # TODO: save loaded services for the dependency method
    end
  end


  module ::RKit::Css
    require 'r_kit/css/base.rb'
  end

end
