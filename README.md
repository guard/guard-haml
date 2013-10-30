# Guard::Haml

[![Gem Version](https://badge.fury.io/rb/guard-haml.png)](http://badge.fury.io/rb/guard-haml) [![Build Status](https://travis-ci.org/guard/guard-haml.png?branch=master)](https://travis-ci.org/guard/guard-haml) [![Dependency Status](https://gemnasium.com/guard/guard-haml.png)](https://gemnasium.com/guard/guard-haml) [![Code Climate](https://codeclimate.com/github/guard/guard-haml.png)](https://codeclimate.com/github/guard/guard-haml) [![Coverage Status](https://coveralls.io/repos/guard/guard-haml/badge.png?branch=master)](https://coveralls.io/r/guard/guard-haml)

Watches HAML files, compiles them to HTML on change.

* Compatible with HAML >= 3.
* Tested against Ruby 1.9.3, 2.0.0, Rubinius & JRuby (1.9 mode only).

## Install

Please be sure to have [Guard](https://github.com/guard/guard) installed before continuing.

Add Guard::Haml to your `Gemfile`:

```ruby
group :development do
  gem 'guard-haml'
end
```

Add guard definition to your Guardfile by running this command:

```bash
$ guard init haml
```

## Options

### Configuring the input folder + automatic watchers generation

Use the `:input` option to define the folder where your HAML files are stored.
This options also ensure the input folder won't be part of the output path.

If you set the `:input` option and don't define any watchers, Guard::Haml will
automatically generates watchers with the pattern
`%r{^#{options[:input]}/(.+(\.html)?\.haml)$}`. For instance:

```ruby
guard :haml, input: 'markup'
```

is equivalent to:

```ruby
guard :haml, input: 'markup' do
  watch %r{^markup/(.+(\.html)?\.haml)$}
end
```

### Configuring the output destination

If you want to change the output directory use the `:output` option in your
Guardfile, e.g.:

```ruby
guard :haml, output: 'public' do
  watch %r{^src/.+(\.html\.haml)}
end
```

This output is relative to the Guardfile.

### Multiple output option

This lets you compile to two (or more) html files from one haml file. This
comes in handy if you want to compile to both a dev and prod build directory,
for instance:

```ruby
guard :haml, input: 'markup', output: ['public/dev', 'public/build'] do
  watch %r{^.+(\.haml)$}
end
```

If you maintain your haml files in a directory that should not be part of the output path, you can set the `:input` option, e.g.:

```ruby
guard :haml, input: 'src', output: 'public' do
  watch %r{^src/.+(\.html\.haml)}
end
```
So when you edit a file `src/partials/_partial.html.haml`
it will be saved to `public/partials/_partial.html` without the `src`.

### File extensions

Guard::Haml will try to add the correct extension based on the input file name. You can provide multiple extensions to control the file name.

```ruby
"foo.haml"     -> "foo.html"
"foo"          -> "foo.html"
"foo.txt"      -> "foo.txt.html"
"foo.php.haml" -> "foo.php"
```

You can override the default extension (`html`) using the `:default_ext` option:

```ruby
guard :haml, default_ext: 'txt' do
  watch %r{^src/.+(\.html\.haml)}
end
```

### Compile when starting guard

If you want to compile haml files when Guard starts you can use `:run_at_start` option.

```ruby
guard :haml, output: 'public', input: 'src', run_at_start: true do
  watch %r{^src/.+(\.html\.haml)}
end
```

### Guard notifications

You can disable Guard notifications by setting `:notifications` option to `false`:

```ruby
guard 'haml', output: 'public', input: 'src', notifications: true do
  watch %r{^src/.+(\.html\.haml)}
end
```

### Configuring HAML

If you want to pass options to the Haml engine, you can set the `:haml_options` option, e.g.:

```ruby
guard :haml, output: 'public', input: 'src', haml_options: { ugly: true } do
  watch %r{^src/.+(\.html\.haml)}
end
```

This will produce compressed HTML. See [Haml Reference](http://haml.info/docs/yardoc/file.HAML_REFERENCE.html#options) for more details.

### List of available options

``` ruby
input: 'markup'                        # define the folder where your HAML files are stored
output: ['public/dev', 'public/build'] # define the output folder where conpiled HAML files are saved
default_ext: 'txt'                     # override the default extension (`html`)
run_at_start: false                    # compile haml files when Guard starts, default: false
notifications: false                   # enable/disable Guard notifications, default: true
haml_options: { ugly: true }           # HAML options (passed directly to HAML), default: {}
auto_append_file_ext: false            # automatically append `.html` to the generated files, default: true
```

## Development

* Documentation hosted at [RubyDoc](http://rubydoc.info/gems/guard-haml/frames).
* Source hosted at [GitHub](https://github.com/guard/guard-haml).

Pull requests are very welcome! Please try to follow these simple rules if applicable:

* Please create a topic branch for every separate change you make.
* Make sure your patches are well tested. All specs must pass on [Travis CI](https://travis-ci.org/guard/guard-haml).
* Update the [Yard](http://yardoc.org/) documentation.
* Update the [README](https://github.com/guard/guard-haml/blob/master/README.md).
* Please **do not change** the version number.

For questions please join us in our [Google group](http://groups.google.com/group/guard-dev) or on
`#guard` (irc.freenode.net).

## Author

[Immanuel Häussermann](https://github.com/manufaktor) ([@manufaktor](http://twitter.com/manufaktor), [manufaktor.com](http://manufaktor.com))

## Maintainer

[Rémy Coutable](https://github.com/rymai)

## Contributors

[https://github.com/guard/guard-haml/graphs/contributors](https://github.com/guard/guard-haml/graphs/contributors)
