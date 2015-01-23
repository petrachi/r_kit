class RKit::Core::Engineer
  attr_accessor :_base, :sprockets_folders

  def initialize base
    @_base = base
    @sprockets_folders = []
  end



  def with_sprockets file, *paths
    paths.each do |path|
      sprockets_folders << File.expand_path(path.to_s, file.chomp!(File.extname(file)))
    end

    _base.load_path file, 'sass_extend'
  end



  def load_folders!
    sprockets_folders.each do |folder|
      Rails.application.assets.append_path folder
    end
  end

  def update_digest!
    digest = _base.digest
    sprockets_extend = Module.new do
      define_method 'digest' do
        super().update(digest)
      end
    end

    Sprockets::Base.send :prepend, sprockets_extend
  end


  def should_load?
    !sprockets_folders.empty?
  end

  def load!
    if should_load?
      load_folders!
      update_digest!
    end
  end
end
