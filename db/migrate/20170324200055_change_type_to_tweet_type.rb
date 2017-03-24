class ChangeTypeToTweetType < ActiveRecord::Migration[5.0]
  def change
    rename_column :tweets, :type, :tweet_type
  end
end
