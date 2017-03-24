class Tweet < ApplicationRecord
  require 'roo'

  def self.import(file)
    # default CSV format not UTF-8 based on example
    sheet = Roo::CSV.new(file.path, csv_options: {external_encoding: 'ISO-8859-1', internal_encoding: 'UTF-8'})
    sheet.each(tweet: 'Tweet_Text', type: 'Type') do |hash|
    Tweet.create!(tweet: hash[:tweet], tweet_type: hash[:type])
    end
  end

end
