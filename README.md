# Guard::Haml

Guard yo Haml, guard yo html cuz they compilin errybody out here.

## Install

As the gem name suggests this is a guard extension. Make sure you get [guard](http://github.com/guard/guard) first.

Install the gem:

    gem install guard-haml
  
Add it to your Gemfile if you're using bundler (you should)
  
    gem 'guard-haml'
  
Add a basic guard setup:
  
    guard init haml

## Options

If you want to change the output directory use the `output` option in your
Guardfile, e.g.:

    guard 'haml', :output => 'public' do
      watch %r{^src/.+(\.html\.haml)}
    end

This output is relative to the Guardfile.
