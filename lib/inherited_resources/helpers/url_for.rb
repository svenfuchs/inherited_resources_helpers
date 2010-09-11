module InheritedResources
  module Helpers
    module UrlFor
      def index_path
        polymorphic_path(parent_resources << resource_class)
      end

      def new_path
        polymorphic_path(parent_resources.unshift(:new) << resource_class.name.underscore)
      end

      def show_path
        raise "can't generate show_path because the current resource (#{resource.inspect}) is a new record" if resource.new_record?
        polymorphic_path(resources)
      end

      def edit_path
        raise "can't generate edit_path because the current resource (#{resource.inspect}) is a new record" if resource.new_record?
        polymorphic_path(resources.unshift(:edit))
      end
    end
  end
end