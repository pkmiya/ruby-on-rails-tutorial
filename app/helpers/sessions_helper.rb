module SessionsHelper
  # 渡されたユーザーでログインする
  # @param [User] user
  # @return [nil]
  def log_in(user)
    session[:user_id] = user.id
    # NOTE: セッションハイジャック防止のためにセッショントークンを保存
    session[:session_token] = user.session_token
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  # @param [User] user
  # @return [nil]
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 永続的セッションを破棄する
  # @return [nil]
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # ログアウトする
  # @return [nil]
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end

  # @return [User]
  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      if user && user.session_token == session[:session_token]
        @current_user = user
      end
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  # @return [Boolean]
  def logged_in?
    !current_user.nil?
  end
end
