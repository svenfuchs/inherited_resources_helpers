module InheritedResources
  module Helpers
    module Resources
      def self.included(base)
        base.send(:helper_method, public_instance_methods(false))
      end

      def instance_name
        resource.type.underscore.singularize
      end

      def collection_name
        resource.type.underscore.pluralize
      end

      def resource
        member_action? ? super : build_resource
      end

      def resources
        @resources ||= with_chain(resource).tap { |r| r.unshift(route_prefix) if route_prefix }
        @resources.dup
      end

      def parent_resources
        resources[0..-2]
      end

      protected

        MEMBER_ACTIONS = [:show, :edit, :update, :destroy]

        def member_action?
          MEMBER_ACTIONS.include?(params[:action].to_sym)
        end

        def route_prefix
          @route_prefix ||= self.class.resources_configuration[:self][:route_prefix].try(:to_sym)
        end
    end
  end
end
