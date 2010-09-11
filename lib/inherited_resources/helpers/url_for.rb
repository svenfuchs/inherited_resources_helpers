module InheritedResources
  module Helpers
    module UrlFor
      def self.included(base)
        base.send(:helper_method, public_instance_methods(false))
      end

      def index_url(options = {})
        polymorphic_url(parent_resources << resource_class.base_class, options)
      end

      def new_url(options = {})
        polymorphic_url(parent_resources.unshift(:new) << resource_class.name.underscore, options)
      end

      def show_url(options = {})
        raise_invalid_url_helper(:show_url, resource) if resource.new_record?
        raise "can't generate show_url because the current resource (#{resource.inspect}) is a new record" if resource.new_record?
        polymorphic_url(resources, options)
      end

      def edit_url(options = {})
        raise_invalid_url_helper(:edit_url, resource) if resource.new_record?
        polymorphic_url(resources.unshift(:edit), options)
      end

      [:index, :new, :show, :edit].each do |action|
        define_method(:"#{action}_path") do |*args|
          send(:"#{action}_url", args.extract_options!.reverse_merge(:routing_type => :path))
        end
      end

      def parent_index_url(options = {})
        polymorphic_url(parent_resources[0..-2] << parent_resources.last.class.base_class, options)
      end

      def parent_new_url(options = {})
        polymorphic_url(parent_resources[0..-2].unshift(:new) << parent_resources.last.class.name.underscore, options)
      end

      def parent_show_url(options = {})
        polymorphic_url(parent_resources, options)
      end

      def parent_edit_url(options = {})
        polymorphic_url(parent_resources.unshift(:edit), options)
      end

      [:index, :new, :show, :edit].each do |action|
        define_method(:"parent_#{action}_path") do |*args|
          send(:"parent_#{action}_url", args.extract_options!.reverse_merge(:routing_type => :path))
        end
      end

      def children_index_url(child, options = {})
        raise_invalid_url_helper("children_index_url(#{:child.inspect})", resource) if resource.new_record?
        polymorphic_url(resources << child.to_s.pluralize, options)
      end

      def children_index_path(*args)
        children_index_url(*args << args.extract_options!.reverse_merge(:routing_type => :path))
      end

      def children_new_url(child, options = {})
        raise_invalid_url_helper("children_new_url(#{:child.inspect})", resource) if resource.new_record?
        polymorphic_url(resources.unshift(:new) << child.to_s.singularize, options)
      end

      def children_new_path(*args)
        children_new_url(*args << args.extract_options!.reverse_merge(:routing_type => :path))
      end

      alias :resources_url :index_url
      alias :resources_path :index_path

      alias :resource_url :show_url
      alias :resource_path :show_path

      alias :parent_resources_url :parent_index_url
      alias :parent_resources_path :parent_index_path

      alias :parent_resource_url :parent_show_url
      alias :parent_resource_path :parent_show_path

      protected

        def raise_invalid_url_helper(method, resource)
          raise "can't generate #{method} because the current resource (#{resource.inspect}) is a new record"
        end
    end
  end
end