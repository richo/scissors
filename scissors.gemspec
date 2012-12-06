# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scissors/version'

Gem::Specification.new do |gem|
  gem.name          = "scissors"
  gem.version       = Scissors::VERSION
  gem.authors       = ["Daniel Heath", "Clifford Heath"]
  gem.email         = ["daniel.r.heath@gmail.com", "clifford.heath@gmail.com"]
  gem.description   = %q{Single Sign-on for apps that trust each other}
  gem.summary       = %q{Helps you roll your own identity provider.}
  gem.homepage      = "https://github.com/DanielHeath/scissors"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'openstruct'
  gem.add_development_dependency 'cane'
  gem.add_dependency 'rack'

end
