# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'guard/haml/version'

Gem::Specification.new do |s|
  s.name        = 'guard-haml'
  s.version     = Guard::HamlVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.authors     = ['Immanuel Häussermann', 'Rémy Coutable']
  s.email       = ['remy@rymai.me']
  s.homepage    = 'https://rubygems.org/gems/guard-haml'
  s.summary     = 'Guard plugin for Haml'
  s.description = 'Compiles file.html.haml into file.html'

  s.required_ruby_version = '>= 1.9.2'

  s.add_runtime_dependency 'guard', '~> 2.0'
  s.add_runtime_dependency 'haml',  '>= 3.0'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec'

  s.files        = Dir.glob('{lib}/**/*') + %w[CHANGELOG.md LICENSE README.md]
  s.require_path = 'lib'
end
