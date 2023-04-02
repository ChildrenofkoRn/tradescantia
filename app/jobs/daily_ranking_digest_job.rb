class DailyRankingDigestJob < ApplicationJob
  queue_as :default

  def perform
    DailyRankingDigestService.new.send_digest
  end
end
