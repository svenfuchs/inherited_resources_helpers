module InheritedResources
  module Helpers
    module UrlFor
      def self.included(base)
        base.send(:helper_method, public_instance_methods(false)) if base.respond_to?(:helper_method, true)
      end

      def index_url(resources, options = {})
        if resources.last.respond_to?(:new_record?)
          resources[-1, 1] = resources.last.class
        elsif resources.last.is_a?(Symbol)
          resources[-1, 1] = resources.last.to_s.camelize.singularize.constantize
        end
        validate_url_helper_arguments!(:index_url, resources)
        polymorphic_url(resources, options)
      end

      def new_url(resources, options = {})
        if resources.last.respond_to?(:new_record?)
          resources[-1, 1] = resources.last.class.name.underscore 
        elsif resources.last.is_a?(Class) && resources.last < ActiveRecord::Base
          resources[-1, 1] = resources.last.name.underscore
        end
        resources.unshift(:new) unless resources.first == :new
        validate_url_helper_arguments!(:new_url, resources)
        polymorphic_url(resources, options)
      end

      def show_url(resources, options = {})
        validate_url_helper_arguments!(:show_url, resources)
        polymorphic_url(resources, options)
      end

      def edit_url(resources, options = {})
        resources.unshift(:edit) unless resources.first == :edit
        validate_url_helper_arguments!(:edit_url, resources)
        polymorphic_url(resources, options)
      end

      [:index, :new, :show, :edit, :parent_index, :parent_new, :parent_show, :parent_edit].each do |action|
        define_method(:"#{action}_path") do |*args|
          send(:"#{action}_url", *args << args.extract_options!.reverse_merge(:routing_type => :path))
        end
      end

      protected
        def validate_url_helper_arguments!(method, args)
          if new_record = args.detect { |arg| arg.respond_to?(:new_record?) && arg.new_record? }
            raise "can't generate #{method} because #{new_record.inspect}) is a new record"
          elsif [:show_url, :edit_url].include?(method) && !(args.last.respond_to?(:persisted?) && args.last.persisted?)
            raise "can't generate #{method} because #{new_record.inspect}) is not a persisted record"
          end
        end
    end
  end
end