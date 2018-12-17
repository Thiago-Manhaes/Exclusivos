* Cria��o ***********************************************************************************************************
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:                                                                                                  *
* HOR�RIO........:                                                                                                  *
*********************************************************************************************************************
* CLIENTE..: Animale                                                                                                        *
* OBJETIVO.: Geracao Custo medio materiais na entrada e Consulta Entradas por colecao propriedade                                                                                                     *
*********************************************************************************************************************

* Altera��o *********************************************************************************************************
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HOR�RIO........:                                                                                                  *
*********************************************************************************************************************
* CLIENTE..:                                                                                                        *
* OBJETIVO.:                                                                                                        *
*********************************************************************************************************************


*********************************************************************************************************************
*- Programa Base de Cria��o de Objeto de Entrada                                                                    *
*********************************************************************************************************************
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela                                      *
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos                                            *
*********************************************************************************************************************
*- Existem 2 parametros que influem nos objetos de Entrada:                                                         *
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos                       *
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execu��o para facilitar o desenvolvimento *
*********************************************************************************************************************
* - Atencao !!!!!!!!!!!														                                        *
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP                                      *
*********************************************************************************************************************

*- MIT[1] - 06/04/2016 - inclusao do tratamento da baixa automatica do desconto

Define Class obj_entrada As Custom
	*- Nome do metodo/fun��o que os objetos linx v�o chamar.

	Procedure metodo_usuario
	*- Parametros do metodo:
	*- Xmetodo= nome do metodo
	*- Xobjeto= variavel com a referencia ao objeto
	*- Xnome_obj  = nome do objeto
	Lparam xmetodo, xobjeto ,xnome_obj

	******************** Metodos chamados pelo FORMSET
	*	USR_INIT  												=> NA INICIALIZACAO DA TELA
	*	USR_ALTER_BEFORE  -> Return .f. Para o Metodo 			=> ANTES DA ALTERACAO ,AO CLICKAR ANTES DE LIBERAR OS CAMPOS
	*	USR_ALTER_AFTER 										=> APOS LIBERAR OS CAMPOS PARA INCLUSAO
	*	USR_INCLUDE_AFTER 										=> APOS LIBERAR OS CAMPOS PARA INCLUSAO
	*	USR_SEARCH_BEFORE -> Return .f. Para o Metodo PESQUISA	=> ANTES DE FAZER A PESQUISA NO BANCO
	*	USR_SEARCH_AFTER										=> APOS FAZER A PESQUISA NO BANCO
	*	USR_CLEAN_AFTER 										=> APOS LIMPAR A TELA
	*	USR_REFRESH                                             =>
	*	USR_SAVE_BEFORE   -> Return .f. Para o Metodo 			=> SALVAR ANTES DE JOGAR INFORMACOES NO BANCO
	*	USR_SAVE_AFTER                                          => APOS SALVAR AS INFORMACOES    NO BANCO
	*	USR_ITEN_DELETE_BEFORE -> Return .f. Para o Metodo 		=> ANTES DE EXCLUIR ITEN NA TABELA FILHA '+'
	*	USR_ITEN_DELETE_AFTER                                   => APOS DELETAR UM ITEM NA TABELA FILHA '-'
	*	USR_ITEN_INCLUDE_BEFORE -> Return .f. Para o Metodo 	=> ANTES DE INCLUIR ITEM NA TABELA FILHA
	*	USR_ITEN_INCLUDE_AFTER									=> APOS INCLUIR ITEM NA TABELA FILHA
	*
	***************** Metodos que ocorrem dentro da Transaction do Banco de Dados
	*	USR_TRIGGER_AFTER ->Return .f. Para o Salvamento e da Rollback ANTES DE EXECUTAR UMA TRIGGER
	*	USR_TRIGGER_BEFORE ->Return .f. Para o Salvamento e da Rollback


	******************** Metodo chamado pelos Objetos na Valida��o
	*   USR_VALID -> Return .f. N�o deixa o Usuario sair do objeto.

	******************** Metodo chamado pelos PageFrames
	*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

	*- Inicio dos procedimentos do Usuario
	*- Testando qual o metodo que esta chamando o metodo entrada

	*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

	*!* Chama a fun��o dispon�vel na classe criada para tratar xml *!* #XML_2015
	Try
		If Type("Thisformset.pp_anm_obj_entrada_xml")<>'U' And Thisformset.pp_anm_obj_entrada_xml
			If ! o_anm.l_Obj_entrada_xml('o_005104',xmetodo, xobjeto ,xnome_obj,Thisformset.p_tool_status)
				Return .F.
			Endif
		Endif
	Catch
	Endtry
	*!* Fim - Instancia um objeto da classe "Obj_Entrada_XML" #XML_2015

	Do Case

	Case Upper(xmetodo) == 'USR_INIT'

		xVersao = '01.1'
		f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
		f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
		WAIT WINDOW "Vers�o: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT

		*!* Declara Fun��o Obj_Entrada_XML ao Iniciar Tela *!* #XML_2015
		If Type("Thisformset.pp_anm_obj_entrada_xml")<>'U' And Thisformset.pp_anm_obj_entrada_xml
			Public o_anm As Object
			o_anm = Newobject("Obj_Entrada_XML","linx\exclusivo\obj_entrada_xml.prg")
		Endif
		*!* Fim - Declara Fun��o Obj_Entrada_XML ao Iniciar Tela *!* #XML_2015

		With Thisformset.Lx_form1.Lx_pageframe1.page7.lx_grid_filha1
			.COL_ETIQUETA.Visible = .F.
			.Parent.BT_TODAS_ETQ.Visible = .F.
			.Parent.BT_TODAS_ETQ.Enabled = .F.
			lcColumnCount = .ColumnCount
			lcColumnCount = lcColumnCount + 1
			.AddColumn(lcColumnCount )
			.Columns[lcColumnCount].Name = 'col_etiqueta_peca'
			.col_etiqueta_peca.Width = 70
			.col_etiqueta_peca.BackColor = 15399423
			.col_etiqueta_peca.ColumnOrder = 7
			.col_etiqueta_peca.header1.Caption = 'Etiqueta'
			.col_etiqueta_peca.header1.Alignment = 2
			.col_etiqueta_peca.header1.FontSize = 8
			.col_etiqueta_peca.AddObject('bt_etiqueta_peca','bt_etiqueta_peca')
			.col_etiqueta_peca.CurrentControl = 'bt_etiqueta_peca'
			.col_etiqueta_peca.RemoveObject('text1')
			.col_etiqueta_peca.CurrentControl = 'bt_etiqueta_peca'
			.col_etiqueta_peca.Sparse = .F.
			.col_etiqueta_peca.Refresh()
		Endwith

		*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_programa_00
		Sele v_entradas_00
		xalias_pai=Alias()

		oCur = Getcursoradapter(xalias_pai)
		oCur.addbufferfield("ENTRADAS.ANM_RATEIO_PRODUCAO", "N(15,5)",.T., "ANM_RATEIO_PRODUCAO", "Entradas.ANM_RATEIO_PRODUCAO")
		oCur.addbufferfield("ENTRADAS.ANM_FRETE_ADICIONAL", "N(14,2)",.T., "ANM_FRETE_ADICIONAL", "Entradas.ANM_FRETE_ADICIONAL")
		oCur.addbufferfield("ENTRADAS.ANM_STATUS_ENTRADA", "C(25)",.T., "ANM_STATUS_ENTRADA", "Entradas.ANM_STATUS_ENTRADA")
		oCur.confirmstructurechanges()
		**-Fim Inclusao Campos Novos de Produtos no Cursor Pai

		*Inicio Inclusao Campos Novos de Produtos no Cursor Filha -- v_producao_programa_00 #XML
		Sele v_entradas_00_ret1_mat
		xalias_pai=Alias()
		oCur = Getcursoradapter(xalias_pai)
		oCur.addbufferfield("ESTOQUE_RET1_MAT.ANM_STATUS_SAIDA_ITEM", "L",.T., "Status Sai Mat. Rev.", "ESTOQUE_RET1_MAT.ANM_STATUS_SAIDA_ITEM")
		oCur.confirmstructurechanges()
		**-Fim Inclusao Campos Novos de Produtos no Cursor Filha #XML

		*** #XML inclus�o da coluna comcheckbox na aba materiais ****
		If Type('Thisformset.pp_anm_hab_finalizar_revisao') <> 'U' And Thisformset.pp_anm_hab_finalizar_revisao

			With Thisformset.Lx_form1.Lx_pageframe1.page6.lx_grid_filha1
				.Parent.AddObject("bt_finaliza_revisao","bt_finaliza_revisao")
				.AddColumn(1)
				.Column1.Name='col_Liberar_revisao'
				With .col_Liberar_revisao
					.RemoveObject("text1")
					.BackColor = Rgb(251,245,220)
					.header1.Name='h_check_revisao'
					.h_check_revisao.Caption=' '
					.AddObject('ck_Liberar_revisao','CheckBox')
					.Sparse= .F.
					.CurrentControl = 'ck_Liberar_revisao'
					.ck_Liberar_revisao.Caption=""
					.ck_Liberar_revisao.Visible = .T.
					.Width=16
					.ControlSource="v_entradas_00_ret1_mat.ANM_STATUS_SAIDA_ITEM"
				Endwith
			Endwith

			Bindevent(Thisformset.Lx_form1.Lx_pageframe1.page6.lx_grid_filha1.col_Liberar_revisao.ck_Liberar_revisao, "Click", This, "Anm_Ctrl_Check", 1)
		Endif
		*** FIM #XML ***

		xalias=Alias()

		*** Declara��o de variaveis ***
		*public xnf_entrada,xserie_nf_entrada,xnome_clifor,xfilial,xvalor_producao,xmotivo_exclusao,xstatus_entrada
		Local xvalor_producao

		*** Seleciona as filiais de armazenagem ***
		If Used("xFilialPedido")
			Use In xFilialPedido
		Endif

		f_select("select filial from filiais where indica_armazem = 1","xFilialPedido")
		xvalor_producao=0

		*** Adiciona objeitos e propriedades destes na tela ****
		With Thisformset.Lx_form1.Lx_pageframe1.page1
			.Parent.page6.RemoveObject("Botao_Pedido")
			.Parent.page6.AddObject("Botao_Pedido","Botao_Pedido")
			.pageframe1.page2.AddObject("lb_anm_rateio_producao","lb_anm_rateio_producao")
			.pageframe1.page2.AddObject("tx_anm_rateio_producao","tx_anm_rateio_producao")
			.pageframe1.page2.AddObject("tx_valor_producao","tx_valor_producao")
			.pageframe1.page2.AddObject("tx_anm_frete_adicional","tx_anm_frete_adicional")
			.pageframe1.page2.AddObject("lb_anm_frete_adicional","lb_anm_frete_adicional")
			.pageframe1.page1.AddObject("lx_entrada_revisao","lx_entrada_revisao")
			.Parent.page6.AddObject("bt_gera_pedido","bt_gera_pedido")
			.Parent.page6.AddObject("cmb_filial_pedido","cmb_filial_pedido")
			.Parent.page6.cmb_filial_pedido.RowSource = "xFilialPedido"
			.Parent.page6.Botao2.Visible= .F.
			.Parent.page6.AddObject("lb_Pedido_Gerado","lb_Pedido_Gerado")
		Endwith

		Bindevent(Thisformset.Lx_form1.Lx_pageframe1.page6, "Activate", This, "Anm_Consulta_fin", 1)

		**Adiciona Botao Etiqueta - Lucas Miranda 06/10/2014***
		With Thisformset.Lx_form1.Lx_pageframe1.page7
			.AddObject("btn_etiqueta","btn_etiqueta")
			.AddObject("btn_importa_peca","btn_importa_peca")
		Endwith

		If !f_vazio(xalias)
			Sele &xalias
		Endif


		Thisformset.L_limpa()


		&&ismara - 27/09/2013 - criar o bot�o para imprimir etiquetas de MP
		Thisformset.Lx_form1.Lx_pageframe1.page1.AddObject("imprime_etq_mp","imprime_etq_mp")

		*** LUCAS MIRANDA ****
	Case Upper(xmetodo) == 'USR_INCLUDE_AFTER'
	

 				**** IN�CIO #12 - BLOQUEIO DO CAMPO CONDI��O PGTO - SILVIO LUIZ - 22/11/2016 ****
					if thisformset.p_tool_status $ 'IA'	
						If thisformset.pp_anm_blq_cond_pgto_005104 = .f.
								thisformset.lx_forM1.lx_pageframe1.page1.pageframe1.page1.tv_condicao_pgto.Enabled= .F.
						ENDIF
					ENDIF 
				**** FIM #12
	
	
		xalias=Alias()


		*** LUCAS MIRANDA REVIS�O 20/02/2015, AJUSTE PARA ENTRAR NA
		***	FILIAL REVISAO DE ACORDO COM O PARAMETRO ANM_FILIAL_REVISAO_MP
		Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page1.lx_entrada_revisao.Value = 0

		If !f_vazio(xalias)
			Sele &xalias
		Endif
		*** FIM LUCAS MIRANDA REVIS�O 20/02/2015 ***
		*********************
		*** #XML *****
	Case Upper(xmetodo) == 'USR_CLEAN_AFTER'

		xalias=Alias()

		Thisformset.p_pai_filtro_query = ""

		If !f_vazio(xalias)
			Sele &xalias
		Endif
		*** FIMM - #XML *****


	Case Upper(xmetodo) == 'USR_WHEN'

		xalias=Alias()

		*** #XML *** ALTERADO IF ABAIXO ****
		If Thisformset.p_tool_status = 'I' And (Upper(xnome_obj)=='BOTAO1' Or Upper(xnome_obj)=='BOTAO2')

			xEntDeposito = "Pedido \ Material - Cor Material, sem Entrada no Deposito"+Chr(13)
			xPedidoMat = ""
			xwhere = ""

			Sele v_entradas_00_ret1_mat
			Go Top

			Scan

				**** #XML -- ALTERADO ****
				f_select("SELECT FILIAL_A_ENTREGAR FROM COMPRAS WHERE PEDIDO = ?v_entradas_00_ret1_mat.PEDIDO","xFilDesposito")
				If Alltrim(v_entradas_00.Filial) $ Thisformset.pp_ANM_FILIAL_REVISAO_MP And ;
						ALLTRIM(xFilDesposito.FILIAL_A_ENTREGAR) $ Thisformset.pp_ANM_FILIAL_ARMAZEM
					*** #XML -- FIM ALTERADO ---

					Sele v_entradas_00_ret1_mat
					Replace Filial With v_entradas_00.Filial

				Endif

				Sele v_entradas_00_ret1_mat
			Endscan

			If Used("xFilDesposito")
				Use In xFilDesposito
			Endif


		Endif
		
		** Bloquear condi��o pagamento caso o fornecedor esteja marcado como nao valida pagamento
			If upper(xnome_obj)=='TV_CONDICAO_PGTO'
			 
				TEXT TO xMetodoPagamento NOSHOW textmerge
					select a.*, isnull(b.ANM_N_VALIDA_PAGAMENTO,0) ANM_N_VALIDA_PAGAMENTO 
					from fornecedores a 
					left join CTB_LX_METODO_PAGAMENTO b 
					on a.LX_METODO_PAGAMENTO = b.LX_METODO_PAGAMENTO 
					where fornecedor = '<<V_ENTRADAS_00.NOME_CLIFOR>>'
				Endtext
				F_select(xMetodoPagamento,"CurMetodoPagamento")

				Sele CurMetodoPagamento
 
				If !F_Vazio(CurMetodoPagamento.anm_n_valida_pagamento) AND CurMetodoPagamento.anm_n_valida_pagamento = .T.
				 	Thisformset.lx_forM1.lx_pageframe1.page1.pageframe1.page1.tv_condicao_pgto.Enabled= .F.
				Endif	
			Endif
		** Fim
		If !f_vazio(xalias)
			Sele &xalias
		Endif

	Case Upper(xmetodo) == 'USR_VALID'


		xalias=Alias()

		Sele v_entradas_00
		Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page1.Tv_RATEIO_FILIAL.Value = Thisformset.Lx_form1.Tx_CliFor1.Value
		f_select("select desc_rateio_filial from CTB_FILIAL_RATEIO where rateio_filial=?v_entradas_00.rateio_filial","curRATEIO",Alias())
		Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page1.tx_desc_filial_rateio.Value = curRATEIO.desc_rateio_filial


		If Used("curRATEIO")
			Use In curRATEIO
		Endif
 

		*** LUCAS MIRANDA REVIS�O 20/02/2015, AJUSTE PARA ENTRAR NA
		***	FILIAL REVISAO DE ACORDO COM O CADASTRO NA FILIAL
		If Upper(xnome_obj)=='LX_ENTRADA_REVISAO'
			f_select("SELECT FILIAL, VALOR_PROPRIEDADE FROM PROP_FILIAIS WHERE PROPRIEDADE = '00206' and filial = ?v_entradas_00.filial","xFilialRevisao")
			sele xFilialRevisao
			
				If f_vazio(xFilialRevisao.Filial)
					Messagebox("Filial Revisao N�o Encontrada."+CHR(13)+"N�o foi Poss�vel Selecionar a Revis�o."+CHR(13)+"Favor verificar !!",0+48)
					thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page1.lx_entrada_revisao.Value = 0
					Return .F.
				Else
					Sele v_entradas_00_ret1_mat
					If Reccount()>0
						If thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page1.lx_entrada_revisao.Value = 1
							Sele v_entradas_00_ret1_mat
							Go Top
							Scan
								Replace v_entradas_00_ret1_mat.Filial With xFilialRevisao.valor_propriedade
							Endscan
						Endif
					Endif 
				Endif  
		Endif		

		*** LUCAS MIRANDA REVIS�O 20/02/2015

		*** Bloqueia alterar a natureza ap�s a verifica��o caso o checkbox importa��o esteja marcado na tela em modo de inclus�o ou altera�ao **
		If v_entradas_00.importacao=.T.
			If Thisformset.p_tool_status $ 'I,A'
				Thisformset.Lx_form1.tv_operacao.ReadOnly= .T.
			Endif
		Else
			Thisformset.Lx_form1.tv_operacao.ReadOnly= .F.
		Endif
		*** Fim do exclusivo de valida��o da natureza na entrada de importa��o ******
		*****************************************************************************



		**** Julio - Veficica junto ao par�metro ANM_NATUREZAS_IMPORTACAO as naturezas Permitidas para entrada de importa��o. ****
		If Upper(xnome_obj)=='CK_IMPORTACAO'

			Sele v_entradas_00
			xSelImp = "SELECT COUNT(*) AS EntImpOK  FROM PARAMETROS WHERE PARAMETRO = 'ANM_NATUREZAS_IMPORTACAO' AND ( VALOR_ATUAL LIKE '%"+Allt(v_entradas_00.NATUREZA)+"%' OR VALOR_ATUAL = 'LIBERADO' )"
			f_select(xSelImp,"xteste")

			If xteste.EntImpOK = 0
				Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page1.Ck_importacao.Value=0
				Messagebox('N�o � permitido Entrada de Importa��o com essa natureza'+Chr(13)+'Favor Procurar o Dpto. Fiscal.',64)
			Endif

			If Used("xteste")
				Use In xteste
				Release xSelImp
			Endif

		Endif



		If Upper(xnome_obj)=='TX_CUSTO_MATERIA_PRIMA'

			*f_select("select convert(numeric(8,2),valor_atual) as dif_max from parametros where parametro='ANM_DIF_MAX_VALOR_ENT_MAT'","curDifmax",alias())
			*if (o_005104.lx_FORM1.lx_pageframe1.page6.lx_grid_filha1.Col_tx_custo_materia_prima.tx_custo_materia_prima.OldValue-nvl(o_005104.lx_FORM1.lx_pageframe1.page6.lx_grid_filha1.Col_tx_custo_materia_prima.tx_custo_materia_prima.Value,0))<curDifmax.dif_max
			If Abs(   Nvl(o_005104.Lx_form1.Lx_pageframe1.page6.lx_grid_filha1.Col_tx_custo_materia_prima.tx_custo_materia_prima.OldValue,0)- ;
					NVL(o_005104.Lx_form1.Lx_pageframe1.page6.lx_grid_filha1.Col_tx_custo_materia_prima.tx_custo_materia_prima.Value,0) ;
					) > Nvl(Thisformset.pp_anm_dif_max_valor_ent_mat,0)

				Messagebox("N�o � poss�vel alterar esta Informa��o!"+Chr(13)+"A Altera��o Excedeu o Limite de Diferen�a.",48,"Aten��o")
				o_005104.Lx_form1.Lx_pageframe1.page6.lx_grid_filha1.Col_tx_custo_materia_prima.tx_custo_materia_prima.Value=o_005104.Lx_form1.Lx_pageframe1.page6.lx_grid_filha1.Col_tx_custo_materia_prima.tx_custo_materia_prima.OldValue
				o_005104.Lx_form1.Lx_pageframe1.page6.lx_grid_filha1.Col_tx_custo_materia_prima.tx_custo_materia_prima.l_desenhista_recalculo()
				o_005104.Lx_form1.Lx_pageframe1.page6.lx_grid_filha1.Refresh()

			Endif

		Endif

		****lucas colocar especie serie padrao ao inserir a chave***
		If Upper(xnome_obj)=='TXT_CHAVE_NFE' Or Upper(xnome_obj)=='TV_NOME_CLIFOR'

			parametro_chave=Thisformset.pp_valida_chave_nfe_entrada
			serie_nf_desc=Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page1.tv_Desc_Especie_Serie.Value

			If parametro_chave = .T. And serie_nf_desc = 'NF-E'
				Sele v_entradas_00
				xEspecie_Serie = 5

				Replace ESPECIE_SERIE  With xEspecie_Serie
			Endif


			Release parametro_chave,serie_nf_desc

		Endif

		If Upper(xnome_obj)=='TX_PERDA'

			If Thisformset.p_tool_status="P" And v_entradas_00.anm_status_entrada <>"4-FINALIZADO"

				TEXT TO xupdtPerda NOSHOW textmerge

								UPDATE ESTOQUE_RET1_MAT SET
								PERDA=<<v_entradas_00_ret1_mat.perda>>
								WHERE REQ_MATERIAL='<<v_entradas_00_ret1_mat.req_material>>'
								AND FILIAL='<<v_entradas_00_ret1_mat.filial>>'
								AND MATERIAL='<<v_entradas_00_ret1_mat.material>>'
								AND COR_MATERIAL='<<v_entradas_00_ret1_mat.cor_material>> '
								AND ITEM='<<v_entradas_00_ret1_mat.item>> '

				ENDTEXT

				If !f_update(xupdtPerda)
					Messagebox("N�o foi Poss�vel Alterar a Perda!!!")
				Else
					Messagebox("Altera��o com Sucesso!!!")
					Thisformset.Lx_form1.Lx_pageframe1.page6.lx_grid_filha1.Col_tx_perda.Enabled = .F.
				Endif

			Endif

		Endif


		** Passa numero da NF para inteiro ** #XML_2015
		If Thisformset.p_tool_status = 'I' And Upper(xnome_obj)=='TX_NF_ENTRADA'

			Thisformset.Lx_form1.TX_NF_ENTRADA.Value = Int(Val(Thisformset.Lx_form1.TX_NF_ENTRADA.Value))

		Endif
		** FIM - Passa numero da NF para inteiro ** #XML_2015

		If	!f_vazio(xalias)
			Sele &xalias
		Endif



	Case Upper(xmetodo) == 'USR_REFRESH'

		xalias=Alias()

		*** Trata o caption do bot�o - #XML *****
		If Type("thisformset.lx_form1.lx_PAGEFRAME1.page6.bt_finaliza_revisao")<>"U"
			If Thisformset.p_tool_status <> 'L'
				Thisformset.Lx_form1.Lx_pageframe1.page6.bt_finaliza_revisao.Caption = "Finalizar Revis�o"
				Thisformset.Lx_form1.Lx_pageframe1.page6.bt_finaliza_revisao.Enabled = .T.
			Else
				Thisformset.Lx_form1.Lx_pageframe1.page6.bt_finaliza_revisao.Caption = "Pendente Finalizar"
				Thisformset.Lx_form1.Lx_pageframe1.page6.bt_finaliza_revisao.Enabled = .T.
			Endif
		Endif

		If Used("vOLD_v_entradas_00_ret1_mat")
			Use In vOLD_v_entradas_00_ret1_mat
		Endif

		Select * From v_entradas_00_ret1_mat Into Cursor vOLD_v_entradas_00_ret1_mat Readwrite
		*** Fim - Trata o caption do bot�o - #XML *****


		If Type("Thisformset.lx_form_rateios")<>"U"
			Thisformset.lx_form_rateios.Width=700
		Endif

		If Type("thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.Cnt_producao.tx_valor_tempo")<>"U"
			xtempo_producao = Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page2.Cnt_producao.tx_valor_tempo.Value
		Else
			xtempo_producao = 0
		Endif

		If Type("thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.tx_anm_rateio_producao")<>"U"
			xvalor_producao = (Round( v_entradas_00.valor_total/(1-(xtempo_producao/100)) ,2))-Nvl(v_entradas_00.anm_rateio_producao,0)
			If Thisformset.p_tool_status = "P"
				Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page2.tx_anm_rateio_producao.Enabled = .F.
			Endif

			Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page2.tx_valor_producao.Visible=.T.

		Endif

		** Volta Valor do campo para default **
		Thisformset.Lx_form1.tv_operacao.ReadOnly= .F.
		*** LUCAS MIRANDA REVIS�O 20/02/2015, AJUSTE PARA ENTRAR NA
		***	FILIAL REVISAO DE ACORDO COM O PARAMETRO ANM_FILIAL_REVISAO_MP
		If Type("THISFORMSET.lx_form1.lx_pageframe1.page1.pageframe1.page1.lx_entrada_revisao") <> "U"
			If Thisformset.p_tool_status = "I"
				Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page1.lx_entrada_revisao.Enabled = .T.
			Else
				Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page1.lx_entrada_revisao.Enabled = .F.
			Endif
		Endif
		*** LUCAS MIRANDA REVIS�O 20/02/2015

		If	!f_vazio(xalias)
			Sele &xalias
		Endif


	Case Upper(xmetodo) == 'USR_SAVE_BEFORE'

		xalias=Alias()

		nf_entrada_propria_false=Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page1.ck_nf_propria.Value
		*!* Chama a fun��o dispon�vel na classe criada para tratar xml *!* #XML_2015
		If Type("o_005104.pp_anm_obj_entrada_xml")<>'U' And Thisformset.pp_anm_obj_entrada_xml And ! nf_entrada_propria_false
			If ! o_anm.l_anm_valida_xml('o_005104',xmetodo, xobjeto ,xnome_obj,Thisformset.p_tool_status)
				Return .F.
			Endif
		Endif

		***** Saida Autom�tica dos materiais comprados para Pilotagem **** #XML_2015


		***** Saida Autom�tica dos materiais comprados para Pilotagem ****
		If Thisformset.pp_anm_saida_auto_piloto And Thisformset.p_tool_status = 'E'
			*-MIT 13/09/2017 - nao permitir excluir com aceite do financeiro
			VLC_Select = "select VALOR_ATUAL_USER from PARAMETROS_USERS where PARAMETRO = 'csm_permite_apagar' and usuario = '" + wusuario + "'"
			F_Select(VLC_Select, 'cur_param')
			
			GO TOP IN cur_param
			
			IF !cur_param.VALOR_ATUAL_USER = '.T.' OR EOF('cur_param')
				IF !f_vazio(V_ENTRADAS_00.ctb_lancamento)
					VLC_Select = "select COUNT(1) as num from CTB_ACOMPANHAMENTO where LANCAMENTO = ?V_ENTRADAS_00.ctb_lancamento and item = ?V_ENTRADAS_00.ctb_item and ocorrencia = 900"
					F_Select(VLC_Select, 'cur_ac')
					
					IF NVL(cur_ac.num,0) > 0
						USE IN cur_ac
						USE IN cur_param
						MESSAGEBOX("Nota fiscal ja foi aceita pelo financeiro. Nao e possivel sua exclusao!",48,wusuario)
						RETURN .f.
					ENDIF
				endif
			ENDIF
			
			USE IN cur_param

			* Fim Mit
		
		

			Select Distinct PEDIDO,Filial,NF_ENTRADA,NOME_CLIFOR,SERIE_NF_ENTRADA From v_entradas_00_ret1_mat Into Cursor xTMP_EPed
			Sele xTMP_EPed
			Go Top

			Scan
				f_update("EXEC LX_ANM_GERA_SAIDA_PILOTO ?xTMP_EPed.PEDIDO,?xTMP_EPed.FILIAL,?xTMP_EPed.NOME_CLIFOR,?xTMP_EPed.NF_ENTRADA,?xTMP_EPed.SERIE_NF_ENTRADA,?o_005104.p_tool_status")

				Sele xTMP_EPed
			Endscan

			If Used("xTMP_EPed")
				Use In xTMP_EPed
			Endif

		Endif


		Sele v_entradas_00
		Replace filial_cobranca With v_entradas_00.Filial

		*** LUCAS MIRANDA ****
		If Thisformset.p_tool_status == 'I'

			parametro_chave=Thisformset.pp_valida_chave_nfe_entrada
			chave_nfe=Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page_NFE.txt_chave_nfe.Value
			serie_nf_desc=Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page1.tv_Desc_Especie_Serie.Value
			nf_entrada_propria=Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page1.ck_nf_propria.Value

			If parametro_chave And f_vazio(chave_nfe) And serie_nf_desc = 'NF-E' And ! nf_entrada_propria
				Messagebox("VOC� N�O INFORMOU A CHAVE !!!" + Chr(13) + "FAVOR INSERIR A CHAVE !",64)
				Return .F.
			Endif

		Endif

		If Thisformset.p_tool_status == 'E'

			Messagebox("Aten��o, Todos os Seus Dados Ser�o Armazenados ",48,"Aten��o_9!")
			xmotivo_exclusao = Inputbox('Descreva o motivo da Exclus�o','Motivo Exclus�o (Campo Obrigat�rio)','')

			TEXT to	xinsert1 noshow textmerge
							INSERT INTO ANM_LOG_EXCLUSAO_NF
							(NF_ENTRADA,SERIE_NF,FILIAL,NOME_CLIFOR,DATA_DIGITACAO,EMISSAO,RECEBIMENTO,VALOR,DATA_EXCLUSAO,
							MOTIVO_EXCLUSAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA)

							SELECT '<<V_ENTRADAS_00.NF_ENTRADA>>','<<V_ENTRADAS_00.SERIE_NF_ENTRADA>>','<<V_ENTRADAS_00.FILIAL>>',
							'<<V_ENTRADAS_00.NOME_CLIFOR>>','<<V_ENTRADAS_00.DATA_DIGITACAO>>','<<V_ENTRADAS_00.EMISSAO>>',
							'<<V_ENTRADAS_00.RECEBIMENTO>>','<<V_ENTRADAS_00.VALOR_TOTAL>>',(SELECT GETDATE()),'<<XMOTIVO_EXCLUSAO>>',
							'<<WUSUARIO>>','<<SYSTEM.NetUserName>>','<<SYSTEM.NetComputerName>>'
			ENDTEXT

			If !f_insert(xinsert1)
				Messagebox("N�o foi poss�vel Excluir a Nota Fiscal ",48,"Aten��o_9!")
				Retu .F.
			Endif

			Release xinsert1,xmotivo_exclusao

		Endif

		TEXT to	xupdt noshow
				insert into prop_entradas
				(PROPRIEDADE,ITEM_PROPRIEDADE,VALOR_PROPRIEDADE,NF_ENTRADA,SERIE_NF_ENTRADA,NOME_CLIFOR)
				select
				'00014',1,b.valor_propriedade,a.nf_entrada, a.serie_nf_entrada,a.nome_clifor
				from
				(select top 1 a.pedido,a.nome_clifor,a.nf_entrada,a.serie_nf_entrada
				from entradas_material a
				where a.nome_clifor    = ?v_entradas_00.nome_clifor
				and a.nf_entrada       = ?v_entradas_00.nf_entrada
				and a.serie_nf_entrada = ?v_entradas_00.serie_nf_entrada ) a
				join prop_compras b
				on a.pedido=b.pedido
				and b.propriedade = '00010'
				left join prop_entradas c
				on  a.nome_clifor      = c.nome_clifor
				and a.nf_entrada       = c.nf_entrada
				and a.serie_nf_entrada = c.serie_nf_entrada
				and c.propriedade = '00014'
				where c.nome_clifor is null
		ENDTEXT

		If !f_update(xupdt)
			Messagebox("N�o foi poss�vel Inserir Propriedade")
		Endif

		Release xupdt

		If	!f_vazio(xalias)
			Sele &xalias
		Endif

		*MIT[1] - INICIO
		IF thisformset.p_tool_status = 'A'
			*- Verifico se houve altera��o no desconto
			VLC_Select = "select ISNULL(ANM_RATEIO_PRODUCAO,0) as ANM_RATEIO_PRODUCAO from entradas where nf_entrada = ?v_entradas_00.nf_entrada and nome_clifor = ?v_entradas_00.NOME_CLIFOR AND serie_nf_entrada = ?v_entradas_00.serie_nf_entrada"
			F_Select(VLC_Select, 'cur_desc')
			
			IF cur_desc.ANM_RATEIO_PRODUCAO <> v_entradas_00.ANM_RATEIO_PRODUCAO
				*- Verifico se o titulo ja foi enviado para o banco
				VLC_Select = "SELECT COUNT(1) as num FROM CTB_BORDERO_PARCELA_NOTA (nolock) where LANCAMENTO_MOV = ?v_entradas_00.ctb_lancamento	and item_mov = ?v_entradas_00.nf_entrada.ctb_item" 
				F_Select(VLC_select, 'cur_bordero')
				
				IF cur_bordero.num > 0
					USE IN cur_desc
					USE IN cur_bordero
					MESSAGEBOX('Titulo j� enviado para banco! Contactar o financeiro!', 16, wusuario)
					RETURN .F.
				ENDIF
				USE IN cur_bordero
				
				*- verifico se o lancamento do desconto ja foi efetuado
				SELECT curpropentradas
				LOCATE FOR propriedade = '00280'
				VLC_Lancamento = ''
				IF FOUND()
					VLC_Lancamento = curpropentradas.valor_propriedade
				ENDIF
				
				IF !f_vazio(VAL(VLC_Lancamento))
					*- Verifico se o lancamento ainda existe
					VLC_Select = "SELECT COUNT(1) as num FROM ctb_lancamento (nolock) where lancamento = " + VLC_Lancamento 
					F_Select(VLC_select, 'cur_lanc')
					
					IF cur_lanc.num > 0
						USE IN cur_desc
						USE IN cur_lanc
						MESSAGEBOX('J� existe lancamento de desconto! Contactar o financeiro!', 16, wusuario)
						RETURN .F.
					ENDIF
					USE IN cur_mov					
				
				ENDIF
				
				
				*-Verifico se o titulo ja teve alguma movimentacao que nao seja a baixa do desconto
				VLC_Select = "SELECT COUNT(1) as num FROM CTB_A_PAGAR_MOV (nolock) where LANCAMENTO_MOV = ?v_entradas_00.ctb_lancamento	and item_mov = ?v_entradas_00.nf_entrada.ctb_item" + IIF(f_vazio(VLC_Lancamento), '', " and lancamento <> '" + VLC_Lancamento + "'")
				F_Select(VLC_select, 'cur_mov')
				
				IF cur_mov.num > 0
					USE IN cur_desc
					USE IN cur_mov
					MESSAGEBOX('Titulo j� foi movimentado. N�o foi poss�vel aplicar o desconto! Contactar o financeiro!', 16, wusuario)
					RETURN .F.
				ENDIF
				USE IN cur_mov
				
				*- WRP - 19/08/2016 (projeto n�)Verifico se o titulo ja teve algum acompanhamento
				VLC_Select = "SELECT COUNT(1) as num FROM w_ctb_acompanhamento (nolock) where LANCAMENTO = ?v_entradas_00.ctb_lancamento" + IIF(f_vazio(VLC_Lancamento), '', " and lancamento <> '" + VLC_Lancamento + "'")
				F_Select(VLC_select, 'cur_acomp')
				
				IF cur_acomp.num > 0
					USE IN cur_desc
					USE IN cur_acomp
					MESSAGEBOX('Titulo j� foi movimentado no acompanhamento. N�o foi poss�vel aplicar o desconto! Contactar o financeiro!', 16, wusuario)
					RETURN .F.
				ENDIF
				USE IN cur_acomp
				*- FIM - WRP - 19/08/2016 (projeto n�)Verifico se o titulo ja teve algum acompanhamento
				
			ENDIF
			USE IN cur_desc
		ENDIF
		*MIT[1] - FIM



	Case Upper(xmetodo) == 'USR_SAVE_AFTER'

		xalias=Alias()
		
		*** Entrega Direta ***
		
		xMsgEntregaDireta=''
		if used("curEntregaDireta") 
			use in curEntregaDireta
		endif

		sele v_entradas_00_ret1_mat
		Go Top
		Scan
			f_select("select * from compras where tabela_filha='compras_material' and pedido=?v_entradas_00_ret1_mat.pedido","curEntregaDireta")
			Sele curEntregaDireta
			If curEntregaDireta.gs_entrega_direta = .t.
				If !ALLTRIM(v_entradas_00_ret1_mat.pedido) $ xMsgEntregaDireta
					xMsgEntregaDireta = xMsgEntregaDireta + ALLTRIM(v_entradas_00_ret1_mat.pedido)+ ' , '
				Endif
			Endif
			
			sele v_entradas_00_ret1_mat
		Endscan

		If !F_Vazio(xMsgEntregaDireta)
			MESSAGEBOX("Esse(s) pedido(s) �(s�o) uma entrega direta: "+LEFT(xMsgEntregaDireta,LEN(xMsgEntregaDireta)-2),0+64)
		Endif	
		*** Fim Entrega Direta ***
		
		***** Saida Autom�tica dos materiais comprados para Pilotagem ****
		If Thisformset.pp_anm_saida_auto_piloto And Thisformset.p_tool_status <> 'E'

			Select Distinct PEDIDO,Filial,NF_ENTRADA,NOME_CLIFOR,SERIE_NF_ENTRADA From v_entradas_00_ret1_mat Into Cursor xTMP_EPed
			Sele xTMP_EPed
			Go Top

			Scan
				f_update("EXEC LX_ANM_GERA_SAIDA_PILOTO ?xTMP_EPed.PEDIDO,?xTMP_EPed.FILIAL,?xTMP_EPed.NOME_CLIFOR,?xTMP_EPed.NF_ENTRADA,?xTMP_EPed.SERIE_NF_ENTRADA,?o_005104.p_tool_status")

				Sele xTMP_EPed
			Endscan

			If Used("xTMP_EPed")
				Use In xTMP_EPed
			Endif

		Endif

						************INICIO CUSTO MEDIO MATERIAIS*********************	
						If v_entradas_00.tipo_operacao='C' OR v_entradas_00.natureza='201.01'
									
									*** Inclus�o feito Por Julio para n�o calcular o custo quando o pedido de compra for mostru�rio **** Giselli e Patricia (Farm)
									*** 11-03-2015 19:36
									*** #Julio#Animale - Inicio
									f_select("SELECT SPACE(8) as pedido,SPACE(11) as material,SPACE(10) cor_material where 1=2","Vanm_exclui_pedido",alias())

									select v_entradas_00_ret1_mat
									go top
									scan
										
										text to txselect textmerge noshow
											
											select a.pedido,material,cor_material 
												from compras a join compras_material b on a.pedido = b.pedido 
											
											where a.pedido = '<<v_entradas_00_ret1_mat.pedido>>' and
											      material  = '<<v_entradas_00_ret1_mat.material>>' and
											      cor_material = '<<v_entradas_00_ret1_mat.cor_material>>' and
											      '<<o_005104.pp_anm_tipo_compra_most>>' not like ('%'+rtrim(ltrim(tipo_compra))+'%')
										
										endtext

										f_select(txselect,"tempcurtipoped")
										if reccount()>0
											insert into vanm_exclui_pedido select * from tempcurtipoped
										endif
										
										if used("tempcurtipoped")
											select tempcurtipoped
											use
										endif
									
										select v_entradas_00_ret1_mat
									endscan	

									select v_entradas_00_ret1_mat
									go top

									select	a.material,a.cor_material,filial,sum(qtde) as qtde, ; 
									sum(valor) as valor from v_entradas_00_ret1_mat	a;
											join  vanm_exclui_pedido b ;
											on a.pedido = b.pedido and a.material = b.material and a.cor_material = b.cor_material;
									group by  a.material,a.cor_material,filial ; 
									into cursor	curentmat
									
									if used("vanm_exclui_pedido")
										select vanm_exclui_pedido
										use
									endif
										
								
								*** #Julio#Animale - Fim

										

										text to	xselmov1 noshow	
											select a.*,sum(qtde_estoque) as qtde_estoque 
											from 
											(select emissao,documento,material,cor_material,tipo,qtde,saldo,
											(valor) as valor_ent,
											convert(numeric(14,5),((valor)/qtde)) as valor_unit 
										endtext	


										Text to	xupd noshow				 
										   UPDATE Materiais_Cores    
										   set  custo_reposicao = convert(numeric(14,2),?xcustomedio),    
										   custo_a_vista = convert(numeric(14,2),?xcustomedio)    
										   WHERE Material=?curEntMat.material   
										   AND Cor_Material=?curEntMat.cor_material  
										Endtext		
										
										
										Sele curEntMat	
										go top	

										scan	
											
											f_prog_bar('Atualizando Pre�o Medio de Entrada dos Materiais...',recno(),reccount()) 
											
								
*!*												xselmov2 = " from FX_ANM_Monta_Cardex_01 ('" +allt(curEntMat.material)+"' , '"+ ; 
*!*							 		            allt(curEntMat.cor_material)+"' , '%' , NULL, 0) " + ;
*!*												"where tipo='ENTRADA DE N.F.') a " + ;
*!*												"join estoque_materiais b  " + ;
*!*												"on a.material=b.material and a.cor_material=b.cor_material " +;
*!*												"group by emissao,documento,a.material,a.cor_material,tipo,qtde,saldo,valor_ent,valor_unit "  
*!*												

*!*												if !f_select(xselmov1+xselmov2,"curCardex")
*!*													messagebox('N�o foi p�ss�vel selecionar movimenta��o dos materiais !',32,'Aten��o_3 !!!')
*!*													retu .f.
*!*												endif		
*!*												sele curCardex	
*!*													xsaldoant		= 0
*!*													xvalorant		= 0
*!*													xvalorestapos	= 0
*!*													xcustomedio		= 0
*!*													xcustoant		= 0 
*!*													xseq_calc       = 0  
*!*												scan	
*!*													xsaldoant		= iif( (curCardex.saldo-curCardex.qtde)<0,0,(curCardex.saldo-curCardex.qtde) )
*!*													xvalorant		= xsaldoant * iif( (xseq_calc=0 and xsaldoant>0), curCardex.valor_unit , xcustoant )
*!*													xvalorestapos	= curCardex.valor_ent+xvalorant
*!*													xcustomedio		= xvalorestapos/iif(curCardex.saldo<=curCardex.qtde,curCardex.qtde,curCardex.saldo) 
*!*													xcustoant		= xcustomedio 
*!*													xseq_calc       = xseq_calc + 1 
*!*												endscan							
											
											sele curEntMat	

*!*												if !f_update(xupd)	 
*!*													messagebox('N�o foi p�ss�vel atualizar os custo medio dos materiais !',32,'Aten��o_4 !!!')
*!*													retu .f.
*!*												endif	
											if !f_update("EXEC PROC_GS_CALCULA_CUSTO_MAT ?curEntMat.material,?curEntMat.cor_material")	 
												messagebox('N�o foi p�ss�vel atualizar os custo medio dos materiais !',32,'Aten��o_4 !!!')
												retu .f.
											endif	
											sele curEntMat	
											
										endscan	
										f_prog_bar()
						
						
							Endif			
						************FIM CUSTO MEDIO MATERIAIS*********************

		If	!f_vazio(xalias)
			Sele &xalias
		Endif

	
	*Mit[1]					
	Case Upper(xmetodo) == 'USR_TRIGGER_AFTER'
		VLC_Execute = "exec MIT_DESCONTO_PRODUCAO ?v_entradas_00.nome_clifor, ?v_entradas_00.nf_entrada, ?v_entradas_00.serie_nf_entrada"
		IF !f_execute(VLC_Execute)
			RETURN .F.
		ENDIF
	*MIT[1] - FIM
	
	Otherwise
		Return .T.
	Endcase
	Endproc

	**** #XML ****
	Procedure Anm_Ctrl_Check

	xalias=Alias()

	Sele vOLD_v_entradas_00_ret1_mat
	Locate For material = v_entradas_00_ret1_mat.material And cor_material = v_entradas_00_ret1_mat.cor_material

	If vOLD_v_entradas_00_ret1_mat.anm_status_saida_item

		Thisformset.Lx_form1.Lx_pageframe1.page6.lx_grid_filha1.col_Liberar_revisao.ck_Liberar_revisao.Value = 1

	Endif

	If !f_vazio(xalias)
		Sele &xalias
	Endif

	Endproc
	**** FIM - #XML ****

	Procedure Anm_Consulta_fin

	xalias=Alias()

	*** Tratamento do status dos objetos ref. a entrada 2AA ***
	If !Empty(Nvl(v_entradas_00.anm_status_entrada,""))
		Thisformset.Lx_form1.Lx_pageframe1.page6.bt_gera_pedido.Visible    = .F.
		Thisformset.Lx_form1.Lx_pageframe1.page6.cmb_filial_pedido.Enabled = .F.

		f_select("SELECT FILIAL_DESTINO FROM ESTOQUE_SAI_MAT WHERE REQ_MATERIAL = replace(?v_entradas_00.ANM_STATUS_ENTRADA,'Pedido Gerado: ','')","xFilDest")

		Thisformset.Lx_form1.Lx_pageframe1.page6.lb_Pedido_Gerado.Visible = .T.
		Thisformset.Lx_form1.Lx_pageframe1.page6.lb_Pedido_Gerado.Caption = Nvl(v_entradas_00.anm_status_entrada,"")
		Thisformset.Lx_form1.Lx_pageframe1.page6.cmb_filial_pedido.Value  = xFilDest.FILIAL_DESTINO
		Thisformset.Lx_form1.Lx_pageframe1.page6.lb_Pedido_Gerado.Left=712
	Else
		Thisformset.Lx_form1.Lx_pageframe1.page6.bt_gera_pedido.Visible   = .T.
		Thisformset.Lx_form1.Lx_pageframe1.page6.cmb_filial_pedido.Enabled= .T.

		Thisformset.Lx_form1.Lx_pageframe1.page6.lb_Pedido_Gerado.Visible = .F.
		Thisformset.Lx_form1.Lx_pageframe1.page6.lb_Pedido_Gerado.Caption = ""
		Thisformset.Lx_form1.Lx_pageframe1.page6.cmb_filial_pedido.Value  = ""
	Endif
	*** Tratamento do status dos objetos ref. a entrada 2AA ***

	If Used("xFilDest")
		Use In xFilDest
	Endif

	If !f_vazio(xalias)
		Sele &xalias
	Endif

	Endproc

Enddefine

************************************************** #XML ***
*-- Class:        pendente_finalizar_ent (c:\pastas\anm_class\pendente_finalizar_ent.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/15/14 01:18:07 PM
*
Define Class bt_finaliza_revisao As CommandButton


	Top = 63
	Left = 33
	Height = 23
	Width = 140
	FontBold = .T.
	Caption = "Pendente Finalizar"
	TabIndex = 40
	Name = "bt_finaliza_revisao"
	Visible = .T.
	Enabled =.T.

	Procedure Click

	If Thisformset.Lx_form1.Lx_pageframe1.page6.bt_finaliza_revisao.Caption = "Pendente Finalizar"

		xOld_p_pai_filtro_query = Thisformset.p_pai_filtro_query

		Select v_entradas_00
		Replace v_entradas_00.Filial With Thisformset.pp_ANM_FILIAL_REVISAO_MP
		Thisformset.p_pai_filtro_query = " ENTRADAS.NOME_CLIFOR+ENTRADAS.NF_ENTRADA+ENTRADAS.SERIE_NF_ENTRADA IN "+;
			" (SELECT DISTINCT NOME_CLIFOR+NF_ENTRADA+SERIE_NF_ENTRADA FROM ESTOQUE_RET_MAT A "+;
			" JOIN ESTOQUE_RET1_MAT B ON A.REQ_MATERIAL = B.REQ_MATERIAL AND A.FILIAL = B.FILIAL "+;
			" WHERE ISNULL(ANM_STATUS_SAIDA_ITEM,0) = 0 AND "+;
			" A.FILIAL = (SELECT DBO.FX_ANM_PARAMETRO_USER('ANM_FILIAL_REVISAO_MP') ) ) "
		o_toolbar.Botao_procura.Click()
	Else
		If Messagebox("Deseja Finalizar a Revis�o do Itens Marcados?",4+32+256,"Aten��o!")=6

			xFiltroFunc = ""
			xRomaneioRev = ""

			Select v_entradas_00_ret1_mat
			Go Top
			Scan
				If v_entradas_00_ret1_mat.anm_status_saida_item == .T.
					Sele vOLD_v_entradas_00_ret1_mat
					Locate For material =v_entradas_00_ret1_mat.material And cor_material = v_entradas_00_ret1_mat.cor_material And ;
						REQ_MATERIAL = v_entradas_00_ret1_mat.REQ_MATERIAL And NOME_CLIFOR = v_entradas_00_ret1_mat.NOME_CLIFOR And ;
						ITEM = v_entradas_00_ret1_mat.Item

					If Nvl(vOLD_v_entradas_00_ret1_mat.anm_status_saida_item,.F.) == .F.
						xFiltroFunc = xFiltroFunc + vOLD_v_entradas_00_ret1_mat.Item+","
						If! Alltrim(vOLD_v_entradas_00_ret1_mat.REQ_MATERIAL) $ xRomaneioRev
							xRomaneioRev = xRomaneioRev + "|"+Alltrim(vOLD_v_entradas_00_ret1_mat.REQ_MATERIAL)+"|,"
						Endif
						
						f_select("SELECT FILIAL, VALOR_PROPRIEDADE FROM PROP_FILIAIS WHERE PROPRIEDADE = '00206' and filial = ?v_entradas_00.filial","xFilialRevisaoFin")
						sele xFilialRevisaoFin
						If Alltrim(vOLD_v_entradas_00_ret1_mat.Filial) <> Alltrim(xFilialRevisaoFin.VALOR_PROPRIEDADE)
							Messagebox('ATEN��O ... Finaliza��o n�o Permitida.',64)
							Return .F.
						Endif
*!*							If Alltrim(vOLD_v_entradas_00_ret1_mat.Filial) <> Alltrim(Thisformset.pp_ANM_FILIAL_REVISAO_MP)
*!*								Messagebox('ATEN��O ... Finaliza��o n�o Permitida.',64)
*!*								Return .F.
*!*							Endif
					Endif

					Select v_entradas_00_ret1_mat
				Endif
			Endscan

			If Empty(xFiltroFunc)
				Messagebox('Os Materiais selecionados j� foram Finalizados.',64)
			Else
				xFiltroFunc = Left(xFiltroFunc,Len(xFiltroFunc)-1)
				xRomaneioRev = Left(xRomaneioRev,Len(xRomaneioRev)-1)

				Sele v_entradas_00_ret1_mat
				Go Top

				TEXT TO xExecProc TEXTMERGE NOSHOW

	                                                     EXECUTE LX_ANM_GERA_PEDIDO_OL_ENT_ITEM  '<<v_entradas_00_ret1_mat.nome_clifor>>','<<v_entradas_00_ret1_mat.nf_entrada>>',
	                                                                                             '<<v_entradas_00_ret1_mat.serie_nf_entrada>>','<<xRomaneioRev>>',
	                                                                                             '<<xFiltroFunc>>'

				ENDTEXT


				If !f_update(xExecProc)
					Return .F.
				Endif

				Messagebox('Revis�o Finalizada com sucesso!',64)

				Sele v_entradas_00_ret1_mat
				Go Top

				Scan
					Sele vOLD_v_entradas_00_ret1_mat
					Locate For material = v_entradas_00_ret1_mat.material And cor_material = v_entradas_00_ret1_mat.cor_material And ;
						REQ_MATERIAL = v_entradas_00_ret1_mat.REQ_MATERIAL And NOME_CLIFOR = v_entradas_00_ret1_mat.NOME_CLIFOR And;
						ITEM = v_entradas_00_ret1_mat.Item

					Replace anm_status_saida_item With v_entradas_00_ret1_mat.anm_status_saida_item

					Sele v_entradas_00_ret1_mat

				Endscan
			Endif

			Sele v_entradas_00_ret1_mat
			Go Top
		Endif
	Endif

	Endproc


Enddefine
*
*-- EndDefine: pendente_finalizar_ent
************************************************** FIM - #XML ***



**************************************************
*-- Class:        bt_pedidos_mat (c:\temp\rbx\bt_pedidos_mat.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   11/20/08 01:37:01 PM
*
Define Class Botao_Pedido As botao


	Top = 42
	Left = 417
	Height = 23
	Width = 291
	FontBold = .T.
	Caption = "\<Pedidos de compra"
	TabIndex = 7
	ForeColor = Rgb(128,0,0)
	ZOrderSet = 14
	Name = "Botao_Pedido"
	Visible = .T.

	Procedure Click
	Local nOldSele, cWhereNF, cWhere, cSQL As String

	nOldSele = Select()

	If ! Inlist(Thisformset.p_tool_status, "I", "A") Or v_entradas_00.NOTA_COMPLEMENTAR

		Select(nOldSele)
		Return

	Endif

	If Inlist(v_entradas_00.tipo_operacao, "D", "N")

		F_Msg(["N�o � poss�vel utilizar essa op��o para devolu��es !", 0+48, "Aten��o"])
		Select(nOldSele)
		Return

	Endif

	If f_vazio(v_entradas_00.NOME_CLIFOR)

		F_Msg(["Informe o fornecedor para selecionar os pedidos !", 0+48, "Aten��o"])
		Select(nOldSele)
		Return .F.

	Endif

	With This.Parent.Parent

		.Page8.cmb_Fornecedores.ControlSource = ""
		.Page8.cmb_Fornecedores.RowSource     = ""
		.Page8.cmb_PEDIDOS.ControlSource	  = ""
		.Page8.cmb_PEDIDOS.RowSource		  = ""

	Endwith


	If Used("xCur_Pedidos")

		Select xCur_Pedidos
		Use

	Endif

	If Used("xCur_Pedidos_Fornec")

		Select xCur_Pedidos_Fornec
		Use

	Endif


	If Thisformset.px_Bloq_EntPed_NOP
		cWhereNF = " AND ( COMPRAS.NATUREZA_ENTRADA IS NULL OR COMPRAS.NATUREZA_ENTRADA = ?v_Entradas_00.NATUREZA ) "
	Else
		cWhereNF = ""
	Endif

	cWhere = "RTRIM(COMPRAS.TABELA_FILHA) = 'COMPRAS_MATERIAL' AND " + ;
		"COMPRAS.TOT_QTDE_ENTREGAR > 0 AND " + ;
		"COMPRAS.STATUS_APROVACAO = 'A' AND " + ;
		"COMPRAS.FORNECEDOR = ?v_entradas_00.nome_clifor  " + ;
		cWhereNF

	*!*			cWhere = "RTRIM(COMPRAS.TABELA_FILHA) = 'COMPRAS_MATERIAL' AND " + ;
	*!*			         "COMPRAS.TOT_QTDE_ENTREGAR > 0 AND " + ;
	*!*			         "COMPRAS.STATUS_APROVACAO = 'A' AND " + ;
	*!*			         "COMPRAS.FILIAL_A_FATURAR = ?v_entradas_00.filial AND " + ;
	*!*					 "COMPRAS.FORNECEDOR = ?v_entradas_00.nome_clifor  " + ;
	*!*			         cWhereNF



	If wCtrl_Multi_Empresa
		cWhere = cWhere + " AND FILIAIS.EMPRESA = ?wEmpresa_Atual"
	Endif

	cSQL = "SELECT DISTINCT COMPRAS.PEDIDO, COMPRAS.FORNECEDOR, COMPRAS.PEDIDO_FORNECEDOR, COMPRAS.FILIAL_COBRANCA, FILIAIS_COBRANCA.COD_FILIAL AS COD_FILIAL_COBRANCA " + ;
		"FROM COMPRAS "

	If Type("ThisFormSet.pp_Filtrar_Limite_Pedido") == "L" And Thisformset.pp_Filtrar_Limite_Pedido
		cSQL = cSQL + "INNER JOIN COMPRAS_MATERIAL ON COMPRAS.PEDIDO = COMPRAS_MATERIAL.PEDIDO AND COMPRAS_MATERIAL.LIMITE_ENTREGA >= ?v_Entradas_00.RECEBIMENTO "
	Endif

	cSQL = cSQL + "INNER JOIN FILIAIS ON COMPRAS.FILIAL_A_ENTREGAR = FILIAIS.FILIAL " + ;
		"LEFT JOIN FILIAIS AS FILIAIS_COBRANCA ON COMPRAS.FILIAL_COBRANCA = FILIAIS_COBRANCA.FILIAL " + ;
		"WHERE " + cWhere + " " + ;
		"ORDER BY COMPRAS.PEDIDO"

	If ! f_select(cSQL, "xCur_Pedidos")

		Select(nOldSele)
		Return .F.

	Endif

	If Reccount("xCur_Pedidos") == 0

		F_Msg(["N�o h� pedidos em aberto !", 0+48, "Aten��o"])

		Select(nOldSele)
		Return .F.

	Endif

	Select Distinct fornecedor From xCur_Pedidos Into Cursor xCur_Pedidos_Fornec

	Select xCur_Pedidos_Fornec
	Locate For fornecedor == v_entradas_00.NOME_CLIFOR

	If ! Found()
		F_Msg(["N�o existem pedidos para o fornecedor da entrada, ser� utilizado para filtro um outro fornecedor.", 0+48, "Aten��o"])
		Go Top
	Endif

	With This.Parent.Parent

		.page1.Enabled = .F.
		.page2.Enabled = .F.
		.Page3.Enabled = .F.
		.Page4.Enabled = .F.
		.Page5.Enabled = .F.
		.page6.Enabled = .F.
		.page7.Enabled = .F.
		.Page8.Enabled = .T.
		.ActivePage    = 8

	Endwith

	Sele v_Compras_01
	Scan
		Replace FILIAL_A_ENTREGAR With v_entradas_00.Filial
	Endscan

	Select(nOldSele)
	Return .T.



	Endproc


Enddefine
*
*-- EndDefine: bt_pedidos_mat
**************************************************




**************************************************
*-- Class:        cmb_pedidos (c:\temp\rbx\cmb_pedidos.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/20/08 04:18:01 PM
*
Define Class cmb_PEDIDOS As lx_combobox


	BoundColumn = 1
	RowSource = ""
	ControlSource = "v_compras_01.pedido"
	Height = 21
	Left = 209
	Top = 31
	Width = 152
	p_tipo_dado = "EDITA"
	Name = "cmb_PEDIDOS"
	Visible = .T.

	Procedure l_desenhista_recalculo
	Local cOldSele, nPerc, nPerc_Qtde, cSQL, nQtde_Entrada, nQtde_Entregar

	Private cPedido

	cOldSele = Select()

	Select v_Compras_01
	F_StuffDBC('Additive', 'Pedido = ?xCur_Pedidos.Pedido')
	Go Top

	If ! Eof()

		Select v_Compras_01_Materiais
		Set Filter To
		Requery()

		Delete All For ( Qtde_Entregar <= 0 )

		If Type("ThisFormSet.pp_Filtrar_Limite_Pedido") == "L" And Thisformset.pp_Filtrar_Limite_Pedido
			Delete All For ( LIMITE_ENTREGA < v_entradas_00.RECEBIMENTO )
		Endif

		Go Top

	Endif

	cPedido = This.Value

	f_select('SELECT Compras.Comprimento_de_Rolos, Compras.Marca_Volumes FROM Compras WHERE Compras.Pedido = ?cPedido', 'curCompras')

	nPerc      = Iif( f_vazio(curCompras.Comprimento_de_Rolos), 0, curCompras.Comprimento_de_Rolos)

	*fbn*	nPerc_Qtde = Iif( F_Vazio(curCompras.Marca_Volumes)       , 0, Iif( Alltrim(v_Entradas_00.Serie_NF_Entrada) <> Alltrim(wTipo_Producao_Serie), curCompras.Marca_Volumes, ( 100 - curCompras.Marca_Volumes ) ) )

	nPerc_Qtde = Iif( f_vazio(curCompras.Marca_Volumes)       , 0, ;
		Iif( ! Inlist(v_entradas_00.SERIE_NF_ENTRADA, wTipo_Producao, wTipo_Producao_Serie), ;
		curCompras.Marca_Volumes, ;
		( 100 - curCompras.Marca_Volumes ) ;
		) ;
		)

	cSQL       = 'SELECT SUM(c.Qtde) AS Qtde FROM Entradas a INNER JOIN Estoque_Ret_Mat b ON a.NF_Entrada = b.NF_Entrada AND ' + ;
		'a.Nome_CliFor = b.Nome_CliFor AND a.Serie_NF_Entrada = b.Serie_NF_Entrada INNER JOIN Estoque_Ret1_Mat c ON ' + ;
		'b.Req_Material = c.Req_Material AND b.Filial = c.Filial WHERE c.Material = ?v_Compras_01_Materiais.Material ' + ;
		'AND c.Cor_Material = ?v_Compras_01_Materiais.Cor_Material AND c.Pedido = ?v_Compras_01_Materiais.Pedido ' + ;
		'AND c.Entrega_Pedido = ?v_Compras_01_Materiais.Entrega AND a.Serie_NF_Entrada ' + ;
		Iif( Inlist(v_entradas_00.SERIE_NF_ENTRADA, wTipo_Producao, wTipo_Producao_Serie), " IN ", " NOT IN " ) + ;
		' ( ?wTipo_Producao, ?wTipo_Producao_Serie )'

	*fbn*	             Iif( Alltrim(v_Entradas_00.Serie_NF_Entrada) == Alltrim(wTipo_Producao_Serie), '=', '<>' ) + ;

	Select v_Compras_01_Materiais
	Go Top

	Scan

		f_select(cSQL, 'curEntrada')

		nQtde_Entrada = Iif( f_vazio(curEntrada.qtde), 0, curEntrada.qtde)

		** Ajusta a qtde *********************************************************
		Select v_entradas_00_ret1_mat
		Go Top

		Locate For PEDIDO   == v_Compras_01_Materiais.PEDIDO And ;
			material == v_Compras_01_Materiais.material And ;
			cor_material == v_Compras_01_Materiais.cor_material And ;
			Entrega_Pedido == v_Compras_01_Materiais.Entrega

		If Found()

			Scan For PEDIDO   == v_Compras_01_Materiais.PEDIDO And ;
					material == v_Compras_01_Materiais.material And ;
					cor_material == v_Compras_01_Materiais.cor_material And ;
					Entrega_Pedido == v_Compras_01_Materiais.Entrega

				nQtde_Entrada = ( nQtde_Entrada + qtde )

			Endscan

		Endif
		**************************************************************************

		Select v_Compras_01_Materiais
		Replace Comprimento_de_Rolos    With nPerc , ;
			Custo_Cheio    With Custo, ;
			Custo          With ( Custo - ( Custo * ( nPerc / 100 ) ) ), ;
			Custo_Moeda    With ( Custo_Moeda - ( Custo_Moeda * ( nPerc / 100 ) ) ), ;
			Valor_Entregar With ( Valor_Entregar - ( Valor_Entregar * ( nPerc / 100 ) ) )

		nQtde_Entregar = ( ( Qtde_Original - Qtde_Cancel_Pedido - nQtde_Entrada ) - ( ( Qtde_Original - Qtde_Cancel_Pedido  ) * ( nPerc_Qtde / 100 ) ) )
		nQtde_Entregar = Iif( nQtde_Entregar < 0, 0, nQtde_Entregar )

		Replace Qtde_Entregar With nQtde_Entregar

		Select v_Compras_01_Materiais

	Endscan

	Delete All For ( Qtde_Entregar <= 0 )
	Go Top

	***tratamento filiais matrizes diferentes
	Sele v_Compras_01
	Scan
		Replace FILIAL_A_ENTREGAR With v_entradas_00.Filial
	Endscan
	*!*			sele v_compras_01
	*!*			xfilial_estoque=filial_a_entregar
	*!*
	*!*			repla filial_a_entregar with v_entradas_00.filial
	*!*			sele v_entradas_00
	*!*			repla filial_estoque with xfilial_estoque
	*!*			thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_filial_estoque.refresh()

	***tratamento filiais matrizes diferentes


	This.Parent.lx_Grid_Pedidos.Refresh()



	Select(cOldSele)
	Return
	Endproc


Enddefine
*
*-- EndDefine: cmb_pedidos
**************************************************




**************************************************
*-- Class:        lb_status_entrada (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
Define Class lb_anm_rateio_producao As lx_label


	Caption = "Desc. Rateio"
	Height = 15
	Left = 205
	Top = 264
	Width = 22
	TabIndex = 10
	ForeColor = Rgb(0,0,0)
	BackColor = Rgb(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_anm_rateio_producao"
	Visible = .T.
	Anchor = 0
	FontBold = .T.


	Procedure DblClick

	TEXT TO CurSelPgto TEXTMERGE NOSHOW

			SELECT 1 AS NF_PAGA
			FROM ENTRADAS
			INNER JOIN CTB_A_PAGAR_MOV
			ON ( ENTRADAS.CTB_LANCAMENTO = CTB_A_PAGAR_MOV.LANCAMENTO_MOV
			OR ENTRADAS.NUMERO_CONFERENCIA = CTB_A_PAGAR_MOV.LANCAMENTO_MOV )
			AND ENTRADAS.CTB_ITEM = CTB_A_PAGAR_MOV.ITEM_MOV
			AND CTB_A_PAGAR_MOV.EMPRESA = 1
			JOIN CTB_LANCAMENTO_ITEM
			ON  CTB_A_PAGAR_MOV.LANCAMENTO = CTB_LANCAMENTO_ITEM.LANCAMENTO
			AND CTB_LANCAMENTO_ITEM.CODIGO_HISTORICO NOT IN ('IAD','BTP')
			WHERE ENTRADAS.NF_ENTRADA = '<<v_entradas_00.nf_entrada>>'
			AND ENTRADAS.SERIE_NF_ENTRADA = '<<v_entradas_00.serie_nf_entrada>>'
			AND ENTRADAS.NOME_CLIFOR = '<<v_entradas_00.nome_clifor>>'

	ENDTEXT

	f_select(CurSelPgto,"xSelPgto",Alias())


	If Thisformset.p_tool_status="P" And xSelPgto.NF_PAGA = 0
		If Messagebox("Deseja Inserir Desconto Financeiro?",4+32+256,"Aten��o!")=6
			o_005104.Lx_form1.Lx_pageframe1.page6.lx_grid_filha1.Col_tx_perda.Enabled = .T.
			*O_TOOLBAR.Botao_salva.Enabled= .T.
			Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page2.tx_anm_rateio_producao.Enabled = .T.
			Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page2.tx_anm_rateio_producao.SetFocus()

		Endif
	Else
		If xSelPgto.NF_PAGA = 1
			Messagebox("Nota Fiscal j� esta Paga. Imposs�vel Inserir o desconto !!",0+48)
		Endif
	Endif

	Endproc


Enddefine
*
*-- EndDefine: lb_anm_rateio_producao
**************************************************


**************************************************
*-- Class:        tx_anm_rateio_producao (c:\work\desenv\filtros_data\tx_valor_itens.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
Define Class tx_anm_rateio_producao As lx_textbox_base


	ControlSource = "V_ENTRADAS_00.ANM_RATEIO_PRODUCAO"
	Height = 19
	Left = 197
	TabIndex = 4
	Top = 281
	Width = 117
	p_tipo_dado = "edita"
	Name = "tx_anm_rateio_producao"
	Visible = .T.
	Enabled = .T.
	ForeColor = Rgb(255,0,0)
	BorderColor = Rgb(128,128,128)
	SpecialEffect = 1
	BackStyle = 0
	BorderStyle = 0
	InputMask = "999 999 999.99"
	FontBold = .T.
	ReadOnly = .F.


	Procedure Valid

	If Thisformset.p_tool_status="P"

		If Messagebox("Deseja Realmente Inserir Desconto Rateio para esta Nota ?",4+32+256,"Aten��o!")=6

			xnf_entrada=v_entradas_00.NF_ENTRADA
			xserie_nf_entrada=v_entradas_00.SERIE_NF_ENTRADA
			xnome_clifor=v_entradas_00.NOME_CLIFOR
			xfilial=v_entradas_00.Filial
			*xfilial_estoque=v_entradas_00.filial_estoque


			TEXT to	xinsert1 noshow textmerge
					UPDATE ENTRADAS SET ANM_RATEIO_PRODUCAO='<<v_entradas_00.ANM_RATEIO_PRODUCAO>>'
					WHERE NF_ENTRADA='<<XNF_ENTRADA>>'
					and SERIE_NF_ENTRADA='<<XSERIE_NF_ENTRADA>>'
					and NOME_CLIFOR='<<XNOME_CLIFOR>>'
			ENDTEXT

			If !f_insert(xinsert1)
				Messagebox("N�o foi poss�vel Inserir Desconto Rateio na Entrada ",48,"Aten��o_10!")
				Retu .F.
			Endif

			Release xnf_entrada,xserie_nf_entrada,xnome_clifor,xfilial
			*,xfilial_estoque

			o_toolbar.Botao_refresh.Click()

		Endif


	Endif

	Endproc


	Procedure DblClick

	*If thisformset.p_tool_status="P"
	If Messagebox("Deseja Alterar o Status da Entrada?",4+32+256,"Aten��o!")=6
		Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page2.tx_anm_rateio_producao.Enabled=.T.
	Endif
	*Endif

	Endproc



Enddefine
*
*-- EndDefine: tx_anm_rateio_producao
**************************************************


**************************************************
*-- Class:        tx_valor_producao (c:\work\desenv\filtros_data\tx_valor_producao.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
Define Class tx_valor_producao As lx_textbox_base


	ControlSource = "xvalor_producao"
	Height = 19
	Left = 88
	TabIndex = 4
	Top = 254
	Width = 102
	p_tipo_dado = "mostra"
	Name = "tx_valor_producao"
	Visible = .T.
	Enabled = .F.
	ForeColor = Rgb(255,0,0)
	BackStyle = 0
	BorderStyle = 0
	BorderColor = Rgb(128,128,128)
	SpecialEffect = 1
	InputMask = "999 999 999.99"
	FontBold = .T.


Enddefine
*
*-- EndDefine: tx_valor_producao
**************************************************



**************************************************
*-- Class:        tx_anm_frete_adicional (c:\work\desenv\filtros_data\tx_valor_itens.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
Define Class tx_anm_frete_adicional As lx_textbox_base


	ControlSource = "V_ENTRADAS_00.ANM_FRETE_ADICIONAL"
	Height = 19
	Left = 8
	TabIndex = 4
	Top = 143
	Width = 117
	p_tipo_dado = "edita"
	Name = "tx_anm_frete_adicional"
	Visible = .T.
	Enabled = .T.
	InputMask = "999 999 999.99"
	FontBold = .T.
	ReadOnly = .F.



Enddefine
*
*-- EndDefine: tx_anm_frete_adicional
**************************************************


**************************************************
*-- Class:        lb_anm_frete_adicional (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
Define Class lb_anm_frete_adicional As lx_label


	Caption = "Frete Add"
	Height = 15
	Left = 8
	Top = 127
	Width = 22
	TabIndex = 10
	ForeColor = Rgb(0,0,0)
	BackColor = Rgb(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_anm_frete_adicional"
	Visible = .T.
	Anchor = 0
	FontBold = .T.


Enddefine
*
*-- EndDefine: lb_anm_frete_adicional
**************************************************






**************************************************
*-- Class:        btAlteraRateio
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
Define Class btAlteraRateio As CommandButton

	Height = 13
	Left = 197
	Top = 296
	Width = 117
	Caption = "Altera Rateio"
	Name = "btAlteraRateio"
	Visible=.T.
	Enabled = .T.
	FontBold=.T.
	FontSize=6
	ToolTipText="Altera Rateio"
	WordWrap = .T.

	Procedure Click

	*If thisformset.p_tool_status="P"
	If Messagebox("Deseja Alterar o Status da Entrada?",4+32+256,"Aten��o!")=6
		Thisformset.Lx_form1.Lx_pageframe1.page1.pageframe1.page2.tx_anm_rateio_producao.Enabled=.T.
	Endif
	*Endif

	Endproc


Enddefine
*
*-- EndDefine: btAlteraRateio
**************************************************



**************************************************
*-- Class:        lb_status_entrada (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
Define Class lb_Pedido_Gerado As lx_label


	Caption = ""
	Top = 8
	Left = 570
	Height = 24
	Width = 145
	FontBold=.T.
	AutoSize= .F.
	Name = "lb_Pedido_Gerado"
	Visible = .F.


Enddefine
*
*-- EndDefine: lb_status_entrada
**************************************************



**************************************************
*-- Class:        cmb_status_entrada (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
Define Class cmb_filial_pedido As lx_combobox


	RowSource = ""
	ControlSource = ""
	Height = 22
	Left = 418
	TabIndex = 1
	Top = 3
	Width = 147
	ZOrderSet = 5
	Name = "cmb_filial_pedido"
	Visible = .T.
	Enabled = .T.
	Anchor = 0

	Procedure Valid

	If !Empty(This.Value) And Thisformset.p_tool_status<>"L"
		Thisformset.Lx_form1.Lx_pageframe1.page6.bt_gera_pedido.Enabled= .T.
	Endif
	Endproc

Enddefine
*
*-- EndDefine: cmb_status_entrada
**************************************************


**************************************************
*-- Class:        bt_saida_avulsa (c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/08/10 01:37:14 PM
*
Define Class bt_gera_pedido As botao


	Top = 2
	Left = 567
	Height = 24
	Width = 140
	FontBold = .T.
	Caption = "Gera Pedido Armazem"
	TabIndex = 40
	Name = "bt_gera_pedido"
	Visible = .T.
	Enabled =.F.


	Procedure Click


	If Messagebox("Deseja Gerar Pedido Para Armazem?",4+32+256,"Aten��o!")=6

		Thisformset.Lx_form1.Lx_pageframe1.page6.lb_Pedido_Gerado.Caption = ""
		xFilDest = Thisformset.Lx_form1.Lx_pageframe1.page6.cmb_filial_pedido.Value
		If !f_update("EXECUTE LX_ANM_GERA_PEDIDO_OL ?v_entradas_00.nome_clifor,?v_entradas_00.nf_entrada,?v_entradas_00.serie_nf_entrada,?xFilDest")
			Return .F.
		Endif


		f_select("SELECT REQ_MATERIAL FROM ESTOQUE_SAI_MAT WHERE CONVERT(VARCHAR(400),OBS)='SAIDA - NF:'+RTRIM(?v_entradas_00.nf_entrada)+', FORNECEDOR:'+RTRIM(?v_entradas_00.nome_clifor)+', SERIE_NF:'+RTRIM(?v_entradas_00.serie_nf_entrada)","xRetornaPedido" )
		f_update("update entradas set anm_status_entrada = 'Pedido Gerado: '+?xRetornaPedido.REQ_MATERIAL where nf_entrada = ?v_entradas_00.nf_entrada and nome_clifor = ?v_entradas_00.nome_clifor and serie_nf_entrada = ?v_entradas_00.serie_nf_entrada")


		f_select("SELECT FILIAL_DESTINO FROM ESTOQUE_SAI_MAT WHERE REQ_MATERIAL = ?xRetornaPedido.REQ_MATERIAL","xFilDest")
		Messagebox("Pedido Gerado com Sucesso. Pedido a ser faturado: "+xRetornaPedido.REQ_MATERIAL,0+64)

		Replace v_entradas_00.anm_status_entrada With "Pedido Gerado: "+xRetornaPedido.REQ_MATERIAL
		Thisformset.Lx_form1.Lx_pageframe1.page6.lb_Pedido_Gerado.Left=570
		Thisformset.Lx_form1.Lx_pageframe1.page6.lb_Pedido_Gerado.Caption = v_entradas_00.anm_status_entrada
		Thisformset.Lx_form1.Lx_pageframe1.page6.lb_Pedido_Gerado.Visible = .T.
		*thisformset.lx_form1.lx_PAGEFRAME1.page6.cmb_filial_pedido.value = xFilDest.FILIAL_DESTINO
		Thisformset.Lx_form1.Lx_pageframe1.page6.cmb_filial_pedido.Enabled = .F.
		Thisformset.Lx_form1.Lx_pageframe1.page6.bt_gera_pedido.Visible = .F.


	Endif


	Endproc


Enddefine
*
*-- EndDefine: bt_saida_avulsa
**************************************************






&&ismara - 27/09/2013 - criar o bot�o para imprimir etiquetas de MP
**************************************************
*-- Class:        imprime_etq_mp
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*
Define Class imprime_etq_mp As CommandButton


	Top = 0
	Left = 553
	Height = 22
	Width = 150
	Caption = "Etiqueta MP"
	Name = "imprime_etq_mp"
	Visible=.T.
	Enabled=.T.



	Procedure Click


	Select v_entradas_00
	&&REPORT FORM wdir+'LINX\REPORT\USER\u005104ar etiqueta de materiais.frx' NOCONSOLE TO PRINTER
	&& ismara - mandar para arquivo e depois pelo .bat enviar para a impressora
	Report Form wdir+'LINX\REPORT\USER\u005104ar etiqueta de materiais.frx' Noconsole To File L:\etiqmp.txt Ascii

	Select v_entradas_00
	Go Top

	Wait Window 'Etiquetas Impressas...' Nowait
	Endproc


Enddefine
*
*-- EndDefine: imprime_etq_mp
**************************************************

* Tiago Carvalho - SS - Impress�o de Etiquetas de codigo de barras.
Define Class bt_etiqueta_peca As CommandButton
	Height = 25
	Width = 85
	FontBold = .F.
	FontName = "Arial"
	FontSize = 8
	Caption = "Etiqueta"
	Name = "bt_etiqueta_peca"
	AutoSize = .T.
	Visible = .T.
	Enabled = .T.

	Procedure Click
	If !(Thisformset.p_tool_status =="P")
		Messagebox("Etiqueta dispon�vel somente em modo pesquisa!",0+64,"Obj-Etiqueta Somente Pesquisa")
		Return .T.
	Else
		* Tiago Carvalho - SS - Impress�o de Etiquetas de codigo de barras.
		lcSQl = "SELECT	A.DESC_MATERIAL, "+;
			"		A.DESC_COMPOSICAO, "+;
			"		A.UNID_ESTOQUE, "+;
			"		A.LARGURA, "+;
			"		B.DESC_COR_MATERIAL, "+;
			"		A.FABRICANTE,  "+;
			"		A.COLECAO  "+;
			"	FROM MATERIAIS A (NOLOCK)  "+;
			"	INNER JOIN MATERIAIS_CORES B (NOLOCK) "+;
			"		ON A.MATERIAL = B.MATERIAL     "+;
			"	WHERE A.MATERIAL = ?v_entradas_00_ret_peca.material "+;
			"		and B.cor_material = ?v_entradas_00_ret_peca.cor_material "

		f_select(lcSQl,"CurTempMat")
		
		TEXT TO xCurRevisao TEXTMERGE NOSHOW
			SELECT COUNT(*) AS OK 
				FROM PROPRIEDADE A(NOLOCK)
			INNER JOIN PROP_FILIAIS B(NOLOCK)
				ON A.PROPRIEDADE = B.PROPRIEDADE 
			WHERE A.TITULO_PROPRIEDADE ='FILIAL REVISAO' AND VALOR_PROPRIEDADE = ?V_ENTRADAS_00_RET1_MAT.FILIAL
			GROUP BY B.FILIAL , B.VALOR_PROPRIEDADE
		ENDTEXT
		f_select(xCurRevisao,"xFilialRevisao")
		
		IF xFilialRevisao.OK = 0
			* Julio - 09-08-2017
			lcSQl = "	select peca,sum(entradas_mat_peca.QTDE-entradas_mat_peca.PERDA) as qtde_peca,entradas_mat_peca.LARGURA, '' AS MSG_ETIQUETA  "+;
					"	from entradas, entradas_mat_peca "+;
					"	where entradas_mat_peca.NF_ENTRADA = entradas.NF_ENTRADA "+;
					"		and ENTRADAS_MAT_PECA.NOME_CLIFOR = entradas.NOME_CLIFOR "+;
					"		and entradas_mat_peca.peca <> 'ajuste' "+;
					"		and entradas.nf_entrada = ?v_entradas_00.NF_ENTRADA "+;
					"		and entradas.serie_nf_entrada = ?v_entradas_00.SERIE_NF_ENTRADA "+;
					"		and entradas.nome_clifor = ?v_entradas_00.NOME_CLIFOR "+;
					"		and entradas_mat_peca.PECA = ?v_entradas_00_ret_peca.PECA "+;
					"group by peca,entradas.emissao, entradas.nf_entrada "
		ELSE
			lcSQl = "	SELECT	B.PECA,B.QTDE - B.PERDA - ISNULL(B.PERDA_SAIDA_REVISAO,0) - ISNULL(P.QTDE,0) as QTDE_PECA, B.LARGURA, "+;
					"           CASE WHEN P.PECA IS NULL THEN 'MATERIAL NO ESTOQUE' ELSE 'MATERIAL NA REVISAO' END AS MSG_ETIQUETA "+;
					"	FROM ESTOQUE_RET_MAT A(NOLOCK) "+;
					"	INNER JOIN ESTOQUE_RET_PECA B(NOLOCK) "+;
					"		ON A.REQ_MATERIAL = B.REQ_MATERIAL AND A.FILIAL = B.FILIAL 	 "+;
					"	LEFT JOIN ESTOQUE_SAI_PECA P  "+;
					"		ON B.PERDA_REQ_MATERIAL = P.REQ_MATERIAL AND B.MATERIAL =  P.MATERIAL AND B.COR_MATERIAL = P.COR_MATERIAL AND B.FILIAL = P.FILIAL AND B.PECA = P.PECA  "+;
					"	WHERE   B.peca <> 'ajuste'  "+;
					"		and A.nf_entrada = ?v_entradas_00.NF_ENTRADA  "+;
					"		and A.serie_nf_entrada = ?v_entradas_00.SERIE_NF_ENTRADA  "+;
					"		and A.nome_clifor = ?v_entradas_00.NOME_CLIFOR  "+;
					"		and B.PECA = ?v_entradas_00_ret_peca.PECA "
		ENDIF
		f_select(lcSQl,"CurPecaTot")
		
		* 22/01/2014 - S�ntese Solu��es - Tiago Carvalho - Alterado para o padr�o Sintese Etiquetas
		strPeca 			= Alltrim(v_entradas_00_ret_peca.PECA)
		strQtde 			= Alltrim(Str(CurPecaTot.qtde_peca, 7,3))
		strUnidEstoque 		= Alltrim(CurTempMat.unid_estoque)
		strLargura 			= Alltrim(Str(v_entradas_00_ret_peca.LARGURA,6,2))
		strPartida			= Alltrim(v_entradas_00_ret_peca.PARTIDA)
		strLocalizacao 		= Alltrim(v_entradas_00_ret_peca.localizacao)
		strFabricante 		= Alltrim(CurTempMat.fabricante)
		strMaterial 		= Alltrim(v_entradas_00_ret_peca.material)
		strDescMaterial 	= Alltrim(CurTempMat.DESC_MATERIAL)
		strDescComposicao 	= Alltrim(CurTempMat.Desc_Composicao)
		strCor 				= Allt(v_entradas_00_ret_peca.cor_material)
		strDescCor 			= Alltrim(CurTempMat.desc_cor_material)
		strNFEntrada		= Alltrim(v_entradas_00.NF_ENTRADA)
		strFornecedor		= Alltrim(v_entradas_00.NOME_CLIFOR)
		strColecao			= Alltrim(CurTempMat.COLECAO)
		strPecaTemp			= ""
		**strSaida			= ""
		strSaida			= Alltrim(CurPecaTot.MSG_ETIQUETA)

		Use In CurTempMat

		nAntArea = Select()

		Wait Wind 'IMPRIMINDO ETIQUETAS...' Nowait

		strProc = Set("Procedure")

		Set Procedure To \Linx\Report\User\Proc_SS_Etiquetas.prg Additive

		If !Directory('C:\SINTESE\ETIQUETA')
			Md('C:\SINTESE\ETIQUETA')
		Endif

		If File ('C:\SINTESE\ETIQUETA\PECAMP.ETQ')
			Delete File 'C:\SINTESE\ETIQUETA\PECAMP.ETQ'
		Endif

		intArq = Fcreate('C:\SINTESE\ETIQUETA\PECAMP.ETQ', 0)
		If (intArq >= 0)
			Fwrite(intArq, Proc_Etiqueta_Peca(strPeca, strQtde, strUnidEstoque, strLargura, strPartida, strLocalizacao, strFabricante, strMaterial, strDescMaterial, strDescComposicao, strCor, strDescCor,strNFEntrada,strFornecedor,strColecao,strPecaTemp,strSaida))
			Fclose(intArq)
			!Copy C:\SINTESE\ETIQUETA\PECAMP.ETQ LPT1
		Endif

		Select (nAntArea)

		Set Procedure To &strProc

		Wait Wind 'IMPRESS�O CONCLUIDA.' Nowait
	Endif
	Endproc
Enddefine


**************************************************
*-- Class:        btn_etiqueta (c:\linx desenv\classes lucas\btn_etiqueta.vcx)
*-- ParentClass:  botao (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/06/14 05:29:10 PM
*
Define Class btn_etiqueta As botao


	Top = 11
	Left = 562
	Height = 22
	Width = 114
	FontBold = .T.
	Caption = "Imprimir Etiqueta"
	ForeColor = Rgb(0,0,0)
	Name = "btn_etiqueta"
	Visible = .T.


	Procedure Click
	Sele v_entradas_00_ret_peca
	Go Top

	Scan

		Thisformset.Lx_form1.Lx_pageframe1.page7.lx_grid_filha1.col_etiqueta_peca.bt_etiqueta_peca.Click()

		Sele v_entradas_00_ret_peca

	Endscan
	Endproc


Enddefine
*
*-- EndDefine: btn_etiqueta
**************************************************

**************************************************
*-- Class:        lx_entrada_revisao (c:\linx desenv\classes lucas\lx_entrada_revisao.vcx)
*-- ParentClass:  lx_checkbox (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   02/20/15 04:41:06 PM
*
Define Class lx_entrada_revisao As lx_checkbox


	Top = 129
	Left = 448
	Height = 15
	Width = 199
	Alignment = 0
	Caption = "Entrada Para Revis�o"
	Name = "lx_entrada_revisao"
	Visible = .T.

Enddefine
*
*-- EndDefine: lx_entrada_revisao
**************************************************
**************************************************
*-- Class:        btn_importa_peca(c:\linx desenv\classes lucas\btn_importa_peca.vcx)
*-- ParentClass:  botao (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/06/14 05:29:10 PM
*
Define Class btn_importa_peca As botao


	Top = 36
	Left = 32
	Height = 22
	Width = 114
	FontBold = .T.
	Caption = "Importar Pe�a"
	ForeColor = Rgb(0,0,0)
	Name = "btn_importa_peca"
	Visible = .T.


	Procedure Click
		If ! ThisFormSet.p_Tool_Status $ 'I,A'
			MESSAGEBOX("Somente pode Importar em modo Inclus�o !!!",0+16)
			Return .F.
		EndIf
		
		IF TYPE("CurArqPeca")<>'U'
			USE IN CurArqPeca
		ENDIF
		
	f_select("SELECT SPACE(11) MATERIAL,SPACE(10) COR_MATERIAL,999999999.999 AS QTDE WHERE 1=2","CurArqPeca")
			  xCaminho = "'"+GETFILE('txt','Arquivo:')+"'"
			  IF ALLTRIM(xCaminho)="''" 
			   	
			   RETURN .f.
			  ENDIF
			   
			  APPEND FROM &xCaminho DELIMITED WITH CHARACTER ';'
			  
			  Count to xTReg
			  xRAtu = 0
			  GO TOP
			  
			  SCAN
			   	IF CurArqPeca.qtde > 0
			  		o_toolbar.Botao_filhas_inserir.Click()
			  		replace v_entradas_00_ret_peca.partida WITH 'UNICA' 
					replace v_entradas_00_ret_peca.qtde WITH CurArqPeca.qtde
					o_005104.lx_FORM1.lx_pageframe1.page7.lx_grid_filha1.col_tx_qtde.Tx_Qtde.l_desenhista_recalculo()
				ENDIF
			  
			   IF (ALLTRIM(v_entradas_00_ret_peca.material) <> ALLTRIM(CurArqPeca.material)) or (v_entradas_00_ret_peca.cor_material <> CurArqPeca.cor_material)
			  	MESSAGEBOX("Material/Cor Selecionado Diferente do Arquivo !!!",0+16)
			  	RETURN .f.
			   ENDIF	  		 
				sele CurArqPeca
			  ENDSCAN

*!*			CREATE TABLE CurArqPeca (MATERIAL CHAR(11),QTDE NUMERIC(9,3))
*!*			  xCaminho = "'"+GETFILE('txt','Arquivo:')+"'"
*!*			  IF ALLTRIM(xCaminho)="''" 
*!*			   RETURN .f.
*!*			  ENDIF
*!*			   
*!*			  APPEND FROM &xCaminho DELIMITED WITH CHARACTER ';'
*!*			  
*!*			  Count to xTReg
*!*			  xRAtu = 0
*!*			  GO TOP
*!*			  
*!*			  SCAN
*!*			   	IF CurArqPeca.qtde > 0
*!*			  		o_toolbar.Botao_filhas_inserir.Click()
*!*			  		replace v_entradas_00_ret_peca.partida WITH 'UNICA' 
*!*					replace v_entradas_00_ret_peca.qtde WITH CurArqPeca.qtde
*!*					ThisFormSet.lx_FORM1.lx_pageframe1.page7.lx_grid_filha1.col_tx_qtde.Tx_Qtde.l_desenhista_recalculo()
*!*				ENDIF
*!*			  
*!*			   IF ALLTRIM(v_entradas_00_ret_peca.material) <> ALLTRIM(CurArqPeca.material)
*!*			  	MESSAGEBOX("Material Selecionado Diferente do Arquivo !!!",0+16)
*!*			  	RETURN .f.
*!*			   ENDIF	  		 
*!*				sele CurArqPeca
*!*			  ENDSCAN


Enddefine
*
*-- EndDefine: btn_importa_peca
**************************************************