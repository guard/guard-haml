require 'guard'
require 'guard/guard'
require 'guard/watcher'

require 'haml'

module Guard
  class Haml < Guard
    
    def initialize(watchers = [], options = {})
      super(watchers, {
        :notifications => true      
      }.merge(options))
      @watchers, @options = watchers, options
      @haml_options = options.delete(:haml_options) || {}
      @input_dir = options.delete(:input)
      @input_dir += '/' if @input_dir && @input_dir[@input_dir.length-1] != '/'
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
        file_dir = File.dirname(file)
        file_dir = file_dir.sub!(@input_dir, '') if @input_dir
        output_folder = File.join(  @options[:output], file_dir )
        FileUtils.mkdir_p(output_folder)
        file_name = File.basename(file).split('.').first
        File.join(output_folder, file_name + '.html')
      else
        file.split('.')[0..-2].join('.')
      end
    end
    
    def run_all
      run_on_change(Watcher.match_files(self, Dir.glob(File.join('**', '*.*'))))
      #patterns = @watchers.map { |w| w.pattern }
      #files = Dir.glob('**/*.*')
      #paths = files.map do |file|
      #  patterns.map  { |pattern| file if file.match(Regexp.new(pattern)) }
      #end
      #run_on_change(paths.flatten.compact)
    end
  
    def run_on_change(paths)
      paths.each do |file|
        output_file = get_output(file)
        File.open(output_file, 'w') { |f| f.write(compile_haml(file)) }
        ::Guard::UI.info "# compiled haml in '#{file}' to html in '#{output_file}'"
        ::Guard::Notifier.notify("# compiled haml in #{file}", :title => "Guard::Haml", :image => :success) if @options[:notifications]
      end
      notify paths
    end

    def notify(changed_files)
      ::Guard.guards.reject{ |guard| guard == self }.each do |guard|
        paths = Watcher.match_files(guard, changed_files)
        guard.run_on_change paths unless paths.empty?
      end
    end
    
  end
end
