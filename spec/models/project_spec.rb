require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) do
    User.create(
      name: 'Alice',
      email: 'alice@test.com',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      project = user.projects.new(name: 'My Project')
      expect(project).to be_valid
    end

    it 'is invalid without a name' do
      project = user.projects.new(name: nil)
      expect(project).to_not be_valid
      expect(project.errors[:name]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      project = user.projects.create(name: 'Project')
      expect(project.user).to eq(user)
    end

    it 'has many tasks' do
      project = user.projects.create(name: 'Project')
      task1 = project.tasks.create(title: 'Task 1', user: user)
      task2 = project.tasks.create(title: 'Task 2', user: user)

      expect(project.tasks.count).to eq(2)
      expect(project.tasks).to include(task1, task2)
    end

    it 'destroys associated tasks when project is destroyed' do
      project = user.projects.create(name: 'Project')
      project.tasks.create(title: 'Task 1', user: user)
      project.tasks.create(title: 'Task 2', user: user)

      expect { project.destroy }.to change(Task, :count).by(-2)
    end
  end
end
