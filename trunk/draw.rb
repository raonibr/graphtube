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
    @vertices = vertices
    @arestas = arestas
    
    @altura = 500
    @largura = 700
    
    @tam_vertice = 12
    
    @Vertices_draw = []
    @Arestas_draw = []

    @vertices.each do |ver|
      
      if  (ver[0]=="ID")
        @Vertices_draw  << [(rand(10000).to_f/10000),(rand(10000).to_f/10000),ver[1],"RED"]
      else
        @Vertices_draw  << [(rand(10000).to_f/10000),(rand(10000).to_f/10000),ver,"BLUE"]
      end
      
    end
    
=begin ESSE BAGULHO NÃO FUNCIONA.... PROCURAR SOLUCAO MELHOR
    @arestas.each do |are|
      i = 0
      @temp_are = []
      while ((i < @Vertices_draw.length()) and (@temp_are.length()<2) )
        pp @Vertices_draw[i][2]
        if (@Vertices_draw[i][2]==are[0])
          @temp_are << i
          pp "RÁ\n"
        end
        if (@Vertices_draw[i][2]==are[1])
          @temp_are << i
          pp "RÁ\n"
        end
        i = i+1
      end
      @Arestas_draw << @temp_are
    end
=end
    
    area = Gtk::DrawingArea.new
    area.set_size_request(100,100)
    
    area.signal_connect("expose_event") do
      
      @altura = @draw_window.size.last()
      @largura = @draw_window.size.first()
      alloc = area.allocation
      
      @Vertices_draw.each do |p|
        x1 = p[0]*@largura
        y1 = p[1]*@altura
      area.window.draw_arc(area.style.fg_gc(area.state), true, x1, y1, @tam_vertice, @tam_vertice, 0 ,64 * 360) 
      
      # Nesse caso tam_vertice/2 representa a correção da posição do canto da linha.. Assim ela aponta para o centro do vertice, não para o canto
      #area.window.draw_line(area.style.fg_gc(area.state), x1+@tam_vertice/2, y1+@tam_vertice/2, x2+@tam_vertice/2,y2+@tam_vertice/2)
   
   end
    
    end
    
    
    @draw_window = Gtk::Window.new.add(area).set_size_request(300, 200)
    @draw_window.title = "Draw Area"
    @draw_window.show_all
    
  end
  
  
  
end