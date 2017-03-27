class HomeController < ApplicationController
  before_action :badge_helper
  
  def index
    if params[:filters_types] && !params[:search]
      @tweets = Tweet.filters(params[:filters_types])
      render partial: 'tweet'
    elsif params[:search]
      search_input = params[:filters_types] || "none"
      @tweets = Tweet.filters(search_input).order("#{params[:search]} #{params[:direction]}")
      render partial: 'tweet'
    else
      @tweets = Tweet.where('score is NOT NULL')
    end
  end

  def filters
    languages   = Tweet.where('language is NOT NULL').uniq.pluck(:language)
    tweet_type  = Tweet.where('tweet_type is NOT NULL')
                       .uniq.pluck(:tweet_type)
    render partial: 'radio', locals: {languages: languages, tweet_type: tweet_type }
  end

  def import
    tweet = Tweet.import(params[:file])
    if tweet.include?('error')
      flash[:alert] = tweet[1]
    end
    redirect_to root_path
  end

  def destroy
    Tweet.destroy_all
    ActionCable.server.broadcast "room_lobby", {empty: 'yes'}
    redirect_to root_path
  end

  private
  def badge_helper
    @pending  = Tweet.any? ? Tweet.all.count : "0"
    @complete = Tweet.where('score is NOT NULL').any? ? Tweet.where('score is NOT NULL').count : "0"
  end
end
