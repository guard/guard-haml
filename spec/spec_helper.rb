require 'rspec'
require 'guard/haml'

RSpec.configure do |config|
  config.color_enabled = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  
  config.before(:each) do
    ENV["GUARD_ENV"] = 'test'
    @fixture_path = Pathname.new(File.expand_path('../fixtures/', __FILE__))
    @lib_path = Pathname.new(File.expand_path('../../lib/', __FILE__))
  end
end
