class SessionsController < ApplicationController
  def new
    @title = "Sign In"
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign In"
      render 'new'
    else
      sign_in(user, params[:persist].nil? ? "no" : params[:persist])
      redirect_back_or root_path
      #redirect_back_or user
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
