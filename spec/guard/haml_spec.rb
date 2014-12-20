require 'guard/haml'

RSpec.describe Guard::Haml do
  let(:subject_with_options) { described_class.new(notifications: false, run_at_start: true) }
  let(:subject_notifiable) { described_class.new(notifications: true) }
  let(:notifier) { Guard::Haml::Notifier }

  describe 'class' do
    it 'should autoload Notifier class' do
      expect { Guard::Haml::Notifier }.not_to raise_error
    end
  end

  describe '#new' do
    context 'notifications option by default' do
      specify { expect(subject.options[:notifications]).to be_truthy }
    end

    context 'when receives options hash' do
      it 'should merge it to @options instance variable' do
        expect(subject_with_options.options[:notifications]).to be_falsey
        expect(subject_with_options.options[:run_at_start]).to be_truthy
      end
    end

    context 'with no watchers and the :input option' do
      let(:plugin) { described_class.new(input: 'markup') }

      it 'generates watchers automatically' do
        expect(plugin.watchers.size).to eq(1)
        expect(plugin.watchers[0].pattern).to eq %r{^markup/([\w\-_]+(\.html)?\.haml)$}
      end
    end
  end

  describe '#start' do
    context 'by default' do
      it 'should not call #run_all' do
        expect(subject).not_to receive(:run_all)
        subject.start
      end
    end

    context 'when run_on_start option set to true' do
      it 'should call #run_all' do
        expect(subject_with_options).to receive(:run_all)
        subject_with_options.start
      end
    end

    context 'when run_on_start option set to false' do
      before do
        subject.options[:run_at_start] = false
      end

      it 'should not call #run_all' do
        expect(subject).not_to receive(:run_all)
        subject.start
      end
    end
  end

  describe '#stop' do
    specify { expect(subject.stop).to be_truthy }
  end

  describe '#reload' do
    it 'should call #run_all' do
      expect(subject).to receive(:run_all).and_return(true)
      subject.reload
    end
  end

  describe '#run_all' do
    it 'should rebuild all files being watched' do
      allow(subject).to receive(:run_on_changes).with([]).and_return([])
      allow(Guard).to receive(:guards).and_return([subject])
      subject.run_all
    end
  end

  describe '#_output_paths' do
    context 'by default' do
      it 'should return test/index.html.haml as [test/index.html]' do
        expect(subject.send(:_output_paths, 'test/index.html.haml'))
          .to eq(['test/index.html'])
      end

      it 'should return test/index.htm.haml as [test/index.htm]' do
        expect(subject.send(:_output_paths, 'test/index.htm.haml'))
          .to eq(['test/index.htm'])
      end

      it 'should return test/index.haml as [test/index.html]' do
        expect(subject.send(:_output_paths, 'test/index.haml'))
          .to eq(['test/index.html'])
      end
    end

    context 'when the output option is set to "demo/output"' do
      before do
        subject.options[:output] = 'demo/output'
      end

      it 'should return test/index.html.haml as [demo/output/test/index.html.haml]' do
        expect(subject.send(:_output_paths, 'test/index.html.haml'))
          .to eq(['demo/output/test/index.html'])
      end
    end

    context 'when the output option is set to ["demo/output", "demo2/output"]' do
      before do
        subject.options[:output] = ['demo1/output', 'demo2/output']
      end

      it 'should return test/index.html.haml as [demo1/output/test/index.html.haml, demo2/output/test/index.html.haml]' do
        expect(subject.send(:_output_paths, 'test/index.html.haml'))
          .to eq(['demo1/output/test/index.html', 'demo2/output/test/index.html'])
      end
    end

    context 'when the default extensions is set to "txt"' do
      before do
        subject.options[:default_ext] = 'txt'
      end

      it 'should return test/index.haml as test/index.txt' do
        expect(subject.send(:_output_paths, 'test/index.haml'))
          .to eq(['test/index.txt'])
      end

      it 'should return test/index.php.haml as test/index.php due to the second extension' do
        expect(subject.send(:_output_paths, 'test/index.php.haml'))
          .to eq(['test/index.php'])
      end
    end

    context 'when the exclude_base_dir option is set to "test/ignore"' do
      before do
        subject.options[:input] = 'test/ignore'
      end

      it 'should return test/ignore/index.html.haml as [index.html]' do
        expect(subject.send(:_output_paths, 'test/ignore/index.html.haml'))
          .to eq(['index.html'])
      end

      context 'when the output option is set to "demo/output"' do
        before do
          subject.options[:output] = 'demo/output'
        end

        it 'should return test/ignore/abc/index.html.haml as [demo/output/abc/index.html]' do
          expect(subject.send(:_output_paths, 'test/ignore/abc/index.html.haml'))
            .to eq(['demo/output/abc/index.html'])
        end
      end
    end

    context 'when the input file contains a second extension"' do
      it 'should return test/index.php.haml as [test/index.php]' do
        expect(subject.send(:_output_paths, 'test/index.php.haml'))
          .to eq(['test/index.php'])
      end
    end
  end

  describe '#_output_filename' do
    context 'by default (if a ".haml" extension has been defined)' do
      it 'should return the file name with the default extension ".html"' do
        expect(subject.send(:_output_filename, 'test/index.haml'))
          .to eq('index.html')
      end
    end

    context 'if no extension has been defined at all' do
      it 'should return the file name with the default extension ".html"' do
        expect(subject.send(:_output_filename, 'test/index'))
          .to eq('index.html')
      end
    end

    context 'if an extension other than ".haml" has been defined' do
      it 'should return the file name with the default extension ".html"' do
        expect(subject.send(:_output_filename, 'test/index.foo'))
          .to eq('index.foo.html')
      end
    end

    context 'if multiple extensions including ".haml" have been defined' do
      it 'should return the file name with the extension second to last' do
        expect(subject.send(:_output_filename, 'test/index.foo.haml'))
          .to eq('index.foo')
      end
    end
  end

  describe '#run_on_changes' do
    context 'when notifications option set to true' do
      let(:success_message) { "Successfully compiled haml to html!\n" }

      context 'with one output' do
        after do
          File.unlink "#{@fixture_path}/test.html"
        end

        it 'should call Notifier.notify with 1 output' do
          message = success_message + '# spec/fixtures/test.html.haml -> spec/fixtures/test.html'
          expect(notifier).to receive(:notify).with(true, message)
          subject_notifiable.run_on_changes(["#{@fixture_path}/test.html.haml"])
        end
      end

      it 'should call Notifier.notify' do
        message = "Successfully compiled haml to html!\n"
        message += '# spec/fixtures/test.html.haml -> spec/fixtures/test.html'
        expect(notifier).to receive(:notify).with(true, message)
        subject_notifiable.run_on_changes(["#{@fixture_path}/test.html.haml"])
      end

      context 'with two outputs' do
        before do
          allow(subject_notifiable).to receive(:_output_paths).and_return(["#{@fixture_path}/test.html", "#{@fixture_path}/test2.html"])
        end

        after do
          File.unlink "#{@fixture_path}/test.html"
          File.unlink "#{@fixture_path}/test2.html"
        end

        it 'should call Notifier.notify with 2 outputs' do
          message = success_message + '# spec/fixtures/test.html.haml -> spec/fixtures/test.html, spec/fixtures/test2.html'
          expect(notifier).to receive(:notify).with(true, message)
          subject_notifiable.run_on_changes(["#{@fixture_path}/test.html.haml"])
        end
      end
    end
  end

  describe '#compile_haml' do
    it 'throws :task_has_failed when an error occurs' do
      expect { subject.send(:compile_haml, "#{@fixture_path}/fail_test.html.haml") }
        .to throw_symbol :task_has_failed
    end

    context 'when notifications option set to true' do
      it 'should call Notifier.notify when an error occurs' do
        message = "HAML compilation of #{@fixture_path}/fail_test.html.haml failed!\n"
        message += "Error: Illegal nesting: content can't be both given on the same line as %p and nested within it."
        expect(notifier).to receive(:notify).with(false, message)
        expect(catch(:task_has_failed) do
          subject_notifiable.send(:compile_haml, "#{@fixture_path}/fail_test.html.haml")
        end).to be_nil
      end
    end
  end
end
