require 'spec_helper'

try_spec do
  describe DataMapper::Property::Enum do
    before :all do
      class User
        include DataMapper::Resource
        property :id, Serial
      end
    end

    describe '.dump' do
      before do
        @enum = User.property(:enum, DataMapper::Property::Enum, :flags => [:first, :second, :third])
      end

      it 'should return the key of the value match from the flag map' do
        @enum.dump(:first).should == 1
        @enum.dump(:second).should == 2
        @enum.dump(:third).should == 3
      end

      describe 'when there is no match' do
        it 'should return nil' do
          @enum.dump(:zero).should be_nil
        end
      end
    end

    describe '.load' do
      before do
        @enum = User.property(:enum, DataMapper::Property::Enum, :flags => [:uno, :dos, :tres])
      end

      it 'returns the value of the key match from the flag map' do
        @enum.load(1).should == :uno
        @enum.load(2).should == :dos
        @enum.load(3).should == :tres
      end

      describe 'when there is no key' do
        it 'returns nil' do
          @enum.load(-1).should be_nil
        end
      end
    end

    describe '.typecast' do
      describe 'of Enum created from a symbol' do
        before :all do
          @enum = User.property(:enum, DataMapper::Property::Enum, :flags => [:uno])
        end

        describe 'when given a symbol' do
          it 'uses Enum type' do
            @enum.typecast(:uno).should == :uno
          end
        end

        describe 'when given a string' do
          it 'uses Enum type' do
            @enum.typecast('uno').should == :uno
          end
        end

        describe 'when given nil' do
          it 'returns nil' do
            @enum.typecast( nil).should == nil
          end
        end
      end

      describe 'of Enum created from integer list' do
        before :all do
          @enum = User.property(:enum, DataMapper::Property::Enum, :flags => [1, 2, 3])
        end

        describe 'when given an integer' do
          it 'uses Enum type' do
            @enum.typecast(1).should == 1
          end
        end

        describe 'when given a float' do
          it 'uses Enum type' do
            @enum.typecast(1.1).should == 1
          end
        end

        describe 'when given nil' do
          it 'returns nil' do
            @enum.typecast( nil).should == nil
          end
        end
      end

      describe 'of Enum created from a string' do
        before :all do
          @enum = User.property(:enum, DataMapper::Property::Enum, :flags => ['uno'])
        end

        describe 'when given a symbol' do
          it 'uses Enum type' do
            @enum.typecast(:uno).should == 'uno'
          end
        end

        describe 'when given a string' do
          it 'uses Enum type' do
            @enum.typecast('uno').should == 'uno'
          end
        end

        describe 'when given nil' do
          it 'returns nil' do
            @enum.typecast( nil).should == nil
          end
        end
      end
    end
  end
end
