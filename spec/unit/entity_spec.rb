require 'rudux/entity'

describe Rudux::Entity, '#initialize' do
  context 'with attributes' do
    before { class Rudux::Child < Rudux::Entity; attr_reader :key1, :key2; end }

    let(:value1) { [1, 2, 3] }
    let(:value2) { double :value2 }
    let(:attributes) { { key1: value1, key2: value2 } }

    subject { Rudux::Child.new(attributes) }

    it 'accepts a hash and creates instance variables from it' do
      expect(subject.key1).to eq value1
      expect(subject.key2).to eq value2
    end

    it 'freezes the attributes' do
      expect { subject.key1 << :other_value }.to raise_error(/can't modify/)
    end
  end
end


describe Rudux::Entity, "#to_hash" do
  context "with attributes" do
    it "returns hash" do
      class Rudux::Child < Rudux::Entity; end
      child = Rudux::Child.new(:a => "aa", :b => "bb")
      hash = child.to_hash
      expect(hash).to include(:a => "aa", :b => "bb")
    end
  end
end


describe Rudux::Entity, "#copy" do
  before :each do
    class Rudux::Child < Rudux::Entity
      attr_reader :one, :two
    end
  end

  context "with attributes" do
    it "returns copy with new values without mutating the original" do
      before = Rudux::Child.new(one: :before1, two: :before2)
      after = before.copy(one: :after1)

      expect(before.one).to eq :before1
      expect(before.two).to eq :before2
      expect(after.one).to eq :after1
      expect(after.two).to eq :before2
    end
  end

  context 'without attributes' do
    it 'returns reference to original object' do
      before = Rudux::Child.new
      expect(before.copy).to eq before
    end
  end

  it 'maintains the #id' do
    id = double :uuid
    before = Rudux::Child.new(id: id)
    expect(before.copy.id).to eq id
  end
end


describe Rudux::Entity, '#id' do
  context 'initialized without id' do
    it 'generates a memoized uuid' do
      expect(SecureRandom).to receive(:uuid).and_return(:id)
      model = Rudux::Entity.new
      expect(model.id).to eq :id
      expect(model.id).to eq :id
    end
  end

  context 'initialized with id' do
    it 'does not generate a new id but maintains the one given' do
      id = double :id
      model = Rudux::Entity.new(id: id)
      expect(SecureRandom).not_to receive(:uuid)
      expect(model.id).to eq id
    end
  end
end
