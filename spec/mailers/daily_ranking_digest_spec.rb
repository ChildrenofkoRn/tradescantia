require "rails_helper"

RSpec.describe DailyRankingDigestMailer, type: :mailer do
  let(:user) { create(:user) }
  let!(:reviews_last_day) { create_list(:review, 3, created_at: Date.yesterday) }
  let!(:review_outdated ) { create(:review, created_at: Date.today.days_ago(3)) }
  let!(:mail) { DailyRankingDigestMailer.ranking_digest(user) }
  let!(:domain) { "http://#{default_url_options[:host]}:#{default_url_options[:port]}" }

  it "renders the headers" do
    expect(mail.subject).to eq("Ranking digest")
    expect(mail.to).to eq [user.email]
    expect(mail.from).to eq(["please-change-me-at-config-initializers-devise@example.com"])
  end

  it "renders the body" do
    expect(mail.body.encoded).to match("This is a digest of review created in the last day")
  end

  it "body has last day's reviews " do
    reviews_last_day.each do |review|
      expect(mail.body.encoded).to have_link(review.title, href: "#{domain}/reviews/#{review.id}")
    end
  end

  it "body not has old questions" do
    expect(mail.body.encoded).to_not have_link(review_outdated.title, href: url_for(review_outdated))
  end

end
