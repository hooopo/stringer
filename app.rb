
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
Bundler.require(:default, ENV['RACK_ENV'] || "development")

require "sinatra/base"
require "sinatra/activerecord"
require "sinatra/flash"
require "sinatra/contrib/all"
require "sinatra/assetpack"
require "rack/ssl"
require "json"
require "i18n"
require "will_paginate"
require "will_paginate/active_record"
require "pocket-ruby"
require 'securerandom'

require_relative "app/helpers/authentication_helpers"
require_relative "app/repositories/user_repository"

Dotenv.load

I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'config/locales', '*.yml').to_s]
I18n.config.enforce_available_locales=false

Pocket.configure do |config|
  config.consumer_key = ENV["pocket_consumer_key"]
end

CALLBACK_URL = "http://localhost:2222/oauth/callback"

class Stringer < Sinatra::Base
  # need to exclude assets for sinatra assetpack, see https://github.com/swanson/stringer/issues/112
  use Rack::SSL, exclude: ->(env) { env['PATH_INFO'] =~ /^\/(js|css|img)/ } if ENV["ENFORCE_SSL"] == 'true'

  register Sinatra::ActiveRecordExtension
  register Sinatra::Flash
  register Sinatra::Contrib
  register Sinatra::AssetPack

  configure do
    set :database_file, "config/database.yml"
    set :views, "app/views"
    set :public_dir, "app/public"
    set :root, File.dirname(__FILE__)

    enable :sessions
    set :session_secret, ENV["SECRET_TOKEN"] || "secret!"
    enable :logging
    enable :method_override

    ActiveRecord::Base.include_root_in_json = false
  end

  helpers do
    include Sinatra::AuthenticationHelpers

    def render_partial(name, locals = {})
      erb "partials/_#{name}".to_sym, layout: false, locals: locals
    end

    def render_js_template(name)
      erb "js/templates/_#{name}.js".to_sym, layout: false
    end

    def render_js(name, locals = {})
      erb "js/#{name}.js".to_sym, layout: false, locals: locals
    end

    def t(*args)
      I18n.t(*args)
    end
  end

  assets {
    serve "/js",     from: "app/public/js"
    serve "/css",    from: "app/public/css"
    serve "/images", from: "app/public/img"

    js :application, "/js/application.js", [
      "/js/jquery-min.js",
      "/js/bootstrap-min.js",
      "/js/bootstrap.file-input.js",
      "/js/mousetrap-min.js",
      "/js/jquery-visible-min.js",
      "/js/underscore-min.js",
      "/js/backbone-min.js",
      "/js/app.js"
    ]

    css :application, "/css/application.css", [
      "/css/bootstrap-min.css",
      "/css/flat-ui-no-icons.css",
      "/css/font-awesome-min.css",
      "/css/styles.css"
    ]

    js_compression  :jsmin
    css_compression :simple

    prebuild true unless ENV['RACK_ENV'] == 'test'
  }

  before do
    I18n.locale = ENV["LOCALE"].blank? ? :en : ENV["LOCALE"].to_sym

    if !is_authenticated? && needs_authentication?(request.path)
      redirect '/login'
    end
  end

  get "/" do
    if current_user
      redirect to("/news")
    else
      redirect to("/login")
    end
  end
end

require_relative "app/controllers/stories_controller"
require_relative "app/controllers/first_run_controller"
require_relative "app/controllers/sessions_controller"
require_relative "app/controllers/feeds_controller"
require_relative "app/controllers/debug_controller"
require_relative "app/controllers/oauth_controller"
