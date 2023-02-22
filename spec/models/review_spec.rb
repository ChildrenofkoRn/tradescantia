require 'rails_helper'

RSpec.describe Review, type: :model do

  describe 'associations' do
    it { should belong_to(:author) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  it_behaves_like 'be Modulable', %w[Authorable]
end
