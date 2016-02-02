get '/users/' do
  @users = User.all
  slim :'users/index'
end
