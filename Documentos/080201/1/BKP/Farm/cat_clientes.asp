<%@ LANGUAGE = VBScript.Encode %>
<% 
	'---- 12/09/01 ----- Marco Calux Recuperação dos Valores Atuais, tipo de pagamento , regiao
	'---- 13/08/01 ----- Marco Calux Vereficação se os Países estão em BOF
	'---- 19/07/01 ----- Marco Calux Término da Página de Cadastro de Clientes
	'---- 18/07/01 ----- Marco Calux Criação do Update Nas tabelas Cadastro_cli_for e Clientes_atacado
	'---- 17/07/01 ----- Marco Calux Inclusão da Função Alterar em VbScript e início do desenvolvimento do Update
	'---- 16/07/01 ----- Marco Calux Inclusão do Combobox  tipo(atacado e varejo)
	'---- 16/07/01 ----- Marco Calux insert na tabela clientes_atacado, inclusão do campo transportadora, pois , é obrigatório na inclusão em clientes_atacado, caso esteja em branco recupera do parametro
	'---- 13/07/01 ----- Marco Calux inclusão do combobox condiçao de pagamento e consistência dos campos 
	'---- 12/07/01 ----- Marco Calux inclusão do combobox carteira, condição de pagamento e região, que são necessários para inclusão de um novo cliente
	'---- 11/07/01 ----- Marco Calux alteração do Layout no exibição do Tipo de Pessoa (Fisica ou Juridica) e início da inclusão  
	'---- 10/07/01 ----- Marco Calux Validação dos Campos  para inlcusão em Cadastro_cli_for
	'---- 10/07/01 ----- Marco Calux Criação de Funções em VbScript indicando o que se deseja fazer, pesquisa, inclusão ou Limpar os Campos
	'---- 19/12/01 ----- Sguillo - Alteração na pesquisa, agora trata parametros e não pesquisa colunas em branco
	'---- 31/03/05 ----- Fabricio - Alteração nos botoes, pois estavam sendo executados duas vezes, causando msg cliente ja existe ao adicionar o cliente e inclusao do campo indica_cliente = 1
	'---- 24/08/2005 --- Fabricio - Inclusão de Objetos de Entrada no cadastro de clientes, antes e depois dos inserts/update, e 
	'---- 24/08/2005 --- Fabricio - Atualizacao da pesquisa para nao dar erro quando voltar da tela de pesquisa
	'---- 02/01/2006 --- Fabricio - Inclusao de traducao de imagens
	'---- 12/04/2006 --- Fabricio - VAlidação do CPF/CNPJ existente se VALIDA_CGC = .T.
	
	Option Explicit	
	Response.Expires = 0
	Response.CacheControl="no-cache"
						
	xnull = SessionOpen(True,"01","../index.asp","Pedidos_001",True)
	
	Session.LCID = 3081
	
	If IsClean(Session("Cgc_aut")) then
		Response.Redirect("Cat_autentic.asp?page=cat_clientes.asp")
	End If
		
	Response.Buffer = true
	
	Dim xnull, xcidade_padrao, xddi_padrao, xddd_padrao, xuf_padrao, xpais_padrao
	Dim xcliente,xcodigo,xrazao,xjuridica,xcadastro,xcgccpf,xierg, xcarteira, xsql, xresult, xresult_p, xresult_u
	Dim xendereco,xcidade,xuf,xbairro,xcep,xddd1,xtel1,xramal1,xddd2,xtel2,xramal2, xdddfax, xfax
	Dim xramal3,xcontato,xemail,xpais,xddi,xniver, xbanco, xagencia, xncliente, xvalidade, xcontrato, xconta	
	Dim xendereco_e,xcidade_e,xuf_e,xbairro_e,xcep_e ,xddd_e,xtel_e,xpais_e,xddi_e,xie_e,xcgc_ie_e
	Dim xendereco_c,xcidade_c,xuf_c,xbairro_c,xcep_c,xddd_c,xtel_c,xpais_c,xddi_c,xie_c,xcgc_c,x_txt_area
	Dim xstr_sql,x,xnome_agencia,xcount_page,xcd,xuf1, xflag, xAdicionar, xmens, xpesquisa, NumRecordsModified
	Dim xCondicao_pg , xRegiao_cad, xTransportadora, xTipo_cli, xpadrao, xstw, xcomissao
	Dim xAlterar,xFilial_Padrao, xTipo_de_Bloqueio, xregiao_padrao, xcondicao_padrao, xtipo_pontualidade
	Dim xsqla, xsqlb, xsqlc
	dim xnumero, xcomplemento, xnumero_c, xcomplemento_c, xnumero_e, xcomplemento_e

	'-------------------------------------------------- Requests
	xcd 	        = Utrim(Request.QueryString("xcd"), "A")
	xjuridica		= true
	xpesquisa       = Request.Form("pesquisa")
	
	If IsClean(xpesquisa) Then
		xcadastro   = date
	Else
		xcadastro   = Utrim(Request.Form("Cadastro"), "A")
	End If
	
	xAlterar        = Request.Form("altera")
	xAdicionar      = Request.form("adiciona")
	xFlag			= Request.Form("Flag")
	
	xcliente        = Utrim(Request.Form("Cliente"), "A")
	xcodigo         = Utrim(Request.Form("Codigo"), "A")
	xrazao          = Utrim(Request.Form("Razao"), "A")
	xjuridica       = Utrim(Request.Form("juridica"), "A")
	
		
	xcgccpf         = Utrim(Request.form("cgccpf"), "A")
	xierg           = Utrim(Request.Form("Ierg"), "A")
		
	xendereco       = Utrim(Request.Form("Endereco"), "A")
	xnumero			= Utrim(Request.Form("numero"), "A")
	xcomplemento	= Utrim(Request.Form("complemento"), "A")
	xcidade         = Utrim(Request.Form("Cidade"), "A")
	xuf		        = Utrim(Request.Form("uf"), "A")
	xbairro         = Utrim(Request.Form("Bairro"), "A")
	xcep            = Utrim(Request.Form("Cep"), "A")
	xddd1           = Utrim(Request.Form("DDD1"), "A")
	xtel1           = Utrim(Request.Form("Tel1"), "A") 
	xramal1         = Utrim(Request.Form("Ramal1"), "A")
	xddd2           = Utrim(Request.Form("DDD2"), "A")
	xtel2           = Utrim(Request.Form("Tel2"), "A") 
	xramal2         = Utrim(Request.Form("Ramal2"), "A")
	xdddfax         = Utrim(Request.Form("dddfax"), "A")
	xfax            = Utrim(Request.Form("fax"), "A")
	xramal3         = Utrim(Request.Form("Ramal3"), "A")	
	xcontato        = Utrim(Request.Form("contato"), "A")
	xemail          = Utrim(Request.Form("Email"), "A")
	xpais           = Utrim(Request.Form("Pais"), "A")
	xddi            = Utrim(Request.Form("dddi"), "A")
	xniver          = Utrim(Request.Form("aniversario"), "A")
 	
	xendereco_e     = Utrim(Request.Form("Endereco_e"), "A")
	xnumero_e		= Utrim(Request.Form("numero_e"), "A")
	xcomplemento_e	= Utrim(Request.Form("complemento_e"), "A")
	xcidade_e       = Utrim(Request.Form("Cidade_e"), "A")
	xuf_e	        = Utrim(Request.Form("Uf_e"), "A")
	xbairro_e       = Utrim(Request.Form("Bairro_e"), "A")
	xcep_e          = Utrim(Request.Form("Cep_e"), "A")
	xddd_e          = Utrim(Request.Form("Ddd_e"), "A")
	xtel_e          = Utrim(Request.Form("Tel_e"), "A") 
	xpais_e         = Utrim(Request.Form("Pais_e"), "A")
	xddi_e          = Utrim(Request.Form("dddi_e"), "A")
	xie_e 		    = Utrim(Request.Form("ierg_e"), "A")
	xcgc_ie_e       = Utrim(Request.Form("cgccpf_e"), "A")
 	
	xendereco_c     = Utrim(Request.Form("Endereco_c"), "A")
	xnumero_c		= Utrim(Request.Form("numero_c"), "A")
	xcomplemento_c	= Utrim(Request.Form("complemento_c"), "A")
	xcidade_c       = Utrim(Request.Form("Cidade_c"), "A")
	xuf_c	  	    = Utrim(Request.Form("Uf_c"), "A")
	xbairro_c       = Utrim(Request.Form("Bairro_c"), "A")
	xcep_c          = Utrim(Request.Form("Cep_c"), "A")
	xddd_c          = Utrim(Request.Form("Ddd_c"), "A")
	xtel_c          = Utrim(Request.Form("tel_c"), "A") 
	xpais_c         = Utrim(Request.Form("Pais_c"), "A")
	xddi_c          = Utrim(Request.Form("dddi_c"), "A")
	xie_c		    = Utrim(Request.Form("ierg_c"), "A")
	xcgc_c		    = Utrim(Request.Form("cgccpf_c"), "A")

	xbanco          = Utrim(Request.Form("Bco"), "A")
	xagencia        = Utrim(Request.Form("Agencia"), "A")
	xcontrato       = Utrim(Request.Form("ncontrato"), "A")
	xcarteira       = Utrim(Request.Form("carteira"), "A")
	xvalidade       = Utrim(Request.Form("validade"), "A")
	xconta          = Utrim(Request.Form("contacorrente"), "A")
	xncliente       = Utrim(Request.Form("ncliente") , "A")
	x_txt_area      = Utrim(Request.Form("obsped") , "A")
	xnome_agencia   = Utrim(Request.Form("agencia_nome") , "A")
	
	xCondicao_pg    = Utrim(Request.form("condicao_pg"), "A")
	xRegiao_cad     = Utrim(Request.form("regiao"), "A")
	xTransportadora = Utrim(Request.Form("transportadora"), "A")
	xTipo_Cli       = Utrim(Request.Form("tipo_cliente"), "A")	
	xstw 			= ""	
	

	'---------------------------------------------------- Parametros do banco	
	xcidade			 = iif( IsClean(xcidade)         , Request_param("Cidade_padrao", ""), xcidade)			
	xpais_padrao     = iif( IsClean(xpais_padrao)    , Request_param("Pais_padrao","")      , xpais_padrao)
	xpais		     = iif( IsClean(xpais)    		 , Request_param("Pais_padrao","")      , xpais)
	xuf_padrao       = iif( IsClean(xuf_padrao)      , Request_param("Uf_padrao","")            , xuf_padrao)
	xddi_padrao      = iif( IsClean(xddi_padrao)     , Request_param("Ddi_padrao","")           , xddi_padrao)
	xddd_padrao      = iif( IsClean(xddd_padrao)     , Request_param("Ddd_padrao","")          , xddd_padrao)
	xregiao_cad		 = iif( IsClean(xregiao_cad)     , Request_param("Regiao_padrao","")          , xregiao_cad)
	xcondicao_padrao = iif( IsClean(xcondicao_padrao), Request_param("Cond_pgto_padrao", "")      , xcondicao_padrao)
	xtransportadora  = iif( IsClean(xtransportadora) , Request_param("Transportadora_padrao", "") , xtransportadora)	
	xjuridica		 = Iif( IsClean(xJuridica)	     , True,  xJuridica)
								
	xcidade_c = iif( IsClean(xcidade_c), xcidade, xcidade_c)
	xcidade_e = iif( IsClean(xcidade_e), xcidade, xcidade_e)	
		
	If xpesquisa = "Pesquisacep" Then
		
		If not ISclean(xcep) and IsNumeric(xcep) Then
			xsql = "Select * from cadcep where cep8_log = '" & xcep & "'"
			'Set xresult = Stcon.execute(xsql)
			
			'If Not xresult.eof Then
			If SqlQuery( xresult, xsql) Then

				xendereco       = trim(xresult("tipo_log")) & Espacos(1) & xresult("Nome_log")
				xcidade         = trim(xresult("Local_log"))
				xuf		        = trim(xresult("uf_log"))
				xbairro         = trim(xresult("Bairro_1_log"))
	
				If xcep_e = xcep Then 
					xendereco_e     = trim(xendereco)
					xcidade_e       = trim(xcidade)
					xuf_e	        = trim(xuf)
					xbairro_e       = trim(xbairro)
				End If
				
				If xcep = xcep_c Then				
					xendereco_c     = trim(xendereco)
					xcidade_c       = trim(xcidade)
					xuf_c	  	    = trim(xuf)
					xbairro_c       = trim(xbairro)
				End If
			Else
				xmens = Lang.F_traduz("Cep não encontrado no cadastro")
			End If
		Else
			xmens = Lang.F_traduz("Cep Inválido")
		End If
		
	End If
	
	' ---------------------------------------------------------------------------Verifica a existencia de texto no form p/ pesquisa	
	If xpesquisa = "Pesquisa" or Not IsClean(xcd) Then
		If  Not IsClean(xcgccpf) Or Not IsClean(xcodigo) Or  Not IsClean(xrazao)  Or Not IsClean(xcliente)  or Not IsClean(xcd) Then
			xstr_sql =	" select d.Nome_clifor, d.Razao_Social, d.CLifor, c.cgc_cpf, d.rg_ie, d.pj_pf, d.cadastramento, c.condicao_pgto, p.desc_cond_pgto, c.regiao, "
			xstr_sql = xstr_sql & "d.endereco, d.numero, d.complemento, d.cidade, d.bairro, d.email, d.cep, d.uf, d.telefone1, d.ddd1, c.transportadora, c.tipo, "
			xstr_sql = xstr_sql & "d.ramal1,d.ddi, d.contato, d.aniversario,  d.entrega_endereco, d.entrega_numero, d.entrega_complemento,d.pais, d.entrega_cidade, d.entrega_uf,"
			xstr_sql = xstr_sql & "d.entrega_bairro, d.entrega_cep, d.entrega_telefone, d.entrega_ddd,"
			xstr_sql = xstr_sql & "d.entrega_ie, d.entrega_ddi, d.ddd2, d.telefone2, d.ramal2, d.fax, d.dddfax, d.entrega_cgc, d.entrega_pais, d.cobranca_endereco, d.cobranca_numero, d.cobranca_complemento, d.cobranca_cidade,"
			xstr_sql = xstr_sql & "d.cobranca_bairro, d.cobranca_uf, d.cobranca_cep, d.cobranca_telefone,"
			xstr_sql = xstr_sql & "d.cobranca_ddd, d.cobranca_cgc, d.cobranca_ie,"
			xstr_sql = xstr_sql & "d.cobranca_pais, d.cobranca_ddi, d.banco, d.carteira, d.cc_agencia, d.cc_nome_agencia, c.seguro_validade, c.seguro_numero_cliente,"
			xstr_sql = xstr_sql & "d.cc_conta, c.seguro_numero_contrato, c.Obs from Clientes_atacado c, Cadastro_Cli_for d, cond_atac_pgtos p, cliente_repre R "
			If IsClean(xcd)  Then	
				xstr_sql = xstr_sql & "where c.cliente_atacado = d.Nome_clifor AND ("
				If Not IsClean(xcliente) Then
					xstw = xstw & " Nome_Clifor like '" & xcliente & "' "
				End If
				If Not IsClean(xrazao) Then
					If Not IsClean(xstw) Then xstw = xstw & " or "
					xstw = xstw & " Razao_Social Like '" & xrazao & "' "
				End If
				If Not IsClean(xcodigo) Then
					If Not IsClean(xstw) Then xstw = xstw & " or "
					xstw = xstw & " d.Clifor Like '" & xcodigo & "' "
				End If
				If Not IsClean(xcgccpf) Then
					If Not IsClean(xstw) Then xstw = xstw & " or "
					xstw = xstw & " c.cgc_cpf Like '" & LimpaCgc(xcgccpf) & "' "
				End If
				
				xstr_sql = xstr_sql & xstw & ") and  c.condicao_pgto = p.condicao_pgto and R.Cliente_atacado = c.Cliente_atacado and "
				xstr_sql = xstr_sql & Iif(Session("ACESSO_GERENCIAL_INTERNET"), "R.Representante in (Select Representante from representantes where representante = '" & Session("Nome_aut") & "' or gerente = '" & Session("Nome_aut") & "')" ,"R.Representante = '" & Session("nome_aut") & "'") 
				
			Else
				xstr_sql = xstr_sql & "where c.cliente_atacado = d.Nome_clifor and c.Clifor = '" & xcd & "' and c.condicao_pgto = p.condicao_pgto and R.Cliente_atacado = c.Cliente_atacado and R.Representante = '" & Session("Nome_aut") & "' "
			End if
			
			Dim xresultCli, xTotCli
			
			Set xresultCli = Server.CreateObject("ADODB.RecordSet")
			xresultCli.CursorType = AdopenStatic
			xresultCli.open xstr_sql, stcon,,,Adcmdtext
			xTotCli = xresultCli.RecordCount
			
			IF xTotCli = 1 Then
				'------------------------------------------------------ Recordset do Cliente 
				xcliente    	= Trim(xresultCli("Nome_clifor"))
				xcodigo     	= Trim(xresultCli("Clifor"))
				xrazao      	= Trim(xresultCli("Razao_Social"))
				xjuridica   	= Trim(xresultCli("pj_pf"))			
				
				xcadastro   	= Trim(xresultCli("cadastramento"))
				xcgccpf     	= Trim(xresultCli("cgc_cpf"))
				xierg       	= Trim(xresultCli("rg_ie"))
				xendereco   	= Trim(xresultCli("endereco"))
				xnumero		   	= Trim(xresultCli("NUMERO"))
				xcomplemento   	= Trim(xresultCli("COMPLEMENTO"))
				xcidade     	= Trim(xresultCli("cidade"))
				xuf		    	= Trim(xresultCli("uf"))	 
				xbairro     	= Trim(xresultCli("bairro"))
				xcep        	= Trim(xresultCli("cep"))
				xddd1       	= Trim(xresultCli("ddd1"))
				xtel1       	= Trim(xresultCli("telefone1"))
				xramal1     	= Trim(xresultCli("ramal1"))
 				xddd2       	= Trim(xresultCli("ddd2"))
 				xtel2       	= Trim(xresultCli("telefone2"))
				xramal2     	= Trim(xresultCli("ramal2"))
				xfax			= Trim(xresultCli("fax"))
				xdddfax			= Trim(xresultCli("dddfax"))
				xcontato    	= Trim(xresultCli("contato"))
				xemail      	= Trim(xresultCli("email"))
				xpais       	= Trim(xresultCli("pais"))
				xddi        	= Trim(xresultCli("ddi"))
				xniver      	= Trim(xresultCli("aniversario"))
'-------------------	----------------------------------- Recordset da Enterga
				xendereco_e 	= Trim(xresultCli("entrega_endereco"))
				xnumero_e		= Trim(xresultCli("entrega_numero"))
				xcomplemento_e 	= Trim(xresultCli("entrega_complemento"))
				xcidade_e   	= Trim(xresultCli("entrega_cidade"))
				xuf_e			= Trim(xresultCli("entrega_uf"))
				xbairro_e   	= Trim(xresultCli("entrega_bairro"))
				xcep_e      	= Trim(xresultCli("entrega_cep"))
				xddd_e      	= Trim(xresultCli("entrega_ddd"))
				xtel_e      	= Trim(xresultCli("entrega_telefone"))
				xpais_e     	= Trim(xresultCli("entrega_pais"))
				xddi_e      	= Trim(xresultCli("entrega_ddi"))
				xie_e 			= Trim(xresultCli("entrega_ie"))
				xcgc_ie_e   	= Trim(xresultCli("entrega_cgc"))	
'-------------------	----------------------------------- Recordset da Cobranca
				xendereco_c 	= Trim(xresultCli("cobranca_endereco"))
				xnumero_c		= Trim(xresultCli("cobranca_numero"))
				xcomplemento_c 	= Trim(xresultCli("cobranca_complemento"))
				xcidade_c   	= Trim(xresultCli("cobranca_cidade"))
				xuf_c			= Trim(xresultCli("cobranca_uf"))
				xbairro_c   	= Trim(xresultCli("cobranca_bairro"))
				xcep_c      	= Trim(xresultCli("cobranca_cep"))
				xddd_c      	= Trim(xresultCli("cobranca_ddd"))
				xtel_c      	= Trim(xresultCli("cobranca_telefone"))
				xpais_c     	= Trim(xresultCli("cobranca_pais"))
				xddi_c      	= Trim(xresultCli("cobranca_ddi"))
				xie_c			= Trim(xresultCli("cobranca_ie"))
				xcgc_c			= Trim(xresultCli("cobranca_cgc"))
'-------------------------------------------------------	Recordset Dados Bancarios e Seguros
				xbanco      	= Trim(xresultCli("banco"))
				xagencia    	= Trim(xresultCli("cc_agencia"))
				xcontrato   	= Trim(xresultCli("seguro_numero_contrato"))
				xcarteira  		= Trim(xresultCli("carteira"))
				xvalidade   	= Trim(xresultCli("seguro_validade"))
				xconta     		= Trim(xresultCli("cc_conta")) 
				xncliente 	    = Trim(xresultCli("seguro_numero_cliente"))
				x_txt_area   	= Trim(xresultCli("obs"))
				
				xnome_agencia   = Trim(xresultCli("cc_nome_agencia")) 										
				xCondicao_pg    = Trim(xresultCli("condicao_pgto"))
				xRegiao_cad     = Trim(xresultCli("regiao"))
				xTransportadora = Trim(xresultCli("transportadora"))
				xTipo_Cli       = Trim(xresultCli("tipo"))
'				Session("ConsultaCliente") = ""
				xflag = "Flag"
			Else
				If xTotCli < 1 Then
					xmens = Lang.F_traduz("Nenhum Cliente Encontrado")
				Else
					Session("ConsultaCliente") = xstr_sql
					Response.Redirect "cat_dados_pesquisa.asp"
				End if
			End if
			
			GravaLogs Request.ServerVariables("Script_Name"), "Pesquisou o Cliente Cnpj:" &  xcgccpf &  "Codigo:" & xcodigo & "Cliente:" & xcliente & "Razao:" & xrazao ,Session("user")
		Else
			xmens = Lang.F_traduz("Digite algum filtro para a procura nas opções logo abaixo! ")
			xflag = ""
		End If
				
	End If	
'---------------------------Consistência de Campos 
	If xAdicionar = "Adicionar" Then

		xmens = Valida()
		
		'------Caso xmens vazio verefica se há algum registro com o mesmo nome cli, codigo, cgccpf, ierg, razao caso contrário inclui

		If IsClean(xMens) Then		
			
			'---------Antes de incluir um novo cliente a query abaixo é executada vereficando se já existe um cliente cadastrado		
			xsql = "select d.Nome_Clifor, d.clifor, d.cgc_cpf, d.rg_ie, d.razao_social from "
			xsql =  xsql & " cadastro_cli_for d where  "
			xsql =  xsql & "d.Nome_Clifor = '" & xcliente & "'"
			If Request_Param("VALIDA_CGC", true) Then
				xsql = xsql & " or d.cgc_cpf = '" & LimpaCgc(xcgccpf) & "'"
			End if
			
			'----------------------------Inserindo um novo cliente caso a pesquisa acima retorne vazia
			If not SqlQuery(xresult, xsql) Then
				
				do
					'--------- Defini o próximo código valido para o cliente
					xcodigo = Sequenciais("Clientes_atacado.Clifor", true)
					
					xsql = "select d.Nome_Clifor, d.clifor, d.cgc_cpf,d.rg_ie, d.razao_social from "
					xsql =  xsql & " cadastro_cli_for d where "
					xsql =  xsql & " d.clifor = '" & xcodigo & "'"
				loop until not SqlQuery(xresult, xsql)
				
				xnull = User_Entrada("User_before_insert_cliente", Array(xcodigo, xcliente, xrazao, LimpaCgc(xcgccpf)), xmens)
				
				If IsClean(xmens)  Then
				
			 		xsqla = "insert into cadastro_cli_for "
					xsqla =  xsqla & "(Nome_cliFor,clifor,Cod_clifor,Razao_Social,pj_pf,cadastramento, "
					xsqla =  xsqla & "cgc_cpf, rg_ie, endereco, numero, complemento, cidade, uf, bairro, cep, ddd1, telefone1, ramal1, "
					xsqla =  xsqla & "ddd2, telefone2, ramal2, fax, dddfax,contato, email, pais, ddi, aniversario, "
					xsqla =  xsqla & "entrega_endereco, entrega_numero, entrega_complemento, entrega_cidade, entrega_uf, entrega_bairro, entrega_cep, entrega_ddd, "
					xsqla =  xsqla & "entrega_telefone, entrega_pais, entrega_ddi, entrega_ie, entrega_cgc, "
					xsqla =  xsqla & "cobranca_endereco, COBRANCA_NUMERO, COBRANCA_COMPLEMENTO, cobranca_cidade, cobranca_uf, cobranca_bairro, cobranca_cep, cobranca_ddd, "
					xsqla =  xsqla & "cobranca_telefone, cobranca_pais, cobranca_ddi, cobranca_ie, cobranca_cgc, "
					xsqla =  xsqla & "banco, cc_agencia, carteira,cc_conta, cc_nome_agencia, cobranca_razao_social, entrega_razao_social, indica_cliente) "
					xsqla =  xsqla & "Values ('" & xcliente & "','"& xcodigo & "','"& xcodigo & "','"& xrazao & "','"& xjuridica &"',Getdate(), "
					xsqla =  xsqla & "'" & LimpaCgc(xcgccpf) & "', '" & xierg & "', '" & xendereco & "','" & xnumero & "','" & xcomplemento & "','" & xcidade & "', '" & xuf & "', '" & xbairro & "',"
					xsqla =  xsqla & "'" & xcep & "', '" & xddd1 & "','" & xtel1 & "', '" & xramal1 & "','" & xddd2 & "','" & xtel2 & "',"
					xsqla =  xsqla & "'" & xramal2 & "','" & xfax & "','" & xdddfax & "','" & xcontato & "', '" & xemail & "',"
					xsqla =  xsqla & "'" & xpais & "','" & xddi & "','" & DataExtend(xniver) & "', '" & xendereco_e & "','" & xnumero_e & "','" & xcomplemento_e & "','" & xcidade_e & "','" & xuf_e & "',"
					xsqla =  xsqla & "'" & xbairro_e & "','" & xcep_e & "','" & xddd_e & "','" & xtel_e & "','" & xpais_e & "','" & xddi_e & "',"
					xsqla =  xsqla & "'" & xie_e & "','" & LimpaCgc(xcgc_ie_e) & "','" & xendereco_c & "','" & xnumero_c & "','" & xcomplemento_c & "','" & xcidade_c & "','" & xuf_c & "','" & xbairro_c & "',"
					xsqla =  xsqla & "'" & xcep_c & "','" & xddd_c & "','" & xtel_c & "','" & xpais_c & "','" & xddi_c & "','" & xie_c & "',"
					xsqla =  xsqla & "'" & LimpaCgc(xcgc_c) & "','" & xbanco & "','" & xagencia & "','" & xcarteira & "','" & xconta & "',"
					xsqla =  xsqla & "'" & xnome_agencia & "','"& xrazao & "','"& xrazao & "',1)  " 
					
					Stcon.Execute xsqla, NumRecordsModified
					
					'--------Recupera valor dos parametros 
					
					xpadrao            = Request_param("conceito_cli_atac_padrao", "")	
					xFilial_Padrao     = Request_param("Filial_Padrao", "")	
					xTipo_de_Bloqueio  = Request_param("Tipo_bloqueio_padrao", "")
					xTipo_Pontualidade = Request_param("Pontual_cli_atac_padrao", NULL)
					
					'--------Inserindo im novo registro na tabela clientes_atacado
					
					xsqlb = "insert into clientes_atacado(cliente_atacado,clifor, cod_cliente, condicao_pgto, "
					xsqlb = xsqlb & "regiao,filial,pontualidade,Transportadora,conceito, "
					xsqlb = xsqlb &  "tipo,tipo_bloqueio, Bloqueio_faturamento,cgc_cpf,seguro_numero_contrato,matriz_cliente, obs)"
					xsqlb = xsqlb &  "values( "					
					xsqlb = xsqlb &  " '" & xcliente & "','" & xcodigo & "','" & xcodigo & "','" & xCondicao_pg & "','" & xRegiao_Cad & "','"& xFilial_Padrao & "','" & xtipo_pontualidade & "', "
					xsqlb = xsqlb &  " '" & xtransportadora & "','" & xpadrao & "','" & xTipo_Cli & "','" & xTipo_de_Bloqueio & "','" & DataExtend(xcadastro) & "','" & xcgccpf & "', '" & xncliente  & "','"& xcliente & "','" & x_txt_area & "')"
					
					Stcon.execute(xsqlb)
					
					xsql = "Select Comissao From representantes where representante = '" & session("nome_aut") & "'"
					xcomissao = Iif(SqlQuery(xresult, xsql), xresult("Comissao"), 0.00)
					
					xsqlc = "Insert into Cliente_repre (Representante, Cliente_atacado, Comissao, REPRESENTANTE_PRINCIPAL) Values ('" & Session("Nome_aut") & "','" & xcliente & "','" & xcomissao & "',0) "
					
					Stcon.Execute xsqlc, NumRecordsModified
					GravaLogs Request.ServerVariables("Script_Name"), "Incluiu o Cliente de Cnpj=" &  xcgccpf ,Session("user")			

					xnull = User_Entrada("User_after_insert_cliente", Array(xcodigo, xcliente, xrazao, LimpaCgc(xcgccpf)), xmens)
					
					'----------------------- Estou Setando o Flag do MArcos neste ponto para apresentar o botão de alterar após a inclusão.
					xflag = "Flag"
					
					xmens = xmens & espacos(1) & Lang.F_traduz("Cliente Incluído com Sucesso!")
				End if
				
			Else
				if xresult("cgc_cpf") = LimpaCgc(xcgccpf) then
					xmens = xmens & espacos(1) & Lang.F_Traduz("CPF/CNPJ já existe")
				else
					xmens = xmens & espacos(1) & Lang.F_Traduz("Cliente já existe")
				end if
			End If
		End If
	End If
	
	If xAlterar = "Altera" Then

		xnull = User_Entrada("User_before_update_cliente", Array(xcodigo, xcliente, xrazao, LimpaCgc(xcgccpf)), xmens)
		xmens = xmens & Valida()

		If IsClean(xmens) Then
			
			xsql = "Update cadastro_cli_for Set cgc_cpf = '"& LimpaCgc(xcgccpf) & "',razao_social = '" & xrazao & "',rg_ie = '" & xierg & "', pj_pf = '"& xjuridica & "',"
			xsql = xsql & "carteira = '"& xcarteira & "', Banco = '"& xbanco & "', cep = '"& xcep & "', endereco = '"& xendereco &"', numero = '"& xnumero &"',complemento = '"& xcomplemento &"', "
			xsql = xsql & "bairro = '" & xbairro & "', cidade = '" & xcidade & "', uf = '" & xuf & "', telefone1 = '" & xtel1 & "', "
			xsql = xsql & "pais = '" & xpais & "', ddi = '" & xddi & "', telefone2 = '" & xtel2 & "', fax = '" & xfax & "', "
			xsql = xsql & "ddd1 = '"& xddd1 &"', ramal1 = '" & xramal1 & "', ramal2 = '"& xramal2 & "', ddd2 = '"& xddd2 & "',"
			xsql = xsql & "cobranca_endereco = '"& xendereco_c & "', cobranca_numero = '"& xnumero_c &"', cobranca_complemento = '"& xcomplemento_c &"', cobranca_cidade = '"& xcidade_c & "',"
			xsql = xsql & "cobranca_bairro = '"& xbairro_c & "',dddfax = '"& xdddfax & "',"
			xsql = xsql & " cobranca_uf = '"& xuf_c & "', cobranca_cep = '"& xcep_c & "', cobranca_telefone = '"& xtel_c & "', "
			xsql = xsql & "entrega_endereco = '"& xendereco_e & "', entrega_numero = '"& xnumero_e &"', entrega_complemento = '"& xcomplemento_e &"', entrega_cidade = '"& xcidade_e & "', entrega_uf = '"& xuf_e & "', "
			xsql = xsql & "entrega_bairro = '"&	xbairro_e & "', entrega_cep = '"& xcep_e & "', entrega_telefone = '"& xtel_e & "', " 
			xsql = xsql & "cobranca_ddd = '"& xddd_c & "', contato = '"& xcontato   & "', cobranca_cgc = '"& LimpaCgc(xcgc_c) & "', "
			xsql = xsql & "cobranca_ie = '"& xie_c & "',aniversario = '"& DataExtend(xniver) & "', "
			xsql = xsql & "entrega_ddd = '"& xddd_e &"', entrega_cgc = '"& LimpaCgc(xcgc_ie_e) & "',entrega_ie = '"& xie_e & "',"
			xsql = xsql & "cc_agencia = '"& xagencia & "', cc_conta = '" & xconta   & "', cc_nome_agencia = '"& xnome_agencia & "',"
			xsql = xsql & "email = '"& xemail & "', entrega_pais = '"& xpais_e & "',cobranca_pais = '" & xpais_c & "',"
			xsql = xsql & "entrega_ddi = '" & xddi_e & "', cobranca_ddi = '" & xddi_c & "', cobranca_razao_social = '" & xrazao & "', Entrega_razao_social='" & xrazao & "' "
			xsql = xsql & "where Nome_clifor = '" & xcliente & "' or clifor = '" & xcodigo & "'"

			Stcon.Execute(xsql)

			xsql = "Update clientes_atacado set "
			xsql =  xsql & "transportadora = '"& xtransportadora & "', condicao_pgto = '"& xCondicao_pg &"', obs = '"& x_txt_area & "', "
			xsql =  xsql & "regiao = '"& xRegiao_cad &"', Tipo = '"& xTipo_Cli &"', seguro_numero_contrato ='" & xcontrato & "',"
			xsql =  xsql & "seguro_numero_cliente = '" & xncliente & "', seguro_validade = '"& DataExtend(xvalidade) &"', cgc_cpf = '"& xcgccpf &"'"
			xsql =  xsql & "where cliente_atacado = '"& xcliente &"' or clifor ='"& xcodigo &"'"

			Stcon.Execute(xsql)			
			GravaLogs Request.ServerVariables("Script_Name"), "Alterou o Cliente de Cnpj =" &  xcgccpf  ,Session("user")
			
			xnull = User_Entrada("User_after_update_cliente", Array(xcodigo, xcliente, xrazao, LimpaCgc(xcgccpf)), xmens)
			
			xmens = xmens & espacos(1) & Lang.F_traduz("Cliente atualizado com Sucesso!")
			
		End If
		xflag = "Flag"
	End If
%>
<!--#include file="../libs/Cat_functions.asp" -->
<!--#include file="../libs/cat_entrada.asp" -->
<!--#include file="../libs/adovbs.inc" -->
<HTML>
<head>
<link href="../css/style.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; chaset=ISO-8859-1">
</head>

<Script Language="VBScript" type="text/vbscript">
<!--	
	Sub Enviar_Onclick() 				
		Document.login.adiciona.value = "Adicionar"
		Document.login.pesquisa.value = ""		
		Document.login.submit()
		
	End Sub	
	
	Sub Pesquisa_Onclick() 
		Document.login.pesquisa.value = "Pesquisa"
		Document.login.adiciona.value = ""

		Document.login.flag.value   = "Flag"
		Document.login.submit()
	End Sub	
	
	Sub Pesquisacep_Onclick() 
		Document.login.pesquisa.value = "Pesquisacep"
		Document.login.adiciona.value = ""

		Document.login.flag.value   = ""
		Document.login.submit()
	End Sub		
	
	Sub Altera_Onclick() 
		Document.login.altera.value = "Altera"				
		Document.login.pesquisa.value = ""
		Document.login.adiciona.value = ""
		
		Document.login.submit()
	End Sub	

	Sub Limpar_onclick()

		Dim Form
		Set Form = Document.Login
		
		Document.Login.cadastro.value = date
		Document.Login.cliente.value = "" 
		Document.Login.Codigo.Value = "" 
		Document.Login.razao.Value = ""
		Document.Login.ierg.Value = ""  
		Document.Login.cgccpf.Value = "" 
		Document.Login.endereco.Value = ""
		Document.Login.numero.Value = ""
		Document.Login.complemento.Value = ""
		Document.Login.cidade.Value = "" 
		Document.Login.bairro.Value = ""
		Document.Login.cep.Value = ""  
		Document.Login.ddd1.Value = "" 
		Document.Login.tel1.Value = "" 
		Document.Login.ramal1.Value = ""
		Document.Login.ddd2.Value = ""
		Document.Login.tel2.Value = ""
		Document.Login.ramal2.Value = ""
		Document.Login.dddfax.Value = ""
		Document.Login.fax.Value = ""
		Document.Login.contato.Value = ""
		Document.Login.email.Value = ""
		Document.Login.dddi.Value = ""	
		Document.Login.aniversario.Value = ""
		Document.Login.endereco_e.Value = ""
		Document.Login.complemento_e.Value = ""
		Document.Login.numero_e.Value = ""
		Document.Login.cidade_e.Value = ""
		Document.Login.bairro_e.Value = ""
		Document.Login.cep_e.Value = ""
		Document.Login.Ddd_e.Value = ""
		Document.Login.Tel_e.Value = ""
		Document.Login.cgccpf_e.Value = ""
		Document.Login.dddi_e.Value = ""
		Document.Login.ierg_e.Value = ""   	 					
		Document.Login.Endereco_c.Value = ""
		Document.Login.complemento_c.Value = ""
		Document.Login.numero_c.Value = "" 
		Document.Login.Cidade_c.Value = ""   	 					
		Document.Login.Bairro_c.Value = ""   	 							
		Document.Login.Cep_c.Value = ""   	 								
		Document.Login.Ddd_c.Value = ""   	 								
		Document.Login.Tel_c.Value = ""   	 									 									
		Document.Login.dddi_c.Value = ""   	 											
		Document.Login.ierg_c.Value = ""   	 											
		Document.Login.cgccpf_c.Value = ""   	 											
		Document.Login.Agencia.Value = ""   	 													
		Document.Login.ncontrato.Value = ""   	 																
		Document.Login.validade.Value = ""   	 																				
		Document.Login.contacorrente.Value = ""   
		Document.Login.agencia_nome.Value = ""   
		Document.Login.ncliente.Value = ""   
		Document.Login.Transportadora.value = ""
		Document.Login.obsped.value = ""
		Set Form = Nothing 

		Document.login.submit()
			 																					
End Sub	

Function Copiar(xpara1, xpara2, xpara3)

	xpara1 = "Document.Login." & xpara1
	xpara2 = "Document.Login." & xpara2
	xpara3 = "Document.Login." & xpara3
	
	If Document.Login.ChkEntrega.checked Then
		Eval(xpara2).value = Eval(xpara1).Value
	End If
	
	If Document.Login.ChkCobranca.checked Then
		Eval(xpara3).value = Eval(xpara1).Value
	End If	

End Function
-->
</Script>

<!--#include file="../libs/cat_script.asp" -->
<body >

<form name="login" action= "<%= Request.Servervariables("Script_name") %>" method=post>
<input type='hidden' name='adiciona' >
<input type='hidden' name='pesquisa' >
<input type='hidden' name='flag' >
<input type='hidden' name='altera'>
<table width="90%" align="center">
    <Tr>
        <%
        Response.Write "<td><p class='tituloPagina'>" & Lang.F_traduz("Cadastro de Clientes") & "</p></td>"
        Response.Write "<td align='right'>" & Icons_menu("","000000000","B") & "</td>"
        Response.Write "<Tr><Td align ='center' colspan='2'>" & espacos (5) & Faviso(xmens) & "</Td></Tr>"
        %>	
    </tr>
</table>
<%
'--------------- Caso a autenticação tenha sido feita por um cliente.
If Session("tipo") <> "R" Then
	xmens = Lang.f_traduz("Desculpe, mas está consulta está liberada somente para Representantes.") & "<Br>"
	xmens = xmens & Lang.f_traduz("Faça Log-off;") & "<Br>"	
	xmens = xmens & Lang.f_traduz("Entre em clientes;") & "<Br>"		
	xmens = xmens & Lang.f_traduz("e registre-se com uma senha de Representante") & "<Br>"
	Response.Write "<Br><Br><Br><Br><Br>" & FAviso(Lang.F_traduz(xmens))
	Response.End
End If
%>
<table class="tblListaDetalhes" border = 0 cellpadding="0" cellspacing="0" width=70%" align="center" >
<Tr>
	<Td>
	<%
		Response.write "<Table class='tblListaDetalhes' style='background-color:#CCCCCC' border=0 cellpadding='4' cellspacing='1'   width='95%'>"
		
		Response.Write "<Tr><Td class='tituloDetalhe'  width='100'>" & Lang.F_Traduz("Cliente") &  "</td>"
		Response.Write "<Td class='td_verd_bk' align='left' colspan='2'>"
		Response.Write "<input type='Text' name='cliente' class='ip_txt' size='50' maxlength='25' value='" & xcliente & "'> </td>"
		
		Response.Write "<Td class='tituloDetalhe' >" & Lang.F_Traduz("Código") & "</td>"
		Response.Write "<Td class='td_verd_bk' >"
		Response.Write "<input type='Text' Name='codigo' class='ip_txt' Readonly size='10' maxlength='6' value='" & xcodigo & "'></td></tr>"
				
		Response.Write "<Tr><Td class='tituloDetalhe' >" & Lang.F_Traduz("Razão Social") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' name='razao' class='ip_txt' size='50' maxlength='40' value='" & xrazao & "'></Td>"
		
		Response.Write "<Td class='tituloDetalhe' align='left' width=>"
		Response.Write Lang.F_Traduz("Pessoa") & espacos(3)
		Response.write "<select name='juridica' class = 'sel' onchange='JavaScript:Troca(this)'>"
				
		Response.Write "<option value = '1' " & Iif(xjuridica, "Selected", "") & " >Juridica</option>"
		Response.Write "<option value = '0' " & Iif(xjuridica, "", "Selected") & " >Física</option>"

		Response.Write "</select>"
		Response.Write "</td>"
		Response.Write "<Td class='tituloDetalhe'  >" & Lang.F_Traduz("Cadastramento") & "</td>"
		Response.Write "<Td class='td_verd_bk'  >" & vbCrLf

		Response.Write "<input type='Text' ReadOnly Name='cadastro'  class='ip_txt' size='12' value='" & xcadastro & "'></td></tr>"	 & vbCrLf
		
		Response.Write "<Tr><Td class='tituloDetalhe'   >" & Lang.F_Traduz("Cnpj/Cpf") & "</td>" & vbCrLf
		Response.Write "<Td class='td_verd_bk' align='Left' colspan='2'>" & vbCrLf
		Response.Write "<input type='Text' name='cgccpf' class='ip_txt' size='23' maxlength='18' value='" & xcgccpf & "' id='cgccpf' onkeypress=""javascript:return txtBoxFormat('" & Request_Param("MASCARA_CGC_PADRAO","99.999.999/9999-99") & "',event);"" onkeyup = ""Copiar 'cgccpf','cgccpf_e','cgccpf_c'""  onchange =""Copiar 'cgccpf','cgccpf_e','cgccpf_c'""></td>" & vbCrLf
		Response.Write "<Td class='tituloDetalhe'  >" & Lang.F_Traduz("IE/RG") & "</td>" & vbCrLf
		Response.Write "<Td class='td_verd_bk' align='Left' colspan='2'>" & vbCrLf
		Response.Write "<input type='Text' Name='ierg' class='ip_txt'  size='19' maxlength='18' value='" & xierg & "' onkeyup = ""Copiar 'ierg','ierg_e','ierg_c'""  onchange =""Copiar 'ierg','ierg_e','ierg_c'""></td></tr>"		 & vbCrLf
		Response.Write "<Tr><Td class='td_verd_bk' align='right' colspan='4'></td><Td class='td_verd_bk'  colspan='2'>" & "<img src='../Images/" & Lang.F_traduz("btLimpar.png") & "'  hspace='1' name='Limpar'  onmouseover=Style.cursor='hand' onmouseout=Style.cursor='' onclick='Limpar_Onclick()'>"
		
		'----Funções em asp que chamam funções em VbScrip que indica em qual ícone foi clicado, incluir ou consulta
		Exibe_Botao_Pesquisa()
		
		If ((xFlag <> "Flag")) and Session("Inclui_cliente_Internet")  Then
			Exibe_Botao_Adicionar()
		End If
		
		If ((xFlag = "Flag") or Not IsClean(xcd)) and Session("Altera_cliente_internet") Then
			Exibe_Botao_Update()
		End IF		
		
		Response.Write  "</td></tr>"
		Response.Write "</Table>" & vbCrLf
		
	%>
	<Br>
	</Td>
</Tr>
<Tr>
	<Td>
	<%
		Response.write "<Table class='tblListaDetalhes' border=0 cellpadding='3' cellspacing='1'   width='95%'>"	
		Response.Write "<Tr><Td class='tituloDetalhe'  width='100'>" & Lang.F_Traduz("Endereço") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' name='endereco' class='ip_txt' size='35' maxlength='40' value='" & xendereco & "' onkeyup = ""Copiar 'endereco','endereco_e','endereco_c'""  onchange =""Copiar 'endereco','endereco_e','endereco_c'""></td>"		
		Response.write "<td  class='tituloDetalhe' >"& Lang.F_Traduz("Número") &"</td><td><input name='numero' type='textbox'  class='ip_txt' maxlength='10' onkeyup = ""Copiar 'numero','numero_e','numero_c'"" value='"& xnumero &"'></td>"
		Response.write "<td  class='tituloDetalhe' >"& Lang.F_Traduz("Complemento") &"</td><td><input name='complemento' type='textbox'  class='ip_txt' maxlength='60' size='40' onkeyup = ""Copiar 'complemento','complemento_e','complemento_c'"" value='"& xcomplemento &"'></td></tr>"	
				
		Response.Write "<Tr><Td class='tituloDetalhe' >" & Lang.F_Traduz("Cidade") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' name='cidade' size='35' maxlength='35' class='ip_txt' value='" & xcidade & "'  onkeyup = ""Copiar 'cidade','cidade_e','cidade_c'""  onchange =""Copiar 'cidade','cidade_e','cidade_c'""></td>"
		Response.Write "<Td class='tituloDetalhe' >" & Lang.F_Traduz("UF") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		'----------------------------------------------------- Combo Unidades Federativas			

		Response.Write "<select Name='uf' class='sel' value = '"& xuf & "' onkeyup = ""Copiar 'uf','uf_e','uf_c'""  onchange =""Copiar 'uf','uf_e','uf_c'"">"
		
		xsql = "Select * from Unidades_federacao order by uf"		
		Set xresult_u = Stcon.Execute(xsql)
		
		If Not xresult_u.eof Then				
			Do While Not xresult_u.eof
				If IsClean(xuf) Then
					Response.Write "<Option Value = '" & xresult_u("uf") & "'" & Iif(UTrim(xuf_padrao,"A") = UTrim(xresult_u("uf"),"A"), "Selected", "") & ">" & xresult_u("uf") & "</option>"			
				Else
					Response.Write "<Option Value = '" & xresult_u("uf") & "'" & Iif(UTrim(xuf,"A") = UTrim(xresult_u("uf"),"A"), "Selected", "") & ">" & xresult_u("uf") & "</option>"			
				End If 
				xresult_u.MoveNext				
			Loop
		Else
			Response.Write "<Option value = '" & xuf_padrao & "'>" & xuf_padrao & "</OPTION>"  	
		End If	
		Response.Write "</Select></td>"
		'-------------------------------------------------------------------			
		Response.Write "<Td class='tituloDetalhe' >" & Lang.F_Traduz("Telefone") & " 1</td>"
		Response.Write "<Td class='td_verd_bk' align='Left' >"
		Response.Write "(<input type='Text' Name='ddd1' class='ip_txt' size='5' maxlength='3' value='"& xddd1 &"' onkeyup = ""Copiar 'ddd1','ddd_e','ddd_c'""  onchange =""Copiar 'ddd1','ddd_e','ddd_c'"">)"
		Response.Write "<input type='Text' Name='tel1' class='ip_txt' size='10' maxlength='9' value='"& xtel1 &"' onkeyup = ""Copiar 'tel1','tel_e','tel_c'""  onchange =""Copiar 'tel1','tel_e','tel_c'""> "
		Response.Write "r.<input type='Text' Name='ramal1' class='ip_txt' size='5' maxlength='5'value='"& xramal1 &"'></td></tr>"				
		Response.Write "<Tr><Td class='tituloDetalhe' >" & Lang.F_Traduz("Bairro") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' size='35'  maxlength='25' name='bairro' class='ip_txt' value='" & xbairro & "' onkeyup = ""Copiar 'Bairro','Bairro_e','Bairro_c'""  onchange =""Copiar 'Bairro','Bairro_e','Bairro_c'""></td>"
		Response.Write "<Td class='tituloDetalhe'  >" & Lang.F_Traduz("Cep") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' name='cep' class='ip_txt' size='9' maxlength='8' value='" & xcep &  "' onkeyup = ""Copiar 'cep','cep_e','cep_c'""  onchange =""Copiar 'cep','cep_e','cep_c'"">&nbsp;&nbsp;<input type=image  src=..\images\bt_detalhe.png name=pesquisacep onclick ='Pesquisacep_Onclick()' align=absmiddle></td>"			
		
		Response.Write "<Td class='tituloDetalhe'  size='15' maxlength='15'>" & Lang.F_Traduz("Telefone") & " 2 </td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "(<input type='Text' Name='ddd2' class='ip_txt' size='5' maxlength='3' value='"& xddd2 &"'>)<input type='Text' Name='tel2' class='ip_txt' size='10' maxlength='9' value='"& xtel2 &"'> r.<input type='Text' Name='ramal2' class='ip_txt' size='5' maxlength='5' value='"& xramal2 &"'></td></tr>"								
		Response.Write "<Tr><Td class='tituloDetalhe'  >" & Lang.F_Traduz("País") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'> "
		'----------------------------------------------------- Combo Paises
		Response.Write "<select Name='pais' class='sel' onkeyup = ""Copiar 'pais','pais_e','pais_c'""  onchange =""Copiar 'pais','pais_e','pais_c'"">"
		
		xsql = "Select * From paises order by pais"
		Set xresult_p = Stcon.execute(xsql)				
								
		'If Not xresult_p.eof  Then
		'	Do While not xresult_p.eof		
		'		Response.Write "<Option Value='" & Trim(xresult_p("Pais")) & "'" &Iif(UTrim(xresult_p("Pais"),"A") = UTrim(xpais,"A"), " Selected ", "") &  ">" & Trim(xresult_p("Pais")) & "</Option>"					
		'		xresult_p.Movenext		
		'	Loop	
		'Else
		'	Response.Write "<Option value='"& Trim(xpais_padrao) &"'>" & Trim(xpais_padrao) & "</Option>"			
		'End If		
		
		If Not xresult_p.eof Then
			Do While not xresult_p.eof	
				If IsClean(xpais_c) then			
					Response.Write "<Option Value='" & Trim(xresult_p("Pais")) & "'" & Iif(UTrim(xresult_p("Pais"),"A") = UTrim(xpais_padrao,"A"), " Selected ", "") &  ">" & Trim(xresult_p("Pais")) & "</Option>"			
				Else
					Response.Write "<Option Value='" & Trim(xresult_p("Pais")) & "'" & Iif(UTrim(xresult_p("Pais"),"A") = UTrim(xpais,"A"), " Selected ", "") &  ">" & Trim(xresult_p("Pais")) & "</Option>"			
				End If
				xresult_p.Movenext	
			Loop
		Else
			Response.Write "<option value='"& xpais_padrao & "'>" & xpais_padrao & "</option>"
		End If	
		
		
		Response.Write "</Select></td>"
				
		
		'-------------------------------------------------------------------
		Response.Write "<Td class='tituloDetalhe' >" & Lang.F_Traduz("DDI") & " </td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "(<input type='Text' Name='dddi' class='ip_txt' size='5' maxlength='5' value='" & xddi & "' onkeyup = ""Copiar 'dddi','dddi_e','dddi_c'""  onchange =""Copiar 'dddi','dddi_e','dddi_c'"">)" & "</td>"
		
		
		Response.Write "<Td class='tituloDetalhe'  size='15' maxlength='15'>" & Lang.F_Traduz("Fax") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left' >"
		Response.Write "(<input type='Text' Name='dddfax' class='ip_txt' size='5' maxlength='3' value='"& xdddfax &"'>)<input type='Text' Name='fax' class='ip_txt' size='10' maxlength='9' value='"& xfax &"'></td>"
		Response.write "</tr>"
		Response.Write "<Tr><Td class='tituloDetalhe' >" & Lang.F_Traduz("Contato") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left' colspan='3'>"
		Response.Write "<input type='Text' name='contato' size='50' maxlength='40' class='ip_txt' value='"& xcontato &"'></td>"		
		Response.Write "<Td class='tituloDetalhe' >" & Lang.F_Traduz("Aniversário") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' Name='aniversario' class='ip_txt' size='12' maxlength='12' value='"& xniver &"'></td></tr>"			
		Response.Write "<Tr><Td class='tituloDetalhe' >" & Lang.F_Traduz("Email") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left' colspan='3'>"
		
		Response.Write "<input type='Text' name='email' class='ip_txt' size='50' maxlength='40' value='" & xemail & "'</td>"
		Response.Write "<Td class='tituloDetalhe' >" & Lang.F_Traduz("Região") & "</TD>"
		Response.Write "<Td class='td_verd_bk' align='left'>" 
		Response.write "<select name='regiao' class = 'sel'>"
		
		xsql = "Select regiao From Regioes_Venda order by regiao"		
		Set xresult = Stcon.Execute(xsql)
		
		IF not xresult.eof Then
			Do While not xresult.eof		
				Response.Write "<option value= '" & xresult("regiao") & "'" & Iif(Utrim(xresult("regiao"),"A") = UTrim(xRegiao_cad,"A"), " Selected ", "") & ">" & xresult("regiao") & "</option>" 
				xresult.MoveNext
			Loop			
		End If				
		Response.Write "</select>"
		Response.Write "</TD></tr>"		
		
		
		'-------------------------------------------------------------------Chama Funcao que valida Form		
		Response.Write "<Tr><Td class='tituloDetalhe' >" & Lang.F_Traduz("Transportadora:") & "</td>"
		Response.Write "<Td class='td_verd_bk' colspan='3'>" 

		Response.write "<select name= 'transportadora' class='sel'>"
								
		xsql = "Select Transportadora From Transportadoras order by Transportadora"		
		Set xresult = Stcon.Execute(xsql)
		
		IF not xresult.eof Then
			Do While not xresult.eof		
				Response.Write "<option " & Iif(Trim(xtransportadora) = Trim(xresult("Transportadora")), "Selected", "") & " value= '" & xresult("Transportadora") & "'" & Iif(Utrim(xresult("Transportadora"),"A") = UTrim(xtransportadora,"A"), " Selected ", "") & ">" & xresult("Transportadora") & "</option>" 
				xresult.MoveNext
			Loop
		Else
			Response.Write "<option value = '" & xregiao_padrao & "'>" & xregiao_padrao & "</OPTION>"  			
		End If				
		Response.Write "</select>"							
		Response.Write "</TD>"
				
		Response.Write "<Td class='tituloDetalhe' >" & Lang.F_Traduz("Tipo") & "</td>"		
		Response.Write "<Td class='td_verd_bk' align='left'>" 
		Response.Write "<select name = 'tipo_cliente' class ='sel'>" 

		xsql = "Select Tipo From cliente_atac_tipos"
		Set xresult = Stcon.execute(xsql)

		Do While not xresult.eof
			If Trim(xTipo_Cli)  = Trim(xresult("Tipo")) Then		
				Response.Write "<option value='" & xresult("Tipo") & "' selected>" & xresult("Tipo") & "</option>"		
			Else
				Response.Write "<option value='" & xresult("Tipo") & "'>" & xresult("Tipo") & "</option>"		
			End If	
			
			xresult.MoveNext
		Loop
		Response.Write "</Select></Td>"
		Response.Write "</tr></table>"		
		
	%>
	</Td>
</Tr>
<Tr>	
	<Td>
	<%
		Response.write "<Table class='tblListaDetalhes' border=0 cellpadding='3' cellspacing='1' width='95%'>"
		Response.write "<tr><td colspan='8' style='height:2px;background-color:#CCCCCC'></td></tr>"
		Response.Write "<Tr><Td colspan='8' class='tituloDetalhe'><input type='checkbox' name=chkEntrega checked>" & Lang.F_traduz("Entrega") & "</td></Tr>"
		
		Response.Write "<Tr><Td class='tituloDetalhe'  width='100'>" & Lang.F_Traduz("Endereço") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' name='endereco_e' class='ip_txt' size='40' maxlength='40' value='"& xendereco_e &"'></td>"			
		Response.write "<td  class='tituloDetalhe' >"& Lang.F_Traduz("Número") &"</td><td><input name='numero_e' type='textbox'  class='ip_txt' maxlength='10' value='"& xnumero_e &"'></td>"
		Response.write "<td  class='tituloDetalhe' >"& Lang.F_Traduz("Complemento") &"</td><td><input name='complemento_e' type='textbox'  class='ip_txt' maxlength='60' size='40' value='"& xcomplemento_e &"'></td></tr>"	
						
		Response.Write "<Tr><Td class='tituloDetalhe' >" & Lang.F_Traduz("Cidade") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' name='cidade_e' size='35' Maxlength='35' class='ip_txt' value='"& xcidade_e &"'></td>"
		Response.Write "<Td class='tituloDetalhe' >" & Lang.F_Traduz("UF") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"		
		'----------------------------------------------------- Combo Unidades Federativas
		Response.Write "<select Name='uf_e' class='sel'>"		
		
		xsql = "Select * from Unidades_federacao order by uf"		
		set xresult_u = Stcon.Execute(xsql)		
		
		IF Not xresult_u.eof Then							
			Do While Not xresult_u.eof
				If IsClean(xuf_e) Then
					Response.Write "<Option Value = '" & xresult_u("uf") & "'" & Iif(UTrim(xuf_padrao, "A") = UTrim(xresult_u("uf"), "A"), "Selected","") & ">" & xresult_u("uf") & "</option>"			
				Else
					Response.Write "<Option Value = '" & xresult_u("uf") & "'" & Iif(UTrim(xuf_e, "A") = UTrim(xresult_u("uf"), "A"), "Selected","") & ">" & xresult_u("uf") & "</option>"			
				End If
				xresult_u.MoveNext				
			Loop
		Else
			Response.Write "<option value='" & xuf_padrao & "'>" & xuf_padrao & "</Option>"
		End IF	

		Response.Write "</Select></td>"
		'-------------------------------------------------------------------		
		Response.Write "<Td class='tituloDetalhe'  maxlenght='9'>" & Lang.F_Traduz("Telefone") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left' >"
		Response.Write "(<input type='Text' Name='ddd_e' class='ip_txt' size='5' maxlength='3' value='"& xddd_e &"'>)<input type='Text' Name='tel_e' class='ip_txt' size='10' maxlength='9'  value='"& xtel_e &"'> </td></tr>"
							
		Response.Write "<Tr><Td class='tituloDetalhe' >" & Lang.F_Traduz("Bairro") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' size='35' Maxlength='25' name='bairro_e' class='ip_txt' value='"& xbairro_e &"'></td>"
		Response.Write "<Td class='tituloDetalhe'  >" & Lang.F_Traduz("Cep") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' name='cep_e' class='ip_txt' size='9' maxlength='9' value='"& xcep_e &"'></td>"			
		Response.Write "<Td class='tituloDetalhe'  >" & Lang.F_Traduz("Cnpj/CPf") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input Size=23 type='Text' name='cgccpf_e' class='ip_txt' value='"& xcgc_ie_e &"' id='cgccpf_e' onkeypress=""javascript:return txtBoxFormat('" & Request_Param("MASCARA_CGC_PADRAO","99.999.999/9999-99") & "',event);""></td></tr>"
				
		Response.Write "<Tr><Td class='tituloDetalhe'  >" & Lang.F_Traduz("País") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'> "
		'----------------------------------------------------- Combo Paises
		Response.Write "<select Name='pais_e' class='sel'>"

		xsql = "Select * From paises order by pais"		
		Set xresult_p = Stcon.execute(xsql)				
	
		If not xresult_p.eof Then		
			Do While not xresult_p.eof		
				If IsClean(xpais_e) Then			
					Response.Write "<Option Value='" & UTrim(xresult_p("Pais"),"A") & "'" &Iif(UTrim(xresult_p("Pais"),"A") = UTrim(xpais_padrao,"A"), " Selected ", "") &  ">" & UTrim(xresult_p("Pais"),"A") & "</Option>"						
				Else
					Response.Write "<Option Value='" & UTrim(xresult_p("Pais"),"A") & "'" &Iif(UTrim(xpais_e,"A") = UTrim(xresult_p("Pais"),"A"), " Selected ", "") &  ">" & UTrim(xresult_p("Pais"),"A") & "</Option>"						
				End If
				xresult_p.Movenext			
			Loop			
		Else
			Response.Write "<Option value ='" & xpais_padrao & "'>" & xpais_padrao & "</Option>"			
		End If	
		
		Response.Write "</Select></td>"
		'-------------------------------------------------------------------				
		Response.Write "<Td class='tituloDetalhe' >" & Lang.F_Traduz("DDI") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "(<input type='Text' Name='dddi_e' class='ip_txt' size='5' maxlength='5' value='"& xddi_e &"'>)</td>"
		
		Response.Write "<Td class='tituloDetalhe'  >" & Lang.F_Traduz("IE/RG") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left' >"
		Response.Write "<input type='Text' Name='ierg_e' maxlength='18' class='ip_txt' value='"& xie_e &"'></td></tr>"				
		Response.Write "</table>"
	%>
	</Td>
</Tr>
<Tr>
	<Td>
	<%
		Response.write "<Table class='tblListaDetalhes' border=0 cellpadding='3' cellspacing='1'   width='95%'>"
		Response.write "<tr><td colspan='8' style='height:2px;background-color:#CCCCCC'></td></tr>"
		Response.Write "<Tr><Td colspan='8' class='tituloDetalhe'><input type='checkbox' name=chkcobranca checked> Cobrança</td></Tr>"		
		
		Response.Write "<Tr><Td class='tituloDetalhe'  width='100'>" & Lang.F_Traduz("Endereço") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left' >"
		Response.Write "<input type='Text' name='endereco_c' class='ip_txt' size='40' maxlength='40' value='"& xendereco_c &"'></td>"		
		Response.write "<td  class='tituloDetalhe' >"& Lang.F_Traduz("Número") &"</td><td><input name='numero_c' type='textbox'  class='ip_txt' maxlength='10' value='"& xnumero_c &"'></td>"
		Response.write "<td  class='tituloDetalhe' >"& Lang.F_Traduz("Complemento") &"</td><td><input name='complemento_c' type='textbox'  class='ip_txt' maxlength='40' size='40' value='"& xcomplemento_c &"'></td></tr>"
		
						
		Response.Write "<Tr><Td class='tituloDetalhe' >" & Lang.F_Traduz("Cidade") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' name='cidade_c' size='35' Maxlength='35' class='ip_txt' value='"& xcidade_c &"'></td>"
		Response.Write "<Td class='tituloDetalhe' >" & Lang.F_Traduz("UF") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		'----------------------------------------------------- Combo Unidades Federativas
		Response.Write "<select Name='uf_c' class='sel'>"		
		
		xsql = "Select * from Unidades_federacao order by uf"		
		set xresult_u = Stcon.Execute(xsql)		
		
		If not xresult_u.eof Then			
			Do While Not xresult_u.eof
				If IsClean(xuf_c)Then
					Response.Write "<Option Value = '" & xresult_u("uf") & "'" & Iif (UTrim(xuf_padrao,"A") = UTrim(xresult_u("uf"),"A"), "Selected", "") & ">" & xresult_u("uf") & "</option>"			
				Else
					Response.Write "<Option Value = '" & xresult_u("uf") & "'" & Iif (UTrim(xuf_c,"A") = UTrim(xresult_u("uf"),"A"), "Selected", "") & ">" & xresult_u("uf") & "</option>"			
				End If
				xresult_u.MoveNext
			Loop
		Else
			Response.Write "<option value ='" & xuf_padrao &"'>" &  xuf_padrao & "</option>"
		End If
		
		Response.Write "</Select></td>"
		'-------------------------------------------------------------------	
		Response.Write "<Td class='tituloDetalhe' >" & Lang.F_Traduz("Telefone") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left' >"
		Response.Write "(<input type='Text' Name='ddd_c' class='ip_txt' size='5' maxlength='3'  value='"& xddd_c &"'>)<input type='Text' Name='tel_c' class='ip_txt' size='10' maxlength='9' value ='"& xtel_c & "'></td></tr>"
		Response.write "<tr><td></td></tr>"						
		Response.Write "<Tr><Td class='tituloDetalhe' >" & Lang.F_Traduz("Bairro") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' size='35' Maxlength='25' name='bairro_c' class='ip_txt' value='"& xbairro_c &"'></td>"
		Response.Write "<Td class='tituloDetalhe'  >" & Lang.F_Traduz("Cep") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' name='cep_c' class='ip_txt' size='9' maxlength='9' value='"& xcep_c &"'></td>"			
		Response.Write "<Td class='tituloDetalhe'  >" & Lang.F_Traduz("Cnpj/Cpf") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' Size=23 name='cgccpf_c' class='ip_txt' value='"& xcgc_c &"'  id='cgccpf_c' onkeypress=""javascript:return txtBoxFormat('" & Request_Param("MASCARA_CGC_PADRAO","99.999.999/9999-99") & "',event);""></td></tr>"		
		Response.Write "<Tr><Td class='tituloDetalhe'  >" & Lang.F_Traduz("País") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left' > "		
		'----------------------------------------------------- Combo Paises		
		Response.Write "<select Name='pais_c' class='sel'>"
				
		xsql = "Select * From paises order by pais"		
		Set xresult_p = Stcon.execute(xsql)				
		
		If Not xresult_p.eof Then
			Do While not xresult_p.eof	
				If IsClean(xpais_c) then			
					Response.Write "<Option Value='" & Trim(xresult_p("Pais")) & "'" & Iif(UTrim(xresult_p("Pais"),"A") = UTrim(xpais_padrao,"A"), " Selected ", "") &  ">" & Trim(xresult_p("Pais")) & "</Option>"			
				Else
					Response.Write "<Option Value='" & Trim(xresult_p("Pais")) & "'" & Iif(UTrim(xresult_p("Pais"),"A") = UTrim(xpais_c,"A"), " Selected ", "") &  ">" & Trim(xresult_p("Pais")) & "</Option>"			
				End If
				xresult_p.Movenext	
			Loop
		Else
			Response.Write "<option value='"& xpais_padrao & "'>" & xpais_padrao & "</option>"
		End If	
			
		Response.Write "</Select></td>"
		'-------------------------------------------------------------------		
		Response.Write "<Td class='tituloDetalhe' >" & Lang.F_Traduz("DDI") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "(<input type='Text' Name='dddi_c' class='ip_txt' size='5' maxlength='5' value='"& xddi_c &"'>)</td>"
		
		Response.Write "<Td class='tituloDetalhe'  >" & Lang.F_Traduz("IE/RG") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left' >"
		Response.Write "<input type='Text'  maxlength='18' Name='ierg_c' class='ip_txt' value='"& xie_c &"'></td></tr>"				
		Response.Write "</table>"
	%>
	</Td>
</Tr>
<Tr>
	<Td>
	<%
		Response.write "<Table class='tblListaDetalhes' border=0 cellpadding='3' cellspacing='1'   width='95%'>"
		Response.write "<tr><td colspan='8' style='height:2px;background-color:#CCCCCC'></td></tr>"	
		Response.Write "<Tr><Td colspan='8' class='tituloDetalhe'>" & Lang.F_traduz("Dados bancarios") & " / " & Lang.F_traduz("Seguro") & "</td></Tr>"
		Response.Write "<Tr><Td class='tituloDetalhe'  width='100'>" & Lang.F_Traduz("Banco") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		'----------------------------------------------------- Combo Bancos
		Response.Write "<select Name='bco' class='sel'>"
				
		xsql = "Select Banco, Nome_banco From Bancos order by banco"		
		Set xresult = Stcon.execute(xsql)
		  
		If not xresult.eof Then
			Do While not xresult.eof		
				Response.Write "<Option Value='" & Trim(xresult("Banco"))  & "'" & Iif(Trim(xbanco) = Trim(xresult("banco")),  "Selected ", "") & ">" & xresult("Banco") & " - " & xresult("Nome_banco") & "</Option>"		
				xresult.Movenext		
			Loop		
		End If		
		Response.Write "</Select></td>"		
		
		'-------------------------------------------------------------------				
		Response.Write "<Td class='tituloDetalhe' >" & Lang.F_Traduz("N' Contrato") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"	
		Response.Write "<input type='Text' name='ncontrato' class='ip_txt' size='15' maxlength='12' value='"& xcontrato &"'></td></tr>"								
		Response.Write "<Tr><Td class='tituloDetalhe' >" & Lang.F_Traduz("Agência") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' name='agencia' class='ip_txt' size='6' maxlength='10' value ='"& xagencia & "' >"
		Response.Write "<input type='Text' name='agencia_nome' class='ip_txt' size='25' maxlength='25' value='"& xnome_agencia &"'></td>"	
		Response.Write "<Td class='tituloDetalhe'  >" & Lang.F_Traduz("N' Cliente") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' name='ncliente' size='12' maxlength='8' class='ip_txt' value='" & xncliente & "'></td>"						
		Response.Write "<Tr><Td class='tituloDetalhe' >" & Lang.F_Traduz("C/C") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left'>"
		Response.Write "<input type='Text' name='contacorrente' size='20' maxlength='20' class='ip_txt'value='"& xconta &"'></td>"
		Response.Write "<Td class='tituloDetalhe'  >" & Lang.F_Traduz("Validade") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left' >"
		Response.Write "<input type='Text' Name='validade' size='15' maxlength='10' class='ip_txt' value='" & xvalidade & "'></td></tr>"		
		Response.Write "<Tr><Td class='tituloDetalhe'  >" & Lang.F_Traduz("Carteira") & "</td>"
		Response.Write "<Td class='td_verd_bk' align='Left' colspan='1'> "
		Response.write "<select name='carteira' class = 'sel'>"
		
'-------Recupera a carteira de carteira cobrança

		xsql = "select carteira from carteiras_cobranca order by carteira"		
		Set xresult = Stcon.Execute(xsql)		
		
		If not xresult.eof Then
			Do while not xresult.eof 		
				Response.Write "<option value = '" & xresult("carteira") & "'" & Iif(UTrim(xcarteira,"A") = UTrim(xresult("carteira"),"A"), "selected", "") & ">"  & xresult("carteira") & "</option>"					
				xresult.movenext			
			loop									
		End If	
		
		Response.Write "</select></TD>"				
		Response.Write "<Td class='tituloDetalhe' >"& Lang.F_Traduz("Condição de Pagamento") &"</TD>"
		Response.Write "<Td class='td_verd_bk' align='Left' colspan='1'>"
		Response.write "<select name='condicao_pg' class = 'sel'>"
		
'--------Combox que seleciona os descontos existentes e na pesquisa exibe o desc referente ao cliente
							
		xsql = "select condicao_pgto, desc_cond_pgto from cond_atac_pgtos where condicao_especial=0 order by desc_cond_pgto"
		Set xresult = Stcon.Execute(xsql)		
		if trim(xCondicao_pg) = ""  then xCondicao_pg = xcondicao_padrao
		
		If Not xresult.eof Then			
			Do While Not xresult.eof 
				Response.Write "<option value = '"&  xresult("condicao_pgto") & "'" & Iif(UTrim(xresult("condicao_pgto"),"A") = UTrim(xCondicao_pg,"A"), "Selected","") & ">" & xresult("condicao_pgto") & " - " & xresult("desc_cond_pgto")  & "</option>"		
				xresult.MoveNext
			Loop			
		Else
			Response.Write "<option value='"& xcondicao_padrao &"'>" & xcondicao_padrao & "</option>"
		End If	
		
		Response.Write "</select></TD>"		
		
		Response.Write "</Tr>"		
		Response.Write "</table>"			
	%>
	</Td>
</Tr>
<Tr>
	<Td>
	<%
		Response.write "<Table class='tblListaDetalhes' border=0 cellpadding='0' cellspacing='1'   width='95%'>"	
		Response.Write "<Tr><Td colspan='8' class='tituloDetalhe' >" & Lang.F_traduz("Observação") & "</td></Tr>"		
		Response.Write "<Tr><Td   class='td_verd_bk'><TEXTAREA cols='100%' name=obsped rows=2 >" &  x_txt_area & "</Textarea></td></tr>"			
		Response.Write "</table>"
'------------ Função que valida os dados do Formulário
Function Valida()
		dim x_mens
		x_mens = ""
		
		'x_mens = x_mens & Iif(IsClean(xCodigo) and Not IsNumeric(xCodigo), Lang.F_Traduz("Código em Branco ou valor inválido") & "<Br>", "")
		x_mens = x_mens & Iif(IsClean(xCliente)  , Lang.F_Traduz("Cliente em Branco") & "<Br>", "")	
		x_mens = x_mens & Iif(IsClean(xRazao)    , Lang.F_Traduz("Razão Social em Branco") & "<Br>", "")					
		x_mens = x_mens & Iif(IsClean(xcgccpf)   , Lang.F_Traduz("CNPJ/CPF em Branco") & "<Br>", "")						
		x_mens = x_mens & Iif(IsClean(xierg)     , Lang.F_Traduz("IE/RG em Branco ou valor inválido") & "<Br>", "")						
		x_mens = x_mens & Iif(IsClean(xuf)       , Lang.F_Traduz("UF em Branco") & "<Br>", "")						
		x_mens = x_mens & Iif(IsClean(xcadastro) , Lang.F_Traduz("Data do Cadastro em Branco") & "<Br>", "")									
		x_mens = x_mens & Iif(IsClean(xcarteira) , Lang.F_Traduz("Selecione a Carteira") & "<Br>", "")			
		x_mens = x_mens & Iif(IsClean(xuf_e)     , Lang.F_Traduz("UF da entrega em Branco") & "<Br>", "")			
		x_mens = x_mens & Iif(IsClean(xuf_c)     , Lang.F_Traduz("UF da cobrança em Branco") & "<Br>", "")							
		x_mens = x_mens & Iif(IsClean(xcgc_c)    , Lang.F_Traduz("CNPJ da cobrança em Branco") & "<Br>", "")							
		x_mens = x_mens & Iif(IsClean(xie_c)     , Lang.F_Traduz("IE da cobrança em Branco") & "<Br>", "")							
		x_mens = x_mens & Iif(IsClean(xcgc_ie_e) , Lang.F_Traduz("CNPJ da entrega em Branco") & "<Br>", "")							
		x_mens = x_mens & Iif(IsClean(xie_e)     , Lang.F_Traduz("IE da entrega em Branco") & "<Br>", "")		
		'x_mens = x_mens & Iif(Not IsDate(xniver) , Lang.F_Traduz("Data de Aniversário inválido") & "<Br>", "")							
		'xmens = x_mens & Iif(IsClean(xbanco)    , espacos(1) & Lang.F_Traduz("Banco em Branco"), "")							
		'xmens = x_mens & Iif(IsClean(xconta)    , espacos(1) & Lang.F_Traduz("Conta Corrente em Branco"), "")									
		x_mens = x_mens & Iif(IsClean(xTipo_Cli) , Lang.F_Traduz("Escolha o Tipo de Cliente ") & "<Br>", "")
		
		x_mens = x_mens & Iif(Iif(xjuridica, ValidaCgc(xCgcCpf)  , ValidaCpf(xCgcCpf))   , "", Lang.F_traduz("Cnpj/Cpf Inválido !!!!") & "<Br>")		
		x_mens = x_mens & Iif(Iif(xjuridica, ValidaCgc(xCgc_ie_e), ValidaCpf(xCgc_ie_e)) , "", Lang.F_traduz("Cnpj/Cpf entrega Inválido !!!!")  & "<Br>")
		x_mens = x_mens & Iif(Iif(xjuridica, ValidaCgc(xCgc_c)   , ValidaCpf(xCgc_c))    , "", Lang.F_traduz("Cnpj/Cpf de cobrança Inválido !!!!") & "<Br>")
		
		Valida = x_mens
End Function

'-------------Função que apresenta o botão incluir e chama a função em VBScript que atribui um valor a um input que posteriormente é recuperado 		
Function Exibe_Botao_Adicionar()
	Response.Write "<img src='../Images/" & Lang.F_traduz("bt_adicionar.png") & "' name='bEnviar' hspace='1' style = cursor='hand' Onclick=Enviar_Onclick()>"	
	'Response.Write "<input type='hidden' name='adiciona' >"		
End Function	

'-------------Função que apresenta o botão pesquisar e chama a função em VbScript que atribui um valor ao input que posteriormente é recuperado
Function Exibe_Botao_Pesquisa()
	Response.Write "<img src='../Images/" & Lang.F_traduz("btPesquisar.png") & "' name='bPesquisa' hspace='1' style = cursor='hand' Onclick=Pesquisa_Onclick()>"
	'Response.Write "<input type='hidden' name='pesquisa' >"
	'Response.Write "<input type='hidden' name='flag' >"
End Function		

'-------------Função que apresenta o botão pesquisar e chama a função em VbScript que atribui um valor ao input que posteriormente é recuperado		
Function Exibe_Botao_Update()				
	Response.Write "<img src='../Images/" & Lang.F_traduz("bt_alterar.png") & "' name='bAltera' hspace='1'  style = cursor='hand' Onclick=Altera_Onclick()>"	
	'Response.Write "<input type='hidden' name='altera' >"														
End Function		

'-------------Zerando os Objetos Instanciados em Memória
Set xresult           = Nothing
Set xResult_u		  = Nothing
Set xResult_p		  = Nothing 				
%>
	</Td>
</Tr>
<Tr><Td>
	<div align="right"><br><a href="javascript:history.back()"><img src="../images/bt_voltar.png" alt="<%= Lang.F_traduz("Voltar") %> " border=0 ></a></div>
</td></Tr>
</Table>
</FORM>

<script language="JavaScript">
xcgccpf = <%= Iif(xjuridica, 1, 0) %>

function Troca(Campo){
	xcgccpf = Campo.value;				

	FormataCNPJ(document.login.cgccpf, null);
	FormataCNPJ(document.login.cgccpf_e, null);
	FormataCNPJ(document.login.cgccpf_c, null);
}

function FormataCNPJ(Campo, teclapres){

	if (teclapres == null)
		tecla = 0;
	else
		var tecla = teclapres.keyCode;
		
	var vr = new String(Campo.value);				
	
	vr = vr.replace(".", "");
	vr = vr.replace(".", "");
	vr = vr.replace("/", "");
	vr = vr.replace("-", "");
		
	tam = vr.length + 1 ;

	if (xcgccpf == 1){
		if (tecla != 9 && tecla != 8 && tecla != 46){
			if (tam > 2 && tam < 6)
				Campo.value = vr.substr(0, 2) + '.' + vr.substr(2, tam);
			if (tam >= 6 && tam < 9)
				Campo.value = vr.substr(0,2) + '.' + vr.substr(2,3) + '.' + vr.substr(5,tam-5);
			if (tam >= 9 && tam < 13)
				Campo.value = vr.substr(0,2) + '.' + vr.substr(2,3) + '.' + vr.substr(5,3) + '/' + vr.substr(8,tam-8);
			if (tam >= 13 && tam < 14)
				Campo.value = vr.substr(0,2) + '.' + vr.substr(2,3) + '.' + vr.substr(5,3) + '/' + vr.substr(8,4)+ '-' + vr.substr(12,tam-12);
			if (tam >= 14)
				Campo.value = Campo.value.substr(0,17);
		}
	}
	else{
		if (tecla != 9 && tecla != 8 && tecla != 46){
			if (tam > 3 && tam < 7)
				Campo.value = vr.substr(0, 3) + '.' + vr.substr(3, 3);	
			if (tam >= 7 && tam < 10)
				Campo.value = vr.substr(0, 3) + '.' + vr.substr(3, 3) + '.' + vr.substr(6, 3);																										
			if (tam >= 10 ) {
				Campo.value = vr.substr(0, 3) + '.' + vr.substr(3, 3) + '.' + vr.substr(6, 3) + '-' + vr.substr(9, 2);			
				Campo.value = Campo.value.substr(0,14);
			}
		}					
	}
}					
</Script>
</BODY>
</HTML>