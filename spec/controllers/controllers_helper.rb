require 'rails_helper'

RSpec.configure do |config|
  config.include OmniauthHelper, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include JsonHelper, type: :controller
  config.extend LoginHelper, type: :controller
end
