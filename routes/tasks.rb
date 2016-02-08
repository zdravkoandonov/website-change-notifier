get '/tasks', authenticate: true do
  @tasks = User.find(session[:user_id]).tasks

  slim :'tasks/index'
end

get '/tasks/new', authenticate: true do
  slim :'tasks/new'
end

post '/tasks/new', authenticate: true do
  url = params[:url]

  if not url.start_with?('http://', 'https://')
    url.prepend('http://')
  end

  page = Page.find_by(url: url) || Page.create(url: url)

  @task = User.find(session[:user_id]).tasks.create(
    name: params[:name],
    frequency: params[:frequency],
    page: page);

  if @task.valid?
    redirect to('/tasks')
  else
    slim :'tasks/new'
  end
end

get '/tasks/update/:id' do
  download_content(params[:id])

  redirect to('/tasks')
end

get '/tasks/edit/:id' do
  @task = Task.find(params[:id])

  slim :'tasks/edit'
end

put '/tasks/edit/:id' do
  @task = Task.find(params[:id])

  @task.name = params[:name]
  @task.frequency = params[:frequency]
  @task.save

  if @task.valid?
    redirect to('/tasks')
  else
    slim :'tasks/edit'
  end
end

get '/tasks/delete/:id' do
  @task = Task.find(params[:id])

  slim :'tasks/delete'
end

delete '/tasks/delete/:id' do
  Task.find(params[:id]).destroy

  redirect to('/tasks')
end
