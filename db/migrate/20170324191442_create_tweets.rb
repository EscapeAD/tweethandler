class CreateTweets < ActiveRecord::Migration[5.0]
  def change
    create_table :tweets do |t|
      t.text :tweet
      t.string :language
      t.string :type
      t.float :score

      t.timestamps
    end
  end
end
