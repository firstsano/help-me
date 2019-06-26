ThinkingSphinx::Index.define :answer, with: :active_record do
  # fields
  indexes body
  indexes created_by.name, as: :author, sortable: true

  # attributes
  has created_by_id, created_at, updated_at, is_best
end
