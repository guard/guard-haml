require 'spec_helper'

describe Guard::Haml do
  subject { Guard::Haml.new }

    describe '#start' do
      it 'should not call #run_all by default' do
        subject.should_not_receive(:run_all).and_return(true)
        subject.start
      end

      context 'when run_on_start option set to true' do
        before do
          subject.options[:run_at_start] = true
        end

        it 'should call #run_all' do
          subject.should_receive(:run_all).and_return(true)
          subject.start
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
      it 'should return true' do
        subject.stop.should be_true
      end
    end

    describe '#reload' do
      it 'should call #run_all' do
        subject.should_receive(:run_all).and_return(true)
        subject.reload
      end
    end
  
  describe 'run all' do
    it 'should rebuild all files being watched' do
      Guard::Haml.stub(:run_on_change).with([]).and_return([])
      Guard.stub(:guards).and_return([subject])
      subject.run_all
    end
  end
  
  describe '#get_output' do
    context 'by default' do
      it 'should return test/index.html.haml as test/index.html' do
        subject.send(:get_output, 'test/index.html.haml').
                        should eq('test/index.html')
      end
      
      it 'should return test/index.htm.haml as test/index.htm' do
        subject.send(:get_output, 'test/index.htm.haml').
                        should eq('test/index.htm')
      end

      it 'should return test/index.haml as test/index.html' do
        subject.send(:get_output, 'test/index.haml').
                        should eq('test/index.html')
      end
    end
    
    context 'when the output option is set to "demo/output"' do
      before do
        subject.options[:output] = 'demo/output'
      end
      
      it 'should return test/index.html.haml as demo/output/test/index.html.haml' do
        subject.send(:get_output, 'test/index.html.haml').
                  should eq('demo/output/test/index.html')
      end
    end
    
    context 'when the exclude_base_dir option is set to "test/ignore"' do
      before do
        subject.options[:input] = 'test/ignore'
      end
      
      it 'should return test/ignore/index.html.haml as index.html' do
        subject.send(:get_output, 'test/ignore/index.html.haml').
                                    should eq('index.html')
      end
      
      context 'when the output option is set to "demo/output"' do
        before do
          subject.options[:output] = 'demo/output'
        end
        
        it 'should return test/ignore/abc/index.html.haml as demo/output/abc/index.html' do
          subject.send(:get_output, 'test/ignore/abc/index.html.haml').
                          should eq('demo/output/abc/index.html')
        end
      end
    end
  end
  
  describe '#run_on_changes' do
    it 'should notify other guards upon completion' do
      subject.should_receive(:notify).with([])
      subject.run_on_changes([])
    end
  end

  describe '#compile_haml' do
    it 'throws :task_has_failed when an error occurs' do
      expect { subject.send(:compile_haml, '') }.to throw_symbol :task_has_failed
    end
  end
end
