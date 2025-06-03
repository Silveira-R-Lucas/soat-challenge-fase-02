class Client < ApplicationRecord
  before_create validates_presence_of :name, :email, :cpf 
end
