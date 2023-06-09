class ReviewSerializer
  include JSONAPI::Serializer

  attributes :title, :body, :created_at, :updated_at

  has_one :link
end
