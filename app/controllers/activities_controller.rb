class ActivitiesController < ApplicationController
  before_action :authenticate,     only: [:create, :destroy, :edit, :update]
  before_action :authorized_user,  only: [:edit, :update, :destroy]

  def new
    @title    = "Log a Run"
    @activity = current_user.activities.build
  end

  def create
    @activity = current_user.activities.build(activity_params)
    if @activity.save
      flash[:success] = "Activity logged!"
      redirect_to root_path
    else
      @feed_items = []
      render 'new'
    end
  end

  def edit
    @title    = "Edit Activity"
    @activity = Activity.find(params[:id])
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def index
    @activities = current_user.activities
  end

  def update
    @activity = Activity.find(params[:id])
    if @activity.update(activity_params)
      flash[:success] = "Activity updated."
      redirect_back_or root_path
    else
      @title = "Edit Activity"
      render 'edit'
    end
  end

  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy

    respond_to do |format|
      format.html do
        flash[:notice] = "Activity deleted!"
        redirect_back_or root_path
      end
      format.js do
        @user_info = render_to_string(partial: 'shared/user_info', locals: { object: current_user })
      end
    end
  end

  private

    def activity_params
      params.require(:activity).permit(:activity_date, :distance, :hours, :minutes,
                                       :comment, :location, :activity_type)
    end

    def authorized_user
      @activity = current_user.activities.find_by(id: params[:id])
      redirect_to root_path if @activity.nil?
    end
end
