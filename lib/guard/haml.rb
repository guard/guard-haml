require 'guard'
require 'guard/guard'
require 'haml'

module Guard
  class Haml < Guard
    
    VERSION = '0.0.1'
    
    def initialize(watchers = [], options = {})
      @watchers, @options = watchers, options
    end
    
    def compile_haml file
      content = File.new(file).read
      engine = Haml::Engine.new(content)
      engine.render
    end
    
    def run_all
      patterns = @watchers.map { |w| w.pattern }
      files = Dir.glob('**/*.*')
      paths = files.select do |file|
        patterns.select do |pattern| 
          file if file.match(Regexp.new(pattern))
        end
      end
      run_on_change(paths.flatten)
    end
  
    def run_on_change(paths)
      paths.each do |file|
        output_file = file[-1, -4]
        File.open(output_file, 'w') { |f| f.write(compile_haml(file)) }
        puts "# compiled '#{file}' to haml at '#{output_file}'"
      end
    end
  end
end