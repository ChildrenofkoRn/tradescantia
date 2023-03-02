require 'rails_helper'

RSpec.describe Authorization, type: :model do

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do

    describe 'uid' do
      it { should validate_presence_of(:uid) }
    end

    describe 'provider' do
      it { should validate_presence_of(:provider) }
    end

    describe "uniqueness" do
      subject { Authorization.new(provider: "github", uid: "220926", user: create(:user)) }

      it { should validate_uniqueness_of(:provider).scoped_to(:uid) }
    end

  end
end
