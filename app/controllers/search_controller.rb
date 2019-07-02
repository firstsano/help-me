class SearchController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  def index
    head :no_content
  end
end
