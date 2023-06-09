class LinkSerializer
  include JSONAPI::Serializer

  attributes :title, :url, :created_at, :updated_at
end
