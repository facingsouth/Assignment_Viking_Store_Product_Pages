class AddressesController < ApplicationController

  def index
    @addresses = Address.all
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(white_listed_address_params)
    if @address.save
      flash[:success] = "New address created."
      redirect_to addresses_path
    else
      flash.now[:error] = @address.errors.full_messages.first
      render :new
    end
  end

  def show
    @address = Address.find(params[:id])
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(white_listed_address_params)
      flash[:success] = "Address successfully modified."
      redirect_to addresses_path
    else
      flash.now[:error] = @address.errors.full_messages.first
      render :edit
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    @address = Address.find(params[:id])
    if @address.destroy
      flash[:success] = "address successfully deleted."
      redirect_to addresses_path
    else
      flash[:error] = @address.errors.full_messages.first
      redirect_to session.delete(:return_to)
    end
  end

  private

  def white_listed_address_params
    params.require(:address).permit(:street_address, 
                                    :secondary_address, 
                                    :zipcode, 
                                    :city_id, 
                                    :state_id, 
                                    :user_id)
  end
end
