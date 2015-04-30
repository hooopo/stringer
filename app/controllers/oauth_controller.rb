class Stringer < Sinatra::Base
  get "/oauth/connect" do
    session[:code] = Pocket.get_code(:redirect_uri => CALLBACK_URL)
    new_url = Pocket.authorize_url(:code => session[:code], :redirect_uri => CALLBACK_URL)
    redirect new_url
  end

  get "/oauth/callback" do
    result = Pocket.get_result(session[:code], :redirect_uri => CALLBACK_URL)
    access_token = result['access_token']
    username = result['username']
    if user = UserRepository.fetch_or_create_by_access_token(access_token, username)
      session[:user_id] = user.id
    end
    redirect "/"
  end
end