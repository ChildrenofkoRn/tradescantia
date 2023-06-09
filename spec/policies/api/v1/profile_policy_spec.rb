require 'rails_helper'

RSpec.describe Api::V1::ProfilePolicy, type: :policy do

  subject { described_class.new(user, :profile) }

  context "Admin" do
    let(:user) { create(:admin) }

    it { should       authorize(:index) }
    it { should          authorize(:me) }
  end

  context "User" do
    let(:user) { create(:user) }

    it { should       authorize(:index) }
    it { should          authorize(:me) }
  end

  context "Visitor" do
    let(:user) { nil }

    it { should_not   authorize(:index) }
    it { should_not      authorize(:me) }
  end

  context "scope" do
    def resolve_for(user)
      described_class::Scope.new(user, User).resolve
    end

    let!(:users) { create_list(:user, 4) }

    it 'admin sees the full list of users' do
      admin = create(:admin)
      expect(resolve_for(admin).count).to eq(5)
    end

    it 'user sees only users' do
      admin = create(:admin)
      expect(resolve_for(users.first).count).to eq(4)
      expect(resolve_for(users.first)).to_not include(admin)
    end
  end

end
