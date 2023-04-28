class Review < ApplicationRecord

  include Authorable
  include Rankable

  has_one :link

  scope :by_date, -> { order(created_at: :desc) }

  validates :title, presence: true
  validates :body, presence: true

  ThinkingSphinx::Callbacks.append(
    self, :behaviours => [:real_time]
  )

end
