# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:view_order, :confirm]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    @orders = current_user.orders.reverse
  end

  def new
    @order = current_user.orders.build
    @order.stops.build
  end

  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      redirect_to orders_path, notice: 'Order was successfully created.'
    else
      render :new
    end
  end

  def view_order
    require "rqrcode"
    qrcode = RQRCode::QRCode.new(request.original_url)
    @svg = qrcode.as_svg(
      color: :black,
      offset: 8,
      fill: :white,
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true
    )

    @order = Order.find_by(confirmation_token: params[:confirmation_token])
    authorize @order, :view_order?
    if @order.nil?
      flash[:alert] = 'Invalid confirmation token.'
      redirect_to root_path
    end
  end

  def edit
    @order = current_user.orders.find(params[:id])
    authorize @order
  end

  def update
    @order = current_user.orders.find(params[:id])
    authorize @order
    if @order.update(order_params)
      redirect_to orders_path, notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @order = current_user.orders.find(params[:id])
    authorize @order
    @order.destroy
    redirect_to orders_path, notice: 'Order was successfully destroyed.'
  end

  def confirm
    @order = Order.find_by(confirmation_token: params[:confirmation_token])

    if @order.status == 'pending'
    # Update the order status to confirmed (you might have a different implementation for this)
      @order.update(status: 'confirmed', truck_number: params[:truck_number], driver_name: params[:driver_name])
      flash[:alert] = 'Order has been confirmed.'

    else
      flash[:alert] = 'Order has already been confirmed.'
    end

    # You can add a flash message here if needed
    redirect_to view_order_path(confirmation_token: @order.confirmation_token)

    # redirect_to view_order_path(confirmation_token: @order.confirmation_token)
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def order_params
    params.require(:order).permit(:confirmation_token, :truck_number, :driver_name, :email, stops_attributes: [:id, :kind, :address, :_destroy])
  end

end
