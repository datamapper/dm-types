module DataMapper
  module Types
    module Paranoid
      module Base
        extend Chainable

        def self.included(model)
          model.extend ClassMethods
          model.instance_variable_set(:@paranoid_properties, {})
        end

        chainable do
          def inherited(model)
            model.instance_variable_set(:@paranoid_properties, @paranoid_properties.dup)
            super
          end
        end

        def paranoid_destroy
          model.paranoid_properties.each do |name, block|
            attribute_set(name, block.call(self))
          end
          save_self
          self.persisted_state = Resource::State::Immutable.new(self)
          true
        end

        private

        # @api private
        def _destroy(execute_hooks = true)
          return false unless saved?
          if execute_hooks
            paranoid_destroy
          else
            super
          end
        end
      end # module Base

      module ClassMethods
        def with_deleted
          with_exclusive_scope({}) { block_given? ? yield : all }
        end

        # @api private
        def paranoid_properties
          @paranoid_properties
        end

        # @api private
        def set_paranoid_property(name, &block)
          paranoid_properties[name] = block
        end
      end # module ClassMethods
    end # module Paranoid
  end # module Types
end # module DataMapper
