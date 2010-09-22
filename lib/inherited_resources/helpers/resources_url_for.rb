module InheritedResources
  module Helpers
    module ResourcesUrlFor
      include UrlFor

      def self.included(base)
        base.send(:helper_method, public_instance_methods(false) + UrlFor.public_instance_methods(false))
      end

      def index_url(*resources)
        resources = normalize_resources_for_url(resources) { parent_resources << resource_class.base_class }
        super(*resources)
      end

      def new_url(*resources)
        resources = normalize_resources_for_url(resources) { parent_resources << resource_class.name.underscore }
        super(*resources)
      end

      def show_url(*resources)
        resources = normalize_resources_for_url(resources) { self.resources }
        super(*resources)
      end

      def edit_url(*resources)
        resources = normalize_resources_for_url(resources) { self.resources }
        super(*resources)
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

      [:parent_index, :parent_new, :parent_show, :parent_edit].each do |action|
        define_method(:"#{action}_path") do |*args|
          send(:"#{action}_url", *args << args.extract_options!.reverse_merge(:routing_type => :path))
        end
      end

      alias :resources_url :index_url
      alias :resources_path :index_path

      alias :resource_url :show_url
      alias :resource_path :show_path

      alias :destroy_url :show_url
      alias :destroy_path :show_path

      alias :parent_resources_url :parent_index_url
      alias :parent_resources_path :parent_index_path

      alias :parent_resource_url :parent_show_url
      alias :parent_resource_path :parent_show_path

      protected

        def normalize_resources_for_url(args, &default)
          options = args.extract_options!
          args = if args.empty?
            default.call
          elsif args.first.is_a?(Array)
            args.first
          else
            resources = self.resources.dup
            resources.pop if resources.last.new_record?
            resources + args
          end
          [args, options]
        end
    end
  end
end