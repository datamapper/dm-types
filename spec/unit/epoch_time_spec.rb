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

    describe 'with a DateTime instance' do
      let(:value) { DateTime.now }

      it { should == Time.parse(value.to_s).to_i }
    end

    describe 'with a number' do
      let(:value) { Time.now.to_i }

      it { should == value }
    end

    describe 'with nil' do
      let(:value) { nil }

      it { should == value }
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
