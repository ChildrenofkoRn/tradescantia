class Rank < ApplicationRecord

  RANGE = 1..7

  include Authorable

  belongs_to :rankable, polymorphic: true

  validates :author_id, uniqueness: { scope: [:rankable_type, :rankable_id], case_sensitive: false }
  validates :score, presence: true, numericality: { only_integer: true }, inclusion: RANGE

  after_save    -> (rank) { rank.rankable.stat.rank_add(rank.score) }
  after_destroy -> (rank) { rank.rankable.stat.rank_del(rank.score) }

end
