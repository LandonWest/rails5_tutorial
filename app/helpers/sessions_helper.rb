module SessionsHelper
  # logs in the current user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # returns the user corresponding to the remember token cookie.
  def current_user
    # this "=" is not a comparison. read: “If session of user id exists (while setting user id to session of user id)…”
    if (user_id = session[:user_id])
      @curent_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])   # dito
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # returns true if the current user is logged in
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # logs in the current user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
