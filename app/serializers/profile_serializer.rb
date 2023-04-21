class ProfileSerializer
  include JSONAPI::Serializer

  def self.owner_admin?
    Proc.new { |record_, params| params[:email] || params[:owner]&.admin? }
  end


  attributes :username, :created_at, :updated_at

  attribute :email, if: owner_admin?
  attribute :type,  if: owner_admin?


  attribute :reviews_count do |object|
    "#{object.reviews.size}"
  end

  attribute :avarage_rank_given do |user|
    ranks = user.ranks.pluck(:score)
    result = ranks.empty? ? 0 : (ranks.sum(0.0) / ranks.size).round(2)
    "#{result}"
  end

end
