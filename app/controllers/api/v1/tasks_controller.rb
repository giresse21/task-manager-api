class Api::V1::TasksController < ApplicationController
  before_action :authorize_request
  before_action :set_project, only: [ :index, :create ]
  before_action :set_task, only: [ :show, :update, :destroy, :toggle ]

  # GET /api/v1/projects/:project_id/tasks
  def index
    tasks = @project.tasks
    render json: tasks
  end

  # POST /api/v1/projects/:project_id/tasks
  def create
    task = @project.tasks.new(task_params)
    task.user = @current_user

    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/tasks/:id
  def show
    render json: @task
  end

  # PUT /api/v1/tasks/:id
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/tasks/:id
  def destroy
    @task.destroy
    head :no_content
  end

  # PATCH /api/v1/tasks/:id/toggle
  def toggle
    @task.update(completed: !@task.completed)
    render json: @task
  end

  private

  def set_project
    @project = @current_user.projects.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found" }, status: :not_found
  end

  def set_task
    @task = @current_user.tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task not found" }, status: :not_found
  end

  def task_params
    params.require(:task).permit(:title, :description, :completed, :priority, :due_date)
  end
end
