module Rankable
  extend ActiveSupport::Concern

  included do
    has_many :ranks, as: :rankable, dependent: :destroy
  end
end
