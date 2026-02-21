require 'rails_helper'

RSpec.describe 'Api::V1::Projects', type: :request do
  let(:user) do
    User.create(
      name: 'Alice',
      email: 'alice@test.com',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET /api/v1/projects' do
    it 'returns all user projects' do
      user.projects.create(name: 'Project 1')
      user.projects.create(name: 'Project 2')

      get '/api/v1/projects', headers: headers

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
    end

    it 'requires authentication' do
      get '/api/v1/projects'

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /api/v1/projects' do
    context 'with valid parameters' do
      it 'creates a new project' do
        post '/api/v1/projects',
          params: { project: { name: 'New Project', description: 'Test' } },
          headers: headers

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json['name']).to eq('New Project')
        expect(json['description']).to eq('Test')
      end
    end

    context 'with invalid parameters' do
      it 'returns error messages' do
        post '/api/v1/projects',
          params: { project: { name: '' } },
          headers: headers

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json).to have_key('errors')
      end
    end

    it 'requires authentication' do
      post '/api/v1/projects', params: { project: { name: 'Project' } }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /api/v1/projects/:id' do
    let(:project) { user.projects.create(name: 'Project') }

    it 'returns the project' do
      get "/api/v1/projects/#{project.id}", headers: headers

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json['name']).to eq('Project')
    end

    it 'returns 404 for non-existent project' do
      get '/api/v1/projects/99999', headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT /api/v1/projects/:id' do
    let(:project) { user.projects.create(name: 'Project') }

    it 'updates the project' do
      put "/api/v1/projects/#{project.id}",
        params: { project: { name: 'Updated Project' } },
        headers: headers

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json['name']).to eq('Updated Project')
    end
  end

  describe 'DELETE /api/v1/projects/:id' do
    let!(:project) { user.projects.create(name: 'Project') }

    it 'destroys the project' do
      expect {
        delete "/api/v1/projects/#{project.id}", headers: headers
      }.to change(Project, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
