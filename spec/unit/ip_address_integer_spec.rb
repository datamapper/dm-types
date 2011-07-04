require 'spec_helper'

require './spec/fixtures/network_node'

try_spec do
  describe DataMapper::Property::IPAddressInteger do
    before :all do
      @stored = 1360298497
      @string = '81.20.130.1'
      @input  = IPAddr.new(@stored, Socket::AF_INET)
      @property = DataMapper::TypesFixtures::NetworkNode.properties[:ip_address_integer]
    end

    describe '#valid?' do
      describe "with a String" do
        subject { @property.valid?(@string) }
        it { subject.should be(true) }
      end
      
      describe "with an Integer" do
        subject { @property.valid?(@stored) }
        it { subject.should be(true) }
      end

      describe "with an IPAddr" do
        subject { @property.valid?(@input) }
        it { subject.should be(true) }
      end
    end

    describe '.dump' do
      describe 'when argument is an IP address given as Ruby object' do
        before :all do
          @result = @property.dump(@input)
        end

        it 'dumps input into an integer' do
          @result.should == @stored
        end
      end
      
      describe 'when input is a valid string' do
        before :all do
          @result = @property.dump(@string)
        end

        it 'dumps input into an integer' do
          @result.should == @stored
        end
      end
      
      describe 'when input is an integer' do
        before :all do
          @result = @property.dump(@stored)
        end

        it 'dumps input into an integer' do
          @result.should == @stored
        end
      end

      describe 'when argument is nil' do
        before :all do
          @result = @property.dump(nil)
        end

        it 'returns nil' do
          @result.should be_nil
        end
      end

      describe 'when input is a blank string' do
        before :all do
          @result = @property.dump('')
        end

        it 'retuns nil' do
          @result.should be_nil
        end
      end
    end

    describe '.load' do
      describe 'when argument is a valid IP address as an integer' do
        before :all do
          @result = @property.load(@stored)
        end

        it 'returns IPAddr instance from stored value' do
          @result.should == @input
        end
      end

      describe 'when argument is nil' do
        before :all do
          @result = @property.load(nil)
        end

        it 'returns nil' do
          @result.should be_nil
        end
      end

      describe 'when argument is zero' do
        before :all do
          @result = @property.load(0)
        end

        it 'returns IPAddr instance from stored value' do
          @result.should == IPAddr.new('0.0.0.0', Socket::AF_INET)
        end
      end

      describe 'when argument is an Array instance' do
        before :all do
          @operation = lambda { @property.load([]) }
        end

        it 'raises ArgumentError with a meaningful message' do
          @operation.should raise_error(ArgumentError, '+value+ must be nil or an Integer')
        end
      end
    end

    describe '.typecast' do
      describe 'when argument is an IPAddr object' do
        before :all do
          @result = @property.typecast(@input)
        end

        it 'does not change the value' do
          @result.should == @input
        end
      end

      describe 'when argument is a valid IP address as a string' do
        before :all do
          @result = @property.typecast(@string)
        end

        it 'instantiates IPAddr instance' do
          @result.should == @input
        end
      end
    end
  end
end
