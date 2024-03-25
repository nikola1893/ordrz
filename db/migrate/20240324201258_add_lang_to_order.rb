class AddLangToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :language, :string
  end
end
