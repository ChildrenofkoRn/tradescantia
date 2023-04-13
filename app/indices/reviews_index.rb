ThinkingSphinx::Index.define :review, with: :real_time do
  indexes title, sortable: true
  indexes body
  indexes author.username, as: :author, sortable: true

  has author_id,  :type => :integer
  has created_at, :type => :timestamp
  has updated_at, :type => :timestamp
end
