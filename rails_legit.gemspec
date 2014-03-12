# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_legit/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_legit"
  spec.version       = RailsLegit::VERSION
  spec.authors       = ["Kashyap"]
  spec.email         = ["kashyap.kmbc@gmail.com"]
  spec.description   = %q{Provides a DSL for common validation formats like Date, Array, DateTime etc.}
  spec.summary       = %q{Provides a DSL for common validation formats like Date, Array, DateTime etc.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_dependency "activemodel", "> 3.0"
end
