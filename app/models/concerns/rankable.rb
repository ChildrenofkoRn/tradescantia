module Rankable
  extend ActiveSupport::Concern

  included do
    has_many :ranks, as: :rankable, dependent: :destroy

    def rank
      ranks.average(:score).to_f || 0
    end

    def ranks_count
      ranks.count
    end
  end
end
