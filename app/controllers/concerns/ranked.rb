module Ranked
  extend ActiveSupport::Concern

  STRONG_PARAMS = %i[ :score ].freeze

  included do
    before_action :set_rankable, only: :ranking
  end


  def ranking
    if current_user.author_of?(@rankable)
      render_ranking_alert("#{@rankable.class} author cannot rank")
    else
      rank = Rank.find_or_initialize_by(author: current_user, rankable: @rankable)

      if rank.persisted?
        return render_ranking_alert("You already ranked for this review!")
      end

      rank.score = params[:rank].to_i

      if rank.save
        render :js, partial: "shared/ranked/ranking"
      else
        render_ranking_alert(rank.errors)
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_rankable
    @rankable = model_klass.find(params[:id])
  end

  def render_ranking_alert(errors)
    flash.now.alert = errors
    render :js, partial: "shared/ranked/ranking", status: 422
  end

end
