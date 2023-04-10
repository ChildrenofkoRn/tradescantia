class SearchController < ApplicationController

  def index
    @results = SearchSphinxService.call(**search_params)
    @results.context[:panes] << ThinkingSphinx::Panes::ExcerptsPane
  end

  private

  def search_params
    params.permit(:search_query, :search_type, :page).to_h.symbolize_keys
  end
end
