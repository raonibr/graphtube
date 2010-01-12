require 'header'

class ViewPP

  def initialize(vertices, arestas)
    #----------------------------------CRIA JANELA PRINCIPAL--------------------------------------#
    window = Gtk::Window.new

    window.title = "Pessoa-Pessoa"
    window.border_width = 10
    window.set_size_request(790, 500)
    
    #window.signal_connect('delete_event') do
      #Gtk.main_quit
      #false
    #end
    
    caixa_comandos = Gtk::VBox.new(true,10)
  #---------------------------------------------------------------------------------------------#

  #------------------------------CRIA O BOTÃO DE DESENHAR---------------------------------------#
    botao_desenhar = Gtk::Button.new("Desenhar GRAFO")

    botao_desenhar.signal_connect("clicked") do |w|
      DrawView.new($grafoExemplo.vertices(),$grafoExemplo.arestas())
    end


    
    caixa_comandos.pack_start(botao_desenhar,true,false,0)
  #---------------------------------------------------------------------------------------------#

  #------------------------------CRIA O BOTÃO DE EXPORTAR---------------------------------------#
    botao_exportar = Gtk::Button.new("Exportar .NET")

    botao_exportar.signal_connect("clicked") do |w|
      gera_arquivo(window)
    end


    
    caixa_comandos.pack_start(botao_exportar,true,false,0)
  #---------------------------------------------------------------------------------------------#

    window.add(caixa_comandos)
    
    window.show_all
    
    Gtk.main
  end
end