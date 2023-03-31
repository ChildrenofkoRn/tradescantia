require 'rails_helper'

RSpec.describe DailyRankingDigestService do
  let(:users) { create_list(:user, 4) }

  it 'sends daily ranking digest to all users' do
    create_list(:review, 10, created_at: Date.yesterday, author: users.first)

    users.each { |user| expect(DailyRankingDigestMailer).to receive(:ranking_digest)
                                                        .with(user)
                                                        .and_call_original }
    subject.send_digest
  end

end
