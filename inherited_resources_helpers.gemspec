# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'inherited_resources_helpers/version'

Gem::Specification.new do |s|
  s.name         = "inherited_resources_helpers"
  s.version      = InheritedResourcesHelpers::VERSION
  s.authors      = ["Sven Fuchs"]
  s.email        = "svenfuchs@artweb-design.de"
  s.homepage     = "http://github.com/svenfuchs/inherited_resources_helpers"
  s.summary      = "[summary]"
  s.description  = "[description]"

  s.files        = Dir.glob("lib/**/**")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
  s.required_rubygems_version = '>= 1.3.6'

  s.add_development_dependency 'rails'
  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'activerecord'
  s.add_development_dependency 'actionpack'
  s.add_development_dependency 'inherited_resources'
  s.add_development_dependency 'test_declarative'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'sqlite3-ruby'
end
