require 'guard'
require 'guard/guard'
require 'guard/watcher'
require 'haml'

module Guard
  class Haml < Guard
    autoload :Notifier, 'guard/haml/notifier'

    def initialize(watchers = [], options = {})
      @options = {
        :notifications => true
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
      paths = paths_without_layout paths
      paths.each do |file|
        output_files = get_output(file)
        output_files.each do |output_file|
          FileUtils.mkdir_p File.dirname(output_file)
          File.open(output_file, 'w') { |f| f.write(compile_haml(file)) }
        end
        message = "Successfully compiled haml to html!\n"
        message += "# #{file} -> #{output_files.join(', ')}".gsub("#{Bundler.root.to_s}/", '')
        ::Guard::UI.info message
        Notifier.notify( true, message ) if @options[:notifications]
      end
      notify paths
    end

    private

    def paths_without_layout paths = []
      if layout_file_name
        paths.reject { |path| path =~ /#{layout_file_name}/ }
      else
        paths
      end
    end

    def layout_file_name
      @layout_file_name ||= if @options[:layout]
        "#{@options[:layout]}_layout"
      end
    end

    def layout_file_path
      @layout_file_path ||= if layout_file_name
        Watcher.match_files(self, Dir.glob(File.join('**', '*.*'))).find { |path| path =~ /#{layout_file_name}/ }
      end
    end

    def layout
      @layout ||= if layout_file_name
        if layout_file_path
          begin
            if content_layout = File.new(layout_file_path).read
              message = "HAML *layout* using: #{layout_file_path}"
              ::Guard::UI.info message
              Notifier.notify( true, message ) if @options[:notifications]
              content_layout
            end
          rescue StandardError => error
            message = "HAML *layout* file not found or unreadable!\nError: #{error.message}"
            ::Guard::UI.error message
            Notifier.notify( false, message ) if @options[:notifications]
            throw :task_has_failed
          end
        else
          message = "HAML *layout* file #{layout_file_name} not found or unreadable!"
          ::Guard::UI.error message
          Notifier.notify( false, message ) if @options[:notifications]
          throw :task_has_failed
        end
      end
    end

    def compile_haml file
      begin
        content = File.new(file).read
        if layout
          ::Haml::Engine.new(layout, (@options[:haml_options] || {})).render do
            ::Haml::Engine.new(content, (@options[:haml_options] || {})).render
          end
        else
          ::Haml::Engine.new(content, (@options[:haml_options] || {})).render
        end
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
    def get_output(files)
      Array(files).map do |file|
        file_dir = File.dirname(file)
        file_name = File.basename(file).split('.')[0..-2].join('.')

        file_name = "#{file_name}.html" if file_name.match("\.html?").nil?

        file_dir = file_dir.gsub(Regexp.new("#{@options[:input]}(\/){0,1}"), '') if @options[:input]
        file_dir = File.join(@options[:output], file_dir) if @options[:output]

        if file_dir == ''
          file_name
        else
          File.join(file_dir, file_name)
        end
      end
    end

    def notify(changed_files)
      ::Guard.guards.reject{ |guard| guard == self }.each do |guard|
        paths = Watcher.match_files(guard, changed_files)
        guard.run_on_changes paths unless paths.empty?
      end
    end
  end
end
