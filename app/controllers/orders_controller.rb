# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:view_order, :confirm]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

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
    @order.number = generate_number
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
      @order.update(status: 'confirmed')
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

  def generate_token
    SecureRandom.hex(10)
  end

  def generate_number
    "#{Time.zone.now.strftime('%d%m%Y')}-#{SecureRandom.alphanumeric(5).upcase}"
  end

  def order_params
    params.require(:order).permit(:confirmation_token, :email, stops_attributes: [:id, :kind, :address, :_destroy])
  end

end
