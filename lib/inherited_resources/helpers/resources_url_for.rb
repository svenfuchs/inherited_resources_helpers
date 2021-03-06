module InheritedResources
  module Helpers
    module ResourcesUrlFor
      include UrlFor

      def self.included(base)
        base.send(:helper_method, public_instance_methods(false) + UrlFor.public_instance_methods(false))
      end

      def index_url(*resources)
        resources = normalize_resources_for_url(resources) { parent_resources << resource_class }
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

      def index_parent_url(*resources)
        resources = normalize_parent_resources_for_url(resources) { parent_resources[0..-2] << parent_resources.last.class.base_class }
        polymorphic_url(*resources)
      end

      def new_parent_url(*resources)
        resources, options = *normalize_parent_resources_for_url(resources) { parent_resources[0..-2] << parent_resources.last.class.name.underscore }
        resources.unshift(:new)
        polymorphic_url(resources, options)
      end

      def show_parent_url(*resources)
        resources = normalize_parent_resources_for_url(resources) { parent_resources }
        polymorphic_url(*resources)
      end

      def edit_parent_url(*resources)
        resources, options = normalize_parent_resources_for_url(resources) { parent_resources }
        resources.unshift(:edit)
        polymorphic_url(resources, options)
      end

      [:index_parent, :new_parent, :show_parent, :edit_parent].each do |action|
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

      alias :parent_path :show_parent_path

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

        def normalize_parent_resources_for_url(args, &default)
          options = args.extract_options!
          args = if args.empty?
            default.call
          elsif args.first.is_a?(Array)
            args.first
          else
            resources = self.parent_resources.dup
            resources.pop if resources.last.new_record?
            resources + args
          end
          [args, options]
        end
    end
  end
end
