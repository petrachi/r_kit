class RKit::Core::Engineer
  attr_accessor :_base, :pathname, :sprockets

  def initialize base
    @_base = base
  end


  def load_engine?
    @pathname
  end

  def load_engine!
    pathname = @pathname

    Class.new(Rails::Engine) do
      paths.path = pathname
    end
  end


  def load_sprockets?
    @sprockets
  end

  def load_sprockets!
    digest = _base.digest
    sprockets_extend = Module.new do
      define_method "digest" do
        super().update(digest)
      end
    end

    Sprockets::Base.send :prepend, sprockets_extend
  end


  def load!
    load_engine! if load_engine?
    load_sprockets! if load_sprockets?
  end
end
