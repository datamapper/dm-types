require 'spec_helper'

require './spec/fixtures/bookmark'

try_spec do
  describe DataMapper::Property::URI do
    subject { DataMapper::TypesFixtures::Bookmark.properties[:uri] }

    let(:uri)     { Addressable::URI.parse(uri_str)        }
    let(:uri_str) { 'http://example.com/path/to/resource/' }

    it { should be_instance_of(described_class) }

    describe '.dump' do
      context 'with an instance of Addressable::URI' do
        it 'returns the URI as a String' do
          subject.dump(uri).should eql(uri_str)
        end
      end

      context 'with nil' do
        it 'returns nil' do
          subject.dump(nil).should be(nil)
        end
      end

      context 'with an empty string' do
        it 'returns an empty URI' do
          subject.dump('').should eql('')
        end
      end
    end

    describe '.load' do
      context 'with a string' do
        it 'returns the URI as an Addressable::URI' do
          subject.load(uri_str).should eql(uri)
        end
      end

      context 'with nil' do
        it 'returns nil' do
          subject.load(nil).should be(nil)
        end
      end

      context 'with an empty string' do
        it 'returns an empty URI' do
          subject.load('').should eql(Addressable::URI.parse(''))
        end
      end

      context 'with a non-normalized URI' do
        let(:uri_str) { 'http://www.example.com:80'                       }
        let(:uri)     { Addressable::URI.parse('http://www.example.com/') }

        it 'returns the URI as a normalized Addressable::URI' do
          subject.load(uri_str).should eql(uri)
        end
      end
    end

    describe '.typecast' do
      context 'with an instance of Addressable::URI' do
        it 'does nothing' do
          subject.typecast(uri).should eql(uri)
        end
      end

      context 'with a string' do
        it 'delegates to .load' do
          subject.typecast(uri_str).should eql(uri)
        end
      end

      context 'with nil' do
        it 'returns nil' do
          subject.typecast(nil).should be(nil)
        end
      end
    end
  end
end
