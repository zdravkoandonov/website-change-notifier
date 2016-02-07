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
