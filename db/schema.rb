# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150628070727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "feeds", force: true do |t|
    t.string   "name"
    t.text     "url"
    t.datetime "last_fetched"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
    t.integer  "group_id"
    t.integer  "user_id"
  end

  add_index "feeds", ["url"], name: "index_feeds_on_url", using: :btree
  add_index "feeds", ["user_id", "url"], name: "index_feeds_on_user_id_and_url", unique: true, using: :btree

  create_table "groups", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "groups", ["user_id"], name: "index_groups_on_user_id", using: :btree

  create_table "stories", force: true do |t|
    t.text     "title"
    t.text     "permalink"
    t.text     "body"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published"
    t.boolean  "is_read"
    t.boolean  "keep_unread", default: false
    t.boolean  "is_starred",  default: false
    t.text     "entry_id"
    t.integer  "user_id"
  end

  add_index "stories", ["entry_id", "feed_id"], name: "index_stories_on_entry_id_and_feed_id", unique: true, using: :btree
  add_index "stories", ["user_id"], name: "index_stories_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "setup_complete"
    t.string   "api_key"
    t.string   "access_token"
    t.string   "username"
  end

  add_index "users", ["access_token"], name: "index_users_on_access_token", using: :btree

end
