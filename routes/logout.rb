get '/logout/' do
  if session[:user_id]
    session.delete(:user_id)
    session.delete(:user_name)
  end

  redirect to('/')
end
