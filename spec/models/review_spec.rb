require 'rails_helper'

RSpec.describe Review, type: :model do

  describe 'associations' do
    it { should belong_to(:author) }
    it { should have_many(:ranks).dependent(:destroy) }
    it { should have_one(:link).dependent(:destroy) }
    it { should have_one(:stat).dependent(:destroy) }
  end

  describe 'nested attrs' do
    it { should accept_nested_attributes_for(:link) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  it_behaves_like 'be Modulable', %w[Authorable Rankable]
end
