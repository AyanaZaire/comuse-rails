class SessionsController < ApplicationController

  # rendering the login form
  def new
    # create a new user instance
    @user = User.new
  end

  # accept the params from the form
  def create
    # find the user by email
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      # actually log the user in
      session[:user_id] = @user.id
      # then render user profile
      redirect_to user_path(@user)
    else # if not authenticated
      # redirect back to login form
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path
  end

end
