class Tweet < ApplicationRecord

  def self.import(file)
    # default CSV format not UTF-8 based on example
    sheet = Roo::CSV.new(file.path, csv_options: {external_encoding: 'ISO-8859-1', internal_encoding: 'UTF-8'})
    sheet.parse(clean: true)
    sheet.each(tweet: 'Tweet_Text', type: 'Type') do |hash|
    Tweet.create!(tweet: hash[:tweet], tweet_type: hash[:type])
    end
    Tweet.first.delete
    Tweet.danedlion
  end

  def self.danedlion
    Dandelionapi.configure do |c|
      c.token   = Figaro.env.api_key
      c.endpoint = "https://api.dandelion.eu/"
    end

    # highest language on top
    tweets = Tweet.all
    tweets.each do |tweet|
      sentiment = Dandelionapi::SentimentAnalysis::Request.new
      sentiment_score = sentiment.analyze(text: tweet.tweet)
      tweet.update_attributes(score: sentiment_score['sentiment']['score'],
                              language: sentiment_score['lang']
      )
      puts sentiment_score['sentiment']
    end
  end

end
