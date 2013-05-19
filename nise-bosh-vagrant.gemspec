# -*- encoding: utf-8 -*-
require File.expand_path('../lib/nise-bosh-vagrant/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brian McClain"]
  gem.email         = ["brianmmcclain@gmail.com"]
  gem.description   = %q{Combining nise-bosh with Vagrant}
  gem.summary       = gem.summary
  gem.homepage      = "https://github.com/BrianMMcClain/nise-bosh-vagrant"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "nise-bosh-vagrant"
  gem.require_paths = ["lib"]
  gem.version       = NiseBOSHVagrant::VERSION
  
  gem.add_dependency "trollop"
end