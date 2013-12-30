# -*- coding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sysflow/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sysflow"
  s.version     = Sysflow::VERSION
  s.authors     = ["Ivan Nečas"]
  s.email       = ["necasik@gmail.com"]
  s.homepage    = "https://github.com/iNecas/sysflow"
  s.summary     = "Dynflow actions and services for system commands execution"
  s.description = "Dynflow actions and services for system commands execution"

  s.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "dynflow"
end
