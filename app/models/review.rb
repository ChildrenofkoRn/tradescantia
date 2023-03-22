class Review < ApplicationRecord

  include Authorable
  include Rankable

  validates :title, presence: true
  validates :body, presence: true
  
end
