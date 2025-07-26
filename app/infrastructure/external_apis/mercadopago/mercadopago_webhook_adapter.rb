module MercadoPago
  class WebhookAdapter
    require 'digest'
    require 'curb'
    def initialize()
      @secret = Rails.application.credentials.mercadopago[:secret]
      @token = Rails.application.credentials.mercadopago[:token]
    end

    def parse_notification(params, headers)
      unless verify_signature(params, headers)
        Rails.logger.warn "Mercado Pago webhook signature verification failed!"
      end

      type = params["type"] || params["topic"]

      case type
      when 'payment'
        puts params
        payment_id = params["data.id"] 
      when 'merchant_order'
        Rails.logger.info "Received Mercado Pago merchant_order notification: #{params[:id]}"
        puts params
        payment_id = params["data.id"] 
      else
        Rails.logger.warn "Received unknown Mercado Pago webhook type: #{type}"
        nil
      end
    rescue JSON::ParserError => e
      Rails.logger.error "Invalid JSON in Mercado Pago webhook: #{e.message}"
      nil
    rescue StandardError => e
      Rails.logger.error "Error parsing Mercado Pago webhook: #{e.message}"
      nil
    end

    def get_payment_details(payment_id)
      http = Curl.get("https://api.mercadopago.com/v1/payments/#{payment_id}" ) {|http|
        http.headers["Authorization"] = "Bearer #{@token}"
        http.headers['Content-Type']='application/json'
      }

      body = JSON.parse(http.body).deep_symbolize_keys
      if http.code == 200
        {successful: true, status: http.code, details: body}
      else
        Rails.logger.error "Mercado Pago API (get_payment_details) error: #{http.code} - #{body[:message]}"
        { successful: false, error: body[:message], status_code: http.code }
      end
    rescue JSON::ParserError => e
      Rails.logger.error "Invalid JSON response from Mercado Pago API: #{e.message}"
      { successful: false, error: "Invalid API response JSON." }
    rescue Curl::Err::CurlError => e
      Rails.logger.error "Curl error connecting to Mercado Pago API: #{e.message}"
      { successful: false, error: "Network error connecting to payment gateway." }
    rescue StandardError => e
      Rails.logger.error "Unexpected error getting Mercado Pago payment details: #{e.message}"
      { successful: false, error: "Unexpected error from payment gateway." }
    end

    private

    def verify_signature(params, headers)
      signature = headers['HTTP_X_SIGNATURE'].split(',').second.split('=').second
      payload= "id:#{params["data"]["id"]};request-id:#{headers["HTTP_X_REQUEST_ID"]};ts:#{headers['HTTP_X_SIGNATURE'].split(',').first.split('=').second};"
      encoded_payload = OpenSSL::HMAC.hexdigest('SHA256', @secret, payload)

      if encoded_payload == signature
        true
      else
        false
      end
    end
  end
end