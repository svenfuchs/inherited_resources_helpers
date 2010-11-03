require 'inherited_resources'

module InheritedResources
  module Helpers
    autoload :Accessors,       'inherited_resources/helpers/accessors'
    autoload :LinkTo,          'inherited_resources/helpers/link_to'
    autoload :Resources,       'inherited_resources/helpers/resources'
    autoload :ResourcesUrlFor, 'inherited_resources/helpers/resources_url_for'
    autoload :UrlFor,          'inherited_resources/helpers/url_for'
  end

  Base.class_eval do
    class << self
      def inherited_with_helpers(base)
        inherited_without_helpers(base)
        base.send :include, Helpers::Resources
        base.send :include, Helpers::ResourcesUrlFor
        base.send :include, Helpers::Accessors
      end
      alias_method_chain :inherited, :helpers # TODO ugh.
    end
  end

  UrlHelpers.module_eval do
    def generate_url_and_path_helpers(prefix, name, resource_segments, resource_ivars)
      # FIXME ... we define our own helpers for now, should merge with inherited_resources.
    end
  end
end

