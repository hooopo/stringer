require "bundler"
Bundler.setup

require "rubygems"
require "net/http"
require 'active_record'
require 'delayed_job'
require 'delayed_job_active_record'

require "sinatra/activerecord/rake"

require "./app"
require_relative "./app/jobs/fetch_feed_job"
require_relative "./app/tasks/fetch_feeds"
require_relative "./app/tasks/remove_old_stories.rb"

desc "Fetch all feeds."
task :fetch_feeds do
  FetchFeeds.new(Feed.all).fetch_all
end

desc "Fetch single feed"
task :fetch_feed, :id do |t, args|
  FetchFeed.new(Feed.find(args[:id])).fetch
end

desc "Clean up old stories that are read and unstarred"
task :cleanup_old_stories, :number_of_days do |t, args|
  args.with_defaults(:number_of_days => 30)
  RemoveOldStories.remove!(args[:number_of_days].to_i)
end

desc "Start server and serve JavaScript test suite at /test"
task :test_js do
  require_relative "./spec/javascript/test_controller"
  Stringer.run!
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:speedy_tests) do |t|
    t.rspec_opts = "--tag ~speed:slow"
  end

  RSpec::Core::RakeTask.new(:spec)

  task :default => [:speedy_tests]
rescue LoadError
  # allow for bundle install --without development:test
end
