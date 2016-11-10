require 'rudux/action'

describe Rudux::Action, '#to_sym' do
  before { class Rudux::SomeFancyClassName < Rudux::Action; end }

  it 'is a snake_cased symbol of the upper camel cased class name' do
    expect(Rudux::SomeFancyClassName.new.to_sym).to eq :some_fancy_class_name
  end
end
