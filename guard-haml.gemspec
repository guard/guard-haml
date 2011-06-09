# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'guard/haml'

Gem::Specification.new do |s|
  s.name        = "guard-haml"
  s.version     = Guard::Haml::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Immanuel Häussermann"]
  s.email       = ["haeussermann@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Guard gem for Haml}
  s.description = %q{Compiles file.html.haml into file.html}

  s.rubyforge_project = "guard-haml"
  
  s.files         = Dir.glob('{lib}/**/*') + %w[LICENSE README.md]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
