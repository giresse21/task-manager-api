require 'rails_helper'

RSpec.describe 'Api::V1::Auth', type: :request do
  describe 'POST /api/v1/signup' do
    context 'with valid parameters' do
      it 'creates a new user and returns a token' do
        post '/api/v1/signup', params: {
          name: 'Alice',
          email: 'alice@test.com',
          password: 'password123',
          password_confirmation: 'password123'
        }

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json).to have_key('token')
        expect(json).to have_key('user')
        expect(json['user']['email']).to eq('alice@test.com')
        expect(json['user']['name']).to eq('Alice')
      end
    end

    context 'with invalid parameters' do
      it 'returns error messages' do
        post '/api/v1/signup', params: {
          name: 'Alice',
          email: 'invalid-email',
          password: 'password123',
          password_confirmation: 'password123'
        }

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json).to have_key('errors')
      end
    end

    context 'with mismatched password confirmation' do
      it 'returns error messages' do
        post '/api/v1/signup', params: {
          name: 'Alice',
          email: 'alice@test.com',
          password: 'password123',
          password_confirmation: 'different'
        }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /api/v1/login' do
    let!(:user) do
      User.create(
        name: 'Alice',
        email: 'alice@test.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
    end

    context 'with valid credentials' do
      it 'returns a token' do
        post '/api/v1/login', params: {
          email: 'alice@test.com',
          password: 'password123'
        }

        expect(response).to have_http_status(:success)

        json = JSON.parse(response.body)
        expect(json).to have_key('token')
        expect(json).to have_key('user')
        expect(json['user']['email']).to eq('alice@test.com')
      end
    end

    context 'with invalid email' do
      it 'returns unauthorized' do
        post '/api/v1/login', params: {
          email: 'wrong@test.com',
          password: 'password123'
        }

        expect(response).to have_http_status(:unauthorized)

        json = JSON.parse(response.body)
        expect(json).to have_key('error')
      end
    end

    context 'with invalid password' do
      it 'returns unauthorized' do
        post '/api/v1/login', params: {
          email: 'alice@test.com',
          password: 'wrongpassword'
        }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/me' do
    let(:user) do
      User.create(
        name: 'Alice',
        email: 'alice@test.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
    end

    context 'with valid token' do
      it 'returns user information' do
        token = JsonWebToken.encode(user_id: user.id)

        get '/api/v1/me', headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to have_http_status(:success)

        json = JSON.parse(response.body)
        expect(json['email']).to eq('alice@test.com')
        expect(json['name']).to eq('Alice')
      end
    end

    context 'without token' do
      it 'returns unauthorized' do
        get '/api/v1/me'

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid token' do
      it 'returns unauthorized' do
        get '/api/v1/me', headers: { 'Authorization' => 'Bearer invalid_token' }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
