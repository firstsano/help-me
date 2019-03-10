require 'rails_helper'

RSpec.configure do |config|
  Capybara.javascript_driver = :selenium_chrome_headless

  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include AttachmentHelper, type: :feature
end
