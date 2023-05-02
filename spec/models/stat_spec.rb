require 'rails_helper'

RSpec.describe Stat, type: :model do

  describe 'associations' do
    it { should belong_to(:review) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:views).is_greater_than_or_equal_to(0).only_integer }
    it { should validate_numericality_of(:ranks_count).is_greater_than_or_equal_to(0).only_integer }
    it { should validate_numericality_of(:rank_avg).is_greater_than_or_equal_to(0) }
  end

end
