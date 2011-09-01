require 'spec_helper'

try_spec do

  require './spec/fixtures/person'

  describe DataMapper::TypesFixtures::Person do
    supported_by :all do
      before :all do
        @resource = DataMapper::TypesFixtures::Person.new(:name => '')
      end

      describe 'with a birthday' do
        before :all do
          @resource.birthday = '1983-05-03'
        end

        describe 'after typecasting string input' do
          it 'has a valid birthday' do
            @resource.birthday.should == ::Time.parse('1983-05-03')
          end
        end

        describe 'when dumped and loaded again' do
          before :all do
            @resource.save.should be(true)
            @resource.reload
          end

          it 'has a valid birthday' do
            @resource.birthday.should == ::Time.parse('1983-05-03')
          end
        end
      end

      describe 'without a birthday' do
        before :all do
          @resource.birthday = nil
        end

        describe 'after typecasting nil' do
          it 'has a nil value for birthday' do
            @resource.birthday.should be_nil
          end
        end

        describe 'when dumped and loaded again' do
          before :all do
            @resource.save.should be(true)
            @resource.reload
          end

          it 'has a nil value for birthday' do
            @resource.birthday.should be_nil
          end
        end
      end

    end
  end
end
