RSpec.configure do |config|
  config.before(:context, :activejob_test_adapter) { ActiveJob::Base.queue_adapter = :test }

  config.around(:context, :sidekiq_inline) do |example|
    Sidekiq::Testing.inline! do
      example.run
    end
  end
end
