class ApitweetJob < ApplicationJob
  queue_as :default

  def perform(data)
    Tweet.danedlion(data)
  end
end
