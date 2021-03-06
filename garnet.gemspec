# -*- encoding: utf-8 -*-
require File.expand_path('../lib/garnet/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Josh Lane"]
  gem.email         = ["lane.joshlane@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "garnet"
  gem.require_paths = ["lib"]
  gem.version       = Garnet::VERSION

  gem.add_runtime_dependency "sinatra"
  gem.add_runtime_dependency "dm-core"
  gem.add_runtime_dependency "dm-serializer"
  gem.add_runtime_dependency "dm-validations"
  gem.add_runtime_dependency "dm-types"
end
