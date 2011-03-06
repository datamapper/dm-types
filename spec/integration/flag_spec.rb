require 'spec_helper'

try_spec do

  require './spec/fixtures/tshirt'

  describe DataMapper::TypesFixtures::TShirt do
    supported_by :all do
      before do
        @resource = DataMapper::TypesFixtures::TShirt.new(
          :writing     => 'Fork you',
          :has_picture => true,
          :picture     => :octocat,
          :color       => :white
        )
      end

      describe 'with the default value' do
        it 'returns it as an array' do
          @resource.size.should eql([DataMapper::TypesFixtures::TShirt.properties[:size].default])
        end
      end

      describe 'with multiple sizes' do
        describe 'dumped and loaded' do
          before do
            @resource.size = [ :xs, :medium ]
            @resource.save.should be(true)
            @resource.reload
          end

          it 'returns size as array' do
            @resource.size.should == [ :xs, :medium ]
          end
        end
      end

      describe 'with a single size' do
        before do
          @resource.size = :large
        end

        describe 'dumped and loaded' do
          before do
            @resource.save.should be(true)
            @resource.reload
          end

          it 'returns size as array with a single value' do
            @resource.size.should == [:large]
          end
        end
      end

      # Flag does not add any auto validations
      describe 'without size' do
        before do
          @resource.should be_valid
          @resource.size = nil
        end

        it 'is valid' do
          @resource.should be_valid
        end

        it 'has no errors' do
          @resource.errors.should be_empty
        end
      end
    end
  end
end
