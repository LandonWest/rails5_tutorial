module SessionsHelper
  # logs in the current user
  def log_in(user)
    session[:user_id] = user.id
  end

  # returns the currently logged in user (if any)
  def current_user
    @curent_user ||= User.find_by(id: session[:user_id])
  end

  # returns true if the current user is logged in
  def logged_in?
    !current_user.nil?
  end
end
