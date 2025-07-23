class Api::V1::MpWebhookController < ActionController::API
  require 'digest'
  include ActionController::MimeResponds

  def payment_notification 
    signature = request.env['HTTP_X_SIGNATURE'].split(',').second.split('=').second
    secret = Rails.application.credentials.mercadopago[:secret]
    payload= "id:#{params["data"]["id"]};request-id:#{request.env["HTTP_X_REQUEST_ID"]};ts:#{request.env['HTTP_X_SIGNATURE'].split(',').first.split('=').second};"
    encoded_payload = OpenSSL::HMAC.hexdigest('SHA256', secret, payload)

    if encoded_payload == signature
      payment = Connectors::Mercadopago.new.get_payment(params[:data][:id].to_i)
      if payment[:successful]
        cart = Cart.find_by(id: payment[:response]["external_reference"])
        if cart
          @cart.payment_status = payment[:response]["status"]
          @cart.save!
          render json: { "successful": true, "status": 200, error: 'Pagamento atualizado!' }, status: :ok
        else
          render json: { "successful": false, "status": 404, error: 'Falha ao atualizar carrinho, carrinho não encontrado.' }, status: :not_found
        end
      else
        render json: { "successful": false, "status": 404, error: 'Falha ao atualizar carrinho, pagamento não encontrado.' }, status: :not_found
      end
    else
      render json: { "successful": false, "status": 401, error: 'Falha na validação da hash.' }, status: :unauthorized	
    end
  end

  def webhook_params
    params.permit(:action, :api_version, :data, :date_created, :id, :live_mode, :type, :user_id, :mp_webhook, :data)
  end
end