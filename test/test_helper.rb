$:.unshift File.expand_path('../../lib', __FILE__)

require 'rubygems'
require 'test/unit'
require 'test_declarative'
require 'ruby-debug'
require 'database_cleaner'

require 'active_support'
require "active_support/core_ext/object/with_options"
require "active_record"
require "action_controller"
require "rails/railtie"

class ApplicationController < ActionController::Base; end

require 'inherited_resources'
require 'inherited_resources/helpers'
require File.expand_path('../test_setup', __FILE__)

DatabaseCleaner.strategy = :truncation

Test::Unit::TestCase.class_eval do
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def setup_controller(klass)
    klass.new.tap do |controller|
      controller.request  = ActionDispatch::TestRequest.new
      controller.response = ActionDispatch::TestResponse.new
      controller.params = { :action => 'show' }
      yield(controller) if block_given?
    end
  end

  def assert_new_record(klass, record)
    assert record.is_a?(klass), "#{record.inspect} should be a #{klass}"
    assert record.new_record?,  "#{record.inspect} should be a new record (#{klass})"
  end
end


