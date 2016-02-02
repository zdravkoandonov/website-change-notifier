get '/register/' do
  slim :'register/index'
end

post '/register/' do
  user = User.create(username: params[:username], password: params[:password], email: params[:email])
  if user.valid?
    session[:user_id] = user.id
    session[:user_name] = user.username
    redirect to('/users/')
  else
    redirect to('/register/')
  end
end
