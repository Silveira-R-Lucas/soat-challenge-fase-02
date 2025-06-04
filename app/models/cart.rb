class Cart < ApplicationRecord 
  belongs_to :client, optional: true
  validates_numericality_of :total_price, greater_than_or_equal_to: 0
  has_many :orders
  has_many :products, through: :orders

  VALID_STATUS = %w[ Recebido Em_preparação Pronto Finalizado].freeze
  IN_PROGRESS_STATUS = %w[ Recebido Em_preparação Pronto].freeze

  def set_cart_total_price
    self.total_price = self.orders.sum{|order| order.quantity * order.product.price}.to_f
    self.save!
  end

  def self.list_checked_out_orders
    Cart.where(status: VALID_STATUS).order(:updated_at)
  end

  def self.list_in_progress_orders
    Cart.where(status: IN_PROGRESS_STATUS).order(:updated_at)
  end
end