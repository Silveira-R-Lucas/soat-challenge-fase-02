class Order < ApplicationRecord
  belongs_to :product
  belongs_to :cart
  validates_numericality_of :quantity, greater_than_or_equal_to: 0
  after_save :set_cart_total_price

  def set_cart_total_price
    self.cart::set_cart_total_price
  end
end