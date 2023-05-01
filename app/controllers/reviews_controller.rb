class ReviewsController < ApplicationController

  include Ranked

  before_action :authenticate_user!, except: %i[show index]
  before_action :load_review, only: %i[show edit update destroy]
  before_action :authorize_review!, except: %i[ranking]
  after_action :verify_authorized
  after_action :publishing_question_in_channel, only: :create

  def new
    @review = current_user.reviews.build
    @review.build_link
  end

  def create
    @review = current_user.reviews.new(review_params)
    if @review.save
      redirect_to review_path(@review)
    else
      render :new
    end
  end

  def edit
    @review.build_link if @review.link.blank?
  end

  def update
    if @review.update(review_params)
      redirect_to review_path(@review)
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to reviews_path, notice: "The review \"#{@review.title}\" was successfully deleted."
  end

  def show
  end

  def index
    @reviews = Review.by_date.with_stats.includes(:author).page(params[:page])
  end

  private

  def review_params
    params.require(:review).permit(:title, :body,
                                   Ranked::STRONG_PARAMS,
                                   link_attributes: [:title, :url, :id, :_destroy])
  end

  def load_review
    @review = Review.find(params[:id])
  end

  def authorize_review!
    authorize(@review || Review)
  end

  def publishing_question_in_channel
    return if @review.errors.any?

    ActionCable.server.broadcast(
      'reviews',
      ApplicationController.render(
        partial: 'reviews/review',
        locals: { review: @review }
      )
    )
  end
  
end
