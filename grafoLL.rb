=begin
---------------------
Modelo de grafo local local

Para criar um grafo, passe como parametro um grafo pessoa-local predefinido

Grafo = GrafoLL.new(grafoPL_Base)


Apesar de GrafoLL herdar Grafo, nem todas as função de grafo funcionarão corretamente em GrafoLL, retornando NIL.
As função que funcionam são: 

  - GrafoLL.vertices()
  - GrafoLL.arestas()
  - GrafoLL.clear_grafo()
  - GrafoLL.retorna_legivel_pessoas()
  - GrafoLL.retorna_legivel_arestas()
  - GrafoLL.imprime_pajek(nome_arquivo)
  
O resto vai apenas retornar Nil...

---------------------
=end

class GrafoLL < Grafo

  def initialize(grafo_base)
    @vertices = []
    @arestas = []
    @arestas_pesos = Hash[]
    # Arestas_aux será um hash que guardará os grupos de pessoas que frequentam o mesmo lugar
    # Cada nó do hash representa um lugar e é um vetor de pessoas.. (A chave do hash é o nome do local) 
    # O valor do tamanho de cada lista representará o tamanho do vertice
    @arestas_aux = Hash[]
    
    # Arestas_aux_cont será um hash que guardará os grupos de lugares frequentados pela mesma pessoa
    @arestas_aux_cont = Hash[]
    
    
    
    # Cria os grupos de pessoas que frequentam os locais
    grafo_base.arestas().each do |aresta|
      if (@arestas_aux[aresta[1]] == nil)
        @arestas_aux[aresta[1]] = []
        @arestas_aux[aresta[1]] << aresta[0]
      else
        @arestas_aux[aresta[1]] << aresta[0]
      end
    end
    
    @arestas_aux.each do |grupo|
      self.coloca_peso(grupo)
    end
    
    # Cria os grupos de locais frequentados por determinada pessoa
    grafo_base.arestas().each do |aresta|
      if (@arestas_aux_cont[aresta[0]] == nil)
        @arestas_aux_cont[aresta[0]] = []
        @arestas_aux_cont[aresta[0]] << aresta[1]
      else
        @arestas_aux_cont[aresta[0]] << aresta[1]
      end
    end
    
    @arestas_aux_cont.each do |grupo_locais|
      self.cria_clique_arestas(grupo_locais[1])
    end
    
  end
  
  
  # Retorna lista de lugares em formato legÃ­vel para exibiÃ§Ã£o em um buffer
  def retorna_legivel_lugares()
	string = ""
	if (@vertices)
		@vertices.each do |vertice|
			if (vertice[0]=="ID")
			#string = string + vertice[1] + "\n"
			else
			string = string + vertice[0] + "    Peso:  " + vertice[1].to_s() + "\n"
			end
		end
	end
	return string
  end
  
  
  def cria_clique_arestas(grupo)
    for i in 0 .. (grupo.length()-1)
      for j in i .. (grupo.length()-1)
        if (i != j)
         if (!@arestas.include?([grupo[i],grupo[j]]) and  !@arestas.include?([grupo[j],grupo[i]]) )
          @arestas << [grupo[i],grupo[j]]
          @arestas_pesos[grupo[i]+grupo[j]] = 1
         else
           if @arestas_pesos[grupo[i]+grupo[j]]
             @arestas_pesos[grupo[i]+grupo[j]] = @arestas_pesos[grupo[i]+grupo[j]]+1
           else
             @arestas_pesos[grupo[j]+grupo[i]] = @arestas_pesos[grupo[j]+grupo[i]]+1
           end
         end
        end
      end
    end
  end

  def coloca_peso(grupo)
    @vertices << [grupo[0],grupo[1].length()]
  end

 def imprime_pajek(nome_arquivo)
    arquivo = File.new(nome_arquivo, "w+")
    i = 1
    #Imprime os vertices no arquivo:
    listav = []
    arquivo.write("*Vertices #{@vertices.length()}\n")
    @vertices.each do |vertice|
       listav << [i,vertice[0],vertice[1],"LOC"]
      i=i+1
    end
    listav.each do |lugar|
      peso = (((lugar[2])*0.2)+1).to_s()
      arquivo.write("#{lugar[0]} \"#{lugar[1]} (#{lugar[2]})\" x_fact #{peso} y_fact #{peso} ic Blue     bc Blue \n")
    end
    
    #Imprime as arestas no arquivo:
    lista = []
    j=0
    k=0
    @arestas.each do |aresta|
      y = @arestas_pesos[aresta[0]+aresta[1]]
      listav.each do |vertice|
	     if (aresta[0] == vertice[1])
	       j=vertice[0]
	     else
	      if (aresta[1] == vertice[1])
	        k=vertice[0]
        end
       end
      end
      lista << [j,k,y]
    end
     arquivo.write("*Arcs\n")
     lista.each do |listao|
       arquivo.write("#{listao[0]} #{listao[1]} #{listao[2]}\n")
     end
     arquivo.close
	 return arquivo
 end


end