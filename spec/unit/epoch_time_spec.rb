require 'spec_helper'

try_spec do
  describe DataMapper::Property::EpochTime do
    before :all do
      class User
        include DataMapper::Resource
        property :id, Serial
        property :bday, EpochTime
      end

      @property = User.properties[:bday]
    end

    describe '.dump' do
      describe 'when given Time instance' do
        before :all do
          @input = Time.now
        end

        it 'returns timestamp' do
          @property.dump(@input).should == @input.to_i
        end
      end

      describe 'when given DateTime instance' do
        before :all do
          @input = DateTime.now
        end

        it 'returns timestamp' do
          @property.dump(@input).should == Time.parse(@input.to_s).to_i
        end
      end

      describe 'when given an integer' do
        before :all do
          @input = Time.now.to_i
        end

        it 'returns value as is' do
          @property.dump(@input).should == @input
        end
      end

      describe 'when given nil' do
        before :all do
          @input = nil
        end

        it 'returns value as is' do
          @property.dump(@input).should == @input
        end
      end
    end

    describe '.load' do
      describe 'when value is nil' do
        it 'returns nil' do
          @property.load(nil).should == nil
        end
      end

      describe 'when value is an integer' do
        it 'returns time object from timestamp' do
          t = Time.now.to_i
          @property.load(Time.now.to_i).should == Time.at(t)
        end
      end
    end
  end
end
