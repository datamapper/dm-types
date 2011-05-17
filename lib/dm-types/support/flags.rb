module DataMapper
  module Types
    module Support
      module Flags
        def self.included(model)
          model.extend ClassMethods
          model.accept_options :flags
          model.__send__ :attr_reader, :flag_map
          model.instance_variable_set(:@generated_classes, {})

          class << model
            attr_accessor :generated_classes
          end
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
