FactoryBot.define do
  factory :attachment do
    transient do
      filename { 'sample.txt' }
    end

    after :build do |attachment, evaluator|
      source_path = attachment_path evaluator.filename
      attachment.source = Rack::Test::UploadedFile.new source_path
    end
  end
end
