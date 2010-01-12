require 'header'

class ViewPP

  def initialize(vertices, arestas)
    #----------------------------------CRIA JANELA PRINCIPAL--------------------------------------#
    window = Gtk::Window.new

    window.title = "Pessoa-Pessoa"
    window.border_width = 10
    window.set_size_request(500, 500)
  
    
    caixa_comandos = Gtk::VBox.new(true,10)
    caixa_comandos.homogeneous=false
  #---------------------------------------------------------------------------------------------#
  
    #-----------------------------TEXTVIEW_1 RELACIONADA A PESSOAS----------------------------------#

    textview_1 = Gtk::TextView.new

    textview_1.buffer.text = ""

    textview_1.editable = false

    textview_1.cursor_visible = false

    textview_1.border_width = 0


    scrolled_textview_1 = Gtk::ScrolledWindow.new

    scrolled_textview_1.border_width = 0
    
    scrolled_textview_1.add(textview_1)

    scrolled_textview_1.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS)
    
  #---------------------------------------------------------------------------------------------#

  #-----------------------------TEXTVIEW_2 RELACIONADA AS ARESTAS----------------------------------#
    textview_2 = Gtk::TextView.new

    textview_2.buffer.text = ""

    textview_2.editable = false

    textview_2.cursor_visible = false

    textview_2.border_width = 0


    scrolled_textview_2 = Gtk::ScrolledWindow.new

    scrolled_textview_2.border_width = 0
    
    scrolled_textview_2.add(textview_2)

    scrolled_textview_2.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS)
  #---------------------------------------------------------------------------------------------#
  
  #----------------------------------CRIA AS LABELS---------------------------------------------#
	textviews = Gtk::Notebook.new
	label1 = Gtk::Label.new("Pessoas")
	label2 = Gtk::Label.new("Arestas")
	textviews.append_page(scrolled_textview_1, label1)
	textviews.append_page(scrolled_textview_2, label2)
  caixa_comandos.pack_start(textviews,true,true,0)
	#---------------------------------------------------------------------------------------------#

  #------------------------------CRIA O BOTÃO DE DESENHAR---------------------------------------#
    botao_desenhar = Gtk::Button.new("Desenhar GRAFO")

    botao_desenhar.signal_connect("clicked") do |w|
      DrawView.new($grafoExemplo.vertices(),$grafoExemplo.arestas())
    end


    
    caixa_comandos.pack_start(botao_desenhar,false,false,0)
  #---------------------------------------------------------------------------------------------#

  #------------------------------CRIA O BOTÃO DE EXPORTAR---------------------------------------#
    botao_exportar = Gtk::Button.new("Exportar .NET")

    botao_exportar.signal_connect("clicked") do |w|
      gera_arquivo(window)
    end


    
    caixa_comandos.pack_start(botao_exportar,false,false,0)
  #---------------------------------------------------------------------------------------------#
   
    window.add(caixa_comandos)
    
    window.show_all
  end
end