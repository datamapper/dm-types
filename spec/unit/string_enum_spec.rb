require 'spec_helper'

try_spec do
  describe DataMapper::Property::StringEnum do
    before :all do
      class ::User
        include DataMapper::Resource
        property :id, Serial
      end

      @property_klass = DataMapper::Property::StringEnum
    end

    it_should_behave_like "A property with flags"

    describe '.dump' do
      before do
        @enum = User.property(:enum, DataMapper::Property::StringEnum[:first, :second, :third])
      end

      it 'should return the key of the value match from the flag map' do
        @enum.dump(:first).should == "first"
        @enum.dump(:second).should == "second"
        @enum.dump(:third).should == "third"
      end

      describe 'when there is no match' do
        it 'should return nil' do
          @enum.dump(:zero).should be_nil
        end
      end
    end

    describe '.load' do
      before do
        @enum = User.property(:enum, DataMapper::Property::StringEnum, :flags => [:uno, :dos, :tres])
      end

      it 'returns the value of the key match from the flag map' do
        @enum.load("uno").should == :uno
        @enum.load("dos").should == :dos
        @enum.load("tres").should == :tres
      end

      describe 'when there is no key' do
        it 'returns nil' do
          @enum.load(-1).should be_nil
        end
      end
    end

    describe '.typecast' do
      describe 'of StringEnum created from a symbol' do
        before :all do
          @enum = User.property(:enum, DataMapper::Property::StringEnum, :flags => [:uno])
        end

        describe 'when given a symbol' do
          it 'uses StringEnum type' do
            @enum.typecast(:uno).should == :uno
          end
        end

        describe 'when given a string' do
          it 'uses StringEnum type' do
            @enum.typecast('uno').should == :uno
          end
        end

        describe 'when given nil' do
          it 'returns nil' do
            @enum.typecast(nil).should == nil
          end
        end
      end

      describe 'of StringEnum created from a string' do
        before :all do
          @enum = User.property(:enum, DataMapper::Property::StringEnum, :flags => ['uno'])
        end

        describe 'when given a symbol' do
          it 'uses StringEnum type' do
            @enum.typecast(:uno).should == 'uno'
          end
        end

        describe 'when given a string' do
          it 'uses StringEnum type' do
            @enum.typecast('uno').should == 'uno'
          end
        end

        describe 'when given nil' do
          it 'returns nil' do
            @enum.typecast(nil).should == nil
          end
        end
      end
    end
  end
end
