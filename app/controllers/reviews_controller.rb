class ReviewsController < ApplicationController

  before_action :authenticate_user!, except: %i[show index]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    if @review.save
      redirect_to review_path(@review)
    else
      render :new
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
