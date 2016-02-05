get '/tasks' do
  authenticate

  @tasks = User.find(session[:user_id]).tasks

  slim :'tasks/index'
end

get '/tasks/new' do
  authenticate

  slim :'tasks/new'
end

post '/tasks/new' do
  authenticate

  @task = User.find(session[:user_id]).tasks.create(
    url: params[:url],
    frequency: params[:frequency])

  if @task.valid?
    redirect to('/tasks')
  else
    slim :'tasks/new'
  end
end
