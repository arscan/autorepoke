# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'autorepoke/version'

Gem::Specification.new do |spec|
  spec.name          = "autorepoke"
  spec.version       = Autorepoke::VERSION
  spec.authors       = ["Rob Scanlon"]
  spec.email         = ["robscanlon@gmail.com"]
  spec.description   = %q{Auto poke back.  Use at own risk}
  spec.summary       = spec.description
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_runtime_dependency "trollop"
  spec.add_runtime_dependency "selenium-webdriver"
  spec.add_runtime_dependency "headless"


  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
