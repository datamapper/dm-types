module DataMapper
  module Types
    module Support
      module Flags
        def self.included(base)
          base.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            extend DataMapper::Types::Support::Flags::ClassMethods

            accept_options :flags
            attr_reader :flag_map

            class << self
              attr_accessor :generated_classes
            end

            self.generated_classes = {}
          RUBY
        end

        def custom?
          true
        end

        module ClassMethods
          # TODO: document
          # @api public
          def [](*values)
            if klass = generated_classes[values.flatten]
              klass
            else
              klass = ::Class.new(self)
              klass.flags(values)

              generated_classes[values.flatten] = klass

              klass
            end
          end
        end # module ClassMethods

      end # module Flags
    end # module Support
  end # module Types
end # module DataMapper
