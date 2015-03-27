require 'spec_helper'
require 'shared/identity_function_group'

try_spec do

  require './spec/fixtures/person'

  describe DataMapper::Property::Yaml do
    before :all do
      @property = DataMapper::TypesFixtures::Person.properties[:inventions]
    end

    describe '.load' do
      describe 'when nil is provided' do
        it 'returns nil' do
          @property.load(nil).should be_nil
        end
      end

      describe 'when YAML encoded primitive string is provided' do
        it 'returns decoded value as Ruby string' do
          @property.load("--- yaml string\n").should == 'yaml string'
        end
      end

      describe 'when something else is provided' do
        it 'raises ArgumentError with a meaningful message' do
          lambda {
            @property.load(:sym)
          }.should raise_error(ArgumentError, '+value+ of a property of YAML type must be nil or a String')
        end
      end
    end

    describe '.dump' do
      describe 'when nil is provided' do
        it 'returns nil' do
          @property.dump(nil).should be_nil
        end
      end

      describe 'when YAML encoded primitive string is provided' do
        it 'does not do double encoding' do
          YAML.safe_load(@property.dump("--- yaml encoded string\n")).should == 'yaml encoded string'
        end
      end

      describe 'when regular Ruby string is provided' do
        it 'dumps argument to YAML' do
          YAML.safe_load(@property.dump('dump me (to yaml)')).should == 'dump me (to yaml)'
        end
      end

      describe 'when Ruby array is provided' do
        it 'dumps argument to YAML' do
          YAML.safe_load(@property.dump([ 1, 2, 3 ])).should == [ 1, 2, 3 ]
        end
      end

      describe 'when Ruby hash is provided' do
        it 'dumps argument to YAML' do
          YAML.safe_load(@property.dump('datamapper' => 'Data access layer in Ruby')).should == { 'datamapper' => 'Data access layer in Ruby' }
        end
      end
    end

    describe '.typecast' do
      class ::SerializeMe
        attr_accessor :name
      end

      describe 'given a number' do
        before :all do
          @input  = 15
          @result = 15
        end

        it_should_behave_like 'identity function'
      end

      describe 'given an Array instance' do
        before :all do
          @input  = ['dm-core', 'dm-more']
          @result = ['dm-core', 'dm-more']
        end

        it_should_behave_like 'identity function'
      end

      describe 'given a Hash instance' do
        before :all do
          @input  = { :format => 'yaml' }
          @result = { :format => 'yaml' }
        end

        it_should_behave_like 'identity function'
      end

      describe 'given a plain old Ruby object' do
        before :all do
          @input      = SerializeMe.new
          @input.name = 'yamly'

          @result = @input
        end

        it_should_behave_like 'identity function'
      end
    end
  end
end
