class UsersController < ApplicationController

  before_action :require_sign_in, only: [:edit, :update, :destroy]

  def new
    @user = User.new
    @user.addresses.build
    @user.addresses.build
  end

  def create
    @user = User.new(whitelisted_user_params)
    if @user.save
      flash[:success] = "Congrats! You are a member now!!"
      sign_in @user
      redirect_to products_path
    else
      flash.now[:error] = "Error! Please try again!"
      render :new
    end
  end

  def edit
    @user = current_user
    @user.addresses.build
  end

  def update
    @user = current_user
    if @user.update(whitelisted_user_params)
      flash[:success] = "Congrats! Your profile is updated!!"
      redirect_to products_path
    else
      flash.now[:error] = "Error! Please try again!"
      render :edit
    end
  end

  def destroy
    @user = current_user
    if @user.destroy
      flash[:success] = "So sad! You account is deleted!"
      sign_out
      redirect_to root_path
    else
      flash.now[:error] = "Congrats! Your account is indestructible!"
      render :edit
    end
  end

  private

  def require_sign_in
    unless signed_in_user?
      flash[:notice] = "Please sign in first!"
      redirect_to new_session_path
    end
  end

  def whitelisted_user_params
    params.require(:user).permit( :email,
                                  :first_name,
                                  :last_name,
                                  :billing_id,
                                  :shipping_id,
                                  :addresses_attributes => [
                                    :street_address,
                                    :city_id,
                                    :state_id,
                                    :zip_code,
                                    :id,
                                    :_destroy
                                  ]

      )
  end
end
