class CreateStops < ActiveRecord::Migration[7.1]
  def change
    create_table :stops do |t|
      t.references :order, null: false, foreign_key: true
      t.string :kind

      t.timestamps
    end
  end
end
