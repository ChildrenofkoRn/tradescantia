class SearchController < ApplicationController

  after_action :verify_authorized

  def index
    authorize(:search)
    @results = SearchSphinxService.call(**search_params)
  end

  private

  def search_params
    search = params.require(:search).permit(:query, :type).to_h.symbolize_keys
    params[:page] ? search.merge!(page: params[:page]) : search
  end
end
