class UsersController < ApplicationController

  def new
    @user = User.new
    @user.addresses.build
  end

  def create
    @user = User.new(whitelisted_user_params)
    sjk
    if @user.save
      flash[:success] = "Congrats! You are a member now!!"
      sign_in @user
      redirect_to products_path
    else
      flash.now[:error] = "Error! Please rey again!"
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    @user.addresses.build
  end

  def update
    @user = User.find(params[:id])
    if @user.update(whitelisted_user_params)
      flash[:success] = "Congrats! Your profile is updated!!"
      redirect_to products_path
    else
      flash.now[:error] = "Error! Please rey again!"
      render :edit
    end
  end

  def destroy
  end

  private 

  def whitelisted_user_params
    params.require(:user).permit( :email,
                                  :first_name,
                                  :last_name,
                                  :billing_id,
                                  :shipping_id,
                                  {
                                    :address => [
                                      :street_address,
                                      :city_id,
                                      :state_id,
                                      :zip_code,
                                      :id,
                                      :_destroy
                                    ]
                                  }

      )
  end
end
