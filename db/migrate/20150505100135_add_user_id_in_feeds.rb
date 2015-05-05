class AddUserIdInFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :user_id, :integer
    add_column :groups, :user_id, :integer
    add_column :stories, :user_id, :integer
    add_index :feeds, :user_id
    add_index :groups, :user_id
    add_index :stories, :user_id
  end
end
