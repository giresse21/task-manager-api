class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header

    if header
      decoded = JsonWebToken.decode(header)
      @current_user = User.find(decoded[:user_id]) if decoded
    end
  rescue ActiveRecord::RecordNotFound
    @current_user = nil
  end

  def authorize_request
    render json: { error: "Not Authorized" }, status: :unauthorized unless @current_user
  end
end
