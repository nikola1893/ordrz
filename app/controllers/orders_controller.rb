class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  def index
    @orders = current_user.orders
  end
end
