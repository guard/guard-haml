require 'guard'
require 'guard/guard'
require 'guard/watcher'
require 'haml'

module Guard
  class Haml < Guard
    autoload :Notifier, 'guard/haml/notifier'

    def initialize(watchers = [], options = {})
      @options = {
        :notifications => true,
        :default_ext   => 'html',
        :auto_append_file_ext => false,
        :evironment_folder => false
      }.merge options
      super(watchers, @options)
    end

    def start
      run_all if @options[:run_at_start]
    end

    def stop
      true
    end

    def reload
      run_all
    end

    def run_all
      run_on_changes(Watcher.match_files(self, Dir.glob(File.join('**', '*.*'))))
    end

    def run_on_changes(paths)
      paths.each do |file|
        output_files = get_output(file)
        output_files.each do |output_file, env|
          compiled_haml = compile_haml(file, env)
          FileUtils.mkdir_p File.dirname(output_file)
          File.open(output_file, 'w') { |f| f.write(compiled_haml) }
        end
        message = "Successfully compiled haml to html!\n"
        message += "# #{file} -> #{output_files.map{|k,v| "#{k}"}.join(', ')}".gsub("#{::Bundler.root.to_s}/", '')
        ::Guard::UI.info message
        Notifier.notify( true, message ) if @options[:notifications]
      end
      notify paths
    end

    private

    def compile_haml file, env=nil
      begin
        content = File.new(file).read
        engine  = ::Haml::Engine.new(content, (@options[:haml_options] || {}))
        engine.render(Object.new, :env =>env)
      rescue StandardError => error
        message = "HAML compilation failed!\nError: #{error.message}"
        ::Guard::UI.error message
        Notifier.notify( false, message ) if @options[:notifications]
        throw :task_has_failed
      end
    end

    # Get the file path to output the html based on the file being
    # built. The output path is relative to where guard is being run.
    #
    # @param file [String, Array<String>] path to file being built
    # @return [Array<String>] path(s) to file where output should be written
    #
    def get_output(file)
      input_file_dir = File.dirname(file)
      file_name = get_file_name(file)
      file_name = "#{file_name}.html" if append_file_ext_to_output_path?(file_name)
      input_file_dir = input_file_dir.gsub(Regexp.new("#{@options[:input]}(\/){0,1}"), '') if @options[:input]
      if @options[:output]
        if @options[:environment_folder]
          Hash[
            Array(@options[:output]).map do |output_dir|
              env = output_dir.gsub(Regexp.new("#{output_dir}(.+){1,}"), '') 
              [File.join(output_dir, input_file_dir, file_name), env]
            end
          ]
        else
          Array(@options[:output]).map do |output_dir|
            File.join(output_dir, input_file_dir, file_name)
          end
        end
      else
        if input_file_dir == ''
          [file_name]
        else
          [File.join(input_file_dir, file_name)]
        end
      end
    end

    # Generate a file name based on the provided file path.
    # Provide a logical extension.
    #
    # Examples:
    #   "path/foo.haml"     -> "foo.html"
    #   "path/foo"          -> "foo.html"
    #   "path/foo.bar"      -> "foo.bar.html"
    #   "path/foo.bar.haml" -> "foo.bar"
    #
    # @param file String path to file
    # @return String file name including extension
    #
    def get_file_name(file)
      sub_strings           = File.basename(file).split('.')
      base_name, extensions = sub_strings.first, sub_strings[1..-1]

      if extensions.last == 'haml'
        extensions.pop
        if extensions.empty?
          [base_name, @options[:default_ext]].join('.')
        else
          [base_name, extensions].flatten.join('.')
        end
      else
        [base_name, extensions, @options[:default_ext]].flatten.join('.')
      end
    end

    def append_file_ext_to_output_path?(file_name)
      return unless @options[:auto_append_file_ext]
      file_name.match("\.html?").nil?
    end

    def notify(changed_files)
      ::Guard.guards.reject{ |guard| guard == self }.each do |guard|
        paths = Watcher.match_files(guard, changed_files)
        guard.run_on_changes paths unless paths.empty?
      end
    end
  end
end
