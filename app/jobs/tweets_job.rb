class TweetsJob < ApplicationJob
  queue_as :default

def perform(tweet)
  tweet_all        = Tweet.all.count
  tweets_processed = Tweet.where('score is NOT NULL').count
  ActionCable.server.broadcast "room_lobby", {tweet: render_message(tweet), processed: tweets_processed, pending: tweet_all}
end

private
  def render_message(data)
    ApplicationController.renderer.render(partial: 'home/tweet0', locals: { tweet: data })
  end
end
