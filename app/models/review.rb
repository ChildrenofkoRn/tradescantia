class Review < ApplicationRecord

  include Authorable

  has_many :ranks, as: :rankable, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  def ranking
    ranks.average(:score)
  end
  
end
