get '/settings', authenticate: true do
  @platforms = Platform.all
  @user = User.find(session[:user_id])

  slim :'settings/index'
end

post '/settings', authenticate: true do
  @platforms = Platform.all
  @user = User.find(session[:user_id])

  @user.platform = Platform.find(params[:platform])
  @user.slack_url = params[:slack_url]
  @user.slack_bot_name = params[:slack_bot_name]
  @user.save

  slim :'settings/index'
end
