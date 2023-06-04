class Authorization < ApplicationRecord
  belongs_to :user

  validates :uid, presence: true
  validates :provider, presence: true, uniqueness: { scope: :uid, message: "Provider already exists for this uid." }
end
