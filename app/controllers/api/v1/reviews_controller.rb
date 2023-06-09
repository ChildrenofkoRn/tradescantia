class Api::V1::ReviewsController < Api::V1::BaseController

  before_action :load_review, only: %i[show update]
  before_action :authorize_review!

  after_action :verify_authorized

  def show
    options = { include: [:link] }
    serialize(@review, options)
  end

  private

  def authorize_review!
    authorize(@review)
  end

  def load_review
    @review = Review.find(params[:id])
  end

  def serialize(...)
    render json: ReviewSerializer.new(...).serializable_hash.to_json
  end

end
