module Connectors
  class Mercadopago
    require 'curb'

    def initialize
      @token = Rails.application.credentials.mercadopago[:token]
      @user_id = Rails.application.credentials.mercadopago[:user_id]
      @external_pos_id = Rails.application.credentials.mercadopago[:external_pos_id]
      @notification_url = "https://d513fee6e427.ngrok-free.app/api/v1/payment_notification"
    end

    def generate_qr_payment(cart)
      params = {
        external_reference: cart.id.to_s,
        title: 'Product order',
        notification_url: @notification_url,
        description: 'SOAT lanches',
        total_amount: cart.total_price.to_f,
        items: cart.orders.map do |order|
          { 
            title: order.product&.name, 
            description: order&.descricao,
            quantity: order&.quantity,
            unit_measure: "unit",
            unit_price: order&.product.price,
            total_amount: (order&.product.price * order&.quantity)
          }
        end
      }
      
      
      http = Curl.post("https://api.mercadopago.com/instore/orders/qr/seller/collectors/#{@user_id}/pos/#{@external_pos_id}/qrs", params.to_json) {|http|
        http.headers["Authorization"] = "Bearer #{@token}"
        http.headers['Content-Type']='application/json'
      }

      body = JSON.parse(http.body)
      if http.code == 201
        {successful: true, status: http.code, response: body}
      else
        {successful: false, status: http.code, response: body}
      end
    end

    def get_payment(payment_id)
      http = Curl.get("https://api.mercadopago.com/v1/payments/search?sort=date_created&criteria=desc&external_reference=13&range=date_created&begin_date=NOW-1DAYS&end_date=NOW" ) {|http|
        http.headers["Authorization"] = "Bearer #{@token}"
        http.headers['Content-Type']='application/json'
      }

      body = JSON.parse(http.body)
      if http.code == 200
        payment = body["results"].find{|payment| payment["id"] == payment_id}

        if payment
          {successful: true, status: http.code, response: payment}
        else
          {successful: false, status: 404, response: "Pagamento não encontrado"}
        end
        
      else
        {successful: false, status: http.code, response: body}
      end
    end
  end 
end