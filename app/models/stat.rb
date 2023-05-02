class Stat < ApplicationRecord
  belongs_to :review

  validates :views, :ranks_count, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :rank_avg, numericality: { greater_than_or_equal_to: 0 }
end
