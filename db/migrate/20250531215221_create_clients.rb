class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.string :cpf
      t.timestamps
    end

    add_index :clients, :cpf, unique: true
  end
end
