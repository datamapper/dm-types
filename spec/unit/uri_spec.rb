require 'spec_helper'

require './spec/fixtures/bookmark'

try_spec do
  describe DataMapper::Property::URI do
    before do
      @uri_str = 'http://example.com/path/to/resource/'
      @uri     = Addressable::URI.parse(@uri_str)

      @property = DataMapper::TypesFixtures::Bookmark.properties[:uri]
    end

    describe '.dump' do
      it 'returns the URI as a String' do
        @property.dump(@uri).should eql(@uri_str)
      end

      describe 'when given nil' do
        it 'returns nil' do
          @property.dump(nil).should be(nil)
        end
      end

      describe 'when given an empty string' do
        it 'returns an empty URI' do
          @property.dump('').should eql('')
        end
      end
    end

    describe '.load' do
      it 'returns the URI as Addressable' do
        @property.load(@uri_str).should eql(@uri)
      end

      describe 'when given nil' do
        it 'returns nil' do
          @property.load(nil).should be(nil)
        end
      end

      describe 'if given an empty String' do
        it 'returns an empty URI' do
          @property.load('').should eql(Addressable::URI.parse(''))
        end
      end
    end

    describe '.typecast' do
      describe 'given instance of Addressable::URI' do
        it 'does nothing' do
          @property.typecast(@uri).should eql(@uri)
        end
      end

      describe 'when given a string' do
        it 'delegates to .load' do
          @property.typecast(@uri_str).should eql(@uri)
        end
      end
    end
  end
end
