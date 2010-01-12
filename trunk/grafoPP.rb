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
    grafo_base.vertices().each do |pessoa|
      if(pessoa[0]=="ID")
        @vertices << pessoa
        pp pessoa
      end
    end
  end
  
end