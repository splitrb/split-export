# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "split/export/version"

Gem::Specification.new do |s|
  s.name        = "split-export"
  s.version     = Split::Export::VERSION
  s.authors     = ["Andrew Nesbitt"]
  s.email       = ["andrewnez@gmail.com"]
  s.homepage    = "https://github.com/splitrb/split-export"
  s.summary     = %q{Split extension to export your data}
  s.license     = 'MIT'

  s.required_ruby_version = '>= 1.9.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "split", "~> 1.4.0"

  # Development Dependencies
  s.add_development_dependency(%q<rspec>, ["~>  2.6"])
end
