=begin
---------------------
Modelo de pessoa

Ao criar uma pessoa, passar parametros:
nova_pessoa = Pessoa.new(interview_id, cidade_entrevista, bairro_entrevista, endereco_entrevista, locais_moradia, locais_trabalho, locais_estudo, locais_lazer)

---------------------
=end

# ESTRUTURA DOS VETORES DE LOCAIS:
#	LOCAIS MORADIA = ["CIDADE","BAIRRO","ENDERECO","NUMERO", "DATA_INICIAL","DATA_FINAL", "LATITUDE", "LONGITUDE"]
#	LOCAIS TRABALHO = ["CIDADE","BAIRRO","ENDERECO","EMPRESA", "DATA_INICIAL","DATA_FINAL", "LATITUDE", "LONGITUDE"]
#	LOCAIS ESTUDO = ["CIDADE","BAIRRO","ENDERECO","NOME_ESCOLA", "DATA_INICIAL","DATA_FINAL", "LATITUDE", "LONGITUDE"]
#	LOCAIS LAZER = ["CIDADE","BAIRRO","ENDERECO","LOCAL", "LATITUDE", "LONGITUDE"]


class Pessoa
sinal = 0
  def initialize(interview_id, cidade_entrevista, bairro_entrevista, endereco_entrevista, locais_moradia, locais_trabalho, locais_estudo, locais_lazer, ativo)
  
    @interview_id = interview_id
    @cidade_entrevista = cidade_entrevista 
    @bairro_entrevista = bairro_entrevista
    @endereco_entrevista = endereco_entrevista
    @locais_moradia = locais_moradia
    @locais_trabalho = locais_trabalho
    @locais_estudo = locais_estudo
    @locais_lazer = locais_lazer
    @ativo = ativo
  end

  def interview_id()
    return @interview_id
  end

  def idade()
    return @idade
  end
  
  def cidade_nascimento()
	return @cidade_nascimento
  end
  
  def bairro_nascimento()
	return @bairro_nascimento
  end
  
  def endereco_nascimento()
	return @endereco_nascimento
  end
  
  def locais_moradia()
	return @locais_moradia
  end

  def locais_trabalho()
	return @locais_trabalho
  end
  
  def locais_estudo()
	return @locais_estudo
  end
  
  def locais_lazer()
	return @locais_lazer
end

  def locais_classe(classe)
    locais = [@locais_moradia, @locais_trabalho, @locais_estudo, @locais_lazer]
    return locais[classe.to_i() - 1]
  end

  def ativo()
	return @ativo
  end

# INATIVO = 0 E ATIVO = 1
  def set_ativo(ativo)
    @ativo = ativo
  end

end
