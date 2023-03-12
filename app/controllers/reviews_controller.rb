class ReviewsController < ApplicationController

  before_action :authenticate_user!, except: %i[show index]
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

  def ranking
    if current_user.author_of?(@review)
      render_json_errors("#{@review.class}-author cannot rank")
    else
      rank = Rank.find_or_initialize_by(author: current_user, rankable: @review)

      if rank.persisted?
        render_json_errors("You already ranked for this review!")
        return
      end

      rank.score = params[:rank].to_i

      if rank.save
        render json: { ranking: "#{@review.ranking}" }
      else
        render_json_errors(rank.errors)
      end
    end
  end

  private

  def render_json_errors(errors)
    render json: { errors: errors }, status: :unprocessable_entity
  end

  def review_params
    params.require(:review).permit(:title, :body, :rank)
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
