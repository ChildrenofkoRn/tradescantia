class ReviewsController < ApplicationController

  before_action :authenticate_user!, except: %i[show index]

  include Ranked

  before_action :load_review, only: %i[show edit update destroy]

  def new
    @review = current_user.reviews.new
    authorize @review
  end

  def create
    @review = current_user.reviews.new(review_params)
    authorize @review
    if @review.save
      redirect_to review_path(@review)
    else
      render :new
    end
  end

  def edit
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
    @reviews = Review.all
  end

  private

  def review_params
    params.require(:review).permit(:title, :body, Ranked::STRONG_PARAMS)
  end

  def load_review
    @review = Review.find(params[:id])
    authorize @review
  end
  
end
