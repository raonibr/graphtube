=begin
-------------------------
Classe que lida com o banco de dados

Abre o arquivo "Tuberculose.sqlite" e carrega uma lista de pessoas.

Ainda está muito frágil, sendo sensivel a alterações na estrutura do banco

TO DO:
	- Fazer com que o nome do arquivo a ser aberto seja passado como parâmetro

-------------------------
=end

class Feeder
  
  def gera_pessoas()
  @pessoa = []
  db = SQLite3::Database.open( "Tuberculose.sqlite" )

  #Invoca a tabela de pessoas
  tabela = db.execute( "SELECT * FROM tabind" )
  tabela.each do |pessoa|
    id = pessoa[0]
    cidade = pessoa[1]
    bairro = pessoa[2]
    endereco = pessoa[3]
    
    #Invoca os locais de moradia de uma pessoa
    tabela_local_mora = db.execute( "SELECT t2.CIDADE_M, t2.BAIRRO_M, t2.END_M, t2.NUMERO_M, t2.TEMPO, t2.TEMPOf, t2.Lat_Morou, t2.Long_Morou FROM tabind AS t1, moradia AS t2 WHERE (t1.NoQES = t2.NoQES) AND t1.NoQES = \"#{id}\""  )
    
    #Invoca os locais de trabalho de uma pessoa
    tabela_local_trab = db.execute( "SELECT t2.Cidade_T, t2.Bairro_T, t2.Endereco_T, t2.Empresa_T, t2.Peri_trabi, t2.Peri_trabf, t2.Lat_Trabalho, t2.Long_Trabalho FROM tabind AS t1, tab_trab AS t2 WHERE (t1.NoQES = t2.NoQES) AND t1.NoQES = \"#{id}\""  )
    
    #Invoca os locais de estudo de uma pessoa
    tabela_local_estudo = db.execute( "SELECT t2.Cidade_E, t2.Bairro_E, t2.End_E, t2.Nome_Escola, t2.Peri_Ei, t2.Peri_Ef, t2.Lat_Estudo, t2.Long_Estudo FROM tabind AS t1, tab_estud AS t2 WHERE (t1.NoQES = t2.NoQES) AND t1.NoQES = \"#{id}\""  )
    
    #Invoca os locais de lazer de uma pessoa
    tabela_local_lazer = db.execute( "SELECT t2.Cidade_L, t2.Bairro_L, t2.Endereco_L, t2.Local , t2.Lat_Lazer, t2.Long_Lazer FROM tabind AS t1, tab_loc AS t2 WHERE (t1.NoQES = t2.NoQES) AND t1.NoQES = \"#{id}\""  )
    
    #O ultimo parametro é o registro se essa pessoa está ativa ou não (está sendo levada em consideração no grafo). Inicialmente todos são inativos     
    pessoa_nova = Pessoa.new(id,cidade,bairro,endereco,tabela_local_mora,tabela_local_trab,tabela_local_estudo,tabela_local_lazer,1)
	
    @pessoa << pessoa_nova
  end
  return @pessoa

  end
end