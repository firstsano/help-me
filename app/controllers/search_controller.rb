class SearchController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  respond_to :html

  def index
    @query = ThinkingSphinx::Query.escape search_params[:query]
    @results = SphinxSearch.search @query, search_params[:category], star: true, per_page: 40
  end

  private

  def search_params
    params.require(:search).permit(:query, :category)
  end
end
