require 'rudux/combined'

describe Rudux::Combined, '#reduce' do
  let(:state)  { double :state }
  let(:action) { double :action }
  let(:reducer1) { double :reducer1 }
  let(:reducer2) { double :reducer2 }

  subject { Rudux::Combined.new(config).reduce(state, action) }


  context 'given config with reducers' do
    let(:config) {
      {
        a: reducer1,
        b: reducer2,
      }
    }

    it 'is hash with keys maintained but values ran through reducers' do
      expect(state).to receive(:a).and_return(:substate1)
      expect(state).to receive(:b).and_return(:substate2)

      expect(reducer1).to receive(:reduce)
        .with(:substate1, action)
        .and_return(:reduced1)

      expect(reducer2).to receive(:reduce)
        .with(:substate2, action)
        .and_return(:reduced2)

      expect(subject).to eq({
        a: :reduced1,
        b: :reduced2})
    end
  end


  context 'given empty config' do
    let(:config) { {} }

    it 'is empty hash' do
      expect(subject).to eq({})
    end
  end
end

