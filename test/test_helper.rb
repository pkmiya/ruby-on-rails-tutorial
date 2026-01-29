ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # テストユーザーがログインしていればtrue、その他ならfalseを返す
    # @return [Boolean]
    def is_logged_in?
      !session[:user_id].nil?
    end

    # テストユーザーとしてログインする
    # @param [User] user
    # @return [nil]
    def log_in_as(user)
      session[:user_id] = user.id
    end

    # Add more helper methods to be used by all tests here...
    include ApplicationHelper
  end
end

class ActionDispatch::IntegrationTest
  # テストユーザーとしてログインする
  # @param [User] user
  # @return [nil]
  def log_in_as(user, password: "password", remember_me: "1")
    post login_path, params: { session: { email: user.email, password: password, remember_me: remember_me } }
  end
end
