class Review < ApplicationRecord

  include Authorable

  has_many :ranks, as: :rankable, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  def rank
    ranks.average(:score).to_i || 0
  end

  def ranks_count
    ranks.count
  end
  
end
