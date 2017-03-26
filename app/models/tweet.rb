class Tweet < ApplicationRecord
  include

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
    end
  end

  def self.filters(object)
    if object['sentiment'] && object['lang'] && object['tweet_type']
    return   Tweet.where(Tweet.checking_sentiment(object['sentiment']), 0)
                  .where(language: object['lang'])
                  .where(tweet_type: object['tweet_type'])
    elsif object['sentiment'] && object['lang']
    return Tweet.where(Tweet.checking_sentiment(object['sentiment']), 0)
                .where(language: object['lang'])
    elsif object['lang'] && object['tweet_type']
    return Tweet.where(tweet_type: object['tweet_type'])
                .where(language: object['lang'])
    elsif object['sentiment'] && object['tweet_type']
    return   Tweet.where(Tweet.checking_sentiment(object['sentiment']), 0)
                  .where(tweet_type: object['tweet_type'])
    elsif object['sentiment']
    return   Tweet.where(Tweet.checking_sentiment(object['sentiment']), 0)
    elsif object['tweet_type']
    return   Tweet.where(tweet_type: object['tweet_type'])
    elsif object['lang']
    return   Tweet.where(language: object['lang'])
    else
      return Tweet.all
    end
  end

  def self.checking_sentiment(phrase)
    if phrase == 'positive'
      return 'score > ?'
    elsif phrase == 'negative'
      return 'score < ?'
    else
      return 'score = ?'
    end
  end

end
