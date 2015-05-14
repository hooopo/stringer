class AddUniqueIndexOnFeedUrlAndUserId < ActiveRecord::Migration
  def change
    add_index :feeds, [:user_id, :url], :unique => true
  end
end
