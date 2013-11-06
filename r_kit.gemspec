# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'r_kit/version'

Gem::Specification.new do |gem|
  gem.name          = "r_kit"
  gem.version       = RKit::VERSION
  gem.authors       = ["Thomas Petrachi"]
  gem.email         = ["thomas.petrachi@vodeclic.com"]
  gem.description   = %q{Library for rails projects}
  gem.summary       = %q{Code library for rails : ruby core extend / rails helpers / css / js}
  gem.homepage      = "https://github.com/petrachi/r_kit"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
