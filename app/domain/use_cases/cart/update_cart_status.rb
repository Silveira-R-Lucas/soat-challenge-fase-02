class UpdateCartStatus
  def initialize(cart_repository:)
    @cart_repository = cart_repository
  end

  def call(cart:, new_status:)
    cart.update_status!(new_status)
    @cart_repository.save(cart)

    cart 
  rescue ArgumentError => e
    raise e 
  end
end