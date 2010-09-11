require 'inherited_resources'

module InheritedResources
  module Helpers
    autoload :Accessors, 'inherited_resources/helpers/accessors'
    autoload :LinkTo,    'inherited_resources/helpers/link_to'
    autoload :Resources, 'inherited_resources/helpers/resources'
    autoload :UrlFor,    'inherited_resources/helpers/url_for'
  end

  Base.class_eval do
    class << self
      def inherited_with_helpers(base)
        base.send :include, Helpers::Resources
        base.send :include, Helpers::UrlFor
        base.send :include, Helpers::Accessors
        inherited_without_helpers(base)
      end
      alias_method_chain :inherited, :helpers # TODO ugh.
    end
  end
end

