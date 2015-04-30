require_relative "../commands/feeds/import_from_opml"
require_relative "../commands/users/complete_setup"
require_relative "../repositories/user_repository"
require_relative "../repositories/story_repository"
require_relative "../tasks/fetch_feeds"

class Stringer < Sinatra::Base
  namespace "/setup" do
    before do
      if UserRepository.setup_complete?
        redirect to("/news")
      end
    end

    get "/tutorial" do
      FetchFeeds.enqueue(Feed.all)
      CompleteSetup.complete(current_user)

      @sample_stories = StoryRepository.samples
      erb :tutorial
    end
  end
end