class UniqueFeedWithUserIdScope < ActiveRecord::Migration
  def change
    remove_index :feeds, :url
  end
end
