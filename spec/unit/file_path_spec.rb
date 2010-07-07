require 'spec_helper'
require './spec/fixtures/software_package'

try_spec do
  describe DataMapper::Property::FilePath do
    before :all do
      @property = DataMapper::TypesFixtures::SoftwarePackage.properties[:source_path]
    end

    before do
      @input = '/usr/bin/ruby'
      @path  = Pathname.new(@input)
    end

    describe '#valid?' do
      describe "with a String" do
        subject { @property.valid?(@input) }
        it { subject.should be(true) }
      end

      describe "with a Pathname" do
        subject { @property.valid?(@path) }
        it { subject.should be(true) }
      end
    end

    describe '.dump' do
      describe 'when input is a string' do
        it 'does not modify input' do
          @property.dump(@input).should == @input
        end
      end

      describe 'when input is nil' do
        it 'returns nil' do
          @property.dump(nil).should be_nil
        end
      end

      describe 'when input is a blank string' do
        it 'returns nil' do
          @property.dump('').should be_nil
        end
      end
    end

    describe '.load' do
      describe 'when value is a non-blank file path' do
        it 'returns Pathname for a path' do
          @property.load(@input).should == @path
        end
      end

      describe 'when value is nil' do
        it 'return nil' do
          @property.load(nil).should be_nil
        end
      end

      describe 'when value is a blank string' do
        it 'returns nil' do
          @property.load('').should be_nil
        end
      end
    end

    describe '.typecast' do
      describe 'when a Pathname is given' do
        it 'does not modify input' do
          @property.typecast(@path).should == @path
        end
      end

      describe 'when a nil is given' do
        it 'does not modify input' do
          @property.typecast(nil).should == nil
        end
      end

      describe 'when a string is given' do
        it 'returns Pathname for given path' do
          @property.typecast(@input).should == @path
        end
      end
    end
  end
end
