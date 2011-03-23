require 'spec_helper'

try_spec do
  require './spec/fixtures/api_user'

  describe DataMapper::TypesFixtures::APIUser do
    supported_by :all do
      subject { described_class.new(:name => 'alice') }

      let(:original_api_key) { subject.api_key }

      it "should have a default value" do
        original_api_key.should_not be_nil
      end

      it "should preserve the default value" do
        subject.api_key.should == original_api_key
      end

      it "should generate unique API Keys for each resource" do
        other_resource = described_class.new(:name => 'eve')

        other_resource.api_key.should_not == original_api_key
      end
    end
  end
end
