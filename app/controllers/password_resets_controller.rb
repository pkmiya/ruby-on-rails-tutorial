class PasswordResetsController < ApplicationController
  before_action :get_user,   only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render "new", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render "edit", status: :unprocessable_entity
    elsif @user.update(user_params)
      @user.forget
      reset_session
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render "edit", status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # パラメータのemailからユーザーを取得する
  # @return [User]
  def get_user
    @user = User.find_by(email: params[:email])
  end

  # 正しいユーザーかどうか確認する
  # @return [nil]
  def valid_user
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  # トークンが期限切れかどうか確認する
  # @return [nil]
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
end
