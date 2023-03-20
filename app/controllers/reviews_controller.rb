class ReviewsController < ApplicationController

  before_action :authenticate_user!, except: %i[show index]

  include Ranked

  before_action :load_review, only: %i[show edit update destroy ranking]
  before_action :allow_only_author, only: %i[edit update destroy]

  def new
    @review = current_user.reviews.new
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
  end

  def allow_only_author
    unless current_user.author_of?(@review)
      redirect_to @review, notice: 'You have no rights to do this.'
    end
  end
  
end
