class AddAddressToStopAndConfirmationEmailToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :stops, :address, :string
    add_column :orders, :confirmation_email, :string
  end
end
