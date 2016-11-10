require 'rudux/store'

describe Rudux::Store, '#dispatch' do
  let(:reducer) { double :reducer }
  let(:state)   { double :state   }
  let(:action)  { double :action  }

  before do
    expect(reducer).to receive(:reduce)
      .with(state, action)
      .and_return(:new_state)
  end

  subject { Rudux::Store.new(reducer, state) }

  it 'mutates state with the result of the dispatched action' do
    subject.dispatch(action)
    expect(subject.state).to eq :new_state
  end
end


describe Rudux::Store, '#state' do
  subject { Rudux::Store.new(reducer, state).state }
  let(:reducer) { double :reducer }
  let(:state)   { double :state }

  it 'exposes state' do
    expect(subject).to eq state
  end
end


describe Rudux::Store, '#select' do
  let(:state) { double :state }
  let(:selector) { double :selector }
  subject { Rudux::Store.new(double, state) }
  it 'calls #select on the passed selector with the state as argument' do
    expect(selector).to receive(:select).with(state) { :selected }
    expect(subject.select(selector)).to eq :selected
  end
end
