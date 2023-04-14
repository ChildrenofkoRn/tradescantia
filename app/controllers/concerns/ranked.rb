module Ranked
  extend ActiveSupport::Concern

  STRONG_PARAMS = %i[ score ].freeze

  included do
    before_action :set_rankable, only: :ranking
  end


  def ranking
    authorize @rankable
    rank = Rank.new(author: current_user, rankable: @rankable)
    rank.score = params[:rank].to_i

    if rank.save
      render :js, partial: "shared/ranked/ranking"
    else
      flash.now.alert = rank.errors
      render :js, partial: "shared/ranked/ranking", status: 422
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_rankable
    @rankable = model_klass.find(params[:id])
  end

end
