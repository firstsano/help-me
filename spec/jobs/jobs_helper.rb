require 'rails_helper'

RSpec.configure do |config|
  config.before(type: :job) { ActiveJob::Base.queue_adapter = :test }
end
