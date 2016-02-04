get '/' do
  redirect to('/tasks') if session[:user_id]

  slim :'home/index'
end
