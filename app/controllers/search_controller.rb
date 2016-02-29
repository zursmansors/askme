class SearchController < ApplicationController
  skip_authorization_check

  def search
    @resources = Search.search params[:query], params[:resource], page: params[:page], per_page: 15
  end
end
