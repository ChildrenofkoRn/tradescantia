require 'rails_helper'

RSpec.describe DashboardPolicy, type: :policy do

  subject { described_class.new(user, :dashboard) }

  context "Admin" do
    let(:user) { create(:admin) }

    it { should     authorize(:index) }
  end

  context "User" do
    let(:user) { create(:user) }

    it { should_not authorize(:index) }
  end

  context "Visitor" do

    let(:user) { nil }

    it { should_not authorize(:index) }
  end

end
