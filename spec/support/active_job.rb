RSpec.configure do |config|
  config.before(:context, :activejob_test_adapter) { ActiveJob::Base.queue_adapter = :test }
end
