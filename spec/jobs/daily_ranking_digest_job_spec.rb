require 'rails_helper'

RSpec.describe DailyRankingDigestJob, type: :job do
  let(:service) { double('DailyRankingDigestService') }

  before do
    allow(DailyRankingDigestService).to receive(:new).and_return(service)
  end

  it 'calls DailyRankingDigestService#send_digest' do
    expect(service).to receive(:send_digest)
    subject.perform_now
  end
end
