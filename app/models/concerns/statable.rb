module Statable
  extend ActiveSupport::Concern

  included do
    has_one :stat, dependent: :destroy, as: :statable

    after_create -> (resource) { resource.create_stat }
  end
end
