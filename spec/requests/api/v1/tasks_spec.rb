require 'rails_helper'

RSpec.describe 'Api::V1::Tasks', type: :request do
  let(:user) do
    User.create(
      name: 'Alice',
      email: 'alice@test.com',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  let(:project) { user.projects.create(name: 'Project') }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET /api/v1/projects/:project_id/tasks' do
    it 'returns all tasks for the project' do
      project.tasks.create(title: 'Task 1', user: user)
      project.tasks.create(title: 'Task 2', user: user)

      get "/api/v1/projects/#{project.id}/tasks", headers: headers

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
    end
  end

  describe 'POST /api/v1/projects/:project_id/tasks' do
    context 'with valid parameters' do
      it 'creates a new task' do
        post "/api/v1/projects/#{project.id}/tasks",
          params: { task: { title: 'New Task', description: 'Test' } },
          headers: headers

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json['title']).to eq('New Task')
        expect(json['project_id']).to eq(project.id)
        expect(json['user_id']).to eq(user.id)
      end
    end

    context 'with invalid parameters' do
      it 'returns error messages' do
        post "/api/v1/projects/#{project.id}/tasks",
          params: { task: { title: '' } },
          headers: headers

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json).to have_key('errors')
      end
    end
  end

  describe 'GET /api/v1/tasks/:id' do
    let(:task) { project.tasks.create(title: 'Task', user: user) }

    it 'returns the task' do
      get "/api/v1/tasks/#{task.id}", headers: headers

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json['title']).to eq('Task')
    end
  end

  describe 'PUT /api/v1/tasks/:id' do
    let(:task) { project.tasks.create(title: 'Task', user: user) }

    it 'updates the task' do
      put "/api/v1/tasks/#{task.id}",
        params: { task: { title: 'Updated Task', completed: true } },
        headers: headers

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json['title']).to eq('Updated Task')
      expect(json['completed']).to eq(true)
    end
  end

  describe 'DELETE /api/v1/tasks/:id' do
    let!(:task) { project.tasks.create(title: 'Task', user: user) }

    it 'destroys the task' do
      expect {
        delete "/api/v1/tasks/#{task.id}", headers: headers
      }.to change(Task, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'PATCH /api/v1/tasks/:id/toggle' do
    let(:task) { project.tasks.create(title: 'Task', user: user, completed: false) }

    it 'toggles the completed status' do
      patch "/api/v1/tasks/#{task.id}/toggle", headers: headers

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json['completed']).to eq(true)

      # Toggle again
      patch "/api/v1/tasks/#{task.id}/toggle", headers: headers

      json = JSON.parse(response.body)
      expect(json['completed']).to eq(false)
    end
  end
end
