require 'rails_helper'

RSpec.describe SearchPolicy, type: :policy do

  subject { described_class.new(user, :search) }

  let(:review) { create(:review) }

  context "Visitor" do
    let(:user) { nil }

    it { should authorize(:index) }
  end

  context "Admin" do
    let(:user) { create(:admin) }

    it { should authorize(:index) }
  end

  context "Author" do
    let(:user) { create(:user) }

    it { should authorize(:index) }
  end

  context "User" do
    let(:user) { create(:user) }

    it { should  authorize(:index) }
  end

end
