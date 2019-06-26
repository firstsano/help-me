ThinkingSphinx::Index.define :question, with: :active_record do
  # fields
  indexes title, sortable: true
  indexes body
  indexes created_by.name, as: :author, sortable: true

  # attributes
  has created_by_id, created_at, updated_at
end
