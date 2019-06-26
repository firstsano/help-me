ThinkingSphinx::Index.define :comment, with: :active_record do
  # fields
  indexes body
  indexes author.name, as: :author, sortable: true

  # attributes
  has user_id, created_at, updated_at
end
