=begin
-------------------------
Classe que lida com o banco de dados

Abre o arquivo "Tuberculose.sqlite" e carrega uma lista de pessoas.

Ainda est√° muito fr√°gil, sendo sensivel a altera√ß√µes na estrutura do banco

TO DO:
	- Fazer com que o nome do arquivo a ser aberto seja passado como par√¢metro

-------------------------
=end


class Feeder
  
  def gera_pessoas()
  @pessoa = []
  db = SQLite3::Database.open( "Database.sqlite" )


  #Primeiro passo È pegar as informaÁıes da tabela clÌnica e arrumar no seu hash.
  @banco_clinico = db.execute( "SELECT t1.NoQES, t1.SEXO, t1.IDADE, t1.v57, t1.v63, t1.v24, t1.v32 FROM clinico_tab AS t1" )
  @hash_clinico = Hash[]
  @banco_clinico.each do |clinico|
      if (@hash_clinico[clinico[0]] == nil)
        @hash_clinico[clinico[0]] = []
        @hash_clinico[clinico[0]] << [clinico[1],clinico[2],clinico[3],clinico[4],clinico[5],clinico[6]]
      else
        @hash_clinico[clinico[0]] << [clinico[1],clinico[2],clinico[3],clinico[4],clinico[5],clinico[6]]
      end
  end

  #Em seguida recuperar as informaÁıes de lugar um por um.
  @locais_moradia = db.execute( "SELECT t2.CIDADE_M, t2.BAIRRO_M, t2.END_M, t2.NUMERO_M, t2.TEMPO, t2.TEMPOf, t2.Lat_Morou, t2.Long_Morou, t2.NoQES FROM moradia AS t2"  )
  @hash_moradia = Hash[]
  @locais_moradia.each do |local|
      if (@hash_moradia[local[8]] == nil)
        @hash_moradia[local[8]] = []
      end
      if ((local[6])and(local[7]))
      @hash_moradia[local[8]] << [local[0],local[1],local[2],local[3],local[4],local[5],local[6].chomp("\302\260"),local[7].chomp("\302\260")]
      else
      @hash_moradia[local[8]] << [local[0],local[1],local[2],local[3],local[4],local[5],local[6],local[7]]
      end
  end
  
  
  
  @locais_trabalho = db.execute( "SELECT t2.Cidade_T, t2.Bairro_T, t2.Endereco_T, t2.Empresa_T, t2.Peri_trabi, t2.Peri_trabf, t2.Lat_Trabalho, t2.Long_Trabalho, t2.NoQES FROM tab_trab AS t2"  )
  @hash_trabalho = Hash[]
  @locais_trabalho.each do |local|
      if (@hash_trabalho[local[8]] == nil)
        @hash_trabalho[local[8]] = []
      end
      if (local[6])
      @hash_trabalho[local[8]] << [local[0],local[1],local[2],local[3],local[4],local[5],local[6].chomp("\302\260"),local[7].chomp("\302\260")]
      else
      @hash_trabalho[local[8]] << [local[0],local[1],local[2],local[3],local[4],local[5],local[6],local[7]]
      end
  end
  
  
  
  
  @locais_estudo = db.execute("SELECT t2.Cidade_E, t2.Bairro_E, t2.End_E, t2.Nome_Escola, t2.Peri_Ei, t2.Peri_Ef, t2.Lat_Estudo, t2.Long_Estudo, t2.NoQES FROM tab_estud AS t2"  )
  @hash_estudo = Hash[]
  @locais_estudo.each do |local|
      if (@hash_estudo[local[8]] == nil)
        @hash_estudo[local[8]] = []
      end
      if (local[6])
      @hash_estudo[local[8]] << [local[0],local[1],local[2],local[3],local[4],local[5],local[6].chomp("\302\260"),local[7].chomp("\302\260")]
      else
      @hash_estudo[local[8]] << [local[0],local[1],local[2],local[3],local[4],local[5],local[6],local[7]]
      end
  end
  
  
    
  @locais_lazer = db.execute("SELECT t2.Cidade_L, t2.Bairro_L, t2.Endereco_L, t2.Local , t2.Lat_Lazer, t2.Long_Lazer, t2.NoQES FROM tab_loc AS t2"  )
  @hash_lazer = Hash[]
  @locais_lazer.each do |local|
      if (@hash_lazer[local[6]] == nil)
        @hash_lazer[local[6]] = []
      end
        @hash_lazer[local[6]] << [local[0],local[1],local[2],local[3],local[4],local[5]]
      if ((local[4])and(local[5]))
      @hash_lazer[local[6]] << [local[0],local[1],local[2],local[3],local[4].chomp("\302\260"),local[5].chomp("\302\260")]
      else
      @hash_lazer[local[6]] << [local[0],local[1],local[2],local[3],local[4],local[5]]
      end
  end
  

  #Invoca a tabela de pessoas
  tabela = db.execute( "SELECT * FROM tabind" )
  tabela.each do |pessoa|
    id = pessoa[0]
    cidade = pessoa[1]
    bairro = pessoa[2]
    endereco = pessoa[3]
    
    #Invoca informacoes do question·rio clÌnico, como sexo e idade.
    if @hash_clinico[id]
      sexo = @hash_clinico[id][0][0]
      idade = @hash_clinico[id][0][1]
      hcontato = @hash_clinico[id][0][2]
      reativacao = @hash_clinico[id][0][3]
      tempo_estudo = @hash_clinico[id][0][4]
      renda = @hash_clinico[id][0][5]
    else
      sexo = 0
      idade = 0
      hcontato = 0
      reativacao = 0
      tempo_estudo = 0
      renda = 0
    end   
    
    #Invoca os locais de moradia de uma pessoa
    if @hash_moradia[id]
      tabela_local_mora = @hash_moradia[id]
    else
      tabela_local_mora = []
    end   
        
    #pp @hash_moradia[id]
    
    #Invoca os locais de trabalho de uma pessoa
    if @hash_trabalho[id]
      tabela_local_trab = @hash_trabalho[id]
    else
      tabela_local_trab = []
    end   
    
    
    #Invoca os locais de estudo de uma pessoa
    if @hash_estudo[id]
      tabela_local_estudo = @hash_estudo[id]
    else
      tabela_local_estudo = []
    end   
    
    #Invoca os locais de lazer de uma pessoa
    if @hash_lazer[id]
      tabela_local_lazer = @hash_lazer[id]
    else
      tabela_local_lazer = []
    end   
    
    
    #O ultimo parametro √© o registro se essa pessoa est√° ativa ou n√£o (est√° sendo levada em considera√ß√£o no grafo). Inicialmente todos s√£o inativos     
    pessoa_nova = Pessoa.new(id,cidade,bairro,endereco,tabela_local_mora,tabela_local_trab,tabela_local_estudo,tabela_local_lazer, sexo, idade, hcontato, reativacao, tempo_estudo, renda, 1)
	
    @pessoa << pessoa_nova
  end
  
  return @pessoa

  end
end