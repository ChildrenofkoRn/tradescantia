class Link < ApplicationRecord
  belongs_to :review

  validates :url, presence: true
end
