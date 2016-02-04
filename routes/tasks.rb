get '/tasks' do
  redirect to('/') if not session[:user_id]

  @tasks = User.find(session[:user_id]).tasks

  slim :'tasks/index'
end

get '/tasks/new' do
  slim :'tasks/new'
end

post '/tasks/new' do
  @task = User.find(session[:user_id]).tasks.create(
    url: params[:url],
    frequency: params[:frequency])

  if @task.valid?
    redirect to('/tasks')
  else
    slim :'tasks/new'
  end
end
