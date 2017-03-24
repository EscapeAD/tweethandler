class HomeController < ApplicationController
  def index
    @tweets = Tweet.all
  end

  def import
    Tweet.import(params[:file])
  end

end
