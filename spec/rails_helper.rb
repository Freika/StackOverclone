ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'

Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

ActiveRecord::Migration.maintain_test_schema!
Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.include UsersHelpers,        type: :feature
  config.extend ControllerHelpers,    type: :controller
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.before(:all) do
    FactoryGirl.reload
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
