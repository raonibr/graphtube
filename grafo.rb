=begin
---------------------
Modelo de grafo

Para criar um grafo, passe como parametro um vetor de pessoas:

grafo_novo = Grafo.new(lista_de_pessoas)

---------------------
=end

class Grafo

  def initialize(pessoa)
    @pessoas = pessoa
    @vertices = []
    @arestas = []
    self.desativar_todos()

  end

=begin
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Funcao que gera o grafo de acordo com os parametros pedidos:

Formato de chamada: gerar_grafo_PL(classe,escopo)

- classe: 
  Passe 1 para locais de Moradia
  Passe 2 para locais de Trabalho
  Passe 3 para locais de Estudo
  Passe 4 para locais de Lazer
  
- escopo: 
  Passe 1 para relacionar por Cidade
  Passe 2 para relacionar por Bairro
  Passe 3 para relacionar por Endereço
  Passe 4 para relacionar por Empresa/Escola/Local_lazer/Número
  
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
=end


  def gerar_grafo_PL(classe,escopo)
    
    #Coloca pessoas na lista de Vertices, sem repetições:
    @pessoas.each do |pessoa|
      if (pessoa.ativo() != 0)
        if !(@vertices.include?(["ID",pessoa.interview_id()]))
          @vertices << ["ID",pessoa.interview_id()]
        end
      end
    end

    #Coloca locais do escopo na lista de Vertices, sem repetições:
    @pessoas.each do |unidade|
      if (unidade.ativo() != 0)
        unidade.locais_classe(classe).each do |lugar|
          if @vertices.empty? 
              if lugar[(escopo - 1)]
                @vertices << lugar[(escopo - 1)].upcase()
              end
          else
            if lugar[(escopo - 1)]
              if ((not(@vertices.include?(lugar[(escopo - 1)].upcase())))and(lugar[(escopo - 1)].upcase()!=''))
                @vertices << lugar[(escopo - 1)].upcase()
              end
            end
          end
        end
      end  
    end
    
    #Agora ele insere as Arestas nos Locais Devidos
    @pessoas.each do |pessoa|
      if (pessoa.ativo() != 0)
        pessoa.locais_classe(classe).each do |local|
          if local[(escopo - 1)]
            if (local[(escopo - 1)].upcase()!='')
              if !(@arestas.include?([pessoa.interview_id(),local[(escopo - 1)].upcase()]))
                @arestas << [pessoa.interview_id(),local[(escopo - 1)].upcase()]
              end
            end
          end
        end
      end
    end
  end

#função para escolher os casos
  def ativa_caso()
    @pessoas.each do |pessoa|	
      id = pessoa.interview_id()
      if (id[0] == 49) #ASCI para "1", que significa que é um caso 
        pessoa.set_ativo(1)
      end 
    end
  end

#função para escolher os controles
  def ativa_controle()
    @pessoas.each do |pessoa|
      id = pessoa.interview_id()
      if (id[0] == 50 )#ASCI para "2", que significa que é um controle 
        pessoa.set_ativo(1)
      end 
    end
  end

#função para desativar todas as pessoas
  def desativar_todos()
    @pessoas.each do |pessoa|
     pessoa.set_ativo(0) 
    end
  end

# Retorna todos os vertices do grafo
  def vertices()
    return @vertices
  end

# Retorna todas as arestas do grafo
  def arestas()
    return @arestas
  end
  
# Limpa o Grafo, retirando suas arestas e vertices (Mas não as pessoas)
  def clear_grafo()
    @vertices = []
    @arestas = []
  end
 
# Retorna lista de pessoas em formato legível para exibição em um buffer
  def retorna_legivel_pessoas()
	string = ""
	if (@vertices)
		@vertices.each do |vertice|
			if (vertice[0]=="ID")
			string = string + vertice[1] + "\n"
			end
		end
	end
	return string
  end

# Retorna lista de lugares em formato legível para exibição em um buffer
  def retorna_legivel_lugares()
	string = ""
	if (@vertices)
		@vertices.each do |vertice|
			if (vertice[0]=="ID")
			#string = string + vertice[1] + "\n"
			else
			string = string + vertice + "\n"
			end
		end
	end
	return string
  end

# Retorna lista de arestas em formato legível para exibição em um buffer
  def retorna_legivel_arestas()
	string = ""
	if (@arestas)
		@arestas.each do |aresta|
			string = string + aresta[0] + "->" +aresta[1] + "\n"
		end
	end
	return string
  end


# Cria um arquivo contendo o grafo descrito em formato .net para ser aberto no pajek
  def imprime_pajek(nome_arquivo)
    arquivo = File.new(nome_arquivo, "w+")
    i = 1
    #Imprime os vertices no arquivo:
    listav = []
    arquivo.write("*Vertices #{@vertices.length()}\n")
    @vertices.each do |vertice|
      if (vertice[0]=="ID")
	listav << [i,vertice[1],"ID"]
	else
	listav << [i,vertice,"LOC"]
	end
	i=i+1
    end
    listav.each do |vertice|
      if (vertice[2]=="ID")
        arquivo.write("#{vertice[0]} \"#{vertice[1]}\" ic Red      bc Red \n")
      else
        arquivo.write("#{vertice[0]} \"#{vertice[1]}\" ic Blue     bc Blue \n")
      end
    end
    
    #Imprime as arestas no arquivo:
    lista = []
    j=0
    k=0
    @arestas.each do |aresta|
      listav.each do |vertice|
	if (aresta[0] == vertice[1])
	  j=vertice[0]
	else
	  if (aresta[1] == vertice[1])
	    k=vertice[0]
	  end
	end
      end
      lista << [j,k]
    end
    arquivo.write("*Arcs\n")
    lista.each do |listao|
      arquivo.write("#{listao[0]} #{listao[1]}\n")
    end
    arquivo.close
	return arquivo
  end

end
