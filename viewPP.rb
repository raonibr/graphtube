require 'header'

class ViewPP

  def initialize(grafo_base)
    @grafoPP = GrafoPP.new(grafo_base)
    #----------------------------------CRIA JANELA PRINCIPAL--------------------------------------#
    window = Gtk::Window.new

    window.title = "Pessoa-Pessoa"
    window.border_width = 10
    window.set_size_request(350, 500)
  
    
    caixa_comandos = Gtk::VBox.new(true,10)
    caixa_comandos.homogeneous=false
  #---------------------------------------------------------------------------------------------#
  
    #-----------------------------TEXTVIEW_1 RELACIONADA A PESSOAS----------------------------------#

    textview_1 = Gtk::TextView.new

    textview_1.buffer.text = @grafoPP.retorna_legivel_pessoas()

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

    textview_2.buffer.text = @grafoPP.retorna_legivel_arestas()

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
      DrawView.new(@grafoPP.vertices(),@grafoPP.arestas())
    end


    
    caixa_comandos.pack_start(botao_desenhar,false,false,0)
  #---------------------------------------------------------------------------------------------#

  #------------------------------CRIA O BOTÃO DE EXPORTAR---------------------------------------#
    botao_exportar = Gtk::Button.new("Exportar .NET")

    botao_exportar.signal_connect("clicked") do |w|
      self.gera_arquivo_PP(window)
    end


    
    caixa_comandos.pack_start(botao_exportar,false,false,0)
  #---------------------------------------------------------------------------------------------#
   
    window.add(caixa_comandos)
    
    window.show_all
  end
  
  
  	def gera_arquivo_PP(parent)
    dialog = Gtk::FileChooserDialog.new(
        "Salvar arquivo como ...",
	      parent,
	      Gtk::FileChooser::ACTION_SAVE,
	      nil,
	      [ Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL ],
	      [ Gtk::Stock::SAVE, Gtk::Dialog::RESPONSE_ACCEPT ]
	  )
    dialog.current_folder = GLib.home_dir()
	  dialog.run do |response|
	    if response == Gtk::Dialog::RESPONSE_ACCEPT
	      @filename = dialog.filename
	    end
	  end
  	dialog.destroy
    if (@filename)
      @grafoPP.imprime_pajek(@filename+".net")
    end
	end
  
  
end