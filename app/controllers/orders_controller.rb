# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders
  end

  def new
    @order = current_user.orders.build
    @order.stops.build
  end

  def create
    @order = current_user.orders.build(order_params)
    @order.confirmation_token = generate_token
    if @order.save
      redirect_to orders_path, notice: 'Order was successfully created.'
    else
      render :new
    end
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def edit
    @order = current_user.orders.find(params[:id])
  end

  def update
    @order = current_user.orders.find(params[:id])
    if @order.update(order_params)
      redirect_to orders_path, notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @order = current_user.orders.find(params[:id])
    @order.destroy
    redirect_to orders_path, notice: 'Order was successfully destroyed.'
  end

  private

  def generate_token
    SecureRandom.hex(10)
  end

  def order_params
    params.require(:order).permit(:confirmation_token, :email, stops_attributes: [:id, :kind, :address, :_destroy])
  end

end
