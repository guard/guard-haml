require 'guard'
require 'guard/guard'
require 'haml'

module Guard
  class Haml < Guard
    
    VERSION = '0.2.0'
    
    def initialize(watchers = [], options = {})
      @watchers, @options = watchers, options
      @haml_options = options.delete(:haml_options) || {}
    end
    
    def compile_haml file
      content = File.new(file).read
      engine = ::Haml::Engine.new(content, @haml_options)
      engine.render
    end

    # Get the file path to output the html based on the file being
    # built.  The output path is relative to where guard is being run.
    #
    # @param file [String] path to file being built
    # @return [String] path to file where output should be written
    #
    def get_output(file)
      if @options[:output]
        FileUtils.mkdir_p(@options[:output])
        File.join(@options[:output], File.basename(file).split('.')[0..-2].join('.'))
      else
        file.split('.')[0..-2].join('.')
      end
    end
    
    def run_all
      patterns = @watchers.map { |w| w.pattern }
      files = Dir.glob('**/*.*')
      paths = files.map do |file|
        patterns.map  { |pattern| file if file.match(Regexp.new(pattern)) }
      end
      run_on_change(paths.flatten.compact)
    end
  
    def run_on_change(paths)
      paths.each do |file|
        output_file = get_output(file)
        File.open(output_file, 'w') { |f| f.write(compile_haml(file)) }
        puts "# compiled haml in '#{file}' to html in '#{output_file}'"
      end
    end
  end
end
