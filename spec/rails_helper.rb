
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/poltergeist'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }

# use headless driver poltergeist for Travis CI environment

if ENV['TRAVIS']
  Capybara.javascript_driver = :poltergeist
end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Helpers need to be included explicitly
  config.include ApplicationHelper
  config.include AuthenticationHelper
  config.include BreadcrumbHelper
  config.include NavTabHelper
  config.include TableHelper
  config.include PageHelper

  config.include HelperMethods

  config.before(:each, type: :view) do
    view.extend AuthenticationHelper
    view.extend BreadcrumbHelper
    view.extend NavTabHelper
    view.extend TableHelper
    view.extend PageHelper
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
