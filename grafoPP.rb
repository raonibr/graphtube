=begin
---------------------
Modelo de grafo pessoa pessoa

Para criar um grafo, passe como parametro um grafo pessoa local predefinido

Grafo = GrafoPP.new(grafoPL_Base)


Apesar de GrafoPP herdar Grafo, nem todas as fun��o de grafo funcionar�o corretamente em GrafoPP, retornando NIL.
As fun��o que funcionam s�o: 

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
    # Arestas_aux ser� um hash que guardar� os grupos de pessoas que frequentam o mesmo lugar
    # Cada b� do hash representa um lugar e � um vetor de pessoas.. (A chave do hash � o nome do local)
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

end