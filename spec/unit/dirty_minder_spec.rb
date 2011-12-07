require 'spec_helper'
require 'dm-types/support/dirty_minder'

describe DataMapper::Property::DirtyMinder,'set!' do

  let(:property_class) do
    Class.new(DataMapper::Property::Object) do
      include DataMapper::Property::DirtyMinder
    end
  end

  let(:model) do
    property_class = self.property_class
    Class.new do
      include DataMapper::Resource
      property :id,DataMapper::Property::Serial
      property :name,property_class

      def self.name; 'FredsClass'; end
    end
  end

  let(:resource) { model.new }

  let(:object) { model.properties[:name] }

  subject { object.set!(resource,value) }

  shared_examples_for 'a non hooked value' do
    it 'should not extend value with hook' do
      value.should_not be_kind_of(DataMapper::Property::DirtyMinder::Hooker)
    end
  end

  shared_examples_for 'a hooked value' do
    it 'should extend value with hook' do
      value.should be_kind_of(DataMapper::Property::DirtyMinder::Hooker)
    end
  end

  before do
    subject
  end

  context 'when setting nil' do
    let(:value) { nil }
    it_should_behave_like 'a non hooked value'
  end

  context 'when setting a String' do
    let(:value) { "The fred" }
    it_should_behave_like 'a non hooked value'
  end

  context 'when setting an Array' do
    let(:value) { ["The fred"] }
    it_should_behave_like 'a hooked value'
  end

  context 'when setting a Hash' do
    let(:value) { {"The" => "fred"} }
    it_should_behave_like 'a hooked value'
  end
end
