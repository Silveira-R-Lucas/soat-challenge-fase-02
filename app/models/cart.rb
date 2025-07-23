class Cart < ApplicationRecord 
  belongs_to :client, optional: true
  validates_numericality_of :total_price, greater_than_or_equal_to: 0
  has_many :orders
  has_many :products, through: :orders

  VALID_STATUS = %w[ Recebido Em_preparação Pronto Finalizado].freeze
  PAYMENT_STATUS = %w[ pending approved authorized in_process in_mediation rejected cancelled refunded charged_back].freeze
  IN_PROGRESS_STATUS = %w[ Pronto Em_preparação Recebido].freeze

  def set_cart_total_price
    self.total_price = self.orders.sum{|order| order.quantity * order.product.price}.to_f
    self.save!
  end

  def self.list_checked_out_orders
    Cart.where(status: VALID_STATUS).order(:updated_at)
  end

  def self.list_in_progress_orders
    list = []
    IN_PROGRESS_STATUS.each do |in_progress_status| 
      Cart.where(status: in_progress_status).order(:updated_at).each{|c| list << c}
    end

    list.map do |cart|
      {
        id: cart.id,
        status: cart.status,
        created_at: cart.created_at,
        updated_at: cart.updated_at,
        products: cart.orders.map do |order| 
          { 
            name: order.product&.name, 
            descricao: order.descricao,
            quantity: order.quantity
          }
        end
      }
    end
  end
end