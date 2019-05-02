require 'rails_helper'

RSpec.configure do |config|
  config.before(:each, type: :controller) do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  config.include OmniauthHelper, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include JsonHelper, type: :controller
end
