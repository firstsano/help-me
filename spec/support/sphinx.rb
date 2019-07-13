RSpec.configure do |config|
  config.around(:context, :with_sphinx) do |example|
    ThinkingSphinx::Test.run do
      example.run
    end
  end
end
