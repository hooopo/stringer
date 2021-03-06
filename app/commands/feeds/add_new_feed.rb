require_relative "../../models/feed"
require_relative "../../utils/feed_discovery"

class AddNewFeed
  ONE_DAY = 24 * 60 * 60

  def self.add(url, user_id, discoverer = FeedDiscovery.new, repo = Feed)
    result = discoverer.discover(url)
    return false unless result

    repo.create(name: result.title,
                url: result.feed_url,
                last_fetched: Time.now - ONE_DAY,
                :user_id => user_id)
  end
end