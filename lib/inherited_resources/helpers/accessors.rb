module InheritedResources
  module Helpers
    module Accessors
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def define_resource_accessors(controller)
          symbols = parents_symbols + [:self]
          symbols.inject([]) do |parents, name| 
            define_resource_accessor(name, parents)
            helper_method(name)
            parents << name
          end
          @resource_accessors_defined = true
        end
        
        def define_resource_accessor(name, parents)
          config = resources_configuration[name]
          target = parents.last || config[:parent_class]
          method = config[:finder] || config[:collection_name]
          param  = config[:param] || :id
          name   = name == :self ? config[:instance_name] : name

          if target.is_a?(Symbol)
            define_method(name) { send(target).send(method, params[param]).first }
          else
            define_method(name) { target.send(method, params[param]) }
          end
        end
      
        def resource_accessors_defined?
          !!@resource_accessors_defined
        end
        
        def resource_accessor?(name)
          resource_accessors.include?(name.to_sym)
        end
      
        def resource_accessors
          @resource_accessors ||= resources_configuration.except(:polymorphic).values.map { |c| c[:instance_name] }
        end
      end
      
      def respond_to?(name, include_private = false)
        self.class.resource_accessor?(name) || super
      end
      
      def method_missing(name, *args, &block)
        self.class.define_resource_accessors(self) unless self.class.resource_accessors_defined?
        respond_to?(name) ? send(name) : super
      end
    end
  end
end