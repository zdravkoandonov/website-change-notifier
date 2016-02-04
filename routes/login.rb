get '/login' do
  redirect to('/') if session[:user_id]

  slim :'login/index'
end

post '/login' do
  @user = User.find_by(username: params[:username])

  if @user and @user.password == params[:password]
    session[:user_id] = @user.id
    session[:user_name] = @user.username
    redirect to('/')
  else
    slim :'login/index'
  end
end
