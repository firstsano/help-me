RSpec.configure do |config|
  config.before(:context, :with_activejob) { ActiveJob::Base.queue_adapter = :test }
end
