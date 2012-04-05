require 'spec_helper'

describe Guard::Haml do
  subject { Guard::Haml.new }
  
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
        subject.get_output('test/index.html.haml').should eq('test/index.html')
      end
      
      it 'should return test/index.htm.haml as test/index.htm' do
        subject.get_output('test/index.htm.haml').should eq('test/index.htm')
      end

      it 'should return test/index.haml as test/index.html' do
        subject.get_output('test/index.haml').should eq('test/index.html')
      end
    end
    
    context 'when the output option is set to "demo/output"' do
      before do
        subject.options[:output] = 'demo/output'
      end
      
      it 'should return test/index.html.haml as demo/output/test/index.html.haml' do
        subject.get_output('test/index.html.haml').should eq('demo/output/test/index.html')
      end
    end
    
    context 'when the exclude_base_dir option is set to "test/ignore"' do
      before do
        subject.options[:input] = 'test/ignore'
      end
      
      it 'should return test/ignore/index.html.haml as index.html' do
        subject.get_output('test/ignore/index.html.haml').should eq('index.html')
      end
      
      context 'when the output option is set to "demo/output"' do
        before do
          subject.options[:output] = 'demo/output'
        end
        
        it 'should return test/ignore/abc/index.html.haml as demo/output/abc/index.html' do
          subject.get_output('test/ignore/abc/index.html.haml').should eq('demo/output/abc/index.html')
        end
      end
    end
  end
  
  describe 'building haml to html' do
    it 'should notify other guards upon completion' do
      other_guard = mock('guard')
      other_guard.should_receive(:watchers).and_return([])
      Guard.stub(:guards).and_return([subject, other_guard])
      subject.notify([])
    end
  end  
end
