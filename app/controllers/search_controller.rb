class SearchController < ApplicationController

  def index
    @result = SearchService.call(**search_params)
  end

  private

  def search_params
    params.permit(:search_query, :search_type).to_h.symbolize_keys
  end
end
