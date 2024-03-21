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
    if user.present?
      if order.user == user
        if order.status == "pending"
          false
        else
          true
        end
      else
        true
      end
    else
      true
    end
  end

end
