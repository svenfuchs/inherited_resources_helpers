module InheritedResources
  module Helpers
    module UrlFor
      def self.included(base)
        base.send(:helper_method, public_instance_methods(false))
      end

      def index_url(options = {})
        polymorphic_url(parent_resources << resource_class, options)
      end

      def new_url(options = {})
        polymorphic_url(parent_resources.unshift(:new) << resource_class.name.underscore, options)
      end

      def show_url(options = {})
        raise "can't generate show_url because the current resource (#{resource.inspect}) is a new record" if resource.new_record?
        polymorphic_url(resources, options)
      end

      def edit_url(options = {})
        raise "can't generate edit_url because the current resource (#{resource.inspect}) is a new record" if resource.new_record?
        polymorphic_url(resources.unshift(:edit), options)
      end

      [:index, :new, :show, :edit].each do |action|
        define_method(:"#{action}_path") do |*args|
          send(:"#{action}_url", args.extract_options!.reverse_merge(:routing_type => :path))
        end
      end

      alias :resources_url :index_url
      alias :resources_path :index_path

      alias :resource_url :show_url
      alias :resource_path :show_path
    end
  end
end