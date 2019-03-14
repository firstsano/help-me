FactoryBot.define do
  factory :attachment do
    transient do
      filename { 'sample.txt' }
    end

    after :build do |attachment, evaluator|
      source_path = attachment_path evaluator.filename
      attachment.source = Rack::Test::UploadedFile.new source_path
    end

    factory :answer_attachment do
      association :attachable, factory: :answer
    end

    factory :question_attachment do
      association :attachable, factory: :question
    end
  end
end
