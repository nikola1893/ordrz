class AddTruckFieldsToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :truck_number, :string
    add_column :orders, :driver_name, :string
    add_column :orders, :terms, :text
    add_column :orders, :price, :string
    add_column :orders, :due_in, :string
    add_column :orders, :company, :string
  end
end
