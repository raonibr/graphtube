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
require 'gtk2'

class DrawView

def initialize(vertices, arestas)
    @draw_window = Gtk::Window.new("Gdk::GC sample").set_size_request(600, 400)
    @draw_window.title = "Draw Area"
    @draw_window.app_paintable = true
    @draw_window.realize
  
    # PRIMEIRO, SE DEFINEM AS GLOBAIS DESSA JANELA.
    @vertices = vertices
    @arestas = arestas
    
    @altura = 500
    @largura = 700
    
    @tam_vertice = 12
    
    @Vertices_draw = Hash[]
    @Arestas_draw = @arestas
    
    
    @red   = Gdk::Color.new(65535, 0, 0)
    @yellow = Gdk::Color.new(57000, 57000, 0)
    @blue = Gdk::Color.new(0,0,  65535)
    @black = Gdk::Color.new(0,0, 0)
    
    #Primeiro, todos os vertices são tratados e colocados no Hash Vertices_draw
    @vertices.each do |ver|
      if  (ver[0]=="ID")
        if (ver[1][0] == 49)
          @Vertices_draw[ver[1]] = [(rand(10000).to_f/10000),(rand(10000).to_f/10000),ver[1],@red]
        else
          @Vertices_draw[ver[1]] = [(rand(10000).to_f/10000),(rand(10000).to_f/10000),ver[1],@yellow]
        end
      else
        #Correção para quando o vertice possui tamanho.
        if (ver.length() == 1)
          @Vertices_draw[ver] = [(rand(10000).to_f/10000),(rand(10000).to_f/10000),ver,@blue]
        else
          @Vertices_draw[ver[0]] = [(rand(10000).to_f/10000),(rand(10000).to_f/10000),ver[0],@blue]
        end
      end
    end
    
    @drawable = @draw_window.window
    
    colormap = Gdk::Colormap.system
    colormap.alloc_color(@red,   false, true)
    colormap.alloc_color(@yellow, false, true)
    colormap.alloc_color(@blue, false, true)
    colormap.alloc_color(@black, false, true)
    @gc = Gdk::GC.new(@drawable)
    @gc.set_background(@black)
    @layout = Pango::Layout.new(Gdk::Pango.context)
    @layout.font_description = Pango::FontDescription.new('Sans 7')
    
    
    # AQUI É O REDRAW
      redraw()

  end
  
  def redraw()
    @draw_window.signal_connect("expose_event") do |win, evt|

      @altura = @draw_window.size.last()
      @largura = @draw_window.size.first()
      
      @gc.set_foreground(@black)
      # ESSES DOIS LOOPs ABAIXO PRECISAM SER MODULARIZADOS... FAZER ISSO NA PRÓXIMA REVISÃO.
      # NESSE LOOP, CADA ARESTA É DESENHADA.
      @Arestas_draw.each do |a|
        # A LINHA ABAIXO É COMPLICADA... Mas ela pega para cada aresta e recupera as coordenadas dos vertices de cada lado e desenha um linha ligando eles.
        # Quando se introduz o "tam_vertice/2" se faz a correção da posição do canto da linha.. Assim ela aponta para o centro do vertice, não para o canto
        @drawable.draw_line(@gc, @Vertices_draw[a[0]][0]*@largura+@tam_vertice/2, @Vertices_draw[a[0]][1]*@altura+@tam_vertice/2, @Vertices_draw[a[1]][0]*@largura+@tam_vertice/2,@Vertices_draw[a[1]][1]*@altura+@tam_vertice/2)
      end

      # NESSE LOOP, CADA VERTICE É DESENHADO.
        @Vertices_draw.each do |p| #Hashs tb tem funcão EACH
          @layout.text = p[1][2]
          x1 = p[1][0]*@largura
          y1 = p[1][1]*@altura
          @drawable.draw_layout(@draw_window.style.fg_gc(@draw_window.state), x1, y1-10, @layout)
          @drawable.draw_arc( @gc.set_foreground(p[1][3]), true, x1, y1, @tam_vertice, @tam_vertice, 0 ,64 * 360) 
        end
      end
    @draw_window.show_all
  end
  
end