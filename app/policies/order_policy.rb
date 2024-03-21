class OrderPolicy
  attr_reader :user, :order

  def initialize(user, order)
    @user = user
    @order = order
  end

  def edit?
    order.status == "pending"
  end

  def update?
    order.status == "pending"
  end

  def destroy?
    order.status == "pending"
  end

  def view_order?
    order.status == "confirmed"
  end
end
