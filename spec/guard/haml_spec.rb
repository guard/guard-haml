require 'spec_helper'

describe Guard::Haml do
  let(:subject_with_options) { described_class.new( [],
                                :notifications => false,
                                :run_at_start => true) }
  let(:subject_notifiable) { described_class.new( [],
                                :notifications => true ) }
  let(:notifier) { Guard::Haml::Notifier }

  describe "class" do
    it 'should autoload Notifier class' do
      expect { Guard::Haml::Notifier }.not_to raise_error
    end
  end

  describe '#new' do
    context 'notifications option by default' do
      specify { subject.options[:notifications].should be_true }
    end

    context "when recieves options hash" do
      it 'should merge it to @options instance variable' do
        subject_with_options.options[:notifications].should be_false
        subject_with_options.options[:run_at_start].should be_true
      end
    end
  end

  describe '#start' do
    context 'by default' do
      it 'should not call #run_all' do
        subject.should_not_receive(:run_all).and_return(true)
        subject.start
      end
    end

    context 'when run_on_start option set to true' do
      it 'should call #run_all' do
        subject_with_options.should_receive(:run_all).and_return(true)
        subject_with_options.start
      end
    end

    context 'when run_on_start option set to false' do
      before do
        subject.options[:run_at_start] = false
      end

      it 'should not call #run_all' do
        subject.should_not_receive(:run_all).and_return(true)
        subject.start
      end
    end
  end

  describe '#stop' do
    specify { subject.stop.should be_true }
  end

  describe '#reload' do
    it 'should call #run_all' do
      subject.should_receive(:run_all).and_return(true)
      subject.reload
    end
  end

  describe '#run_all' do
    it 'should rebuild all files being watched' do
      Guard::Haml.stub(:run_on_change).with([]).and_return([])
      Guard.stub(:guards).and_return([subject])
      subject.run_all
    end
  end

  describe '#get_output' do
    context 'by default' do
      it 'should return test/index.html.haml as [test/index.html]' do
        subject.send(:get_output, 'test/index.html.haml').
                        should eq(['test/index.html'])
      end

      it 'should return test/index.htm.haml as [test/index.htm]' do
        subject.send(:get_output, 'test/index.htm.haml').
                        should eq(['test/index.htm'])
      end

      it 'should return test/index.haml as [test/index.html]' do
        subject.send(:get_output, 'test/index.haml').
                        should eq(['test/index.html'])
      end

      it 'should return [test/index1.html.haml, test/index2.html.haml] as [test/index1.html, test/index2.html]' do
        subject.send(:get_output, ['test/index1.html.haml', 'test/index2.html.haml']).
                        should eq(['test/index1.html', 'test/index2.html'])
      end
    end

    context 'when the output option is set to "demo/output"' do
      before do
        subject.options[:output] = 'demo/output'
      end

      it 'should return test/index.html.haml as [demo/output/test/index.html.haml]' do
        subject.send(:get_output, 'test/index.html.haml').
                  should eq(['demo/output/test/index.html'])
      end
    end

    context 'when the exclude_base_dir option is set to "test/ignore"' do
      before do
        subject.options[:input] = 'test/ignore'
      end

      it 'should return test/ignore/index.html.haml as [index.html]' do
        subject.send(:get_output, 'test/ignore/index.html.haml').
                                    should eq(['index.html'])
      end

      context 'when the output option is set to "demo/output"' do
        before do
          subject.options[:output] = 'demo/output'
        end

        it 'should return test/ignore/abc/index.html.haml as [demo/output/abc/index.html]' do
          subject.send(:get_output, 'test/ignore/abc/index.html.haml').
                          should eq(['demo/output/abc/index.html'])
        end
      end
    end
  end

  describe '#run_on_changes' do
    it 'should notify other guards upon completion' do
      subject.should_receive(:notify).with([])
      subject.run_on_changes([])
    end

    context 'when notifications option set to true' do
      let(:success_message) { "Successfully compiled haml to html!\n" }

      context 'with one output' do
        after do
          File.unlink "#{@fixture_path}/test.html"
        end

        it 'should call Notifier.notify with 1 output' do
          message = success_message + "# spec/fixtures/test.html.haml -> spec/fixtures/test.html"
          notifier.should_receive(:notify).with(true, message)
          subject_notifiable.run_on_changes(["#{@fixture_path}/test.html.haml"])
        end
      end


      it 'should call Notifier.notify' do
        message = "Successfully compiled haml to html!\n"
        message += "# spec/fixtures/test.html.haml -> spec/fixtures/test.html"
        notifier.should_receive(:notify).with(true, message)
        subject_notifiable.run_on_changes(["#{@fixture_path}/test.html.haml"])
      end

      context 'with two outputs' do
        before do
          subject_notifiable.stub(:get_output).and_return(["#{@fixture_path}/test.html", "#{@fixture_path}/test2.html"])
        end

        after do
          File.unlink "#{@fixture_path}/test.html"
          File.unlink "#{@fixture_path}/test2.html"
        end

        it 'should call Notifier.notify with 2 outputs' do
          message = success_message + "# spec/fixtures/test.html.haml -> spec/fixtures/test.html, spec/fixtures/test2.html"
          notifier.should_receive(:notify).with(true, message)
          subject_notifiable.run_on_changes(["#{@fixture_path}/test.html.haml"])
        end
      end
    end
  end

  describe '#compile_haml' do
    it 'throws :task_has_failed when an error occurs' do
      expect { subject.send(:compile_haml, "#{@fixture_path}/fail_test.html.haml") }.
              to throw_symbol :task_has_failed
    end

    context 'when notifications option set to true' do
      it 'should call Notifier.notify when an error occurs' do
        message = "HAML compilation failed!\n"
        message += "Error: Illegal nesting: content can't be both given on the same line as %p and nested within it."
        notifier.should_receive(:notify).with(false, message)
        catch(:task_has_failed) do
          subject_notifiable.send(:compile_haml, "#{@fixture_path}/fail_test.html.haml")
        end.should be_nil

      end
    end
  end
end
