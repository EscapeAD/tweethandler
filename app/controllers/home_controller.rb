class HomeController < ApplicationController
  def index
    if params[:filters] && !params[:search]
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
    languages   = Tweet.uniq.pluck(:language)
    tweet_type  = Tweet.uniq.pluck(:tweet_type)
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
    render :index
  end

end
