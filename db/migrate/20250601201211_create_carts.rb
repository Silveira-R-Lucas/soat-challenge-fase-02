class CreateCarts < ActiveRecord::Migration[7.2]
  def change
    create_table :carts do |t|
      t.decimal :total_price, precision: 17, scale: 2
      t.belongs_to :client, foreign_key: true
      t.string :status
      t.timestamps
    end
  end
end
