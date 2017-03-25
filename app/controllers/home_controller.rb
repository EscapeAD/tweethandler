class HomeController < ApplicationController
  def index
    if params[:search]
      @tweets = Tweet.order("#{params[:search]} #{params[:direction]}")
      render partial: 'tweet'
    else
      @tweets = Tweet.all
    end

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
