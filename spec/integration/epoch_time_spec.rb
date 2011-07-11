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

        describe 'when dumped and loaded again' do
          before :all do
            #puts DataMapper::TypesFixtures::Person.properties[:birthday].valid?(Time.now)
            @resource.save.should be(true)
            @resource.reload
          end

          it 'has a valid birthday' do
            @resource.birthday.should == ::Time.parse('1983-05-03')
          end
        end
      end

    end
  end
end
