ThinkingSphinx::Index.define :user, with: :real_time do
  indexes username, sortable: true

  has created_at, :type => :timestamp
  has updated_at, :type => :timestamp
end
