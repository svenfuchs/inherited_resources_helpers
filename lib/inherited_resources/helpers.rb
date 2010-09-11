module InheritedResources
  module Helpers
    autoload :Resources, 'inherited_resources/helpers/resources'
    autoload :UrlFor,    'inherited_resources/helpers/url_for'
    autoload :LinkTo,    'inherited_resources/helpers/link_to'
  end

  Base.class_eval do
    class << self
      def inherited_with_helpers(base)
        base.send :include, Helpers::Resources
        base.send :include, Helpers::UrlFor
        inherited_without_helpers(base)
      end
      alias_method_chain :inherited, :helpers # TODO ugh.
    end
  end
end

