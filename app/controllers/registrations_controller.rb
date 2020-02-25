class RegistrationsController < ApplicationController

  # rendering the signup form
  def new
    # create a new user instance
    @user = User.new
  end

  # accept the params from the form
  def create
    # [x] active record validations
    # create the user
    @user = User.new(user_params)
    if @user.save # if inputs filled and email unique
      # actually log the user in
      session[:user_id] = @user.id
      # then render user profile
      redirect_to user_path(@user)
    else # if validations fail
      # redirect back to sign up form
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :image_url, :bio)
  end


end
