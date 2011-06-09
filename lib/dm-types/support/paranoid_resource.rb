module DataMapper
  module Types
    module Support
      module ParanoidResource
        def self.included(model)
          model.extend ClassMethods
          model.instance_variable_set(:@paranoid_properties, [].to_set)
        end

      private

        # @api private
        def _destroy(execute_hooks = true)
          if !saved?
            false
          elsif execute_hooks
            paranoid_destroy
          else
            super
          end
        end

        # @api private
        def paranoid_destroy
          model.paranoid_properties.each do |property|
            property.stamp_resource(self)
          end
          save_self
          self.persisted_state = Resource::State::Immutable.new(self)
          true
        end

        module ClassMethods
          # @api private
          attr_reader :paranoid_properties

          def inherited(model)
            model.instance_variable_set(:@paranoid_properties, @paranoid_properties.dup)
            super
          end

          # @api public
          def with_deleted
            with_exclusive_scope({}) { block_given? ? yield : all }
          end
        end # module ClassMethods
      end # module Paranoia
    end # module Support
  end # module Types
end # module DataMapper
