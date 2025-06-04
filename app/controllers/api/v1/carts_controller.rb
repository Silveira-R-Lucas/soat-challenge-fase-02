class Api::V1::CartsController < ActionController::API
  include ActionController::MimeResponds
  before_action :set_cart

  def create_order
    return render json: {error: @error[:msg]}, status: @error[:status] unless cart_parms_is_valid?
    response_create = @cart.orders.create(product_id: @product.id, cart_id: @cart.id, quantity: @quantity)

    if response_create
      render json: cart_list, status: :accepted
    else
      render json: { error: 'Algo deu errado !' }, status: :internal_server_error		
    end
  end

  def show
    render json: cart_list, status: :ok	
  end

  def update_order
    return render json: {error: @error[:msg]}, status: @error[:status] unless cart_parms_is_valid?
    order = @cart.orders.find_by(product_id: @product.id)
     
    if order
      order.quantity += @quantity
      order.save!
    else
      return render json: {error: "Produto não existe no carrinho"}, status: :not_found	
    end

    render json: cart_list, status: :accepted
  end

  def remove_order
    return render json: {error: @error[:msg]}, status: @error[:status] unless cart_parms_is_valid?(validate_quantity = false)
    order = @cart.orders.find_by(product_id: @product.id)

    if order
      order.destroy
      render json: cart_list, status: :accepted
    else
      return render json: {error: "Produto não existe no carrinho"}, status: :not_found	
    end
  end

  def checkout
    return render json: {error: @error[:msg]}, status: @error[:status] unless cart_parms_is_valid?(validate_quantity = false)
    @cart.status = 'Recebido'

    if @cart.save
      render json: {msg: "pedido enviado para cozinha!"}, status: :accepted
    else
      render json: { error: 'Algo deu errado !' }, status: :internal_server_error		
    end

    render json: cart_list, status: :ok	
  end

  def list_checked_out_orders
    response = Cart::list_checked_out_orders
    render json: response, status: :accepted
  end

  def list_in_progress_orders
    response = Cart::list_in_progress_orders
    render json: response, status: :accepted
  end

  private

  def cart_parms_is_valid?(validate_quantity = true)
    @product = Cart.find_by(id: cart_params[:product_id])
    @error = {msg: 'carrinho inexistente', status: :not_found}
    return false unless @product

    true
  end

  def set_cart
    @cart ||= Cart.find_by(id: cart_params[:cart_id])
    @cart ||= Cart.find_by(id: session[:cart_id])
    @cart ||= Cart.create(id: session[:cart_id], total_price: 0.0)
    session[:cart_id] = @cart.id

    @cart.client ||= Client.find_by(id: cart_params[:client_id]) if cart_params[:client_id]
    @cart.client ||= Client.find_by(id: session[:client_id]) if session[:client_id]
    @cart.save!
  end

  def cart_list
    {
      id: @cart.id,
      products: @cart.orders.map do |order| 
        { id: order.product.id, 
          name: order.product.name, 
          quantity: order.quantity, 
          unit_price: order.product.price, 
          total_price: (order.product.price * order.quantity).to_f
        }
      end,
      cart_total_price: @cart.total_price.to_f
    }
  end

  def cart_params
    params.permit(:quantity, :product_id, :cart_id, :client_id)
  end
end
