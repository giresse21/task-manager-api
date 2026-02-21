require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) do
    User.create(
      name: 'Alice',
      email: 'alice@test.com',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  let(:project) { user.projects.create(name: 'Project') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      task = project.tasks.new(
        title: 'My Task',
        user: user
      )
      expect(task).to be_valid
    end

    it 'is invalid without a title' do
      task = project.tasks.new(
        title: nil,
        user: user
      )
      expect(task).to_not be_valid
      expect(task.errors[:title]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      task = project.tasks.create(title: 'Task', user: user)
      expect(task.user).to eq(user)
    end

    it 'belongs to a project' do
      task = project.tasks.create(title: 'Task', user: user)
      expect(task.project).to eq(project)
    end
  end

  describe 'default values' do
    it 'sets completed to false by default' do
      task = project.tasks.create(title: 'Task', user: user)
      expect(task.completed).to eq(false)
    end

    it 'sets priority to medium by default' do
      task = project.tasks.create(title: 'Task', user: user)
      expect(task.priority).to eq('medium')
    end
  end
end
