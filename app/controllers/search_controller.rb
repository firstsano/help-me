class SearchController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  respond_to :html

  def index
    @query = params.require(:search).permit(:query)[:query]
    escaped_query = ThinkingSphinx::Query.escape @query
    @results = ThinkingSphinx.search @query
  end
end
