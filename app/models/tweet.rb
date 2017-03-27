class Tweet < ApplicationRecord
  after_update_commit {TweetsJob.perform_later(self)}
  after_create_commit {ApitweetJob.perform_later(self)}

  def self.import(file)
    # error handling for format
    return  ['error', 'Sorry uploaded incorrect format, only CSV'] if file.content_type != "text/csv"
    # default CSV format not UTF-8 based on example
    sheet = Roo::CSV.new(file.path, csv_options: {external_encoding: 'ISO-8859-1', internal_encoding: 'UTF-8'})
    sheet.parse(clean: true)
    # error handling for column
    if !(sheet.row(1).include?("Tweet_Text") && sheet.row(1).include?("Type"))
      return  ['error', 'Sorry uploaded incorrect headers, Tweet_Text, Type, must be included']
    end
    sheet.each(tweet: 'Tweet_Text', type: 'Type') do |hash|
      if hash[:tweet] != 'Tweet_Text'
      Tweet.create!(tweet: hash[:tweet], tweet_type: hash[:type])
      end
    end
    return []
  end

  def self.danedlion(data)
    Dandelionapi.configure do |c|
      c.token   = Figaro.env.api_key
      c.endpoint = "https://api.dandelion.eu/"
    end
    # highest language on top
      sentiment = Dandelionapi::SentimentAnalysis::Request.new
      sentiment_score = sentiment.analyze(text: data.tweet)
      if !sentiment_score['error']
      data.update_attributes(score: sentiment_score['sentiment']['score'],
                              language: sentiment_score['lang']
      )
      else
        total_tweets = Tweet.all.count
        ActionCable.server.broadcast "room_lobby", {problem: sentiment_score['message'], pending: total_tweets}
      end
  end

  def self.filters(object)
    if object['sentiment'] && object['lang'] && object['tweet_type']
    return Tweet.where('score is NOT NULL')
                .where(Tweet.checking_sentiment(object['sentiment']), 0)
                .where(language: object['lang'])
                .where(tweet_type: object['tweet_type'])
    elsif object['sentiment'] && object['lang']
    return Tweet.where('score is NOT NULL')
                .where(Tweet.checking_sentiment(object['sentiment']), 0)
                .where(language: object['lang'])
    elsif object['lang'] && object['tweet_type']
    return Tweet.where('score is NOT NULL')
                .where(tweet_type: object['tweet_type'])
                .where(language: object['lang'])
    elsif object['sentiment'] && object['tweet_type']
    return Tweet.where('score is NOT NULL')
                .where(Tweet.checking_sentiment(object['sentiment']), 0)
                .where(tweet_type: object['tweet_type'])
    elsif object['sentiment']
    return Tweet.where('score is NOT NULL')
                .where(Tweet.checking_sentiment(object['sentiment']), 0)
    elsif object['tweet_type']
    return Tweet.where('score is NOT NULL')
                .where(tweet_type: object['tweet_type'])
    elsif object['lang']
    return Tweet.where('score is NOT NULL')
                .where(language: object['lang'])
    else
      return Tweet.where('score is NOT NULL')
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
