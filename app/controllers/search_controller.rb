class SearchController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  respond_to :html

  def index
    @query = ThinkingSphinx::Query.escape search_params[:query]
    @category = search_params[:category]
    @results = SphinxSearch.search @query, @category, star: true, per_page: 40
  end

  private

  def search_params
    params.require(:search).permit(:query, :category)
  end
end
