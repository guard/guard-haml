require 'spec_helper'

describe Guard::Haml::Notifier do
  subject { described_class }

  describe '#image' do
    context 'when recieves true' do
      specify { subject.image(true).should be :success }
    end

    context 'when recieves false' do
      specify { subject.image(false).should be :failed }
    end
  end

  describe '#notify' do
    context 'when recieves true with message' do
      it 'should call Guard::Notifier with success image' do
        ::Guard::Notifier.should_receive(:notify).with(
            'Successful compilation!',
            title: 'Guard::Haml',
            image: :success
            )
        subject.notify(true, 'Successful compilation!')
      end
    end

    context 'when recieves false with message' do
      it 'should call Guard::Notifier with failed image' do
        ::Guard::Notifier.should_receive(:notify).with(
                'Compilation failed!',
                title: 'Guard::Haml',
                image: :failed
                )
        subject.notify(false, 'Compilation failed!')
      end
    end
  end
end