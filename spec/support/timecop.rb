RSpec.configure do |config|
  config.around(:context, :with_timecop) do |example|
    freeze_time = Time.local(1990)
    Timecop.freeze freeze_time
    example.run
    Timecop.return
  end
end
