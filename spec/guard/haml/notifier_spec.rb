require 'guard/haml'

RSpec.describe Guard::Haml::Notifier do
  subject { described_class }

  describe '#image' do
    context 'when recieves true' do
      specify { expect(subject.image(true)).to be :success }
    end

    context 'when recieves false' do
      specify { expect(subject.image(false)).to be :failed }
    end
  end

  describe '#notify' do
    context 'when recieves true with message' do
      it 'should call Guard::Notifier with success image' do
        expect(::Guard::Notifier).to receive(:notify).with(
            'Successful compilation!',
            title: 'Guard::Haml',
            image: :success
            )
        subject.notify(true, 'Successful compilation!')
      end
    end

    context 'when recieves false with message' do
      it 'should call Guard::Notifier with failed image' do
        expect(::Guard::Notifier).to receive(:notify).with(
                'Compilation failed!',
                title: 'Guard::Haml',
                image: :failed
                )
        subject.notify(false, 'Compilation failed!')
      end
    end
  end
end
