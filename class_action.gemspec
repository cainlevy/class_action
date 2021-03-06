# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'class_action/version'

Gem::Specification.new do |spec|
  spec.name          = "class_action"
  spec.version       = ClassAction::VERSION
  spec.authors       = ["Lance Ivy"]
  spec.email         = ["lance@cainlevy.net"]
  spec.summary       = "Separate classes for each Rails controller action."
  spec.description   = spec.summary
  spec.homepage      = "http://github.com/cainlevy/class_action"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "activesupport", "~> 3.2"
  spec.add_dependency "actionpack", "~> 3.2"
end
