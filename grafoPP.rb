=begin
---------------------
Modelo de grafo pessoa pessoa

Para criar um grafo, passe como parametro um grafo pessoa local predefinido

Grafo = GrafoPP.new(grafoPL_Base)


Apesar de GrafoPP herdar Grafo, nem todas as função de grafo funcionarão corretamente em GrafoPP, retornando NIL.
As função que funcionam são: 

  - GrafoPP.vertices()
  - GrafoPP.arestas()
  - GrafoPP.clear_grafo()
  - GrafoPP.retorna_legivel_pessoas()
  - GrafoPP.retorna_legivel_arestas()
  - GrafoPP.imprime_pajek(nome_arquivo)
  
O resto vai apenas retornar Nil...

---------------------
=end

class GrafoPP < Grafo

  def initialize(grafo_base)
    @vertices = []
    @arestas = []
    
    @pessoas = grafo_base.pessoas()
    
    # Arestas_aux será um hash que guardará os grupos de pessoas que frequentam o mesmo lugar
    # Cada bó do hash representa um lugar e é um vetor de pessoas.. (A chave do hash é o nome do local)
    @arestas_aux = Hash[]
    grafo_base.vertices().each do |pessoa|
      if(pessoa[0]=="ID")
        @vertices << pessoa
      end
    end
    
    grafo_base.arestas().each do |aresta|
      if (@arestas_aux[aresta[1]] == nil)
        @arestas_aux[aresta[1]] = []
        @arestas_aux[aresta[1]] << aresta[0]
      else
        @arestas_aux[aresta[1]] << aresta[0]
      end
    end
    
    @arestas_aux.each do |grupo|
      self.cria_clique(grupo[1])
    end
    
  end
  
  def cria_clique(grupo)
    for i in 0 .. (grupo.length()-1)
      for j in i .. (grupo.length()-1)
        if (i != j)
          @arestas << [grupo[i],grupo[j]]
        end
      end
    end
  end
  
  
  def calcula_distancia(lat1,long1,lat2,long2)
    pi = 3.1415926
    r = 6371
    dLat = (lat2 - lat1)
    dLat = (dLat * pi)/180
    dLon = (long2 - long1)
    dLon = (dLon * pi)/180
    a = Math.sin(dLat/2)*Math.sin(dLat/2) +
          Math.cos((lat1*pi)/180)*Math.cos((lat2*pi)/180)*
          Math.sin(dLon/2)*Math.sin(dLon/2)
    
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    d = r*c
    return d*1000
  end
  
  
  # Essa função calcula a distância minima entre duas pessoas, levando em conta todas as localidades que cada pessoa morou ou estudou ou teve lazer ou trabalho.
  def distancia_minima(pessoa1,pessoa2)
    
    dist = 100000000.0
    
    for q in 0 .. (pessoa1.length()-1)
      for w in 0 .. (pessoa2.length()-1)
        dist_temp = calcula_distancia(pessoa1[q][0],pessoa1[q][1],pessoa2[w][0],pessoa2[w][1])
        if (dist_temp < dist)
          dist = dist_temp
        end
      end
    end  
    
   return dist
  end
  
  
  
  # A função imprime a matriz de distancias mínimas para o conjunto de vertices exisentes de forma indiscriminada
  def imprime_matriz_distancias_minimas(nome_arquivo)
    arquivo = File.new(nome_arquivo, "w+")
    i = @vertices.length()
    
    # Isso cria uma matriz de n por n onde n é o número de vértices.
    @matriz_dist = Array.new(i)
    @matriz_dist.map! { Array.new(i,0) }

    
    # Esse hash auxiliara mentendo uma lista de todos os elementos e suas respectivas posições na matriz de distancias
    @hash_aux_matriz = Hash[]
    cont = 0
    @vertices.each do |vertice|
      @hash_aux_matriz[vertice[1]] = cont
      cont=cont+1
    end
    
    # O hash auxiliar de pessoas guarda a lista de coordenadas dos locais que cada pessoa frequentou em sua vida...
    @hash_aux_pessoas = Hash[]
    @pessoas.each do |pessoa|
      @hash_aux_pessoas[pessoa.interview_id()] = []
      pessoa.locais_moradia().each do |local_moradia|
        if (local_moradia[6])
          @hash_aux_pessoas[pessoa.interview_id()] << [local_moradia[6].to_f(),local_moradia[7].to_f()]
        end
      end
      pessoa.locais_trabalho().each do |local_trabalho|
        if (local_trabalho[6])
          @hash_aux_pessoas[pessoa.interview_id()] << [local_trabalho[6].to_f(),local_trabalho[7].to_f()]
        end
      end
      pessoa.locais_estudo().each do |local_estudo|
        if (local_estudo[6])
          @hash_aux_pessoas[pessoa.interview_id()] << [local_estudo[6].to_f(),local_estudo[7].to_f()]
        end
      end
      pessoa.locais_lazer().each do |local_lazer|
        if (local_lazer[4])
          @hash_aux_pessoas[pessoa.interview_id()] << [local_lazer[4].to_f(),local_lazer[5].to_f()]
        end
      end
    end
    
    
    #Aqui acontece o calculo de distância mínima entre duas pessoas
    for q in 0 .. (@vertices.length()-1)
      for w in q+1 .. (@vertices.length()-1)
        
        if ((@hash_aux_pessoas[@vertices[q][1]].length() !=0) and (@hash_aux_pessoas[@vertices[w][1]].length() !=0))
          dist = distancia_minima(@hash_aux_pessoas[@vertices[q][1]],@hash_aux_pessoas[@vertices[w][1]])
        else
          dist = 0 # Essa linha define o valor da distancia se a pessoa não possuir georeferencia
        end
        a = @hash_aux_matriz[@vertices[q][1]]
        b = @hash_aux_matriz[@vertices[w][1]]
      
        @matriz_dist[a][b] = dist
        @matriz_dist[b][a] = dist
        
      end
    end  
    
    
    
    
    #Isso imprime a matriz inteira no arquivo.
    for q in 0 .. (i-1)
      for w in 0 .. (i-1)
        arquivo.write("#{@matriz_dist[q][w]}")
        if (w < (i-1))
         arquivo.write(" ")
        end
      end
      arquivo.write("\n")
    end  
    
    arquivo.write(i)
    arquivo.write("\n")
    arquivo.write(i)
    
    arquivo.close
	  return arquivo
  end

end