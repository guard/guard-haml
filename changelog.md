# CHANGELOG

## Development
* Added new notifier, guard compatible methods, Travis-CI testing ([@kugaevsky])

## 0.4
* ensure guard 1.1 compatibility, use run_on_changes, throw :task_has_failed on error

## 0.3.3
* appending .html to file name if the input file doesn't match the pattern *.html.haml or *.htm.haml ([@rtircher][])
* Add documentation for :haml_options ([@zhangsu][])

## 0.3.2
* Fix bug with ignored options in initialization. ([@ordinaryzelig][])

## 0.3.1.
* guard-haml is no longer crashing guard when HAML fails to compile

## 0.3.0
* Added the input option, to exclude a path from the output path. ([@draiken][])

## 0.2.0
* Added output option, to save compiled files into a different directory ([@Nemo157][])

## 0.1.2
* Set empty default HAML options

## 0.1.1
* Allow to pass an option hash directly to HAML via :haml_options => { ... }

## 0.1
* inital release

[@zhangsu]: https://github.com/zhangsu
[@rtircher]: https://github.com/rtircher
[@ordinaryzelig]: https://github.com/ordinaryzelig
[@Nemo157]: https://github.com/Nemo157
[@draiken]: https://github.com/draiken
[@kugaevsky]: https://github.com/kugaevsky