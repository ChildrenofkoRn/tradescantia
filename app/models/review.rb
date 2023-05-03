class Review < ApplicationRecord

  include Authorable
  include Rankable

  has_one :link, dependent: :destroy
  has_one :stat, dependent: :destroy, as: :statable

  accepts_nested_attributes_for :link,
                                reject_if: :all_blank,
                                allow_destroy: true

  scope :by_date, -> { order(created_at: :desc) }

  validates :title, presence: true
  validates :body, presence: true

  after_create ->(review) { review.create_stat }

  ThinkingSphinx::Callbacks.append(
    self, :behaviours => [:real_time]
  )

end
