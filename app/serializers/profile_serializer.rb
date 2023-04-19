class ProfileSerializer
  include JSONAPI::Serializer

  attributes :email, :username, :created_at, :updated_at

  attribute :reviews_count do |object|
    object.reviews.size
  end

  attribute :avarage_rank_given do |user|
    ranks = user.ranks.pluck(:score)
    ranks.empty? ? 0 : (ranks.sum(0.0) / ranks.size).round(2)
  end

end
