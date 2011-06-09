require 'spec_helper'

describe Guard::Haml do
  subject { Guard::Haml.new }
  
  describe "run all" do
    it "should rebuild all files being watched" do
      Guard::Haml.stub(:run_on_change).with([]).and_return([])
      Guard.stub(:guards).and_return([subject])
      subject.run_all
    end
  end
  
  describe "building haml to html" do
    it "should convert haml to html" do
      file = <<EOS
!!!
%html
  %body
    %h1 Index
    %p Hello World
EOS
      file_name = '_index.haml'
      File.open(file_name, 'w') do |f|
        f.write file
      end
      res = <<EOS
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <body>
    <h1>Index</h1>
    <p>Hello World</p>
  </body>
</html>
EOS
      
      subject.compile_haml(file_name).should == res

      FileUtils.rm file_name
    end
    
    it "should notify other guards upon completion" do
      other_guard = mock('guard')
      other_guard.should_receive(:watchers).and_return([])
      Guard.stub(:guards).and_return([subject, other_guard])
      subject.notify([])
    end
  end
  
  describe "getting path to output file" do
    it "should change extension to html" do
      subject.options[:output] = "css"
      r = subject.get_output("haml-test/_haml/index.haml")
      r.split('.')[1].should == "html"
    end
    
    it "should not change the file name" do
      subject.options[:output] = "css"
      r = subject.get_output("haml-test/_haml/index.haml")
      File.basename(r).split(".")[0].should == "index"
    end
  end
  
end
