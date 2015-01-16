source 'https://rubygems.org'

gemspec

gem 'rake'

group :development do
  gem 'ruby_gntp'
  gem 'guard-rspec'
  gem 'transpec'
end

# The test group will be
# installed on Travis CI
#
group :test do
  gem 'rspec', '~> 3.1'
  gem 'coveralls', require: false
  gem 'rubocop', require: false
end
