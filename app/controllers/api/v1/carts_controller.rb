class Api::V1::CartsController < ActionController::API
  include ActionController::MimeResponds
  before_action :set_cart

  def create_order 
    response_create = @cart.orders.create(product_id: Product.find(cart_params[:product_id]).id, cart_id: @cart.id, quantity: cart_params[:quantity])

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
    order = @cart.orders.find_by(product_id: Product.find(cart_params[:product_id]).id)
     
    if order
      order.quantity += cart_params[:product_id]
      order.save!
    else
      return render json: {error: "Produto não existe no carrinho"}, status: :not_found	
    end

    render json: cart_list, status: :accepted
  end

  def remove_order
    order = @cart.orders.find_by(product_id: cart_params[:product_id])

    if order
      order.destroy
      render json: cart_list, status: :accepted
    else
      return render json: {error: "Produto não existe no carrinho"}, status: :not_found	
    end
  end

  def checkout
    @cart.status = 'Recebido' unless @cart.orders.blank?

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

  def set_cart
    @cart ||= Cart.find_by(id: session[:cart_id])
    @cart ||= Cart.find_by(id: cart_params[:cart_id])
    @cart ||= Cart.create(id: session[:cart_id], total_price: 0.0)
    session[:cart_id] = @cart.id

    @cart.client ||= Client.find_by(id: cart_params[:client_id]) if cart_params[:client_id]
    @cart.client ||= Client.find_by(id: session[:client_id]) if session[:client_id]
    @cart.save!
  end

  def cart_list
    {
      id: @cart.id,
      cart_total_price: @cart.total_price.to_f,
      products: products(@cart)
    }
  end

  def products(cart)  
    unless cart.orders.blank?
       cart.orders.map do |order| 
        { id: order.product&.id, 
          name: order.product&.name, 
          quantity: order.quantity, 
          unit_price: order.product&.price, 
          total_price: (order.product&.price * order.quantity).to_f
        }
      end
    else
      []
    end
  end

  def cart_params
    params.permit(:quantity, :product_id, :cart_id, :client_id)
  end
end
