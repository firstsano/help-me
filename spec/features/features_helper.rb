require 'rails_helper'
require 'capybara-screenshot/rspec'
require 'capybara/email/rspec'

RSpec.configure do |config|
  OmniAuth.config.test_mode = true

  Capybara.server = :puma
  Capybara.javascript_driver = :selenium_chrome_headless

  config.include OmniauthHelper, type: :feature
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include CoreHelper, type: :feature
  config.include AttachmentHelper, type: :feature
  config.extend LoginHelper::Feature, type: :feature
  config.include SphinxHelper, type: :feature
end
