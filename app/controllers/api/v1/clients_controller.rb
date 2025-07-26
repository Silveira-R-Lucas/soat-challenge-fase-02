class Api::V1::ClientsController < ActionController::API
  include ActionController::MimeResponds

  def create
    create_client_service = CreateClient.new(
      client_repository: ActiveRecordClientRepository.new
    )

    begin
      created_client = create_client_service.call(client_params)

      render json: { "successful": true, "status": 201, response: created_client}, status: :created
    rescue ArgumentError => e 
      render json: { "successful": false, "status": 422, error: e.message }, status: :unprocessable_entity
    rescue ActiveRecord::RecordInvalid => e 
      render json: { "successful": false, "status": 422, errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { "successful": false, "status": 500, errors: "Um erro inesperado aconteceu: #{e.message}" }, status: :internal_server_error
    end
  end

  def identify_session
    identify_client_session_use_case = IdentifyClientSession.new(
      client_repository: ActiveRecordClientRepository.new
    )

    begin
      client = identify_client_session_use_case.call(cpf: client_params[:cpf])

      if client
        session[:client_id] = client.id
        render json: { "successful": true, "status": 200, message: 'Sessão identificada', client: client }, status: :ok
      else
        render json: { "successful": false, "status": 404, error: 'CPF não encontrado' }, status: :not_found
      end
    rescue ArgumentError => e 
      render json: { errors: e.message }, status: :bad_request
    rescue StandardError => e 
      render json: { "successful": false, "status": 500, errors: "Um erro inesperado ocorreu: #{e.message}" }, status: :internal_server_error
    end
  end

  def client_params
    params.permit(:name, :email, :cpf)
  end
end