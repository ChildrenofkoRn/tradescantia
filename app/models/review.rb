class Review < ApplicationRecord

  include Authorable
  include Rankable
  include Statable

  has_one :link, dependent: :destroy

  accepts_nested_attributes_for :link,
                                reject_if: :all_blank,
                                allow_destroy: true

  scope :by_date, -> { order(created_at: :desc) }

  validates :title, presence: true
  validates :body, presence: true

  ThinkingSphinx::Callbacks.append(
    self, :behaviours => [:real_time]
  )

end
