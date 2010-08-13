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
@sem_sexo = [1,1]
@sem_hcontato = [1,1]
@sem_reativacao = [1,1]
@sem_filtros_extra = [0]
@idadeinicial = 0 
@idadefinal = 99
@renda_incial = 0
@renda_final = 9999999
@escolaridade_incial = 0
@escolaridade_final = 15

@Cluster = "IGNORAR"

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
   
    if (escopo == "hcontato")
	  	if (@sem_hcontato[w-1]==0)
		  	@sem_hcontato[w-1] = 1
		  else 
			 @sem_hcontato[w-1] = 0
     end
    end
    
    if (escopo == "reativacao")
	  	if (@sem_reativacao[w-1]==0)
		  	@sem_reativacao[w-1] = 1
		  else 
			 @sem_reativacao[w-1] = 0
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
    
    if ((@sem_hcontato[0]+@sem_hcontato[1]) == 1)
      if (@sem_hcontato[0]==1)
        $grafoExemplo.desativa_hcontato_nao()
      end
      if (@sem_hcontato[1]==1)
        $grafoExemplo.desativa_hcontato_sim()
      end
    end
    
    if ((@sem_reativacao[0]+@sem_reativacao[1]) == 1)
      if (@sem_reativacao[0]==1)
        $grafoExemplo.desativa_reativacao_nao()
      end
      if (@sem_reativacao[1]==1)
        $grafoExemplo.desativa_reativacao_sim()
      end
    end
    
    if (@Cluster != "IGNORAR")
      $grafoExemplo.desativar_cluster(@Cluster)
    end
    
    $grafoExemplo.desativar_pessoas_idade(@idadeinicial, @idadefinal)
    $grafoExemplo.desativar_pessoas_renda(@renda_inicial, @renda_final)
    $grafoExemplo.desativar_pessoas_escolaridade(@escolaridade_inicial, @escolaridade_final)
    
    if (((@sem_caso[0]+@sem_caso[1]) == 0) or ((@sem_sexo[0]+@sem_sexo[1]) == 0) or ((@sem_hcontato[0]+@sem_hcontato[1])==0) or ((@sem_reativacao[0]+@sem_reativacao[1])==0) )
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
      elsif(tipo == "net2")
        grafo_usado.imprime_pajek(@filename+".net", 1)
      else
        grafo_usado.imprime_matriz_distancias_minimas(@filename+".txt")
      end
    end
	end
  
  
  
  
  
#----------------------------------CRIA JANELA PRINCIPAL--------------------------------------#
	window = Gtk::Window.new

	window.title = "GraphTube"
	window.border_width = 10
	window.set_size_request(800, 730)
	
	window.signal_connect('delete_event') do
		Gtk.main_quit
		false
	end
	
	caixa_comandos = Gtk::VBox.new(true,10)
#---------------------------------------------------------------------------------------------#



#-------------------------------------CAIXA DE CASO OU CONTROLE-------------------------------#


	caixa_caso_controle = Gtk::HBox.new(true,10)
  label = Gtk::Label.new("Grupo:")
  caixa_caso_controle.pack_start(label,false,true,0)	
  
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
  label = Gtk::Label.new("Sexo:")
  caixa_sexos.pack_start(label,false,true,0)	
  
  check_masculino = Gtk::CheckButton.new("Masculino")

  check_masculino.active = true

	check_masculino.signal_connect("toggled") do |w|
		gera_ativos( "Sexo", 1)

	end
	caixa_sexos.pack_start(check_masculino,false,true,0)	

	check_feminino = Gtk::CheckButton.new("Feminino")

  check_feminino.active = true

	check_feminino.signal_connect("toggled") do |w|
		gera_ativos( "Sexo", 2)

	end
	caixa_sexos.pack_start(check_feminino,false,true,0)

	caixa_comandos.pack_start(caixa_sexos,false,true,0)


#---------------------------------------------------------------------------------------------#	

#-----------------------------COMBOBOXs DE IDADE--------------------------------------------------------#	
  # A INICIAL
  
	combobox_idade = Gtk::ComboBox.new
	
	for i in (0..99)
		combobox_idade.append_text(i.to_s())
	end
  
  combobox_idade.active = 0

  combobox_idade.signal_connect("changed") do |d|
    @idadeinicial = combobox_idade.active_text
    gera_ativos("idade",1)
  end
  
  #A FINAL
  combobox_idade2 = Gtk::ComboBox.new
  
  for i in (0..99)
		combobox_idade2.append_text(i.to_s())
	end


	combobox_idade2.active = 99
  combobox_idade2.signal_connect("changed") do |d|
    @idadefinal = combobox_idade2.active_text
    gera_ativos("idade",1)
  end
  
  
  caixa_comboboxs_idade = Gtk::HBox.new(true,10)
  label = Gtk::Label.new("Faixa de idade:")
  caixa_comboboxs_idade.pack_start(label,false,true,0)	

  caixa_comboboxs_idade.pack_start(combobox_idade,false,true,0)
  caixa_comboboxs_idade.pack_start(combobox_idade2,false,true,0)

	caixa_comandos.pack_start(caixa_comboboxs_idade,false,true,0)
#---------------------------------------------------------------------------------------------#





#-----------------------------COMBOBOXs DE RENDA--------------------------------------------------------#	
  # A INICIAL
  
	combobox_renda = Gtk::ComboBox.new
	
	$faixas_de_renda.each do |r|
		combobox_renda.append_text(r.to_s())
	end
  
  combobox_renda.active = 0

  combobox_renda.signal_connect("changed") do |d|
    @renda_inicial = combobox_renda.active_text
    gera_ativos("renda",1)
  end
  
  #A FINAL
  combobox_renda2 = Gtk::ComboBox.new
  
	$faixas_de_renda.each do |r|
		combobox_renda2.append_text(r.to_s())
	end


	combobox_renda2.active = $faixas_de_renda.length() -1
  combobox_renda2.signal_connect("changed") do |d|
    @renda_final  = combobox_renda2.active_text
    gera_ativos("renda",1)
  end
  
  
  caixa_comboboxs_renda = Gtk::HBox.new(true,10)
  label = Gtk::Label.new("Faixa de renda:")
  caixa_comboboxs_renda.pack_start(label,false,true,0)	

  caixa_comboboxs_renda.pack_start(combobox_renda,false,true,0)
  caixa_comboboxs_renda.pack_start(combobox_renda2,false,true,0)

	caixa_comandos.pack_start(caixa_comboboxs_renda,false,true,0)
#---------------------------------------------------------------------------------------------#



#-----------------------------COMBOBOXs DE TEMPO DE ESTUDO--------------------------------------------------------#	
  # A INICIAL
  
	combobox_temp_est = Gtk::ComboBox.new
	
	for i in (0..15)
		combobox_temp_est.append_text(i.to_s())
	end
  
  combobox_temp_est.active = 0

  combobox_temp_est.signal_connect("changed") do |d|
    @escolaridade_inicial = combobox_temp_est.active_text
    gera_ativos("escola",1)
  end
  
  #A FINAL
  combobox_temp_est2 = Gtk::ComboBox.new
  
  for i in (0..15)
		combobox_temp_est2.append_text(i.to_s())
	end


	combobox_temp_est2.active = 15
  combobox_temp_est2.signal_connect("changed") do |d|
    @escolaridade_final = combobox_temp_est2.active_text
    gera_ativos("escola",1)
  end
  
  
  caixa_comboboxs_tempo_estudo = Gtk::HBox.new(true,10)
  label = Gtk::Label.new("Anos de estudo:")
  caixa_comboboxs_tempo_estudo.pack_start(label,false,true,0)	

  caixa_comboboxs_tempo_estudo.pack_start(combobox_temp_est,false,true,0)
  caixa_comboboxs_tempo_estudo.pack_start(combobox_temp_est2,false,true,0)

	caixa_comandos.pack_start(caixa_comboboxs_tempo_estudo,false,true,0)
#---------------------------------------------------------------------------------------------#



#-------------------------------------CAIXA DE HISTORIA DE CONTATO-------------------------------#


	caixa_hcontato = Gtk::HBox.new(true,10)
  label = Gtk::Label.new("Historia de contato:")
  caixa_hcontato.pack_start(label,false,true,0)	
  
  check_sim = Gtk::CheckButton.new("Sim")
  check_sim.active = true
  
	check_sim.signal_connect("toggled") do |w|
		gera_ativos( "hcontato", 1)

	end
  
	caixa_hcontato.pack_start(check_sim,false,true,0)	

	check_nao = Gtk::CheckButton.new("Nao")
  check_nao.active = true
  
	check_nao.signal_connect("toggled") do |w|
		gera_ativos( "hcontato", 2)

	end
	caixa_hcontato.pack_start(check_nao,false,true,0)

	caixa_comandos.pack_start(caixa_hcontato,false,true,0)


#---------------------------------------------------------------------------------------------#	


#-------------------------------------CAIXA DE REATIVACﾃO------------------------------#


	caixa_reativa = Gtk::HBox.new(true,10)
  label = Gtk::Label.new("Reativacao:")
  caixa_reativa.pack_start(label,false,true,0)	
	check_sim = Gtk::CheckButton.new("Sim")
  check_sim.active = true
  
	check_sim.signal_connect("toggled") do |w|
		gera_ativos( "reativacao", 1)

	end
	caixa_reativa.pack_start(check_sim,false,true,0)	

	check_nao = Gtk::CheckButton.new("Nao")
  check_nao.active = true
  
	check_nao.signal_connect("toggled") do |w|
		gera_ativos( "reativacao", 2)

	end
	caixa_reativa.pack_start(check_nao,false,true,0)

	caixa_comandos.pack_start(caixa_reativa,false,true,0)


#---------------------------------------------------------------------------------------------#	

separator = Gtk::HSeparator.new
caixa_comandos.pack_start(separator, false, true, 5)


#--------------------------------------CAIXA DE CLUSTER------------------------------#
  # A INICIAL
  
	combobox_cluster = Gtk::ComboBox.new
	
  combobox_cluster.append_text("IGNORAR")
	for i in (1..40)
		combobox_cluster.append_text(i.to_s())
	end
  combobox_cluster.append_text("TODOS OS CLUSTERS")
  
  combobox_cluster.active = 0

  combobox_cluster.signal_connect("changed") do |d|
    @Cluster = combobox_cluster.active_text
    gera_ativos("cluster",1)
  end
  
  caixa_combobox_cluster = Gtk::HBox.new(true,10)
  label = Gtk::Label.new("Mostrar apenas o(s) cluster(s):")
  caixa_combobox_cluster.pack_start(label,false,true,0)	

  caixa_combobox_cluster.pack_start(combobox_cluster,false,true,0)

	caixa_comandos.pack_start(caixa_combobox_cluster,false,true,0)
#---------------------------------------------------------------------------------------------#	


separator2 = Gtk::HSeparator.new
caixa_comandos.pack_start(separator2, false, true, 5)


#-----------------------------COMBOBOXs DE PERIODO DE CONTATO --------------------------------------------------------#	
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
  label = Gtk::Label.new("Periodo de contato:")
  caixa_comboboxs.pack_start(label,false,true,0)	
  
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
    
    if (@sem_global[0]==0)
      @sem_global[0] = 1
    else 
      @sem_global[0] = 0
    end
    
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
    if (@sem_global[1]==0)
      @sem_global[1] = 1
    else 
      @sem_global[1] = 0
    end
	
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

    if (@sem_global[2]==0)
      @sem_global[2] = 1
    else 
      @sem_global[2] = 0
    end
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
    
    if (@sem_global[3]==0)
      @sem_global[3] = 1
    else 
      @sem_global[3] = 0
    end
    
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
	desenhar_grafo = Gtk::MenuItem.new("  Desenhar GRAFO ")
  
	desenhar_grafo.signal_connect("activate") do |w|
		DrawView.new($grafoExemplo.vertices(),$grafoExemplo.arestas())
	end
#---------------------------------------------------------------------------------------------#

#------------------------------CRIA O BOTﾃグ DE PESSOA-PESSOA-------------------#
  gerar_pp   = Gtk::MenuItem.new("  Gerar Grafo PP ")

  
  gerar_pp.signal_connect("activate") do |w|
    ViewPP.new($grafoExemplo, @sem_global)
	end
#---------------------------------------------------------------------------------------------#

#------------------------------CRIA O BOTﾃグ DE LOCAL-LOCAL-------------------#
gerar_ll   = Gtk::MenuItem.new("  Gerar Grafo LL ")

	gerar_ll.signal_connect("activate") do |w|
    ViewLL.new($grafoExemplo)
	end
#---------------------------------------------------------------------------------------------#

#------------------------------CRIA O BOTﾃグ DE EXPORTAR . NET---------------------------------------#
	exportar_net = Gtk::MenuItem.new("  Exportar .NET ")

	exportar_net.signal_connect("activate") do |w|
		gera_arquivo(window,"net",$grafoExemplo)
	end
#---------------------------------------------------------------------------------------------#

#------------------------------CRIA O BOTﾃグ DE EXPORTAR . NET COM CLUSTERS---------------------------------------#
	exportar_net_2 = Gtk::MenuItem.new("  Exportar .NET + CLUSTERS ")

	exportar_net_2.signal_connect("activate") do |w|
		gera_arquivo(window,"net2",$grafoExemplo)
	end
#---------------------------------------------------------------------------------------------#

#------------------------------CRIA O BOTﾃグ DE EXPORTAR MATRIZ DE ADJ---------------------------------------#
	exportar_mat = Gtk::MenuItem.new("  Exportar Matriz Adj. ")

	exportar_mat.signal_connect("activate") do |w|
		gera_arquivo(window,"matrix",$grafoExemplo)
	end
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

#----------------------------CRIA MENU BAR--------------------------------------------------#
  menubar = Gtk::MenuBar.new

  gerar_menu = Gtk::Menu.new
  exportar_menu = Gtk::Menu.new
  desenhar_menu = Gtk::Menu.new

  gerar = Gtk::MenuItem.new(" Gerar ")
  exportar = Gtk::MenuItem.new(" Exportar ")
  desenhar = Gtk::MenuItem.new(" Desenhar ")
  
  gerar_menu.append(gerar_pp)
  gerar_menu.append(gerar_ll) 

  exportar_menu.append(exportar_net)
  exportar_menu.append(exportar_net_2)
  exportar_menu.append(exportar_mat) 
  
  desenhar_menu.append(desenhar_grafo) 

  gerar.submenu = gerar_menu
  exportar.submenu = exportar_menu
  desenhar.submenu = desenhar_menu

  menubar.append(gerar)
  menubar.append(exportar)
  menubar.append(desenhar)
#--------------------------------------------------------------------------------------------------------------#

#--------------------------INSERE TUDO NA JANELA PRINCIPAL------------------------------------#

  janela_total = Gtk::HBox.new(false,10)
  janela_total.pack_start(caixa_comandos,true,true,0)
	janela_total.pack_start(textviews,true,true,0)
  
  janela_externa = Gtk::VBox.new(false,10)
  janela_externa.pack_start(menubar,false,false,0)
  janela_externa.pack_start(janela_total,true,true,0)
  
  window.add(janela_externa)
	window.show_all
	
	Gtk.main