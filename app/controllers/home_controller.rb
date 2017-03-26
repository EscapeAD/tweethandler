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
      @tweets = Tweet.all
    end
  end

  def filters
    languages   = Tweet.uniq.pluck(:language)
    tweet_type  = Tweet.uniq.pluck(:tweet_type)
    render partial: 'radio', locals: {languages: languages, tweet_type: tweet_type }
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
