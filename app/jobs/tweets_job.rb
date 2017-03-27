class TweetsJob < ApplicationJob
  queue_as :default

def perform(tweet)
  ActionCable.server.broadcast "room_lobby", tweet: render_message(tweet)
end

private
  def render_message(data)
    ApplicationController.renderer.render(partial: 'home/tweet0', locals: { tweet: data })
  end
end
