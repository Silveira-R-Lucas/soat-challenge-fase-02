class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.belongs_to :product, null: false, foreign_key: true
      t.belongs_to :cart, null: false, foreign_key: true
      t.integer :quantity, :integer, default: 1
      t.string :descricao
      t.timestamps
    end
  end
end
