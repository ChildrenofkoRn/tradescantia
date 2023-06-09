require 'rails_helper'

RSpec.describe Api::V1::ReviewPolicy, type: :policy do

  subject { described_class.new(user, review) }

  let(:review) { create(:review) }

  context "Admin" do
    let(:user) { create(:admin) }

    it { should         authorize(:show) }
    it { should       authorize(:update) }
  end

  context "Author" do
    let(:user)   { create(:user) }
    let(:review) { create(:review, author: user) }

    it { should         authorize(:show) }
    it { should       authorize(:update) }
  end

  context "User" do
    let(:user) { create(:user) }

    it { should         authorize(:show) }
    it { should_not   authorize(:update) }
  end

  context "Visitor" do
    let(:user) { nil }

    it { should_not     authorize(:show) }
    it { should_not   authorize(:update) }
  end
end
