class HomeController < ApplicationController
  def index
    @tweets = Tweet.all
  end

  def import
    Tweet.import(params[:file])
    redirect_to root_path
  end

  def destroy
    Tweet.destroy_all
    redirect_to root_path
  end

end
