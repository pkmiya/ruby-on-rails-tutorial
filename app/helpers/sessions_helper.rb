module SessionsHelper
  # 渡されたユーザーでログインする
  # @param [User] user
  # @return [void]
  def log_in(user)
    session[:user_id] = user.id
  end

  # ログアウトする
  # @return [void]
  def log_out
    reset_session
    @current_user = nil
  end

  # 現在のユーザーを返す
  # @return [User]
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  # @return [Boolean]
  def logged_in?
    !current_user.nil?
  end
end
