get '/register' do
  redirect to('/') if session[:user_id]

  slim :'register/index'
end

post '/register' do
  @user = User.create(
    username: params[:username],
    email: params[:email],
    password: params[:password])

  if @user.valid?
    session[:user_id] = @user.id
    session[:user_name] = @user.username
    redirect to('/tasks')
  else
    slim :'register/index'
  end
end
