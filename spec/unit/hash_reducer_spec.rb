require 'rudux/hash_reducer'

describe Rudux::HashReducer, '#reduce' do
  let(:subreducer) { double :subreducer }

  let(:action)     { double :action }

  let(:state1)     { double :state1, id: :key1 }
  let(:state2)     { double :state2, id: :key2 }
  let(:state)      {
    {
      key1: state1,
      key2: state2
    }
  }

  let(:new_state) {
    {
      key1: new_state1,
      key2: new_state2
    }
  }
  let(:new_state1) { double :new_state1, id: :key1 }
  let(:new_state2) { double :new_state2, id: :key2 }


  before {
    expect(subreducer).to receive(:reduce)
      .with(state1, action).and_return(new_state1)
  }

  before {
    expect(subreducer).to receive(:reduce)
      .with(state2, action).and_return(new_state2)
  }

  subject { Rudux::HashReducer.new(subreducer).reduce(state, action) }

  it 'mutates state with the result of the dispatched action' do
    expect(subject).to eq(new_state)
  end
end

