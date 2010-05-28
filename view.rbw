require 'header'

=begin
--------------------------------
View do programa em GTK, estﾃ｡gio primﾃ｡rio

TO DO	
	- Refatorar
	- Comentar este cﾃｳdigo
	
--------------------------------
=end

#++++++++++++++++++++++++++++++++++++++++++++++++++++++
#             DECLARAﾃ�ﾃグ DE CONSTANTES
#++++++++++++++++++++++++++++++++++++++++++++++++++++++
MORADIA = 1 
TRABALHO = 2
ESTUDO = 3
LAZER = 4

CIDADE = 1 
BAIRRO = 2
ENDERECO = 3
LOCAL = 4
#++++++++++++++++++++++++++++++++++++++++++++++++++++++
#         FINAL DA DECLARAﾃ�ﾃグ DE CONSTANTES
#++++++++++++++++++++++++++++++++++++++++++++++++++++++

#--------------------AQUI ACONTECE O LOAD DO BANCO ---------------------------
feeder = Feeder.new
$grafoExemplo = Grafo.new(feeder.gera_pessoas())
#---------------------------------------------------------------------------------------------


@sem_global = [0,0,0,0]
@sem_moradia = [0,0,0,0]
@sem_trabalho = [0,0,0,0]
@sem_estudo = [0,0,0,0]
@sem_lazer = [0,0,0,0]
@sem_caso = [0,0]
@sem_sexo = [0,0]
@sem_filtros_extra = [0]
@idadeinicial = 0 
@idadefinal = 99

	def atualiza_buffer()
		$grafoExemplo.clear_grafo()
		cont = 0	
		while (cont < 4)
			if (@sem_moradia[cont]==1)
				$grafoExemplo.gerar_grafo_PL(MORADIA,cont+1, @datainicial, @datafinal)
			end
			if (@sem_trabalho[cont]==1)
				$grafoExemplo.gerar_grafo_PL(TRABALHO,cont+1, @datainicial, @datafinal)
			end
			if (@sem_estudo[cont]==1)
				$grafoExemplo.gerar_grafo_PL(ESTUDO,cont+1, @datainicial, @datafinal)
			end
			if (@sem_lazer[cont]==1)
				$grafoExemplo.gerar_grafo_PL(LAZER,cont+1, @datainicial, @datafinal)
			end
		cont = cont + 1
  end
    if (@sem_filtros_extra[0] == 0)
      $grafoExemplo.coloca_pessoas_todas()
    else
      $grafoExemplo.coloca_pessoas_ativas()
    end
    
		$textview_1.buffer.text = $grafoExemplo.retorna_legivel_pessoas()
		$textview_2.buffer.text = $grafoExemplo.retorna_legivel_lugares()
		$textview_3.buffer.text = $grafoExemplo.retorna_legivel_arestas()
	end

	def set_reset_check(w,check_Cidade,check_Bairro,check_End,check_Local)
		check_Cidade.sensitive = w.active? ? true : false
		check_Bairro.sensitive = w.active? ? true : false
		check_End.sensitive = w.active? ? true : false
		check_Local.sensitive = w.active? ? true : false
	end

	def gera_ativos(escopo, w)
    if (escopo == "Caso_Controle")
	  	if (@sem_caso[w-1]==0)
		  	@sem_caso[w-1] = 1
		  else 
			 @sem_caso[w-1] = 0
		  end
    end
    
    if (escopo == "Sexo")
	  	if (@sem_sexo[w-1]==0)
		  	@sem_sexo[w-1] = 1
		  else 
			 @sem_sexo[w-1] = 0
     end
    end
    
    $grafoExemplo.ativar_todos()
    
    if ((@sem_caso[0]+@sem_caso[1]) == 1)
      if (@sem_caso[0]==1)
        $grafoExemplo.desativa_controle()
      end
      if (@sem_caso[1]==1)
        $grafoExemplo.desativa_caso()
      end
    end
    
    if ((@sem_sexo[0]+@sem_sexo[1]) == 1)
      if (@sem_sexo[0]==1)
        $grafoExemplo.desativa_feminino()
      end
      if (@sem_sexo[1]==1)
        $grafoExemplo.desativa_masculino()
      end
    end
    
    $grafoExemplo.desativar_pessoas_idade(@idadeinicial, @idadefinal)
    
    if (((@sem_caso[0]+@sem_caso[1]) == 0) or ((@sem_sexo[0]+@sem_sexo[1]) == 0) )
      $grafoExemplo.desativar_todos()
    end
		atualiza_buffer()
	end
  

  def gera_lugares(escopo, w)
    lugares_aux = [@sem_moradia, @sem_trabalho, @sem_estudo, @sem_lazer]
    lugares = lugares_aux[escopo-1]
      
    if (lugares[w-1]==0)
			lugares[w-1] = 1
      #Essa parte executa caso seja um novo lugar selecionado Otimiza鈬o feita para salvar processamento
      $grafoExemplo.gerar_grafo_PL(escopo,w, @datainicial, @datafinal)
      if (@sem_filtros_extra[0] == 1)
        $grafoExemplo.coloca_pessoas_ativas()
      end
      $textview_1.buffer.text = $grafoExemplo.retorna_legivel_pessoas()
      $textview_2.buffer.text = $grafoExemplo.retorna_legivel_lugares()
      $textview_3.buffer.text = $grafoExemplo.retorna_legivel_arestas()
		else 
			lugares[w-1] = 0
      atualiza_buffer()
		end
  end
  
	def gera_arquivo(parent , tipo, grafo_usado)
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
      if(tipo == "net")
        grafo_usado.imprime_pajek(@filename+".net")
      elsif(tipo == "matrix")
        grafo_usado.imprime_matriz_adjacencias(@filename+".txt")
      else
        grafo_usado.imprime_matriz_distancias_minimas(@filename+".txt")
      end
    end
	end
  
  
  
  
  
#----------------------------------CRIA JANELA PRINCIPAL--------------------------------------#
	window = Gtk::Window.new

	window.title = "GraphTube"
	window.border_width = 10
	window.set_size_request(890, 600)
	
	window.signal_connect('delete_event') do
		Gtk.main_quit
		false
	end
	
	caixa_comandos = Gtk::VBox.new(true,10)
#---------------------------------------------------------------------------------------------#



#-------------------------------------CAIXA DE CASO OU CONTROLE-------------------------------#


	caixa_caso_controle = Gtk::HBox.new(true,10)
	check_caso = Gtk::CheckButton.new("Casos")

	check_caso.signal_connect("toggled") do |w|
		gera_ativos( "Caso_Controle", 1)

	end
	caixa_caso_controle.pack_start(check_caso,false,true,0)	

	check_controle = Gtk::CheckButton.new("Controles")

	check_controle.signal_connect("toggled") do |w|
		gera_ativos( "Caso_Controle", 2)

	end
	caixa_caso_controle.pack_start(check_controle,false,true,0)

	caixa_comandos.pack_start(caixa_caso_controle,false,true,0)


#---------------------------------------------------------------------------------------------#	




#-------------------------------------CAIXA DE SEXOS-------------------------------#


	caixa_sexos = Gtk::HBox.new(true,10)
	check_masculino = Gtk::CheckButton.new("Masculino")

	check_masculino.signal_connect("toggled") do |w|
		gera_ativos( "Sexo", 1)

	end
	caixa_sexos.pack_start(check_masculino,false,true,0)	

	check_feminino = Gtk::CheckButton.new("Feminino")

	check_feminino.signal_connect("toggled") do |w|
		gera_ativos( "Sexo", 2)

	end
	caixa_sexos.pack_start(check_feminino,false,true,0)

	caixa_comandos.pack_start(caixa_sexos,false,true,0)


#---------------------------------------------------------------------------------------------#	

#-----------------------------COMBOBOXs DE IDADE--------------------------------------------------------#	
  # A INICIAL
  
	combobox = Gtk::ComboBox.new
	
	for i in (0..99)
		combobox.append_text(i.to_s())
	end
  
  combobox.active = 0

  combobox.signal_connect("changed") do |d|
    @idadeinicial = combobox.active_text
    gera_ativos("idade",1)
  end
  
  #A FINAL
  combobox2 = Gtk::ComboBox.new
  
  for i in (0..99)
		combobox2.append_text(i.to_s())
	end


	combobox2.active = 99
  combobox2.signal_connect("changed") do |d|
    @idadefinal = combobox2.active_text
    gera_ativos("idade",1)
  end
  
  
  caixa_comboboxs_idade = Gtk::HBox.new(true,10)

  caixa_comboboxs_idade.pack_start(combobox,false,true,0)
  caixa_comboboxs_idade.pack_start(combobox2,false,true,0)

	caixa_comandos.pack_start(caixa_comboboxs_idade,false,true,0)
#---------------------------------------------------------------------------------------------#


#-----------------------------COMBOBOXs--------------------------------------------------------#	
  # A INICIAL
  
	combobox_inicio = Gtk::ComboBox.new
	
	#@anos.each do |val|
	#	combobox.append_text(val)
	#end
  
	combobox_inicio.insert_text(0,'Periodo inicial.')
  combobox_inicio.insert_text(1,'2001')
	combobox_inicio.insert_text(2,'2002')
	combobox_inicio.insert_text(3,'2003')
	combobox_inicio.insert_text(4,'2004')
	combobox_inicio.insert_text(5,'2005')
	combobox_inicio.insert_text(6,'2006')
	combobox_inicio.insert_text(7,'2007')
	combobox_inicio.insert_text(8,'2008')
	combobox_inicio.insert_text(9,'2009')
  
  combobox_inicio.active = 0

  combobox_inicio.signal_connect("changed") do |d|
    @datainicial = combobox_inicio.active_text
    if (@datainicial == "Periodo inicial.")
      @datainicial = nil
      atualiza_buffer()
    else
      atualiza_buffer()
    end
  end
	
  #A FINAL
  combobox_final = Gtk::ComboBox.new

	combobox_final.insert_text(0,'Periodo final.')
  combobox_final.insert_text(1,'2001')
	combobox_final.insert_text(2,'2002')
	combobox_final.insert_text(3,'2003')
	combobox_final.insert_text(4,'2004')
	combobox_final.insert_text(5,'2005')
	combobox_final.insert_text(6,'2006')
	combobox_final.insert_text(7,'2007')
	combobox_final.insert_text(8,'2008')
	combobox_final.insert_text(9,'2009')

	combobox_final.active = 0
  
   combobox_final.signal_connect("changed") do |d|
    @datafinal = combobox_final.active_text
    if (@datafinal == "Periodo final.")
      @datafinal = nil
      atualiza_buffer()
    else
      atualiza_buffer()
    end
  end
  
 
  caixa_comboboxs = Gtk::HBox.new(true,10)

  caixa_comboboxs.pack_start(combobox_inicio,false,true,0)
  caixa_comboboxs.pack_start(combobox_final,false,true,0)

	caixa_comandos.pack_start(caixa_comboboxs,false,true,0)
#---------------------------------------------------------------------------------------------#


#---------------------TODAS AS CAIXAS RELACIONADAS A MORADIA----------------------------------#
	caixa_opcoes_moradia = Gtk::HBox.new(true,10)
	caixa_opcoes_moradia.spacing = 0

	check_Moradia = Gtk::CheckButton.new("Moradia")

	check_Cidade_moradia = Gtk::CheckButton.new("Cidade")

	check_Bairro_moradia = Gtk::CheckButton.new("Bairro")

	check_End_moradia = Gtk::CheckButton.new("Endereﾃｧo")

	check_Local_moradia = Gtk::CheckButton.new("Numero")	

	
	check_Moradia.sensitive = true

	check_Cidade_moradia.sensitive = false

	check_Bairro_moradia.sensitive = false

	check_End_moradia.sensitive = false

	check_Local_moradia.sensitive = false

	
	check_Moradia.signal_connect("toggled"){

		|w| set_reset_check(w,check_Cidade_moradia,check_Bairro_moradia,check_End_moradia,check_Local_moradia)
	}

	caixa_comandos.pack_start(check_Moradia,false,true,0)
		
	check_Cidade_moradia.signal_connect("toggled") do |w|

		gera_lugares(MORADIA,1)

	end

	caixa_opcoes_moradia.pack_start(check_Cidade_moradia,false,true,0)
		
	check_Bairro_moradia.signal_connect("toggled") do |w|

		gera_lugares(MORADIA,2)

	end

	caixa_opcoes_moradia.pack_start(check_Bairro_moradia,false,true,0)

	check_End_moradia.signal_connect("toggled") do |w|

		gera_lugares(MORADIA,3)

	end
	
	caixa_opcoes_moradia.pack_start(check_End_moradia,false,true,0)

	check_Local_moradia.signal_connect("toggled") do |w|

		gera_lugares(MORADIA,4)

	end

	caixa_opcoes_moradia.pack_start(check_Local_moradia,false,true,0)

	caixa_comandos.pack_start(caixa_opcoes_moradia,true,false,0)#---------------------------------------------------------------------------------------------#

#------------------------TODAS AS CAIXAS RELACIONADAS A TRABALHO------------------------------#
	caixa_opcoes_trabalho = Gtk::HBox.new(true,10)
	caixa_opcoes_trabalho.spacing = 0
	check_trabalho = Gtk::CheckButton.new("Trabalho")

	check_cidade_trabalho = Gtk::CheckButton.new("Cidade")

	check_bairro_trabalho = Gtk::CheckButton.new("Bairro")

	check_end_trabalho = Gtk::CheckButton.new("Endereﾃｧo")

	check_local_trabalho = Gtk::CheckButton.new("Local")	

	
	check_trabalho.sensitive = true

	check_cidade_trabalho.sensitive = false

	check_bairro_trabalho.sensitive = false

	check_end_trabalho.sensitive = false

	check_local_trabalho.sensitive = false

	
	check_trabalho.signal_connect("toggled"){

		|w| set_reset_check(w,check_cidade_trabalho,check_bairro_trabalho,check_end_trabalho,check_local_trabalho)
	
	}

	caixa_comandos.pack_start(check_trabalho,false,true,0)
		
	check_cidade_trabalho.signal_connect("toggled") do |w|

		gera_lugares(TRABALHO,1)

	end

	caixa_opcoes_trabalho.pack_start(check_cidade_trabalho,false,true,0)
		
	check_bairro_trabalho.signal_connect("toggled") do |w|

		gera_lugares(TRABALHO,2)

	end

	caixa_opcoes_trabalho.pack_start(check_bairro_trabalho,false,true,0)

	check_end_trabalho.signal_connect("toggled") do |w|

		gera_lugares(TRABALHO,3)

	end
	
	caixa_opcoes_trabalho.pack_start(check_end_trabalho,false,true,0)

	check_local_trabalho.signal_connect("toggled") do |w|

		gera_lugares(TRABALHO,4)

	end

	caixa_opcoes_trabalho.pack_start(check_local_trabalho,false,true,0)

	caixa_comandos.pack_start(caixa_opcoes_trabalho,true,false,0)
#---------------------------------------------------------------------------------------------#

#---------------------------TODAS AS CAIXAS RELACIONADAS A ESTUDO-----------------------------#
	caixa_opcoes_estudo = Gtk::HBox.new(true,10)
	caixa_opcoes_estudo.spacing = 0
	check_estudo = Gtk::CheckButton.new("Estudo")

	check_cidade_estudo = Gtk::CheckButton.new("Cidade")

	check_bairro_estudo = Gtk::CheckButton.new("Bairro")

	check_end_estudo = Gtk::CheckButton.new("Endereﾃｧo")

	check_local_estudo = Gtk::CheckButton.new("Local")	

	
	check_estudo.sensitive = true

	check_cidade_estudo.sensitive = false

	check_bairro_estudo.sensitive = false

	check_end_estudo.sensitive = false

	check_local_estudo.sensitive = false

	
	check_estudo.signal_connect("toggled"){

		|w| set_reset_check(w,check_cidade_estudo,check_bairro_estudo,check_end_estudo,check_local_estudo)
	}

	caixa_comandos.pack_start(check_estudo,false,true,0)
		
	check_cidade_estudo.signal_connect("toggled") do |w|

		gera_lugares(ESTUDO,1)

	end

	caixa_opcoes_estudo.pack_start(check_cidade_estudo,false,true,0)
		
	check_bairro_estudo.signal_connect("toggled") do |w|

		gera_lugares(ESTUDO,2)

	end

	caixa_opcoes_estudo.pack_start(check_bairro_estudo,false,true,0)

	check_end_estudo.signal_connect("toggled") do |w|

		gera_lugares(ESTUDO,3)

	end
	
	caixa_opcoes_estudo.pack_start(check_end_estudo,false,true,0)

	check_local_estudo.signal_connect("toggled") do |w|

		gera_lugares(ESTUDO,4)

	end

	caixa_opcoes_estudo.pack_start(check_local_estudo,false,true,0)

	caixa_comandos.pack_start(caixa_opcoes_estudo,true,false,0)
#---------------------------------------------------------------------------------------------#

#-----------------------------TODAS AS CAIXAS RELACIONADAS A LAZER----------------------------#
	caixa_opcoes_lazer = Gtk::HBox.new(true,10)
	caixa_opcoes_lazer.spacing = 0
	check_lazer = Gtk::CheckButton.new("Lazer")

	check_cidade_lazer = Gtk::CheckButton.new("Cidade")

	check_bairro_lazer = Gtk::CheckButton.new("Bairro")

	check_end_lazer = Gtk::CheckButton.new("Endereﾃｧo")

	check_local_lazer = Gtk::CheckButton.new("Local")	

	
	check_lazer.sensitive = true

	check_cidade_lazer.sensitive = false

	check_bairro_lazer.sensitive = false

	check_end_lazer.sensitive = false

	check_local_lazer.sensitive = false

	
	check_lazer.signal_connect("toggled"){

		|w| set_reset_check(w,check_cidade_lazer,check_bairro_lazer,check_end_lazer,check_local_lazer)
	}

	caixa_comandos.pack_start(check_lazer,false,true,0)
		
	check_cidade_lazer.signal_connect("toggled") do |w|

		gera_lugares(LAZER,1)

	end

	caixa_opcoes_lazer.pack_start(check_cidade_lazer,false,true,0)
		
	check_bairro_lazer.signal_connect("toggled") do |w|

		gera_lugares(LAZER,2)

	end

	caixa_opcoes_lazer.pack_start(check_bairro_lazer,false,true,0)

	check_end_lazer.signal_connect("toggled") do |w|

		gera_lugares(LAZER,3)

	end
	
	caixa_opcoes_lazer.pack_start(check_end_lazer,false,true,0)

	check_local_lazer.signal_connect("toggled") do |w|

		gera_lugares(LAZER,4)

	end

	caixa_opcoes_lazer.pack_start(check_local_lazer,false,true,0)

	caixa_comandos.pack_start(caixa_opcoes_lazer,true,false,0)
#---------------------------------------------------------------------------------------------#
	
	
#-----------------------------TEXTVIEW_1 RELACIONADA A CASOS----------------------------------#

	$textview_1 = Gtk::TextView.new

	$textview_1.buffer.text = ""

	$textview_1.editable = false

	$textview_1.cursor_visible = false

	$textview_1.border_width = 0


	scrolled_textview_1 = Gtk::ScrolledWindow.new

	scrolled_textview_1.border_width = 0
	
	scrolled_textview_1.add($textview_1)

	scrolled_textview_1.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS)
	
#---------------------------------------------------------------------------------------------#

#-----------------------------TEXTVIEW_2 RELACIONADA A LUGAR----------------------------------#
	$textview_2 = Gtk::TextView.new

	$textview_2.buffer.text = ""

	$textview_2.editable = false

	$textview_2.cursor_visible = false

	$textview_2.border_width = 0


	scrolled_textview_2 = Gtk::ScrolledWindow.new

	scrolled_textview_2.border_width = 0
	
	scrolled_textview_2.add($textview_2)

	scrolled_textview_2.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS)
#---------------------------------------------------------------------------------------------#

#--------------------------TEXTVIEW_3 RELACIONADA AS ARESTAS----------------------------------#

	$textview_3 = Gtk::TextView.new

	$textview_3.buffer.text = ""

	$textview_3.editable = false

	$textview_3.cursor_visible = false

	$textview_3.border_width = 0


	scrolled_textview_3 = Gtk::ScrolledWindow.new

	scrolled_textview_3.border_width = 0
	
	scrolled_textview_3.add($textview_3)

	scrolled_textview_3.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS)
	
#---------------------------------------------------------------------------------------------#


#------------------------------CRIA A RADIOBOX DE EXCLUIR NﾃO ATIVOS------------------#

caixa_opcao_exc_n_ativos = Gtk::HBox.new(true,10)
check_Excluir = Gtk::CheckButton.new("Ignorar individuos sem conexoes.")

	check_Excluir.signal_connect("toggled") do
    if(@sem_filtros_extra[0] == 0)
      @sem_filtros_extra[0] = 1
    else
      @sem_filtros_extra[0] = 0
    end
    atualiza_buffer()
  end

	caixa_opcao_exc_n_ativos.pack_start(check_Excluir,false,true,0)
  caixa_comandos.pack_start(caixa_opcao_exc_n_ativos,true,false,0)

#---------------------------------------------------------------------------------------------#

#------------------------------CRIA O BOTﾃグ DE DESENHAR---------------------------------------#
	botao_desenhar = Gtk::Button.new("Desenhar GRAFO")

	botao_desenhar.signal_connect("clicked") do |w|
		DrawView.new($grafoExemplo.vertices(),$grafoExemplo.arestas())
	end


	
	caixa_comandos.pack_start(botao_desenhar,true,false,0)
#---------------------------------------------------------------------------------------------#

#------------------------------CRIA O BOTﾃグ DE PESSOA-PESSOA-------------------#

botao_pessoa_pessoa = Gtk::Button.new("Gerar grafo Pessoa-Pessoa")

	botao_pessoa_pessoa.signal_connect("clicked") do |w|
    ViewPP.new($grafoExemplo)
	end


	
	caixa_comandos.pack_start(botao_pessoa_pessoa,true,false,0)

#---------------------------------------------------------------------------------------------#

#------------------------------CRIA O BOTﾃグ DE LOCAL-LOCAL-------------------#

botao_pessoa_pessoa = Gtk::Button.new("Gerar grafo Local-Local")

	botao_pessoa_pessoa.signal_connect("clicked") do |w|
    ViewLL.new($grafoExemplo)
	end


	
	caixa_comandos.pack_start(botao_pessoa_pessoa,true,false,0)

#---------------------------------------------------------------------------------------------#

#------------------------------CRIA O BOTﾃグ DE EXPORTAR . NET---------------------------------------#
	botao_exportar = Gtk::Button.new("Exportar .NET")

	botao_exportar.signal_connect("clicked") do |w|
		gera_arquivo(window,"net",$grafoExemplo)
	end


	
	caixa_comandos.pack_start(botao_exportar,true,false,0)
#---------------------------------------------------------------------------------------------#

#------------------------------CRIA O BOTﾃグ DE EXPORTAR MATRIZ DE ADJ---------------------------------------#
	botao_exportar = Gtk::Button.new("Exportar Matriz de Adjacencias")

	botao_exportar.signal_connect("clicked") do |w|
		gera_arquivo(window,"matrix",$grafoExemplo)
	end


	
	caixa_comandos.pack_start(botao_exportar,true,false,0)
#---------------------------------------------------------------------------------------------#

#-------------------------------CRIA O BOTﾃグ SAIR---------------------------------------------#
	botao_sair = Gtk::Button.new("Sair")
	
	botao_sair.signal_connect("clicked") do
		Gtk.main_quit
  end	
  
  
	caixa_comandos.pack_start(botao_sair,true,true,0)
	caixa_comandos.set_size_request(100,-1)
#---------------------------------------------------------------------------------------------#

#----------------------------------CRIA AS LABELS---------------------------------------------#
	textviews = Gtk::Notebook.new
	label1 = Gtk::Label.new("Casos")
	label2 = Gtk::Label.new("Locais")
	label3 = Gtk::Label.new("Arestas")
	textviews.append_page(scrolled_textview_1, label1)
	textviews.append_page(scrolled_textview_2, label2)
	textviews.append_page(scrolled_textview_3, label3)
#---------------------------------------------------------------------------------------------#

#--------------------------INSERE TUDO NA JANELA PRINCIPAL------------------------------------#
	janela_total = Gtk::HBox.new(true,10)

	janela_total.pack_start(textviews,true,true,0)

	janela_total.pack_start(caixa_comandos,true,true,0)	

	window.add(janela_total)
	
	window.show_all
	
	Gtk.main