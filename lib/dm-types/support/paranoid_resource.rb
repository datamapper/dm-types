module DataMapper
  module Types
    module Support
      module ParanoidResource
        def self.included(model)
          model.extend ClassMethods
          model.instance_variable_set(:@paranoid_properties, {})
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

        # @api private
        def paranoid_destroy
          model.paranoid_properties.each do |name, block|
            attribute_set(name, block.call(self))
          end
          save_self
          self.persisted_state = Resource::State::Immutable.new(self)
          true
        end

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

          def inherited(model)
            model.instance_variable_set(:@paranoid_properties, @paranoid_properties.dup)
            super
          end
        end # module ClassMethods
      end # module Paranoia
    end # module Support
  end # module Types
end # module DataMapper
