class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy start cancel finish ]
  before_action :authenticate_user!

  # GET /tasks or /tasks.json
  def index
    @q = Task.ransack(params[:q])
    @tasks = @q.result(distinct: true).order(deadline: :asc).includes(:responsible, :author)
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new(responsible: current_user)
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.author = current_user

    if @task.save
      redirect_to task_url(@task), notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to task_url(@task), notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy!

    redirect_to tasks_url, notice: "Task was successfully destroyed."
  end

  # PATCH/PUT /tasks/1/start
  def start
    @task.start!
    redirect_to task_url(@task), notice: "Task has been started."
  end

  # PATCH/PUT /tasks/1/cancel
  def cancel
    @task.cancel!
    redirect_to task_url(@task), notice: "Task has been cancelled."
  end

  # PATCH/PUT /tasks/1/finish
  def finish
    @task.finish!
    redirect_to task_url(@task), notice: "Task has been finished."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:name, :description, :deadline, :responsible_id)
    end
end
