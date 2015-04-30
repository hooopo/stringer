class Stringer < Sinatra::Base
  get "/login" do
    erb :"sessions/new"
  end

  get "/logout" do
    flash[:success] = t('sessions.destroy.flash.logged_out_successfully')
    session[:user_id] = nil

    redirect to("/")
  end
end