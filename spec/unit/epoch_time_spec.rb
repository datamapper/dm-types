require 'spec_helper'

describe DataMapper::Property::EpochTime do
  before :all do
    class ::User
      include DataMapper::Resource

      property :id,   Serial
      property :bday, EpochTime
    end

    @property = User.properties[:bday]
  end

  describe '#dump' do
    subject { @property.dump(value) }

    describe 'with a Time instance' do
      let(:value) { Time.now }

      it { should == value.to_i }
    end

    describe 'with nil' do
      let(:value) { nil }

      it { should == value }
    end
  end

  describe '#typecast' do
    subject { @property.typecast(value) }

    describe 'with a DateTime instance' do
      let(:value) { DateTime.now }

      it { should == Time.parse(value.to_s) }
    end

    describe 'with a number' do
      let(:value) { Time.now.to_i }

      it { should == ::Time.at(value) }
    end

    describe 'with a numeric string' do
      let(:value) { Time.now.to_i.to_s }

      it { should == ::Time.at(value.to_i) }
    end

    describe 'with a DateTime string' do
      let(:value) { '2011-07-11 15:00:04 UTC' }

      it { should == ::Time.parse(value) }
    end
  end

  describe '#load' do
    subject { @property.load(value) }

    describe 'with a number' do
      let(:value) { Time.now.to_i }

      it { should == Time.at(value) }
    end

    describe 'with nil' do
      let(:value) { nil }

      it { should == value }
    end
  end
end
