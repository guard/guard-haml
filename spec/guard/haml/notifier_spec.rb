require 'spec_helper'

describe Guard::Haml::Notifier do
  subject { Guard::Haml::Notifier }

  it 'should select success image' do
    subject.image(true).should == :success
  end

  it 'should select failed image' do
    subject.image(false).should == :failed
  end

  it 'should call Guard::Notifier for successful compilation' do
    ::Guard::Notifier.should_receive(:notify).with(
      'Successful compilation!',
      :title => 'Guard::Haml',
      :image => :success
    )
    subject.notify(true, 'Successful compilation!')
  end

  it 'should call Guard::Notifier for failed compilation' do
    ::Guard::Notifier.should_receive(:notify).with(
      "Compilation failed!",
      :title => 'Guard::Haml',
      :image => :failed
    )
    subject.notify(false, 'Compilation failed!')
  end
end