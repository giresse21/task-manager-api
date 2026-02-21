require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        name: 'Alice',
        email: 'alice@test.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      expect(user).to be_valid
    end

    it 'is invalid without a name' do
      user = User.new(
        email: 'alice@test.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      expect(user).to_not be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      user = User.new(
        name: 'Alice',
        password: 'password123',
        password_confirmation: 'password123'
      )
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      User.create(
        name: 'Alice',
        email: 'alice@test.com',
        password: 'password123',
        password_confirmation: 'password123'
      )

      user = User.new(
        name: 'Bob',
        email: 'alice@test.com',
        password: 'password123',
        password_confirmation: 'password123'
      )

      expect(user).to_not be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'is invalid with an invalid email format' do
      user = User.new(
        name: 'Alice',
        email: 'not-an-email',
        password: 'password123',
        password_confirmation: 'password123'
      )
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include('is invalid')
    end

    it 'is invalid without a password' do
      user = User.new(
        name: 'Alice',
        email: 'alice@test.com'
      )
      expect(user).to_not be_valid
      expect(user.errors[:password]).to be_present
    end
  end

  describe 'associations' do
    it 'has many projects' do
      user = User.create(
        name: 'Alice',
        email: 'alice@test.com',
        password: 'password123',
        password_confirmation: 'password123'
      )

      project1 = user.projects.create(name: 'Project 1')
      project2 = user.projects.create(name: 'Project 2')

      expect(user.projects.count).to eq(2)
      expect(user.projects).to include(project1, project2)
    end

    it 'has many tasks' do
      user = User.create(
        name: 'Alice',
        email: 'alice@test.com',
        password: 'password123',
        password_confirmation: 'password123'
      )

      project = user.projects.create(name: 'Project')
      task1 = user.tasks.create(title: 'Task 1', project: project)
      task2 = user.tasks.create(title: 'Task 2', project: project)

      expect(user.tasks.count).to eq(2)
      expect(user.tasks).to include(task1, task2)
    end

    it 'destroys associated projects when user is destroyed' do
      user = User.create(
        name: 'Alice',
        email: 'alice@test.com',
        password: 'password123',
        password_confirmation: 'password123'
      )

      user.projects.create(name: 'Project 1')
      user.projects.create(name: 'Project 2')

      expect { user.destroy }.to change(Project, :count).by(-2)
    end

    it 'destroys associated tasks when user is destroyed' do
      user = User.create(
        name: 'Alice',
        email: 'alice@test.com',
        password: 'password123',
        password_confirmation: 'password123'
      )

      project = user.projects.create(name: 'Project')
      user.tasks.create(title: 'Task 1', project: project)
      user.tasks.create(title: 'Task 2', project: project)

      expect { user.destroy }.to change(Task, :count).by(-2)
    end
  end

  describe 'authentication' do
    it 'authenticates with correct password' do
      user = User.create(
        name: 'Alice',
        email: 'alice@test.com',
        password: 'password123',
        password_confirmation: 'password123'
      )

      expect(user.authenticate('password123')).to eq(user)
    end

    it 'does not authenticate with wrong password' do
      user = User.create(
        name: 'Alice',
        email: 'alice@test.com',
        password: 'password123',
        password_confirmation: 'password123'
      )

      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end
end
