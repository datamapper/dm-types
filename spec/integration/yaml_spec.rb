require 'spec_helper'

try_spec do

  require './spec/fixtures/person'
  require './spec/fixtures/invention'

  describe DataMapper::TypesFixtures::Person do
    supported_by :all do
      before :all do
        @resource = DataMapper::TypesFixtures::Person.new(:name => '')
      end

      describe 'with no inventions information' do
        before :all do
          @resource.inventions = nil
        end

        describe 'when dumped and loaded again' do
          before :all do
            @resource.save.should be(true)
            @resource.reload
          end

          it 'has nil inventions list' do
            @resource.inventions.should be_nil
          end
        end
      end

      describe 'with a few items on the inventions list' do
        before :all do
          @input = [ 'carbon telephone transmitter', 'light bulb', 'electric grid' ].map do |name|
            DataMapper::TypesFixtures::Invention.new(name)
          end
          @resource.inventions = @input
        end

        describe 'when dumped and loaded again' do
          before :all do
            @resource.save.should be(true)
            @resource.reload
          end

          it 'loads inventions list to the state when it was dumped/persisted with keys being strings' do
            @resource.inventions.should == [{ 'name' => 'carbon telephone transmitter' }, { 'name' => 'light bulb' }, { 'name' => 'electric grid' }]
          end
        end
      end

      describe 'with inventions information given as empty list' do
        before :all do
          @resource.inventions = []
        end

        describe 'when dumped and loaded again' do
          before :all do
            @resource.save.should be(true)
            @resource.reload
          end

          it 'has empty inventions list' do
            @resource.inventions.should == []
          end
        end
      end

      describe 'with inventions as a string' do
        before :all do
          object = "Foo and Bar" #.freeze
          @resource.inventions = object
        end

        describe 'when dumped and loaded again' do
          before :all do
            @resource.save.should be(true)
            @resource.reload
          end

          it 'has correct inventions' do
            @resource.inventions.should == 'Foo and Bar'
          end
        end
      end
    end
  end
end
