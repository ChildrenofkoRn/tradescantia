require 'rails_helper'

RSpec.describe Rank, type: :model do
  describe 'associations' do
    it { should belong_to(:author) }
    it { should belong_to(:rankable) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:rank) }
    it { should validate_uniqueness_of(:author_id).scoped_to([:rankable_type, :rankable_id]).case_insensitive }
    it { should validate_presence_of(:score) }
    it { should validate_numericality_of(:score).only_integer }
    it { should validate_inclusion_of(:score).in_range(1..7) }
  end

  it_behaves_like 'be Modulable', %w[Authorable]
end
