ThinkingSphinx::Index.define :review, with: :active_record do
  indexes title, sortable: true
  indexes body
  indexes author.username, as: :author, sortable: true

  has author_id, created_at, updated_at
end
