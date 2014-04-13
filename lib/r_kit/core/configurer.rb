class RKit::Core::Configurer
  attr_accessor :_base, :_config, :_presets, :_aliases

  def initialize base, config = {}
    @_base = base
    @_config = config
    @_presets = Hash.new{ |hash, key| hash[key] = self.class.new(_base) }
    @_aliases = []
  end


  def preset name, config
    _presets[name] = self.class.new(_base, config)
  end

  def load_preset! name
    _config.deep_merge! _presets[name]._config
  end


  def config *name, default
    _config.deep_merge! [*name, default].reverse.inject{ |nested, key| Hash[key, nested] }
  end

  def load_config! config_options
    _config.deep_merge! config_options
    _base.const_set :CONFIG, OpenStruct.new(_config)
  end


  def alias_config *name, old_name
    _aliases << [name, old_name]
  end

  def alias *name, old_name
    new_name = name.pop
    config = name.inject(_config){ |config, nested| config = config[nested] }

    config[new_name] = config[old_name] if config[new_name].blank?
  end

  def load_alias!
    _aliases.each do |(name, old_name)|
      self.alias *name, old_name
    end
  end


  def load! config
    load_preset! config.delete(:preset)
    load_config! config
    load_alias!
  end


  def inspect
    _config.inspect
  end

  def fingerprint
    _config.sort.join
  end
end
