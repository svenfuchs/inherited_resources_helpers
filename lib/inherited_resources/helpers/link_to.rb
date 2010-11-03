module InheritedResources
  module Helpers
    module LinkTo
      def links_to_actions(actions, *args)
        actions.map { |action| capture { send(:"link_to_#{action}", *args) } }.join.html_safe
      end

      [:index, :new, :show, :edit, :destroy].each do |action|
        define_method(:"link_to_#{action}") do |*args|
          options = args.extract_options!
          options[:class] = [action, options[:class]].compact.join(' ')
          scope = options.key?(:scope) ? options.delete(:scope) : 'actions'

          if action == :destroy
            model   = args.last.class.respond_to?(:model_name) ? args.last : controller.resource
            name    = model.class.model_name.human
            confirm = t(:'.confirmations.destroy', :model_name => name)
            options.reverse_merge!(:method => :delete, :confirm => confirm)
          end

          link_text = args.shift if args.first.is_a?(String)
          link_text = t(args.shift) if args.first.is_a?(Symbol)
          link_text ||= t(:".#{[scope, action].compact.join('.')}")

          url = if args.first.is_a?(String)
            args.first
          else
            controller.send(:"#{action}_path", *args)
          end

          link_to(link_text, url, options)
        end
      end
    end
  end
end

