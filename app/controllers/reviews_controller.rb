class ReviewsController < ApplicationController

  before_action :authenticate_user!, except: %i[show index]

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
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])

    unless current_user.author_of?(@review)
      redirect_to @review, notice: 'You have no rights to do this.'
      return true
    end

    if @review.update(review_params)
      redirect_to review_path(@review)
    else
      render :edit
    end
  end

  def show
    @review = Review.find(params[:id])
  end

  def index
    @reviews = Review.all
  end

  private

  def review_params
    params.require(:review).permit(:title, :body)
  end
  
end
