require 'spec_helper'

require './spec/fixtures/network_node'

try_spec do
  describe DataMapper::Property::IPAddress do
    before :all do
      @stored = '81.20.130.1'
      @input  = IPAddr.new(@stored)
      @property = DataMapper::Types::Fixtures::NetworkNode.properties[:ip_address]
    end

    describe '.dump' do
      describe 'when argument is an IP address given as Ruby object' do
        before :all do
          @result = @property.dump(@input)
        end

        it 'dumps input into a string' do
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

        it 'retuns a blank string' do
          @result.should == ''
        end
      end
    end

    describe '.load' do
      describe 'when argument is a valid IP address as a string' do
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

      describe 'when argument is a blank string' do
        before :all do
          @result = @property.load('')
        end

        it 'returns IPAddr instance from stored value' do
          @result.should == IPAddr.new('0.0.0.0')
        end
      end

      describe 'when argument is an Array instance' do
        before :all do
          @operation = lambda { @property.load([]) }
        end

        it 'raises ArgumentError with a meaningful message' do
          @operation.should raise_error(ArgumentError, '+value+ must be nil or a String')
        end
      end
    end

    describe '.typecast' do
      describe 'when argument is an IpAddr object' do
        before :all do
          @result = @property.typecast(@input)
        end

        it 'does not change the value' do
          @result.should == @input
        end
      end

      describe 'when argument is a valid IP address as a string' do
        before :all do
          @result = @property.typecast(@stored)
        end

        it 'instantiates IPAddr instance' do
          @result.should == @input
        end
      end
    end
  end
end
