require 'rails_helper'

def resource_uri(resource)
  "/api/v1/#{resource}"
end

RSpec.configure do |config|
  config.extend LoginHelper::Request, type: :request
  config.include JsonSpec::Helpers, type: :request
end
