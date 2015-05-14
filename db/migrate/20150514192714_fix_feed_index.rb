class FixFeedIndex < ActiveRecord::Migration
  def change
    remove_index :feeds, :user_id
    add_index :feeds, :url
  end
end
