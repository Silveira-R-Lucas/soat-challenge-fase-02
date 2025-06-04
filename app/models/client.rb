class Client < ApplicationRecord
  has_many :carts
  validates_presence_of :name, :email, :cpf 
end
