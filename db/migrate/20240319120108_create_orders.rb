class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :email
      t.string :confirmation_token

      t.timestamps
    end
  end
end
