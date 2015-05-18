class AddToPocket
  attr_reader :user, :story, :client

  def initialize(story, user)
    @user, @story = user, story
    @client = Pocket.client(:access_token => user.access_token)
  end

  def self.add(user, story)
    self.new(user, story).add
  end

  def add
    client.add :url => story.url, :title => story.title, :tags => "feed2pocket"
  end
end