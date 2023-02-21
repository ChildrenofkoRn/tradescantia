class Review < ApplicationRecord

  include Authorable

  validates :title, presence: true
  validates :body, presence: true
  
end
