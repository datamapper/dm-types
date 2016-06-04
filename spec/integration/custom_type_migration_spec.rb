require 'spec_helper'

# When dm-migrations' dm-do-adapter runs, Adapter#property_schema_hash is invoked
# on each property to generate the SQL for it.
#
# For Property::Text, type_map[Property::Text] yields a schema of TEXT with no
# :length property.  When DM encounters a String primitive whose length exceeds
# the schema's capacity, it auto-adjusts the schema primitive to compensate
# (i.e. in MySQL, {SHORT,MEDIUM,LONG}TEXT).  Result: MEDIUMTEXT == AWESOME.
#
# The case is different for (1) a custom Property derived from (2) a builtin
# Property whose schema primitive changes based on the Property's size options.
# For Property::Json, the first type_map[property.class] lookup is nil because
# custom types can't/don't update Adapter#type_map -- custom properties can't know
# what model/repository/adapter they're going to be on at definition time, which
# they would need because the type_map is stored on the adapter *class*.
#
# So, the second lookup type_map[property.primitive] kicks in, which for
# Property::Json is type_map[String].  That in turn yields a schema of VARCHAR
# with a :length property.  As with Property::Text, when DM encounters a String
# primitive whose length exceeds the schema's capacity, it auto-adjusts the schema
# primitive to compensate (i.e. in MySQL, {SHORT,MEDIUM,LONG}TEXT).  However, when
# dm-migrations encounters any property_schema_hash with a :length option, it
# automatically appends "(%i)" % length to the SQL statement.  Result:
# MEDIUMTEXT(123412341234) == entire migration FKD.
#

require './spec/fixtures/custom'

try_spec do

  describe 'a model with a builtin property whose schema primitive changes according to size options and a custom property based on it' do

    supported_by :postgres, :mysql, :sqlite, :oracle, :sqlserver do # basically all SQL/DO-based

      {
        ::DataMapper::TypesFixtures::CustomWithoutOptions => "without any specified property options",
        ::DataMapper::TypesFixtures::CustomWithOptions => "with specified property options that shift the schema primitive",
      }.each do |klass, desc|

        describe(desc) do
          let(:model) { klass }

          context 'when migrated' do
            it 'should use the same property_schema_hash as its logical parent' do
              proc { model.auto_upgrade! }.should_not raise_error(DataObjects::SQLError)

              adapter = model.repository.adapter

              json_hash = adapter.send(:property_schema_hash, model.json)
              text_hash = adapter.send(:property_schema_hash, model.text)

              json_hash.delete(:name)
              text_hash.delete(:name)

              json_hash.should == text_hash
            end
          end
        end

      end # each test

    end # supported_by
  end # describe: model
end # try_spec

