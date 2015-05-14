class User < ActiveRecord::Base
  has_many :feeds
  has_many :groups
  has_many :stories

  def setup_complete?
    setup_complete
  end
end
