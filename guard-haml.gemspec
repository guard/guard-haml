# encoding: utf-8
Kernel.load File.expand_path('../lib/guard/haml/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'guard-haml'
  s.version     = Guard::HamlVersion::VERSION
  s.summary     = 'Guard gem for Haml'
  s.description = 'Compiles file.html.haml into file.html'
  s.authors     = ['Immanuel Häussermann']
  s.email       = ['haeussermann@gmail.com']
  s.homepage    = 'http://rubygems.org/gems/guard-haml'

  s.files = Dir.glob('{lib}/**/*') + %w[CHANGELOG.md LICENSE README.md]

  s.add_dependency 'guard', '~> 1.1'
  s.add_dependency 'haml',  '>= 3.0'

  s.add_development_dependency 'bundler', '~> 1.3'

  s.require_path = 'lib'
end