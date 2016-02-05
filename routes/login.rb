get '/login' do
  redirect to('/') if authenticated?

  slim :'login/index'
end

post '/login' do
  redirect to('/') if authenticated?

  @user = login(params[:username], params[:password])

  if @user
    redirect to('/')
  else
    slim :'login/index'
  end
end
