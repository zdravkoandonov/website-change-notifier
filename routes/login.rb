get '/login/' do
  slim :'login/index'
end

post '/login/' do
  user = User.find_by(username: params[:username], password: params[:password])
  if user
    session[:user_id] = user.id
    session[:user_name] = user.username
    redirect to('/')
  else
    redirect to('/login/')
  end
end
