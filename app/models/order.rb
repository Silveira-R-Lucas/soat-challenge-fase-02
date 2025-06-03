class Order < ApplicationRecord
  has_many :products
  validates_numericality_of :quantity, greater_than_or_equal_to: 0

end