=begin
--------------------------------
Classe que cria a janela de desenho de grafo.

Existe estruturas especial dentro dessa classe para definir vertices e arestas: São elas:

Vertice_draw: [COORDENADA_X,COODENADA_Y,LABEL,COR]
    - Cada Coordenada é um número entre 0 e 1 que será mltiplicado pelo tamanho da janela para achar a coordenada real
    - Todos os vértices ficam na lista @Vertives_draw
Aresta_draw: [POSICAO_DO_ELEM_1,POSICAO_DO_ELEM_2]
    - Cada aresta possui apenas a posição dos elentos que ela liga dentro do vetor @Vertices_draw
    - Todas as arestas ficam na lista @Arestas_draw
	
--------------------------------
=end


class DrawView

def initialize(vertices, arestas)
  
    # PRIMEIRO, SE DEFINEM AS GLOBAIS DESSA JANELA.
    @vertices = vertices
    @arestas = arestas
    
    @altura = 500
    @largura = 700
    
    @tam_vertice = 12
    
    @Vertices_draw = Hash[]
    @Arestas_draw = @arestas
  
    #Primeiro, todos os vertices são tratados e colocados no Hash Vertices_draw
    @vertices.each do |ver|
      if  (ver[0]=="ID")
        @Vertices_draw[ver[1]] = [(rand(10000).to_f/10000),(rand(10000).to_f/10000),ver[1],"RED"]
      else
        @Vertices_draw[ver] = [(rand(10000).to_f/10000),(rand(10000).to_f/10000),ver,"BLUE"]
      end
    end
    
    
    #Depois a drowing area é criada
    area = Gtk::DrawingArea.new
    area.set_size_request(100,100)
    
    
    # AQUI É O REDRAW, DEPOIS PRECISA VIRAR UM MODULO
    area.signal_connect("expose_event") do
      
      @altura = @draw_window.size.last()
      @largura = @draw_window.size.first()
      
      
      # ESSES DOIS LOOPs ABAIXO PRECISAM SER MODULARIZADOS... FAZER ISSO NA PRÓXIMA REVISÃO.
      # NESSE LOOP, CADA ARESTA É DESENHADA.
      @Arestas_draw.each do |a|
        # A LINHA ABAIXO É COMPLICADA... Mas ela pega para cada aresta e recupera as coordenadas dos vertices de cada lado e desenha um linha ligando eles.
        # Quando se introduz o "tam_vertice/2" se faz a correção da posição do canto da linha.. Assim ela aponta para o centro do vertice, não para o canto
        area.window.draw_line(area.style.fg_gc(area.state), @Vertices_draw[a[0]][0]*@largura+@tam_vertice/2, @Vertices_draw[a[0]][1]*@altura+@tam_vertice/2, @Vertices_draw[a[1]][0]*@largura+@tam_vertice/2,@Vertices_draw[a[1]][1]*@altura+@tam_vertice/2)
      end
          
      # NESSE LOOP, CADA VERTICE É DESENHADO.
        @Vertices_draw.each do |p| #Hashs tb tem funcão EACH
          x1 = p[1][0]*@largura
          y1 = p[1][1]*@altura
          area.window.draw_arc(area.style.fg_gc(area.state), true, x1, y1, @tam_vertice, @tam_vertice, 0 ,64 * 360) 
        end
        
        

          
          
          
    end
    
    
    @draw_window = Gtk::Window.new.add(area).set_size_request(600, 400)
    @draw_window.title = "Draw Area"
    @draw_window.show_all
    
  end
  
  
  
end