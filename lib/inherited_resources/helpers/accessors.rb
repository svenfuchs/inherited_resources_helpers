module InheritedResources
  module Helpers
    module Accessors
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def begin_of_association_chain(symbol)
          resources_configuration[:self][:begin_of_association_chain] = symbol
          define_method(:_begin_of_association_chain) { send(symbol) }
        end

        def define_resource_accessors(controller)
          symbols = parents_symbols + [:self]
          targets = [resources_configuration[:self][:begin_of_association_chain]].compact

          symbols.uniq.inject(targets) do |parents, symbol|
            config = resources_configuration[symbol]
            name   = symbol == :self ? config[:instance_name] : symbol

            define_resource_accessor(name, config, parents.last)
            helper_method(name)
            parents << name
          end
          @resource_accessors_defined = true
        end

        def define_resource_accessor(name, config, target)
          target ||= config[:parent_class] || resource_class
          param  = config[:param] || :id

          if name == resources_configuration[:self][:instance_name]
            define_method(name) { resource }
          elsif target.is_a?(Symbol)
            define_method(name) { send(target).send(config[:collection_name], params[param]).first }
          else
            define_method(name) { target.send(config[:finder] || :find, params[param]) }
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

      def initialize(*)
        self.class.define_resource_accessors(self)
        super
      end
    end
  end
end