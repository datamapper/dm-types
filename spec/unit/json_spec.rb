require 'spec_helper'
require 'shared/identity_function_group'

try_spec do

  require './spec/fixtures/person'

  describe DataMapper::Property::Json do
    before :all do
      @property = DataMapper::TypesFixtures::Person.properties[:positions]
    end

    describe '#valid?' do
      before :all do
        @string = '{ "foo": "bar" }'
        @json   = JSON.load(@string)
      end

      describe "with a String" do
        subject { @property.valid?(@input) }
        it { subject.should be(true) }
      end

      describe "with JSON" do
        subject { @property.valid?(@json) }
        it { subject.should be(true) }
      end
    end

    describe '.load' do
      describe 'when nil is provided' do
        it 'returns nil' do
          @property.load(nil).should be_nil
        end
      end

      describe 'when Json encoded primitive string is provided' do
        it 'returns decoded value as Ruby string' do
          @property.load(JSON.dump(:value => 'JSON encoded string')).should == { 'value' => 'JSON encoded string' }
        end
      end

      describe 'when something else is provided' do
        it 'raises ArgumentError with a meaningful message' do
          lambda {
            @property.load(:sym)
          }.should raise_error(ArgumentError, '+value+ of a property of JSON type must be nil or a String')
        end
      end
    end

    describe '.dump' do
      describe 'when nil is provided' do
        it 'returns nil' do
          @property.dump(nil).should be_nil
        end
      end

      describe 'when Json encoded primitive string is provided' do
        it 'does not do double encoding' do
          @property.dump('Json encoded string').should == 'Json encoded string'
        end
      end

      describe 'when regular Ruby string is provided' do
        it 'dumps argument to Json' do
          @property.dump('dump me (to JSON)').should == 'dump me (to JSON)'
        end
      end

      describe 'when Ruby array is provided' do
        it 'dumps argument to Json' do
          @property.dump([1, 2, 3]).should == '[1,2,3]'
        end
      end

      describe 'when Ruby hash is provided' do
        it 'dumps argument to Json' do
          @property.dump({ :datamapper => 'Data access layer in Ruby' }).
            should == '{"datamapper":"Data access layer in Ruby"}'
        end
      end
    end

    describe '.typecast' do
      class ::SerializeMe
        attr_accessor :name
      end

      describe 'when given instance of a Hash' do
        before :all do
          @input = { :library => 'DataMapper' }

          @result = @property.typecast(@input)
        end

        it_should_behave_like 'identity function'
      end

      describe 'when given instance of an Array' do
        before :all do
          @input = %w[ dm-core dm-more ]

          @result = @property.typecast(@input)
        end

        it_should_behave_like 'identity function'
      end

      describe 'when given nil' do
        before :all do
          @input = nil

          @result = @property.typecast(@input)
        end

        it_should_behave_like 'identity function'
      end

      describe 'when given JSON encoded value' do
        before :all do
          @input = '{ "value": 11 }'

          @result = @property.typecast(@input)
        end

        it 'decodes value from JSON' do
          @result.should == { 'value' => 11 }
        end
      end

      describe 'when given instance of a custom class' do
        before :all do
          @input      = SerializeMe.new
          @input.name = 'Hello!'

          # @result = @property.typecast(@input)
        end

        it 'attempts to load value from JSON string'
      end
    end
  end
end
