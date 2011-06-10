# -*- encoding: utf-8 -*-
require File.expand_path('../lib/guard/haml/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "guard-haml"
  s.version     = Guard::HamlVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Immanuel Häussermann"]
  s.email       = ["haeussermann@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Guard gem for Haml}
  s.description = %q{Compiles file.html.haml into file.html}

  s.rubyforge_project = "guard-haml"


  s.add_dependency( 'guard', '>= 0.3' )
  s.add_dependency( 'haml', '>= 3.0' )

  s.add_development_dependency( 'rspec' )

  s.files         = Dir.glob('{lib}/**/*') + %w[LICENSE README.md Gemfile]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
