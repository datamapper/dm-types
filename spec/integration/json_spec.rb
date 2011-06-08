require 'spec_helper'

try_spec do

  require './spec/fixtures/person'

  describe DataMapper::TypesFixtures::Person do
    supported_by :all do
      before :all do
        @resource = DataMapper::TypesFixtures::Person.new(:name => 'Thomas Edison')
      end

      describe 'with no positions information' do
        before :all do
          @resource.positions = nil
        end

        describe 'when dumped and loaded again' do
          before :all do
            @resource.save.should be(true)
            @resource.reload
          end

          it 'has nil positions list' do
            @resource.positions.should be_nil
          end
        end
      end

      describe 'with a few items on the positions list' do
        before :all do
          @resource.positions = [
            { :company => 'The Death Star, Inc', :title => 'Light sabre engineer'    },
            { :company => 'Sane Little Company', :title => 'Chief Curiosity Officer' },
          ]
        end

        describe 'when dumped and loaded again' do
          before :all do
            @resource.save.should be(true)
            @resource.reload
          end

          it 'loads positions list to the state when it was dumped/persisted with keys being strings' do
            @resource.positions.should == [
              { 'company' => 'The Death Star, Inc',  'title' => 'Light sabre engineer'    },
              { 'company'  => 'Sane Little Company', 'title' => 'Chief Curiosity Officer' },
            ]
          end
        end
      end

      describe 'with positions information given as empty list' do
        before :all do
          @resource.positions = []
        end

        describe 'when dumped and loaded again' do
          before :all do
            @resource.save.should be(true)
            @resource.reload
          end

          it 'has empty positions list' do
            @resource.positions.should == []
          end
        end
      end

      describe 'with positions indirectly mutated as a hash' do
        before :all do
          @resource.positions = {
            'company' => "Soon To Be Dirty, LLC",
            'title'   => "Layperson",
            'details' => { 'awesome' => true },
          }
          @resource.save
          @resource.reload
        end

        describe "when I change positions" do
          before :all do
            @resource.clean?.should == true
            @resource.positions['title'] = 'Chief Layer of People'
            @resource.save
            @resource.reload
          end

          it "should remember the new position" do
            @resource.positions['title'].should == 'Chief Layer of People'
          end
        end

        describe "when I add a new attribute of the position" do
          before :all do
            @resource.clean?.should == true
            @resource.positions['pays_buttloads_of_money'] = true
            @resource.save
            @resource.reload
          end

          it "should remember the new attribute" do
            @resource.positions['pays_buttloads_of_money'].should be(true)
          end
        end

        describe "when I change the details of the position" do
          before :all do
            @resource.clean?.should == true
            @resource.positions['details'].merge!('awesome' => "VERY TRUE")
            @resource.save
            @resource.reload
          end

          it "should NOT remember the changed detail (YET)" do
            # TODO: Not supported (yet?) -- this is a much harder problem to
            # solve: using mutating accessors of nested objects.  We could
            # detect it from #dirty? (using the #hash method), but #dirty? only
            # returns the status of known-mutated properties (not full,
            # on-demand scan of object dirty-ness).
            @resource.positions['details']['awesome'].should == true
          end
        end
      end # positions indirectly mutated as a hash

      describe 'with positions indirectly mutated as an array' do
        before :all do
          @resource.positions = [
            { 'company' => "Soon To Be Dirty, LLC",
              'title'   => "Layperson",
              'details' => { 'awesome' => true },
            },
          ]
          @resource.save
          @resource.reload
        end

        describe "when I remove the position" do
          before :all do
            @resource.clean?.should == true
            @resource.positions.pop
            @resource.save
            @resource.reload
          end

          it "should know there aren't any positions" do
            @resource.positions.should == []
          end
        end

        describe "when I add a new position" do
          before :all do
            @resource.clean?.should == true
            @resource.positions << {
              'company' => "Down and Dirty, LP",
              'title'   => "Porn Star",
              'details' => { 'awesome' => "also true" },
            }
            @resource.save
            @resource.reload
          end

          it "should know there's two positions" do
            @resource.positions.length.should == 2
          end

          it "should know which position is which" do
            @resource.positions.first['title'].should == "Layperson"
            @resource.positions.last['title'].should == "Porn Star"
          end

          describe "when I change the details of one of the positions" do
            before :all do
              @resource.positions.last['details'].merge!('high_risk' => true)
              @resource.save
              @resource.reload
            end

            it "should NOT remember the changed detail (YET)" do
              # TODO: Not supported (yet?) -- this is a much harder problem to
              # solve: using mutating accessors of nested objects.  We could
              # detect it from #dirty? (using the #hash method), but #dirty? only
              # returns the status of known-mutated properties (not full,
              # on-demand scan of object dirty-ness).
              @resource.positions.last['details'].has_key?('high_risk').should == false
            end
          end
        end
      end # positions indirectly mutated as an array

    end
  end
end
