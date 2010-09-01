require 'spec_helper'

try_spec do
  describe DataMapper::Property::Regexp  do
    before :all do
      class ::User
        include DataMapper::Resource
        property :id, Serial
        property :regexp, Regexp
      end

      @property = User.properties[:regexp]
    end

    describe '.load' do
      describe 'when argument is a string' do
        before :all do
          @input  = '[a-z]\d+'
          @result = @property.load(@input)
        end

        it 'create a regexp instance from argument' do
          @result.should == Regexp.new(@input)
        end
      end

      describe 'when argument is nil' do
        before :all do
          @input  = nil
          @result = @property.load(@input)
        end

        it 'returns nil' do
          @result.should be_nil
        end
      end
    end

    describe '.dump' do
      describe 'when argument is a regular expression' do
        before :all do
          @input  = /\d+/
          @result = @property.dump(@input)
        end

        it 'escapes the argument' do
          @result.should == '\\d+'
        end
      end

      describe 'when argument is nil' do
        before :all do
          @input = nil
          @result = @property.dump(@input)
        end

        it 'returns nil' do
          @result.should be_nil
        end
      end
    end
  end
end
