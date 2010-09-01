require 'spec_helper'

try_spec do
  describe DataMapper::Property::Csv do
    supported_by :all do
      before :all do
        class ::User
          include DataMapper::Resource
          property :id, Serial
          property :things, Csv
        end

        @property = User.properties[:things]
      end

      describe '.load' do
        describe 'when argument is a comma separated string' do
          before :all do
            @input  = 'uno,due,tre'
            @result = @property.load(@input)
          end

          it 'parses the argument using CVS parser' do
            @result.should == [ %w[ uno due tre ] ]
          end
        end

        describe 'when argument is an empty array' do
          before :all do
            @input    = []
            @result   = @property.load(@input)
          end

          it 'does not change the input' do
            @result.should == @input
          end
        end

        describe 'when argument is an empty hash' do
          before :all do
            @input    = {}
            @result   = @property.load(@input)
          end

          it 'returns nil' do
            @result.should be_nil
          end
        end

        describe 'when argument is nil' do
          before :all do
            @input    = nil
            @result   = @property.load(@input)
          end

          it 'returns nil' do
            @result.should be_nil
          end
        end

        describe 'when argument is an integer' do
          before :all do
            @input    = 7
            @result   = @property.load(@input)
          end

          it 'returns nil' do
            @result.should be_nil
          end
        end

        describe 'when argument is a float' do
          before :all do
            @input    = 7.0
            @result   = @property.load(@input)
          end

          it 'returns nil' do
            @result.should be_nil
          end
        end

        describe 'when argument is an array' do
          before :all do
            @input  = [ 1, 2, 3 ]
            @result = @property.load(@input)
          end

          it 'returns input as is' do
            @result.should eql(@input)
          end
        end
      end

      describe '.dump' do
        describe 'when value is a list of lists' do
          before :all do
            @input  = [ %w[ uno due tre ], %w[ uno dos tres ] ]
            @result = @property.dump(@input)
          end

          it 'dumps value to comma separated string' do
            @result.should == "uno,due,tre\nuno,dos,tres\n"
          end
        end

        describe 'when value is a string' do
          before :all do
            @input  = 'beauty hides in the deep'
            @result = @property.dump(@input)
          end

          it 'returns input as is' do
            @result.should == @input
          end
        end

        describe 'when value is nil' do
          before :all do
            @input  = nil
            @result = @property.dump(@input)
          end

          it 'returns nil' do
            @result.should be_nil
          end
        end

        describe 'when value is a hash' do
          before :all do
            @input  = { :library => 'DataMapper', :language => 'Ruby' }
            @result = @property.dump(@input)
          end

          it 'returns nil' do
            @result.should be_nil
          end
        end
      end
    end
  end
end
