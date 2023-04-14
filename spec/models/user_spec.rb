require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'associations' do
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:ranks).dependent(:destroy) }
  end

  describe 'validations' do
    context 'email' do
      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of(:email).case_insensitive }
      it { should  allow_value("Seven.Ways_Till_Sunday+tag@email.tram").for(:email) }
      it { should_not allow_value("Inverted#Ballad+tag@email.tram").for(:email) }
    end

    context 'username' do
      it { should validate_presence_of(:username) }
      it { should validate_uniqueness_of(:username).case_insensitive }
      it { should allow_value("_99_Problems-").for(:username) }
      it { should_not allow_value("@yolo").for(:username) }
      it { should validate_length_of(:username).is_at_least(1).is_at_most(40) }
    end
  end

  describe '.find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '2255')}

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:call).with(auth)
      User.find_for_oauth(auth)
    end
  end

  describe '#ranked?' do
    let(:user) { create(:user) }
    let(:review) { create(:review) }

    it 'true if already ranked' do
      create(:rank, author: user, rankable: review)

      expect(user.ranked?(review)).to be_truthy
    end

    it 'false if not ranked' do
      expect(user.ranked?(review)).to be_falsey
    end
  end

  describe '#author_of?' do
    let(:author) { create(:user) }
    let(:resource) { create(:review) }
    let(:resource_author) { create(:review, author: author) }

    it 'true if the user is the author of the resource' do
      expect(author).to be_an_author_of(resource_author)
    end

    it 'false if the user is not the author of the resource' do
      expect(author).not_to be_an_author_of(resource)
    end
  end

  describe '#admin?' do
    let(:review) { create(:review) }

    it 'true if admin' do
      admin = create(:admin)
      expect(admin.admin?).to be_truthy
    end

    it 'false if user' do
      user = create(:user)
      expect(user.admin?).to be_falsey
    end
  end
end
