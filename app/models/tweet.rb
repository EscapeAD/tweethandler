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
    element = Dandelionapi::LanguageDetection::Request.new
    response = element.analyze(text: "HELLO SIRS")
    puts response.detectedLangs
    tweets = Tweet.all
    tweets.each do |tweet|

    end
  end

end
