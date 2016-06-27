module TokenAuth
  extend ActiveSupport::Concern

  include ActionController::HttpAuthentication::Token::ControllerMethods

  def authenticate_with_token!
    account = @current_account || Account.find_by_hashid(params[:id] || params[:account_id])

    authenticate_or_request_with_http_token do |token, options|
      @current_user = account.users.find_by auth_token: token if account
    end
  end

  def authenticate_with_token?
    account = @current_account || Account.find_by_hashid(params[:id] || params[:account_id])

    authenticate_with_http_token do |token, options|
      @current_user = account.users.find_by auth_token: token if account
    end
  end

  protected

  def request_http_token_authentication(realm = "Application", message = nil)
    render_unauthorized({
      detail: "must be a valid token",
      source: {
        pointer: "/data/attributes/authToken"
      }
    })
  end
end
