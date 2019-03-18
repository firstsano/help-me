require 'rails_helper'
require 'capybara-screenshot/rspec'

RSpec.configure do |config|
  Capybara.javascript_driver = :selenium_chrome_headless

  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include CoreHelper, type: :feature
  config.include AttachmentHelper, type: :feature
end
