class Review < ApplicationRecord

  include Authorable
  include Rankable

  validates :title, presence: true
  validates :body, presence: true

  scope :by_date, -> { order(created_at: :asc) }
  
end
