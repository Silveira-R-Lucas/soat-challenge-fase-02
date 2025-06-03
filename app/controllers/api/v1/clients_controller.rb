class Api::V1::ClientsController < ApplicationController

  def create
    @client = Client.new(client_params)

    if @client.save
      render json: @client, status: :created, location: @client
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  def identify_session
    @client = Client.find_by(client_params[:cpf])

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