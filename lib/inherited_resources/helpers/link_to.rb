module InheritedResources
  module Helpers
    module LinkTo
      [:index, :new, :show, :edit].each do |action|
        define_method(:"link_to_#{action}") do |*args|
          link_to(t(:".#{action}"), controller.send(:"#{action}_path"), args.extract_options!)
        end
      end

      def link_to_destroy(*args)
        options = args.extract_options!
        options.reverse_merge!(:method => :delete, :confirm => t(:"confirm.#{instance_name}"))
        link_to(t(:'.destroy'), controller.show_path, options)
      end
    end
  end
end