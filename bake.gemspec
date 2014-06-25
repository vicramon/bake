# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bake/version'

Gem::Specification.new do |spec|
  spec.name          = "bake"
  spec.version       = Bake::VERSION
  spec.authors       = ["Vic Ramon"]
  spec.email         = ["vic@vicramon.com"]
  spec.summary       = %q{Run your test suite in the cloud.}
  spec.description   = %q{Bake: Run your test suite in the cloud.}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_runtime_dependency "thor", "~> 0.19"
end
