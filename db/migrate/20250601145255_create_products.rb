class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :category
      t.string :description
      t.string :price
      t.string :quantity
      t.timestamps

    end
  end
end
