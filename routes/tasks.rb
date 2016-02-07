get '/tasks', authenticate: true do
  @tasks = User.find(session[:user_id]).tasks

  slim :'tasks/index'
end

get '/tasks/new', authenticate: true do
  slim :'tasks/new'
end

post '/tasks/new', authenticate: true do
  page = Page.find_by(url: params[:url]) || Page.create(url: params[:url])

  @task = User.find(session[:user_id]).tasks.create(
    frequency: params[:frequency],
    page: page);

  if @task.valid?
    redirect to('/tasks')
  else
    slim :'tasks/new'
  end
end
