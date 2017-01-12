require 'rudux/reducer'
require 'rudux/action' # TODO
require 'rudux/entity' # TODO


describe Rudux::Reducer, '.reduce' do
  let(:action) { double :action }
  let(:target) { Rudux::Reducer }
  subject { target.reduce(states, action) }

  context 'given array of states' do
    let(:states) { [] }
    it 'delegates to array reducer' do
      expect(target).to receive(:reduce_array_of_states).with(states, action) { :reduced }
      expect(subject).to eq :reduced
    end
  end

  context 'given hash state' do
    let(:states) { {} }
    it 'delegates to single reducer' do
      expect(target).to receive(:reduce_single_state).with(states, action) { :reduced }
      expect(subject).to eq :reduced
    end
  end

  context 'given object state' do
    let(:states) { double :state }
    it 'delegates to single reducer' do
      expect(target).to receive(:reduce_single_state).with(states, action) { :reduced }
      expect(subject).to eq :reduced
    end
  end
end



describe Rudux::Reducer, '.reduce_array_of_states' do
  let(:action) { double :action }
  let(:state1)  { double :state1 }
  let(:state2)  { double :state2 }
  let(:state3)  { double :state3 }
  let(:states) { [state1, state2, state3] }
  let(:target) { Rudux::Reducer }

  subject { target.reduce_array_of_states(states, action) }

  it 'delegates to single state reducer for each state' do
    expect(target).to receive(:reduce_single_state).with(state1, action) { :reduced1 }
    expect(target).to receive(:reduce_single_state).with(state2, action) { :reduced2 }
    expect(target).to receive(:reduce_single_state).with(state3, action) { :reduced3 }
    expect(subject).to eq [:reduced1, :reduced2, :reduced3]
  end
end



describe Rudux::Reducer, '.reduce_single_state' do
  let(:action) { instance_double Rudux::Action }
  let(:state)  { instance_double Rudux::Entity }
  let(:target) { Rudux::Reducer }
  let(:base_reducer)   { double :base_reducer   }
  let(:action_reducer) { double :action_reducer }
  let(:action_symbol)  { :action_symbol }

  subject { target.reduce_single_state(state, action) }

  before { allow(action).to receive(:to_sym) { action_symbol } }
  before { expect(target).to receive(:base) { base_reducer } }

  class Rudux::DummyReducer < Rudux::Reducer
    def self.action_symbol state, action
    end
  end

  context 'given reduction results in changes' do
    let(:reduced_base)   { { a: :a1, b: :b1 } }
    let(:reduced_action) { { a: :a2, c: :c1 } }

    before do
      expect(base_reducer).to receive(:reduce).with(state, action) { reduced_base }
    end

    context 'given action exists' do
      let(:target) { Rudux::DummyReducer }
      before { expect(target).to receive(action_symbol).with(state, action) { reduced_action } }
      it 'copies state with merged result of base and action (taking precedence) reduction' do
        expect(state).to receive(:copy).with(a: :a2, b: :b1, c: :c1) { :merged }
        expect(subject).to eq :merged
      end
    end


    context 'given action does not exist' do
      let(:target) { Rudux::Reducer }
      it 'copies state with result of base reduction' do
        expect(state).to receive(:copy).with(reduced_base) { :base }
        expect(subject).to eq :base
      end
    end
  end

  context 'given base reduction and action reduction both result in {}, i.e. no changes' do
    let(:target) { Rudux::DummyReducer }
    before { expect(target).to receive(action_symbol).with(state, action) { {} } }
    before { expect(base_reducer).to receive(:reduce).with(state, action) { {} } }
    it 'returns the orginal, not a copy of the original' do
      expect(subject).to eq state
    end
  end
end



describe Rudux::Reducer, '.base' do
  it 'has a default implementation that returns null reducer' do
    expect(Rudux::Combined).to receive(:new).with({}).and_return(:null_reducer)
    expect(Rudux::Reducer.base).to eq :null_reducer
  end
end



describe Rudux::Reducer, '.method_missing' do
  it 'does not catch methods that exist in subclasses' do
    class Rudux::Sub < Rudux::Reducer
      def self.existing
        :proof
      end
    end

    expect(Rudux::Sub.existing).to eq :proof
  end
end

