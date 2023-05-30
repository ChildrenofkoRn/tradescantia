class ReviewsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "reviews"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
