class CreateClient
  def initialize(client_repository:)
    @client_repository = client_repository
  end

  def call(params)
    client = Client.new(params)

    unless client.valid?
      raise ArgumentError, "Atributos inválidos."
    end

    if @client_repository.find_by_email(client.email)
      raise ArgumentError, "Cliente já cadastrado com este email."
    end

    @client_repository.save(client) 
    client 
  end
end