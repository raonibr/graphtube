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
    
    #Hash que guarda as informa��es moleculares das pessoas para facilitar a consulta depois.
    @hash_molecular = Hash[]
    
    @pessoas.each do |unidade|
      if (@hash_molecular[unidade.interview_id()] == nil)
        @hash_molecular[unidade.interview_id()] = [unidade.cluster()]
      end
    end
    
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

  def trata_data(lugar)
    td=[]
    if (lugar != nil)
      lugar.split('/').each{ |d|
          td << d.to_i}
      return td.last() #Pega o ultimo campo da data. Espera-se que seja o ano
    end
  end

#Retorna True caso a data inicial e final tenham periodo em comum com as datas estabelecidas. 
#Retorna True  se n�o houver data estabelecida.
  def verifica_data(datai_det, dataf_det, datai, dataf)
    if ((datai_det == nil) and (dataf_det == nil))
      return true
    else
      #Vamos tratar as datas dos locais que tenham nil.
      # Se houver nil no inicio, vamos considerar, que a pessoa sempre esteve naquele lugar at� o periodo final.
      # Se houver nil no final, vamos considerar, que a pessoa esteve naquele lugar do periodo inial at� hoje.
      # Se houverem dois nil, vamos considerar que o periodo n�o pode ser definido, logo, retorna false.
      if ((datai== nil)and(dataf == nil))
        return false
      else
        if (datai== nil)
          datai = 0;
        end
        if (dataf== nil)
          dataf = 9999;
        end
      end
      #
      if (dataf_det == nil)
        if (datai >= datai_det.to_i) or (dataf >= datai_det.to_i)
          return true
        else
          return false
        end
      else
        if (datai_det == nil)
          if (dataf <= dataf_det.to_i) or (datai <= dataf_det.to_i)
            return true
          else
            return false
          end
        else
          if ((dataf < datai_det.to_i) or (datai > dataf_det.to_i))
            return false
          else
            return true
          end
        end
      end
    end
  end
  
  
  # Essa fun��o refina o grafo que se tem adiconando os locais e arestas correspendentes aos parametros passados.
  def gerar_grafo_PL(classe,escopo,data_inicial,data_final)

    #Coloca locais do escopo na lista de Vertices, sem repetições:
    @pessoas.each do |unidade|
      if (unidade.ativo() != 0)
        unidade.locais_classe(classe).each do |lugar|
          datainicial = trata_data(lugar[4])
          datafinal = trata_data(lugar[5])
          if @vertices.empty?
            if verifica_data(data_inicial, data_final, datainicial, datafinal)
              if lugar[(escopo - 1)]
                @vertices << lugar[(escopo - 1)].upcase()
              end
            end
          else
            if verifica_data(data_inicial, data_final, datainicial, datafinal)
              if lugar[(escopo - 1)]
                if ((not(@vertices.include?(lugar[(escopo - 1)].upcase())))and(lugar[(escopo - 1)].upcase()!=''))
                 @vertices << lugar[(escopo - 1)].upcase()
                end
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
          datai = trata_data(local[4])
          dataf = trata_data(local[5])
          if verifica_data(data_inicial, data_final, datai, dataf)
            if local[(escopo - 1)]
              if (local[(escopo - 1)].upcase()!=' ')
                if !(@arestas.include?([pessoa.interview_id(),local[(escopo - 1)].upcase()]))
                  @arestas << [pessoa.interview_id(),local[(escopo - 1)].upcase()]
                end
              end
            end
          end
        end
      end
    end
  end
  
  
# Fun��o que coloca pessoas na lista de pessoas
  def coloca_pessoas_todas()
    @pessoas.each do |pessoa|
      if (pessoa.ativo() != 0)
        if !(@vertices.include?(["ID",pessoa.interview_id()]))
          @vertices << ["ID",pessoa.interview_id()]
        end
      end
    end
  end
  
  def coloca_pessoas_ativas()
    @arestas.each do |pessoa|
      if !(@vertices.include?(["ID",pessoa[0]]))
        @vertices << ["ID",pessoa[0]]
      end
    end
  end
  
#função para escolher os casos
  def desativa_controle()
    @pessoas.each do |pessoa|	
      id = pessoa.interview_id()
      if (id[0] == 50) #ASCI para "1", que significa que é um caso 
        pessoa.set_ativo(0)
      end 
    end
  end

#função para escolher os controles
  def desativa_caso()
    @pessoas.each do |pessoa|
      id = pessoa.interview_id()
      if (id[0] == 49 )#ASCI para "2", que significa que é um controle 
        pessoa.set_ativo(0)
      end 
    end
  end
  
  #função para escolher as pessoas do sexo masculino
  def desativa_feminino()
    @pessoas.each do |pessoa|	
      if (pessoa.sexo == "2")
        pessoa.set_ativo(0)
      end 
    end
  end

  #função para escolher as pessoas do sexo feminino
  def desativa_masculino()
    @pessoas.each do |pessoa|
      if (pessoa.sexo == "1")
        pessoa.set_ativo(0)
      end 
    end
  end
  
  def desativa_hcontato_sim()
    @pessoas.each do |pessoa|
      if ((pessoa.hcontato == "1") or (pessoa.hcontato == "7") or (pessoa.hcontato == "8"))
        pessoa.set_ativo(0)
      end 
    end
  end
  
  def desativa_hcontato_nao()
    @pessoas.each do |pessoa|
      if ((pessoa.hcontato == "2") or (pessoa.hcontato == "7") or (pessoa.hcontato == "8"))
        pessoa.set_ativo(0)
      end 
    end
  end


  def desativa_reativacao_sim()
    @pessoas.each do |pessoa|
      if ((pessoa.reativacao == "1") or (pessoa.reativacao == "9"))
        pessoa.set_ativo(0)
      end 
    end
  end
  
  def desativa_reativacao_nao()
    @pessoas.each do |pessoa|
      if ((pessoa.reativacao == "2") or (pessoa.reativacao == "9"))
        pessoa.set_ativo(0)
      end 
    end
  end


#função para ativar todas as pessoas
  def ativar_todos()
    @pessoas.each do |pessoa|
     pessoa.set_ativo(1) 
    end
  end
  
  #função para desativar todas as pessoas
  def desativar_todos()
    @pessoas.each do |pessoa|
     pessoa.set_ativo(0) 
    end
  end
  
  #função para desativar todas as pessoas que n�o fazem parte de algum cluster;
  def desativar_cluster(qual)
    if (qual == "TODOS OS CLUSTERS")
      @pessoas.each do |pessoa|
        if !(pessoa.cluster())
          pessoa.set_ativo(0) 
        end
      end
    else
      @pessoas.each do |pessoa|
        if (pessoa.cluster() != qual)
          pessoa.set_ativo(0) 
        end
      end
    end
  end
  
  def desativar_pessoas_idade(min,max)
    @pessoas.each do |pessoa|
      if ((pessoa.idade.to_i() < min.to_i()) or (pessoa.idade.to_i() > max.to_i()))
        pessoa.set_ativo(0)
      end 
    end
  end
  
  def desativar_pessoas_renda(min,max)
    @pessoas.each do |pessoa|
      if ((pessoa.renda.to_i() < min.to_i()) or (pessoa.renda.to_i() > max.to_i()))
        pessoa.set_ativo(0)
      end 
    end
  end
  
  def desativar_pessoas_escolaridade(min,max)
    @pessoas.each do |pessoa|
      if ((pessoa.tempo_estudo.to_i() < min.to_i()) or (pessoa.tempo_estudo.to_i() > max.to_i()))
        pessoa.set_ativo(0)
      end 
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
  
# Retorna todas as arestas do grafo
  def pessoas()
    return @pessoas
  end

#Retorna o hash auxiliar molecular
  def hash_molecular()
    return @hash_molecular
  end
  
# Limpa o Grafo, retirando suas arestas e vertices (Mas não as pessoas)
  def clear_grafo()
    @vertices = []
    @arestas = []
  end
 
# Retorna lista de pessoas em formato legível para exibição em um buffer
  def retorna_legivel_pessoas()
  cont = 0
	if (@vertices)
    @vertices.each do |vertice|
			if (vertice[0]=="ID")
        cont = cont +1
      end
		end
    string = "Total:   "
    string << cont.to_s()
    string << " Pessoas\n\n"
		@vertices.each do |vertice|
			if (vertice[0]=="ID")
			  string << vertice[1] 
        string << "\n"
			end
		end
	end
	return string
  end

# Retorna lista de lugares em formato legível para exibição em um buffer
  def retorna_legivel_lugares()
  cont = 0
	if (@vertices)
      @vertices.each do |vertice|
			if (vertice[0]=="ID")
			#string = string + vertice[1] + "\n"
			else
			 cont = cont +1
			end
		end
    string = "Total:   "
    string << cont.to_s()
    string << " Lugares\n\n"
		@vertices.each do |vertice|
			if (vertice[0]=="ID")
			#string = string + vertice[1] + "\n"
			else
			  string << vertice
        string << "\n"
			end
		end
	end
	return string
  end

# Retorna lista de arestas em formato legível para exibição em um buffer
  def retorna_legivel_arestas()
	string = "Total:   "
  string << @arestas.length().to_s()
  string << " Arestas\n\n"
	if (@arestas)
		@arestas.each do |aresta|
			string << aresta[0]
      string << "->"
      string << aresta[1]
      string << "\n"
		end
	end
	return string
  end


# Cria um arquivo contendo o grafo descrito em formato .net para ser aberto no pajek
# PRECISA SER REFATORADO USANDO HASH DE VERTICES
  def imprime_pajek(nome_arquivo, *args)
    arquivo = File.new(nome_arquivo, "w+")
    
    if (args.length != 0 )
      param_tipo = args[0]
    end
    
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
        if (vertice[1][0] == 50)
          if !(param_tipo)
            arquivo.write("#{vertice[0]} \"#{vertice[1]}\" ic Yellow      bc Yellow \n")
          else
            if(@hash_molecular[vertice[1]])
              arquivo.write("#{vertice[0]} \"#{@hash_molecular[vertice[1]]}(#{vertice[1]})\" ic Yellow      bc Yellow \n")
            else
              arquivo.write("#{vertice[0]} \"(#{vertice[1]})\" ic Yellow      bc Yellow \n")
            end
          end
        else  
          if !(param_tipo)
            arquivo.write("#{vertice[0]} \"#{vertice[1]}\" ic Red      bc Red \n")
          else
            if(@hash_molecular[vertice[1]])
              arquivo.write("#{vertice[0]} \"#{@hash_molecular[vertice[1]]}(#{vertice[1]})\" ic Red      bc Red \n")
            else
              arquivo.write("#{vertice[0]} \"(#{vertice[1]})\" ic Red      bc Red \n")
            end
          end
        end
      else
        if !(param_tipo)
          arquivo.write("#{vertice[0]} \"#{vertice[1]}\" ic Blue     bc Blue \n")
        else
          arquivo.write("#{vertice[0]} \"(#{vertice[1]})\" ic Blue     bc Blue \n")
        end
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

# A fun��o imprime a matriz de adjacencias para o conjunto de vertices exisentes de forma indiscriminada
  def imprime_matriz_adjacencias(nome_arquivo)
    arquivo = File.new(nome_arquivo, "w+")
  
    i = @vertices.length()
    
    # Isso cria uma matriz de n por n onde n � o n�mero de v�rtices.
    @matriz_adj = Array.new(i)
    @matriz_adj.map! { Array.new(i,0) }

    
    # Esse hash auxiliara mentendo uma lista de todos os elementos e suas respectivas posi��es na matriz de adjacencias
    @hash_aux_matriz = Hash[]
    cont = 0
    @vertices.each do |vertice|
      if (vertice.is_a?(String))
       @hash_aux_matriz[vertice] = cont
      elsif (vertice[0]=="ID")
	      @hash_aux_matriz[vertice[1]] = cont
      else
        @hash_aux_matriz[vertice[0]] = cont
      end
      cont=cont+1
    end
    
    #Agora cada aresta vai representar um par de 1�s na matrzi de adjacencias
    @arestas.each do |aresta|
      a = @hash_aux_matriz[aresta[0]]
      b = @hash_aux_matriz[aresta[1]]
      @matriz_adj[a][b] = 1
      @matriz_adj[b][a] = 1
    end
    
    for q in 0 .. (i-1)
      for w in 0 .. (i-1)
        arquivo.write("#{@matriz_adj[q][w]}")
      end
      arquivo.write("\n")
    end  
    arquivo.write(i)
    arquivo.write("\n")
    arquivo.write(i)
    #Isso imprime a matriz inteira no arquivo
    #@matriz_adj.each do |linha|
     # linha.each do |casa|
    #    arquivo.write("#{casa}")
     # end
     # arquivo.write("\n")
   # end
    
    
    arquivo.close
	  return arquivo
  end


# Cria um arquivo contendo o grafo descrito em formato .net com matriz de adjacencia bipartida para ser usado no framework de Alex Santana
  def imprime_pajek_com_matriz_bipartiti(nome_arquivo, *args)
    arquivo = File.new(nome_arquivo, "w+")
    nome_arquivo_conf = nome_arquivo.chomp(".net")
    nome_arquivo_conf = nome_arquivo_conf << ".conf"
    arquivo_conf = File.new(nome_arquivo_conf, "w+")
    
    i = 1
    agents = 0
    #Imprime os vertices no arquivo:
    listav_P = []
    listav_L = []
    arquivo.write("*Vertices #{@vertices.length()}")
    @vertices.each do |vertice|
      if (vertice[0]=="ID")
	     listav_P << [i,vertice[1],"ID"]
       agents = agents + 1
       i=i+1
	    end
    end
    
    @vertices.each do |vertice|
      if (vertice[0]!="ID")
	     listav_L << [i,vertice,"LOC"]
        i=i+1
	    end
    end
    
    arquivo.write(" #{agents}\n")
    listav_P.each do |vertice|
        arquivo.write("#{vertice[0]}\n")
    end
    
    listav_L.each do |vertice|
  
        arquivo.write("#{vertice[0]}\n")
    end
    
    arquivo.write("*Matrix\n")
    
    altura = listav_P.length()
    largura = listav_L.length()
        
    # Isso cria uma matriz de n por n onde n � o n�mero de v�rtices.
    @matriz_adj = Array.new(altura)
    @matriz_adj.map! { Array.new(largura,0) }

    
    
    
    # Esseshashs auxiliara mentendo uma lista de todos os elementos e suas respectivas posi��es na matriz de adjacencias
    @hash_aux_matriz_pessoas = Hash[]
    @hash_aux_matriz_lugares = Hash[]
    cont_P = 0
    cont_L = 0
    @vertices.each do |vertice|
      if (vertice.is_a?(String))
       @hash_aux_matriz_lugares[vertice] = cont_L
       cont_L=cont_L+1
      elsif (vertice[0]=="ID")
	      @hash_aux_matriz_pessoas[vertice[1]] = cont_P
        cont_P=cont_P+1
      else
        @hash_aux_matriz_pessoas[vertice[0]] = cont_P
        cont_P=cont_P+1
      end
    end
    
    
    
    #Agora cada aresta vai representar um  1 na matriz de adjacencias
    @arestas.each do |aresta|
      a = @hash_aux_matriz_pessoas[aresta[0]]
      b = @hash_aux_matriz_lugares[aresta[1]]
      @matriz_adj[a][b] = 1
    end
    
    for q in 0 .. (altura-1)
      for w in 0 .. (largura-1)
        arquivo.write("#{@matriz_adj[q][w]}")
        if(w != largura-1)
          arquivo.write(" ")
        end
      end
      arquivo.write("\n")
    end  
    
    
    arquivo_conf.write("#{listav_P.length()} 0 #{listav_L.length()} 0\n")
    flag = 0
    for q in 0 .. (altura-1)
    flag = 0
    arquivo_conf.write("#{q+1} 0 ")
      for w in 0 .. (largura-1)
        if((flag != 1)and(@matriz_adj[q][w]==1))
          arquivo_conf.write("#{w+1}\n")
          flag = 1;
        end
      end
      if (flag==0)
        arquivo_conf.write("0\n")
      end
    end  
    
    
  arquivo.close
  arquivo_conf.close
	return arquivo
  end

end
