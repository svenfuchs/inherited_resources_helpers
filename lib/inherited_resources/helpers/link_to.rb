module InheritedResources
  module Helpers
    module LinkTo
      [:index, :new, :show, :edit, :destroy].each do |action|
        define_method(:"link_to_#{action}") do |*args|
          link_to(t(:".#{action}"), controller.send(:"#{action}_path"), args.extract_options!)
        end
      end
    end
  end
end