# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'run_later/version'

Gem::Specification.new do |spec|
  spec.name          = "run_later"
  spec.version       = RunLater::VERSION
  spec.authors       = ["Ioannis Kolovos"]
  spec.email         = ["yannis.kolovos@gmail.com"]
  spec.summary       = "Run commands later"
  spec.description   = "Save commands to be run later and run them"
  spec.homepage      = "https://github.com/msroot/run_later"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "thor", "~> 0.19.1"
end
