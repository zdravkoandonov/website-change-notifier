get '/register' do
  redirect to('/') if authenticated?

  slim :'register/index'
end

post '/register' do
  redirect to('/') if authenticated?

  @user = register(
    params[:username],
    params[:email],
    params[:password])

  if @user.valid?
    redirect to('/tasks')
  else
    slim :'register/index'
  end
end
