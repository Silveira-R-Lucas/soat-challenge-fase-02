class Api::V1::ClientsController < ActionController::API
  include ActionController::MimeResponds

  def create
    @client = Client.new(client_params)

    if @client.save
      render json: @client, status: :created
    else
      render json: { error: "Algo deu errado ! verifique os dados enviados" }, status: :unprocessable_entity
    end
  end

  def identify_session
    @client = Client.find_by(cpf: client_params[:cpf])

    if @client
      session[:client_id] = @client.id
      render json: @client, status: :accepted
    else
      render json: {error: 'CPF não encontrado'}, status: :not_found
    end
  end

  def client_params
    params.permit(:name, :email, :cpf)
  end
end