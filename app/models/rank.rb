class Rank < ApplicationRecord

  RANGE = 1..7

  include Authorable

  belongs_to :rankable, polymorphic: true

  validates :author_id, uniqueness: { scope: [:rankable_type, :rankable_id], case_sensitive: false }
  validates :score, presence: true, numericality: { only_integer: true }, inclusion: RANGE

end
