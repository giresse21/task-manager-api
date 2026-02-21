class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [ :signup, :login ]

  # POST /api/v1/signup
  def signup
    user = User.new(user_params)

    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: {
        token: token,
        user: user.as_json(except: [ :password_digest ])
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/login
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: {
        token: token,
        user: user.as_json(except: [ :password_digest ])
      }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  # GET /api/v1/me
  def me
    authorize_request
    return if performed?  # ← Arrête si authorize_request a déjà fait un render

    render json: @current_user.as_json(except: [ :password_digest ])
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
