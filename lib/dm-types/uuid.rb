require 'dm-core'
require 'uuidtools'  # must be ~>2.0

module DataMapper
  class Property
    # UUID Type
    # First run at this, because I need it. A few caveats:
    #  * Only works on postgres, using the built-in native uuid type.
    #    To make it work in mysql, you'll have to add a typemap entry to
    #    the mysql_adapter. I think. I don't have mysql handy, so I'm
    #    not going to try. For SQLite, this will have to inherit from the
    #    String primitive
    #  * Won't accept a random default, because of the namespace clash
    #    between this and the UUIDtools gem. Also can't set the default
    #    type to UUID() (postgres-contrib's native generator) and
    #    automigrate, because auto_migrate! tries to make it a string "UUID()"
    # Feel free to enchance this, and delete these caveats when they're fixed.
    #
    #  -- Rando Sept 25, 08
    #
    # Actually, setting the primitive to "UUID" is not neccessary and causes
    # a segfault when trying to query uuid's from the database.  The primitive
    # should be a class which has been added to the do driver you are using.
    # Also, it's only neccessary to add a class to the do drivers to use as a
    # primitive when a value cannot be represented as a string.  A uuid can be
    # represented as a string, so setting the primitive to String ensures that
    # the value argument is a String containing the uuid in string form.
    #
    # <strike>It is still neccessary to add the UUID entry to the type map for
    # each different adapter with their respective database primitive.</strike>
    #
    # The method that generates the SQL schema from the typemap currently
    # ignores the size attribute from the type map if the primitive type
    # is String.  The causes the generated SQL statement to contain a size for
    # a UUID column (e.g. id UUID(50)), which causes a syntax error in postgres.
    # Until this is resolved, you will have to manually change the column type
    # to UUID in a migration, if you want to use postgres' built in UUID type.
    #
    #  -- benburkert Nov 15, 08
    #
    class UUID < String

      length 36

      # We need to override this method otherwise typecast_to_primitive won't be called.
      # In the future we will set primitive to UUIDTools::UUID but this can happen only
      # when adapters can handle it
      def primitive?(value)
        value.kind_of?(UUIDTools::UUID)
      end

      def valid?(value, negated = false)
        super || dump(value).kind_of?(::String)
      end

      def dump(value)
        value.to_s unless value.nil?
      end

      def load(value)
        if primitive?(value)
          value
        elsif !value.nil?
          UUIDTools::UUID.parse(value)
        end
      end

      def typecast_to_primitive(value)
        load(value)
      end

    end
  end
end
