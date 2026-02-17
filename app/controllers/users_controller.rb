class UsersController < ApplicationController
  before_action :authenticate,     only: [:index, :edit, :update, :destroy, :show, :statistics]
  before_action :correct_user,     only: [:edit, :update]
  before_action :admin_user,       only: [:destroy]
  before_action :redirect_if_signed_in, only: [:signup, :create]
  before_action :same_user_type,   only: [:show]

  def signup
    @user = User.new
    @title = "Sign Up"
  end

  def statistics
    @user  = current_user
    @title = "Statistics"
    stats  = Statistics.new(@user)

    month_opts = Utilities::UI.get_month_options

    @mileage_breakdown_year = stats.get_pie_chart("mileage", "year", month_opts)

    @average_mph = {}
    @average_mph[:year_run]     = stats.average_mph("year", "run")
    @average_mph[:year_walk]    = stats.average_mph("year", "walk")
    @average_mph[:year_overall] = stats.average_mph("year", "overall")
    @average_mph[:week_run]     = stats.average_mph("week", "run")
    @average_mph[:week_walk]    = stats.average_mph("week", "walk")
    @average_mph[:week_overall] = stats.average_mph("week", "overall")

    @speed_line_chart = stats.get_speed_line_chart(colors: month_opts[:colors])
    @wdaybreakdown    = stats.get_weekday_breakdown_bar_chart("year", colors: month_opts[:colors])
  end

  def index
    @title = "All Users"
    if current_user.admin?
      @users = User.paginate(page: params[:page])
    elsif current_user.user_type.nil?
      @users = [current_user]
    else
      viewable_types = current_user.user_type.split('|') + ["1|2", "2|1"]
      @users = User.where("user_type IN (?) OR admin = ?", viewable_types, true)
                   .paginate(page: params[:page])
    end
  end

  def show
    @user       = User.find(params[:id])
    @activities = @user.activities.paginate(page: params[:page], per_page: 10)
    @title      = @user.fname
    @stats      = Statistics.new(@user)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user, "no"
      flash[:success] = "Welcome! Now you're ready to run 500 miles!"
      redirect_to @user
    else
      @title = "Sign Up"
      @user.password = ""
      @user.password_confirmation = ""
      @user.secret_word = ""
      render 'signup'
    end
  end

  def edit
    @title = "Edit User"
  end

  def update
    @user = User.find(params[:id])
    if !params[:user].nil? && @user.update(user_params)
      flash[:success] = "Profile updated."
      current_user.admin? ? redirect_to(users_path) : redirect_to(@user)
    elsif current_user.admin?
      if params[:user_type].present? && @user.update(user_type: params[:user_type])
        flash[:success] = "User type updated."
        redirect_to users_path
      elsif params[:admin].present?
        if current_user?(@user)
          flash[:error] = "You may not alter your own admin privileges!"
          redirect_to users_path
        elsif @user.update(admin: !@user.admin?)
          flash[:success] = "User permissions updated."
          redirect_to users_path
        else
          flash[:error] = "Couldn't update permissions"
          redirect_to users_path
        end
      else
        flash[:error] = "Error updating user"
        @title = "Edit User"
        @user.password = ""
        @user.password_confirmation = ""
        render 'edit'
      end
    else
      @title = "Edit User"
      @user.password = ""
      @user.password_confirmation = ""
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      flash[:error] = "You may not destroy yourself"
    else
      @user.destroy
      flash[:success] = "User destroyed"
    end
    redirect_to users_path
  end

  private

    def user_params
      permitted = [:fname, :lname, :email,
                   :password, :password_confirmation, :secret_word]
      permitted << :user_type if current_user&.admin?
      params.require(:user).permit(*permitted)
    end

    def redirect_if_signed_in
      redirect_to(root_path) if signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) || current_user.admin?
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def same_user_type
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user&.can_view_user?(@user)
    end
end
