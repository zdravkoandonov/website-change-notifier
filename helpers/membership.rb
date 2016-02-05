module Membership
  def authenticated?
    session.has_key?(:user_id)
  end

  def authenticate
    redirect to('/login') if not authenticated?
  end

  def login(username, password)
    if not authenticated?
      user = User.find_by(username: params[:username])

      if user and user.password == params[:password]
        create_logged_in_session(user.id, user.username)
        user
      end
    end
  end

  def register(username, email, password)
    user = User.create(username: username, email: email, password: password)

    create_logged_in_session(user.id, user.username) if user.valid?

    user
  end

  def logout
    delete_logged_in_session if authenticated?
  end

  private

  def create_logged_in_session(user_id, username)
    session[:user_id] = user_id
    session[:user_name] = username
  end

  def delete_logged_in_session
    session.delete(:user_id)
    session.delete(:user_name)
  end
end
