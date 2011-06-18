# Guard::Haml

Guard yo Haml, guard yo html cuz they compilin errybody out here.

## Install

As the gem name suggests this is a guard extension. Make sure you get [guard](https://github.com/guard/guard) first.

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

If you maintain your haml files in a directory that should not be part of the output path, you can set the `input` option, e.g.:

    guard 'haml', :output => 'public', :input => 'src' do
      watch %r{^src/.+(\.html\.haml)}
    end

So when you edit a file `src/partials/_partial.html.haml`
it will be outputted in `public/partials/_partial.html` without the `src`.

## Development

* Source is hosted on [Github: guard-haml](https://github.com/manufaktor/guard-haml)
* Report issues/questions/feature requests on the [Github Issue tracker for guard-haml](https://github.com/manufaktor/guard-haml/issues)

Pull requests are welcome. 
Specs are very welcome, make sure you support both ruby 1.8.7 and  ruby 1.9.2.