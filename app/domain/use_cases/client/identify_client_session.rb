class IdentifyClientSession
  def initialize(client_repository:)
    @client_repository = client_repository
  end

  def call(cpf:)
    normalized_cpf = cpf.to_s.gsub(/[^0-9]/, '')

    if normalized_cpf.empty?
      raise ArgumentError, "CPF não pode estar vazio ou inválido."
    end

    client = @client_repository.find_by_cpf(normalized_cpf)

    if client
      return client
    end

    nil
  end
end