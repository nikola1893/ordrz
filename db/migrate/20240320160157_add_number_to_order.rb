class AddNumberToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :number, :string
  end
end
