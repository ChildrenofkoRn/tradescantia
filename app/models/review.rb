class Review < ApplicationRecord

  include Authorable
  include Rankable

  validates :title, presence: true
  validates :body, presence: true

  default_scope { order(:created_at) }
  
end
