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
    # language = Dandelionapi::LanguageDetection::Request.new
    # language_detected = language.analyze(text: "HELLO SIR")
    # puts language_detected
    # # highest language on top
    # puts language_detected['detectedLangs'][0]
    # sentiment contains both files
    sentiment = Dandelionapi::SentimentAnalysis::Request.new
    sentiment_score = sentiment.analyze(text: "welcome to the zone")
    puts sentiment_score
    # highest language on top
    puts sentiment_score['sentiment']
    tweets = Tweet.all
    tweets.each do |tweet|
      tweet.update_attributes(score: sentiment_score['sentiment']['score'],
                              language: sentiment_score['lang']
      )
    end
  end

end
