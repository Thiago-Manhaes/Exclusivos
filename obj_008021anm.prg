* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  20/01/2007                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Inclusao coluna 1ª Reserva e Filiais Estoque					                    *
********************************************************************************************************************* 

* Alteração ********************************************************************************************************* 
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                                        *
* OBJETIVO.:                                                                                                        *
********************************************************************************************************************* 


********************************************************************************************************************* 
*- Programa Base de Criação de Objeto de Entrada                                                                    *
********************************************************************************************************************* 
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela                                      *
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos                                            *
********************************************************************************************************************* 
*- Existem 2 parametros que influem nos objetos de Entrada:                                                         *
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos                       *
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execução para facilitar o desenvolvimento *
********************************************************************************************************************* 
* - Atencao !!!!!!!!!!!														                                        *
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP                                      *
********************************************************************************************************************* 

define class obj_entrada as custom
	*- Nome do metodo/função que os objetos linx vão chamar.

	procedure metodo_usuario
		*- Parametros do metodo:
		*- Xmetodo= nome do metodo
		*- Xobjeto= variavel com a referencia ao objeto
		*- Xnome_obj  = nome do objeto
		lparam xmetodo, xobjeto ,xnome_obj
		
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


		******************** Metodo chamado pelos Objetos na Validação
		*   USR_VALID -> Return .f. Não deixa o Usuario sair do objeto.

		******************** Metodo chamado pelos PageFrames
		*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

		*- Inicio dos procedimentos do Usuario
		*- Testando qual o metodo que esta chamando o metodo entrada

		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
		
		*** Lucas Miranda - 09/05/2018 - Automação para emissão de Pedidos PCP -- #1
		*** Silvio Luiz - 07/12/2018 - Retornar a informação processado do log GS_MATERIAL_OP_LOG -- #07122018	
			do case
							
	 			case upper(xmetodo) == 'USR_INIT'  
					
				thisformset.lx_foRM1.lx_pageframe1.page2.tv_pedido.Visible= .F.
				thisformset.lx_foRM1.lx_pageframe1.page2.tv_cliente_atacado.Visible= .F.
				thisformset.lx_foRM1.lx_pageframe1.page2.tx_codigo_local_entrega.Visible= .F.
				thisformset.lx_foRM1.lx_pageframe1.page2.lx_label10.Visible= .F.
				thisformset.lx_foRM1.lx_pageframe1.page2.lx_label11.Visible= .F.
				thisformset.lx_foRM1.lx_pageframe1.page2.lx_label12.Visible= .F.
				thisformset.lx_foRM1.lx_pageframe1.page2.lx_label13.Visible= .F.
				thisformset.lx_foRM1.lx_pageframe1.page2.shape6.Visible= .F.
					
					
					PUBLIC xReservaAnterior,xTipoAnterior
					PUBLIC xOldFilial,xFilConsumo
					PUBLIC xMsg,xClick

					xReservaAnterior = 0
					xMsg = ''
					xClick = 0
					*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_ordem_01
					sele v_producao_ordem_01
					xalias_pai=alias()
					
	  				oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("FILIAL_PRODUCAO", "C(25)",.T., "FILIAL_PRODUCAO", "PRODUCAO_ORDEM.FILIAL_PRODUCAO")
					** #1	
					oCur.addbufferfield("PRODUCAO_ORDEM.GS_LOTE_OP", "N(10)",.T., "Lote", "PRODUCAO_ORDEM.GS_LOTE_OP")
					**	
					** #07122018
					*oCur.addbufferfield("PROCESSADO", "C(250)",.F., "PROCESSADO", " GS_MATERIAL_OP_LOG.PROCESSADO")
					oCur.addbufferfield("convert(varchar(250),'') AS PROCESSADO", "C(250)",.F., "PROCESSADO", "PROCESSADO")	
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 	
					sele v_filiais_00
					xalias_pai=alias()
					
					oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("FILIAIS.CTRL_PRODUCAO_PRODUTO", "L",.T., "CTRL_PRODUCAO_PRODUTO", "FILIAIS.CTRL_PRODUCAO_PRODUTO")
					oCur.addbufferfield("CADASTRO_CLI_FOR.INATIVO", "L",.T., "INATIVO", "CADASTRO_CLI_FOR.INATIVO")

					
					oCur.confirmstructurechanges()
					
				
					f_select("select ltrim(rtrim(depto)) as depto,usuario from users where UPPER(usuario)=UPPER(?wusuario)","curUser",alias())
					
					IF ALLTRIM(UPPER(curUser.depto)) == ALLTRIM('FINANCEIRO')
						*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_ordem_01
						sele v_producao_ordem_01
						xalias_pai=alias()
						
		  				oCur = getcursoradapter(xalias_pai)
						oCur.addbufferfield("ANM_CK_FINANC", "LOGICAL(1)" ,.T., "ANM_CK_FINANC", "PRODUCAO_ORDEM.ANM_CK_FINANC")	
						oCur.addbufferfield("ANM_OBS_FIN", "CHARACTER(250)",.T., "ANM_OBS_FIN", "PRODUCAO_ORDEM.ANM_OBS_FIN")			
						oCur.confirmstructurechanges() 	
						**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 	
						
						WITH THISFORMSET.lx_FORM1.lx_pageframe1.Page11
							.addobject("obs_fin","obs_fin")
							.addobject("bt_conf_fin","bt_conf_fin")		
							.addobject("ck_finaliza_fin","ck_finaliza_fin")				
						ENDWITH
						
						THISFORMSET.lx_FORM1.addobject("lb_Finaliza_Fin","lb_Finaliza_Fin")
					ENDIF	

					*Inicio Inclusao Campos Novos de Produtos no Cursor Filha  -- v_producao_ordem_01_materiais  
					sele v_producao_ordem_01_materiais 
					xalias_pai=alias()

	  				oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("PRIMEIRA_RESERVA", "N(9,3)",.T., "PRIMEIRA_RESERVA", "PRODUCAO_RESERVA.PRIMEIRA_RESERVA")	
					oCur.addbufferfield("ANM_DATA_S_SOBRA", "D",.T., "DATA_S_SOBRA", "PRODUCAO_RESERVA.ANM_DATA_S_SOBRA")			
					oCur.addbufferfield("TIPO", "C(25)",.T., "TIPO", "MATERIAIS.TIPO")
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Filha  				
				
					*** Inclusao da do Label Agendado - Lucas Miranda - 04/10/2017
					Thisformset.lx_form1.AddObject("gs_lbl_agendado","gs_lbl_agendado")
					** #1
					Thisformset.lx_form1.addObject("tx_gs_lote","tx_gs_lote")
					Thisformset.lx_form1.addObject("lb_gs_lote","lb_gs_lote")	
					Thisformset.lx_form1.addObject("botaocancelaop","botaocancelaop")
					
				    *adicao da coluna na grid de materiais 
				    *adicao da coluna, col_data_s_sobra, onde irá irá preecher a data sem sobra no estoque
				    ** lucas miranda 
					WITH THISFORMSET.lx_form1.lx_PAGEFRAME1.page3.LX_PAGEFRAME1.Page1.lx_GRID_FILHA1 				
						.addColumn(7)
						.Columns(40).name="col_Primeira_reserva"
						.col_Primeira_reserva.BackColor=15399423
						.col_Primeira_reserva.Width=100
						.col_Primeira_reserva.Header1.Caption="Primeira Reserva"
						.col_Primeira_reserva.Header1.FontName="Tahoma"
						.col_Primeira_reserva.Header1.FontSize=8
						.col_Primeira_reserva.header1.Alignment=2
						.col_Primeira_reserva.ControlSource='v_producao_ordem_01_materiais.primeira_reserva'
						.col_Primeira_reserva.enabled=.f.
						
						.addColumn(8)
						.Columns(41).name="col_data_s_sobra"
						.col_data_s_sobra.Header1.Caption="Data Sem Sobra"
						.col_data_s_sobra.Header1.FontName="Tahoma"
						.col_data_s_sobra.Header1.FontSize=8
						.col_data_s_sobra.header1.Alignment=2
						.col_data_s_sobra.ControlSource='v_producao_ordem_01_materiais.ANM_DATA_S_SOBRA'
						.col_data_s_sobra.Width=100
						.col_data_s_sobra.enabled=.f.
						.col_data_s_sobra.BackColor=15399423
					ENDWITH
					
										
					WITH THISFORMSET.lx_form1.lx_PAGEFRAME1.page2 	
						.Lx_label8.visible=.f.
						.lx_textbox_base5.visible=.f.
						.Lx_label8.enabled=.f.
						.lx_textbox_base5.enabled=.f.
						.addobject("lb_filial_producao","lb_filial_producao")	
						.addobject("cmb_filial_producao","cmb_filial_producao")	
						** #07122018
						.addobject("tx_processado","tx_processado")	
						.addobject("lb_processado","lb_processado")					
					ENDWITH

				thisformset.Lx_form1.lx_PAGEFRAME1.page3.lX_PAGEFRAME1.page1.addobject("bt_mata_reserva","bt_mata_reserva")
				thisformset.Lx_form1.lx_PAGEFRAME1.page3.lX_PAGEFRAME1.page1.addobject("bt_altera_reserva","bt_altera_reserva")				


					THISFORMSET.L_LIMPA() 
				
					
				CASE UPPER(xmetodo) == 'USR_SEARCH_AFTER'
				
					**#07122018	
					SELECT v_producao_ordem_01
					GO top
					scan				
					TEXT TO xsel NOSHOW TEXTMERGE
						select ordem_producao, processado from gs_material_op_log
						where ordem_producao=?v_producao_ordem_01.ORDEM_PRODUCAO
					ENDTEXT
					f_select(xsel, 'cur_log', ALIAS())
					SELECT cur_log
					SELECT v_producao_ordem_01
						replace processado WITH cur_log.processado
					endscan
					SELECT v_producao_ordem_01
					GO top
									
															
													
*!*						SELECT v_producao_ordem_01
*!*						scan
*!*						
*!*						TEXT TO xsel NOSHOW TEXTMERGE
*!*							select ordem_producao, processado from gs_material_op_log
*!*							where ordem_producao=?v_producao_ordem_01.ORDEM_PRODUCAO
*!*						ENDTEXT
*!*						f_select(xsel, 'cur_log', ALIAS())
*!*						
*!*						SELECT cur_log
*!*						
*!*							replace processado WITH cur_log.processado
*!*						*thisformset.lx_form1.lx_pageframe1.page2.tx_processado.value=cur_log.processado
*!*						endscan
					
				*CASE UPPER(xmetodo) == 'USR_CLEAN_AFTER'
					*thisformset.lx_form1.lx_pageframe1.page2.tx_processado.value=''
					

				case upper(xmetodo) == 'USR_ALTER_AFTER'  
					
					F_select("SELECT COUNT(*) AS OK FROM W_PRODUCAO_ORDEM_HIST_OS WHERE ORDEM_PRODUCAO = ?V_PRODUCAO_ORDEM_01.ordem_producao","xOP_Corte")
					
					If xOP_Corte.OK = 0
						Thisformset.lx_fORM1.cmb_status.Value = 'S'
					ENDIF
					
					*** Bloqueia os campos caso a O.P. esteja agendado ***
					*** Lucas Miranda - 04/10/2017	
					SET STEP ON 	
					If Thisformset.pp_gs_bloq_rota_agendado = .T.
						f_select("SELECT * FROM DBO.FX_GS_OP_PEDIDO_AGENDADO(?v_producao_ordem_01.ordem_producao, 'OP')","CurAgendado",ALIAS())
						Sele CurAgendado

						If RECCOUNT("CurAgendado") > 0
							Thisformset.lx_form1.gs_lbl_agendado.visible=.t.
							Thisformset.lx_form1.lx_pageframe1.page5.lx_pageframe1.page1.lx_GRID_FILHA1.col_tv_FASE_PRODUCAO.ReadOnly=.t.
							Thisformset.lx_form1.lx_pageframe1.page5.lx_pageframe1.page1.lx_GRID_FILHA1.col_tv_SETOR_PRODUCAO.ReadOnly=.t.
							Thisformset.lx_form1.lx_pageframe1.page5.lx_pageframe1.page1.lx_GRID_FILHA1.col_tv_RECURSO_PRODUTIVO.ReadOnly=.t.
							Thisformset.lx_form1.lx_pageframe1.page5.lx_pageframe1.page1.lX_TOOL_GRID_FILHA1.CMDEXCLUIRFILHA.Enabled=.F.
							Thisformset.lx_form1.lx_pageframe1.page5.lx_pageframe1.page1.Ck_visualiza_tarefa.ReadOnly=.t.
						Else	
							Thisformset.lx_form1.gs_lbl_agendado.visible=.F.
							Thisformset.lx_form1.lx_pageframe1.page5.lx_pageframe1.page1.Ck_visualiza_tarefa.ReadOnly=.f.
						Endif
					Endif
					*** Fim
					
****** Bloqueio de alocação de recursos - Silvio Luiz - 27042016 ***********************
 			case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TX_CUSTO_TAREFA'  
				 						
					IF THISFORMSET.pp_ANM_BLOQUEIO_RECURSO=.T.
		
						SELECT v_producao_ordem_01_tarefas
						
						TEXT TO XCUSTO NOSHOW TEXTMERGE
							select CUSTO_TAREFA from PRODUCAO_TAREFAS 
							where ORDEM_PRODUCAO=?v_producao_ordem_01.ORDEM_PRODUCAO
							and RECURSO_PRODUTIVO =?v_producao_ordem_01_tarefas.RECURSO_PRODUTIVO
						ENDTEXT
							
						F_SELECT(XCUSTO, 'CUR_CUSTO_ANTERIOR')
					
						TEXT TO XFASE NOSHOW TEXTMERGE
							SELECT FASE_PRODUCAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_FASE
							WHERE PROPRIEDADE='00210'
							AND FASE_PRODUCAO=?v_producao_ordem_01_tarefas.Fase_Producao
						ENDTEXT
						
						F_SELECT(XFASE, 'CUR_FASE')
						
						TEXT TO XPRODUTO NOSHOW TEXTMERGE
							SELECT PRODUTO, VALOR_PROPRIEDADE FROM PROP_PRODUTOS
							WHERE PROPRIEDADE='50016'
							AND PRODUTO=?v_producao_ordem_01.produto
						ENDTEXT
						
						F_SELECT(XPRODUTO, 'CUR_PRODUTO')
					
					
						SELECT CUR_FASE
						SELECT CUR_PRODUTO
						SELECT CUR_CUSTO_ANTERIOR
						
							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' AND CUR_PRODUTO.VALOR_PROPRIEDADE='INTERNO'   
								MESSAGEBOX("O USUÁRIO NÃO TEM PERMISSÃO PARA ALTERAR O CUSTO DESTA FASE!!",48) 
				    			thisform.LX_FORM1.LX_pageframe1.PAge5.LX_pageframe1.PAge1.LX_GRID_FILHA1.COL_tx_CUSTO_EFETIVO.TX_CUSTO_EFETIVO.Enabled= .F.
				    			REPLACE v_producao_ordem_01_tarefas.CUSTO_TAREFA WITH CUR_CUSTO_ANTERIOR.CUSTO_TAREFA
				    			*RETURN .f.
							ENDIF
					ENDIF	
					
									
			case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TV_RECURSO_PRODUTIVO'
				**** Lucas Miranda - 16/03/2017 - Bloqueia Programação *****
				Sele V_Producao_Ordem_01_tarefas

				TEXT TO xBloqProg NOSHOW TEXTMERGE
					SELECT A.*
					FROM PRODUCAO_RECURSOS A
					JOIN CADASTRO_CLI_FOR B
					ON A.NOME_CLIFOR = B.NOME_CLIFOR
					JOIN PROP_FORNECEDORES C
					ON B.NOME_CLIFOR = C.FORNECEDOR
					AND PROPRIEDADE = '00465'
					WHERE C.VALOR_PROPRIEDADE = 'SIM' 
					AND	A.RECURSO_PRODUTIVO = ?V_Producao_Ordem_01_tarefas.recurso_produtivo 
				 
				ENDTEXT
				F_SELECT(xBloqProg,"Cur_BloqProd")
				Sele Cur_BloqProd

				If !F_Vazio(Cur_BloqProd.recurso_produtivo)
					TEXT TO xTarefas NOSHOW TEXTMERGE
						Select a.*,b.desc_recurso from producao_tarefas A
						join producao_recursos b
						on a.RECURSO_PRODUTIVO = b.RECURSO_PRODUTIVO
						where tarefa=?V_Producao_Ordem_01_tarefas.tarefa and ordem_producao=?V_Producao_Ordem_01_tarefas.ordem_producao
					ENDTEXT
					F_SELECT(xTarefas,"Cur_Tarefas")
					Sele Cur_Tarefas
					
					Replace V_Producao_Ordem_01_tarefas.recurso_produtivo with IIF(F_Vazio(Cur_Tarefas.recurso_produtivo),'22264',Cur_Tarefas.recurso_produtivo)
					Replace V_Producao_Ordem_01_tarefas.desc_recurso with IIF(F_VAZIO(Cur_Tarefas.recurso_produtivo),'INDEFINIDO',Cur_Tarefas.DESC_RECURSO)
					Thisformset.lx_form1.lx_pageframe1.page5.Lx_pageframe1.page1.lx_GRID_FILHA1.col_tv_faSE_PRODUCAO.SetFocus
					MESSAGEBOX("Fornecedor bloqueado programação !!!",0+16)
					Return .F.
				Endif

				*Fim Bloqueia Programação*
				IF THISFORMSET.pp_ANM_BLOQUEIO_RECURSO=.T.
			
					SELECT v_producao_ordem_01_tarefas
			
					TEXT TO XFASE NOSHOW TEXTMERGE
							SELECT FASE_PRODUCAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_FASE
							WHERE PROPRIEDADE='00210'
							AND FASE_PRODUCAO=?v_producao_ordem_01_tarefas.Fase_Producao
						ENDTEXT
						
						F_SELECT(XFASE, 'CUR_FASE')
						
					TEXT TO XPRODUTO NOSHOW TEXTMERGE
							SELECT PRODUTO, VALOR_PROPRIEDADE FROM PROP_PRODUTOS
							WHERE PROPRIEDADE='50016'
							AND PRODUTO=?v_producao_ordem_01.produto
					ENDTEXT
						
						F_SELECT(XPRODUTO, 'CUR_PRODUTO')
					
						SELECT CUR_FASE
						SELECT CUR_PRODUTO
						
							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' AND CUR_PRODUTO.VALOR_PROPRIEDADE='INTERNO'  
								SELECT v_producao_ordem_01_tarefas
									IF v_producao_ordem_01_tarefas.recurso_produtivo<>'99'
										MESSAGEBOX("O USUÁRIO TEM PERMISSÃO PARA INCLUIR NESTA FASE SOMENTE O RECURSO '99' - 'AGUARDANDO DEFINIÇAO'!!",48) 
										REPLACE recurso_produtivo WITH '99'
										REPLACE desc_recurso WITH 'AGUARDANDO DEFINIÇAO'
										RETURN .f.
									ENDIF 
							ENDIF                                                       
					ENDIF	
					
					
					
				case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TV_FASE_PRODUCAO'	
					
					IF THISFORMSET.pp_ANM_BLOQUEIO_RECURSO=.T.
			
						SELECT v_producao_ordem_01_tarefas
			
						TEXT TO XFASE NOSHOW TEXTMERGE
							SELECT FASE_PRODUCAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_FASE
							WHERE PROPRIEDADE='00210'
							AND FASE_PRODUCAO=?v_producao_ordem_01_tarefas.Fase_Producao
						ENDTEXT
						
						F_SELECT(XFASE, 'CUR_FASE')
						
						TEXT TO XPRODUTO NOSHOW TEXTMERGE
							SELECT PRODUTO, VALOR_PROPRIEDADE FROM PROP_PRODUTOS
							WHERE PROPRIEDADE='50016'
							AND PRODUTO=?v_producao_ordem_01.produto
						ENDTEXT
						
						F_SELECT(XPRODUTO, 'CUR_PRODUTO')
					
						SELECT CUR_FASE
						SELECT CUR_PRODUTO
						
							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' AND CUR_PRODUTO.VALOR_PROPRIEDADE='INTERNO'  
								SELECT v_producao_ordem_01_tarefas
									IF v_producao_ordem_01_tarefas.recurso_produtivo<>'99'
										MESSAGEBOX("O USUÁRIO TEM PERMISSÃO PARA INCLUIR NESTA FASE SOMENTE O RECURSO '99' - 'AGUARDANDO DEFINIÇAO'!!",48) 
										REPLACE recurso_produtivo WITH '99'
										REPLACE desc_recurso WITH 'AGUARDANDO DEFINIÇAO'
										RETURN .f.
									ENDIF 
							ENDIF                                                       
					ENDIF	    				
****** Bloqueio de alocação de recursos - Silvio Luiz - 27042016 ***********************

				case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj)=='TX_RESERVA_ORIGINAL' AND thisformset.p_tool_status $'IA'

** Bloqueio alterar reserva se estiver enviado para almoxarifado Lucas Miranda e permissao para alterar reserva- 30/11/2016 **	
					Text To xVerRede TextMerge Noshow
						select B.PRODUTO from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_BLOQ_ALT_RESERVA_REDE') A
						JOIN (SELECT PRODUTO, REDE_LOJAS 
							  FROM PRODUTOS (NOLOCK) 
							  WHERE PRODUTO = LTRIM(RTRIM('<<v_producao_ordem_01.produto>>')) 
							  ) B
						ON A.REDE_LOJAS = B.REDE_LOJAS
						WHERE A.VALOR_ATUAL = 'SIM'
					Endtext
					f_select(xVerRede,"CurxVerRede") 
					sele CurxVerRede
					
					Text To xVerFilial TextMerge Noshow
						select C.FILIAL
						from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_FILIAL_FABRICA_RL') A
						JOIN (SELECT PRODUTO, REDE_LOJAS 
							  FROM PRODUTOS (NOLOCK) 
							  WHERE PRODUTO = LTRIM(RTRIM('<<v_producao_ordem_01.produto>>')) 
							  ) B
						ON A.REDE_LOJAS = B.REDE_LOJAS
						JOIN (SELECT COD_FILIAL, FILIAL FROM FILIAIS  (NOLOCK)) C
						ON A.VALOR_ATUAL = C.COD_FILIAL
					Endtext
					f_select(xVerFilial,"CurFilial") 
					sele CurFilial
 					 
 					IF !F_Vazio(CurxVerRede.Produto)
 						 						
	 					F_Select("Select * From WANM_CONSOLIDADA_MP_FILIAL where filial =?CurFilial.filial and material=?V_PRODUCAO_ORDEM_01_MATERIAIS.material and cor_material=?V_PRODUCAO_ORDEM_01_MATERIAIS.cor_material","CurVerDispMat")
							Sele CurVerDispMat
							
						F_Select("Select * From producao_reserva (nolock) where material=?V_PRODUCAO_ORDEM_01_MATERIAIS.material and cor_material=?V_PRODUCAO_ORDEM_01_MATERIAIS.cor_material and ordem_producao=?v_producao_ordem_01.ordem_producao","CurVerReserva")
							Sele CurVerReserva

	 					f_select("select VALOR_ATUAL from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_PROG_MOSTR') WHERE VALOR_ATUAL = ?V_PRODUCAO_ORDEM_01.TIPO_ORDEM_PRODUCAO","xTipoMost")
							Sele xTipoMost

						f_select("select a.* from materiais_tipo a join materiais (nolock) b on a.tipo = b.tipo where material=?v_producao_ordem_01_materiais.material","xMatTipo")
							Sele xMatTipo
						
					   *If !(xMatTipo.indica_tecido = .T. and !F_Vazio(xTipoMost.valor_atual) AND Thisformset.pp_anm_perm_alt_panos_most = .T. )	
					    If !((xMatTipo.indica_tecido = .T. or (Thisformset.pp_anm_tipo_mat_av_panos $ xMatTipo.TIPO and Thisformset.pp_anm_entra_como_panos=.T.)) ;
					    	and !F_Vazio(xTipoMost.valor_atual) AND o_008021.pp_anm_perm_alt_panos_most = .T. )	
					    	
							If Thisformset.pp_anm_perm_sem_sobra_op = .F. 
								If V_PRODUCAO_ORDEM_01_MATERIAIS.reserva > CurVerReserva.reserva OR F_VAZIO(CurVerReserva.reserva)									
									If !'RECORRE' $ xMatTipo.TIPO	
										If V_PRODUCAO_ORDEM_01_MATERIAIS.reserva > IIF(CurVerDispMat.qtde_sobra_s_compra<0,0,CurVerDispMat.qtde_sobra_s_compra+IIF(F_VAZIO(CurVerReserva.reserva),0,CurVerReserva.reserva)) ;
													   AND 	V_PRODUCAO_ORDEM_01_MATERIAIS.reserva <> IIF(F_VAZIO(CurVerReserva.reserva),0,CurVerReserva.reserva) 

											Sele V_PRODUCAO_ORDEM_01_MATERIAIS						
											Replace V_PRODUCAO_ORDEM_01_MATERIAIS.reserva_original with IIF(F_VAZIO(CurVerReserva.reserva_original),0,CurVerReserva.reserva_original) IN V_PRODUCAO_ORDEM_01_MATERIAIS			
											Replace V_PRODUCAO_ORDEM_01_MATERIAIS.tipo_reserva with IIF(F_VAZIO(CurVerReserva.tipo_reserva),2,CurVerReserva.tipo_reserva) IN V_PRODUCAO_ORDEM_01_MATERIAIS
											
											MESSAGEBOX("Material sem sobra no estoque !",0+16,"Estoque Materiais")
											USE IN CurxVerRede
											USE IN CurVerDispMat 
											USE IN CurVerReserva
											USE IN xTipoMost
											USE IN xMatTipo
											Return .F.									
										Endif
									Endif
								Endif
							Else
									If V_PRODUCAO_ORDEM_01_MATERIAIS.reserva > CurVerReserva.reserva OR F_VAZIO(CurVerReserva.reserva)
										If V_PRODUCAO_ORDEM_01_MATERIAIS.reserva > IIF(CurVerDispMat.qtde_sobra_s_compra<0,0,CurVerDispMat.qtde_sobra_s_compra+IIF(F_VAZIO(CurVerReserva.reserva),0,CurVerReserva.reserva)) ;
												   AND 	V_PRODUCAO_ORDEM_01_MATERIAIS.reserva <> IIF(F_VAZIO(CurVerReserva.reserva),0,CurVerReserva.reserva)
										
											Sele v_producao_ordem_01_materiais
											USE IN CurxVerRede
											USE IN CurVerDispMat
											USE IN CurVerReserva
											USE IN xTipoMost
											USE IN xMatTipo
											Replace v_producao_ordem_01_materiais.anm_data_s_sobra with DATE()
										Endif	
									Endif
							Endif	
						Endif
					ENDIF						

** Fim - Bloqueio alterar reserva se estiver enviado para almoxarifado Lucas Miranda e permissao para alterar reserva- 30/11/2016 **							

							IF Thisformset.pp_ALTERA_RESERVA_PARA_MENOS = .F.
						       
						       F_Select("Select * From producao_reserva (nolock) where material=?V_PRODUCAO_ORDEM_01_MATERIAIS.material and cor_material=?V_PRODUCAO_ORDEM_01_MATERIAIS.cor_material and ordem_producao=?v_producao_ordem_01.ordem_producao","CurVerReserva")
							   Sele CurVerReserva
						       
							   IF IIF(F_VAZIO(CurVerReserva.reserva_original),0,CurVerReserva.reserva_original) > V_PRODUCAO_ORDEM_01_MATERIAIS.RESERVA_ORIGINAL AND thisformset.p_tool_status $'A'
							   	 
							   	 MESSAGEBOX("Sem permissão para alterar reserva para menos,"+CHR(13)+"Favor verificar.",0+48,"Atenção!!!")
							   	 
							   	 SELECT V_PRODUCAO_ORDEM_01_MATERIAIS 
							   	 replace reserva_original WITH IIF(F_VAZIO(CurVerReserva.reserva_original),0,CurVerReserva.reserva_original)
								 repla tipo_reserva 	  with IIF(F_VAZIO(CurVerReserva.tipo_reserva ),1,CurVerReserva.tipo_reserva )

								 thisformset.Lx_form1.lx_PAGEFRAME1.page3.lX_PAGEFRAME1.page1.lx_GRID_FILHA1.Refresh()
							   	 
							     RETURN .F.
							   
							   ENDIF
						    ENDIF
					    
					IF thisformset.p_tool_status $'I'
						SELECT V_PRODUCAO_ORDEM_01_MATERIAIS
						   replace primeira_reserva WITH reserva_original 
					ENDIF 
				
				case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj)=='BOTAO1' AND thisformset.p_tool_status $'IA'
							SELECT V_PRODUCAO_ORDEM_01_MATERIAIS
							SCAN 							
								
								TEXT TO xsel NOSHOW TEXTMERGE
											select primeira_reserva 
											from producao_reserva 
											where ordem_producao='<<ALLTRIM(V_PRODUCAO_ORDEM_01_MATERIAIS.ordem_producao)>>' 
											and material='<<ALLTRIM(V_PRODUCAO_ORDEM_01_MATERIAIS.material)>>'  
											and cor_material='<<ALLTRIM(V_PRODUCAO_ORDEM_01_MATERIAIS.cor_material)>>' 
								ENDTEXT

								f_select(xsel,'cur_reserva',ALIAS())
								
								replace primeira_reserva WITH cur_reserva.primeira_reserva IN V_PRODUCAO_ORDEM_01_MATERIAIS
								
								RELEASE cur_reserva
							ENDSCAN

*--Ronald -- retirado replace em atualização 


** Bloqueio alterar reserva se estiver enviado para almoxarifado Lucas Miranda e permissao para alterar reserva- 30/11/2016 **		
				case upper(xmetodo) == 'USR_WHEN' and upper(xnome_obj) == 'BOTAO1'
				
					Text To xVerOSEnviada TextMerge Noshow
						select distinct a.ordem_servico,max(a.ordem_producao) as ordem_producao 
						from producao_os_tarefas (nolock) a
						join producao_ordem b on a.ordem_producao = b.ordem_producao
						join producao_ordem_servico c on a.ordem_servico = c.ordem_servico
						where b.ordem_producao=LTRIM(RTRIM('<<v_producao_ordem_01.ordem_producao>>'))
						and c.anm_status_almox='1-ENVIADO PARA ALMOX'
						group by a.ordem_servico
					Endtext
					f_select(xVerOSEnviada,"CurVerOSEnviada")
					sele CurVerOSEnviada

					If !F_Vazio(CurVerOSEnviada.ordem_producao) 
					
						xOS=CurVerOSEnviada.ordem_servico
						Messagebox("Proibido alterar reserva de Material enviado para Consumo."+chr(13)+"O.S.: "+xOS+CHR(13)+"Favor alterar o Status da OS diferente de 1-ENVIADO PARA ALMOX",0+16,"O.S. Enviada")
						RELEASE CurVerOSEnviada
						Return .F.
					Endif
						
					Text To xVerRede TextMerge Noshow
						select B.PRODUTO from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_BLOQ_BT_MOST_REDE') A
						JOIN PRODUTOS B
						ON A.REDE_LOJAS = B.REDE_LOJAS
						WHERE A.VALOR_ATUAL = 'SIM'
						AND B.PRODUTO = LTRIM(RTRIM('<<v_producao_ordem_01.produto>>')) 
					Endtext
					f_select(xVerRede,"CurxVerRede")
					sele CurxVerRede
					
					f_select("select * from prop_producao_programa where propriedade = '00038' and programacao=?v_producao_ordem_01.programacao and valor_propriedade = 'MOSTRUARIO'","xVerMost")
					Sele V_PRODUCAO_ORDEM_01_MATERIAIS						
				    xQtdeMat = RECCOUNT()
				    
					If !F_Vazio(CurxVerRede.Produto) and !F_Vazio(xVerMost.programacao) and xQtdeMat > 0
						Messagebox("Proibido Recalcular a O.P. de Mostruário !!!",0+16,"Mostruário")
						Return .F.
					Endif
				
					
					
				case upper(xmetodo) == 'USR_WHEN' and upper(xnome_obj) == 'BT_ALTERA_RESERVA'
					
					xTipoAnterior = V_PRODUCAO_ORDEM_01_MATERIAIS.TIPO_RESERVA
					
					Text To xVerOSEnviada TextMerge Noshow
						select distinct a.ordem_servico,max(a.ordem_producao) as ordem_producao 
						from producao_os_tarefas (nolock) a
						join producao_ordem b on a.ordem_producao = b.ordem_producao
						join producao_ordem_servico c on a.ordem_servico = c.ordem_servico
						where b.ordem_producao=LTRIM(RTRIM('<<v_producao_ordem_01.ordem_producao>>'))
						and c.anm_status_almox='1-ENVIADO PARA ALMOX'
						group by a.ordem_servico
					Endtext
					f_select(xVerOSEnviada,"CurVerOSEnviada")
					sele CurVerOSEnviada

					If !F_Vazio(CurVerOSEnviada.ordem_producao) 
					
						xOS=CurVerOSEnviada.ordem_servico
						Messagebox("Proibido alterar reserva de Material enviado para Consumo."+chr(13)+"O.S.: "+xOS+CHR(13)+"Favor alterar o Status da OS diferente de 1-ENVIADO PARA ALMOX",0+16,"O.S. Enviada")
						RELEASE CurVerOSEnviada
						Return .F.
					Endif
					
*!*						Text To xVerRede TextMerge Noshow
*!*							select B.PRODUTO from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_BLOQ_BT_MOST_REDE') A
*!*							JOIN PRODUTOS B
*!*							ON A.REDE_LOJAS = B.REDE_LOJAS
*!*							WHERE A.VALOR_ATUAL = 'SIM'
*!*							AND B.PRODUTO = LTRIM(RTRIM('<<v_producao_ordem_01.produto>>')) 
*!*						Endtext
*!*						f_select(xVerRede,"CurxVerRede")
*!*						sele CurxVerRede
*!*						
*!*						f_select("select * from prop_producao_programa where propriedade = '00038' and programacao=?v_producao_ordem_01.programacao and valor_propriedade = 'MOSTRUARIO'","xVerMost")
*!*						Sele xVerMost						
*!*						 
*!*						f_select("select a.* from materiais_tipo a join materiais b on a.tipo = b.tipo where material=?v_producao_ordem_01_materiais.material","xMatTipo")
*!*								Sele xMatTipo			

*!*						If !F_Vazio(CurxVerRede.Produto) and !F_Vazio(xVerMost.programacao) and Thisformset.pp_ANM_BLOQ_USUA_MOST = .T.
*!*							IF !(xMatTipo.indica_tecido = .T. and Thisformset.pp_ANM_PERM_ALT_PANOS_MOST = .T. )	
*!*								If !'RECORRE' $ xMatTipo.TIPO
*!*									Messagebox("Proibido alterar reserva de Mostruário !!!",0+16,"Mostruário")
*!*									USE IN xVerMost
*!*									USE IN xMatTipo
*!*									Return .F.
*!*								Endif
*!*							Endif
*!*						Endif
					
***** verificar o botao 3
***** matar saldo somente a domenica criar parametro
				
				case upper(xmetodo) == 'USR_WHEN' AND upper(xnome_obj) == 'BOTAO3'
					
					Text To xVerOSEnviada TextMerge Noshow
						select distinct a.ordem_servico,max(a.ordem_producao) as ordem_producao 
						from producao_os_tarefas (nolock) a
						join producao_ordem b on a.ordem_producao = b.ordem_producao
						join producao_ordem_servico c on a.ordem_servico = c.ordem_servico
						where b.ordem_producao=LTRIM(RTRIM('<<v_producao_ordem_01.ordem_producao>>'))
						and c.anm_status_almox='1-ENVIADO PARA ALMOX'
						group by a.ordem_servico
					Endtext
					f_select(xVerOSEnviada,"CurVerOSEnviada")
					sele CurVerOSEnviada

					If !F_Vazio(CurVerOSEnviada.ordem_producao) 
					
						xOS=CurVerOSEnviada.ordem_servico
						Messagebox("Proibido alterar reserva de Material enviado para Consumo."+chr(13)+"O.S.: "+xOS+CHR(13)+"Favor alterar o Status da OS diferente de 1-ENVIADO PARA ALMOX",0+16,"O.S. Enviada")
						RELEASE CurVerOSEnviada
						Return .F.
					Endif

** Bloqueio alterar reserva se estiver enviado para almoxarifado Lucas Miranda e permissao para alterar reserva- 30/11/2016 **				  	
			  	case (upper(xmetodo) == 'USR_ITEN_INCLUDE_BEFORE' OR upper(xmetodo) == 'USR_ITEN_DELETE_BEFORE' ) AND upper(xnome_obj) == 'PRODUCAO_ORDENS_021' 
 
*!*							Text To xVerRedeMost TextMerge Noshow
*!*								select B.PRODUTO from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_BLOQ_BT_MOST_REDE') A
*!*								JOIN PRODUTOS B
*!*								ON A.REDE_LOJAS = B.REDE_LOJAS
*!*								WHERE A.VALOR_ATUAL = 'SIM'
*!*								AND B.PRODUTO = LTRIM(RTRIM('<<v_producao_ordem_01.produto>>')) 
*!*							Endtext
*!*							f_select(xVerRedeMost,"CurxVerRedeMost")
*!*							sele CurxVerRedeMost
*!*	 						
*!*	 						f_select("select * from prop_producao_programa where propriedade = '00038' and programacao=?v_producao_ordem_01.programacao and valor_propriedade = 'MOSTRUARIO'","xVerMost")
*!*							Sele xVerMost	
*!*	 						
*!*							If !F_Vazio(CurxVerRedeMost.Produto) AND Thisformset.pp_ANM_BLOQ_USUA_MOST = .T. AND !F_Vazio(xVerMost.programacao)
*!*								Messagebox("Proibido Incluir/Excluir Material Manualmente na O.P. de  mostruário",0+16)
*!*								Return .F.
*!*							Endif               	
	                	
	                	Text To xVerOSEnviada TextMerge Noshow
							select distinct a.ordem_servico,max(a.ordem_producao) as ordem_producao 
							from producao_os_tarefas (nolock) a
							join producao_ordem b on a.ordem_producao = b.ordem_producao
							join producao_ordem_servico c on a.ordem_servico = c.ordem_servico
							where b.ordem_producao=LTRIM(RTRIM('<<v_producao_ordem_01.ordem_producao>>'))
							and c.anm_status_almox='1-ENVIADO PARA ALMOX'
							group by a.ordem_servico
						Endtext
						f_select(xVerOSEnviada,"CurVerOSEnviada")
						sele CurVerOSEnviada

						If !F_Vazio(CurVerOSEnviada.ordem_producao)
							xOS=CurVerOSEnviada.ordem_servico
							Messagebox("Proibido incluir/excluir reserva de Material enviado para Consumo."+chr(13)+"O.S.: "+xOS+CHR(13)+"Favor alterar o Status da OS diferente de 1-ENVIADO PARA ALMOX",0+16,"O.S. Enviada")
							RELEASE CurVerOSEnviada
							Return .F.
						Endif
**  Fim - Bloqueio alterar reserva se estiver enviado para almoxarifado Lucas Miranda - 30/11/2016 **	
            
				case upper(xmetodo) == 'USR_REFRESH' && AND thisformset.p_tool_status $'IA'						
						
						If type("Thisformset.lx_form1.botaocancelaop")<>"U"
							Thisformset.lx_form1.botaocancelaop.enabled = IIF(V_PRODUCAO_ORDEM_01.QTDE_EM_PRODUCAO=0,.F.,Thisformset.p_botao_exclui)
						Endif
						
						** #1 
						if type("thisformset.lx_form1.tx_gs_lote")<>"U"
							If Thisformset.p_tool_status = "I"
								thisformset.lx_form1.tx_gs_lote.value=null
							Endif	
							
							thisformset.lx_form1.tx_gs_lote.Enabled = thisformset.p_tool_status = "L"
						endif	
						** #1
						
						if type("THISFORMSET.lx_FORM1.lx_pageframe1.Page11.ck_finaliza_fin")<>"U"
							IF v_producao_ordem_01.ANM_CK_FINANC = .T.	
								THISFORMSET.lx_FORM1.lb_Finaliza_Fin.visible = .t.
							ELSE	
								THISFORMSET.lx_FORM1.lb_Finaliza_Fin.visible = .f.
							ENDIF
						
						
							if thisformset.p_tool_status $'P'	
								WITH THISFORMSET.lx_FORM1.lx_pageframe1.Page11
								.obs_fin.enabled = .f.
								.bt_conf_fin.caption = "Conf. Financ."		
								.ck_finaliza_fin.enabled = .f.				
								ENDWITH
							endif
						endif
					
						
					
						if type("thisformset.Lx_form1.lx_PAGEFRAME1.page3.lX_PAGEFRAME1.page1.bt_altera_reserva")<>"U"
							if thisformset.p_tool_status='A'
								thisformset.Lx_form1.lx_PAGEFRAME1.page3.lX_PAGEFRAME1.page1.bt_altera_reserva.visible=.t.
							else		
								thisformset.Lx_form1.lx_PAGEFRAME1.page3.lX_PAGEFRAME1.page1.bt_altera_reserva.visible=.f.
							endif	
						endif
						
						*** Bloqueia os campos caso a O.P. esteja agendado ***
						*** Lucas Miranda - 04/10/2017
						If type("Thisformset.lx_form1.gs_lbl_agendado") <> "U"
							If Thisformset.pp_gs_bloq_rota_agendado = .T.
								if thisformset.p_tool_status $ 'P'
								
									f_select("SELECT * FROM DBO.FX_GS_OP_PEDIDO_AGENDADO(?v_producao_ordem_01.ordem_producao, 'OP')","CurAgendado",ALIAS())
									Sele CurAgendado

									If RECCOUNT("CurAgendado") > 0
										Thisformset.lx_form1.gs_lbl_agendado.visible=.t.
										Thisformset.lx_form1.lx_pageframe1.page5.lx_pageframe1.page1.lx_GRID_FILHA1.col_tv_FASE_PRODUCAO.ReadOnly=.t.
										Thisformset.lx_form1.lx_pageframe1.page5.lx_pageframe1.page1.lx_GRID_FILHA1.col_tv_SETOR_PRODUCAO.ReadOnly=.t.
										Thisformset.lx_form1.lx_pageframe1.page5.lx_pageframe1.page1.lx_GRID_FILHA1.col_tv_RECURSO_PRODUTIVO.ReadOnly=.t.
										Thisformset.lx_form1.lx_pageframe1.page5.lx_pageframe1.page1.lX_TOOL_GRID_FILHA1.CMDEXCLUIRFILHA.Enabled=.F.
										Thisformset.lx_form1.lx_pageframe1.page5.lx_pageframe1.page1.Ck_visualiza_tarefa.ReadOnly=.t.
									Else	
										Thisformset.lx_form1.gs_lbl_agendado.visible=.F.
									Endif
								Else
									Thisformset.lx_form1.gs_lbl_agendado.visible=.F.
								Endif
							Endif
						Endif
						*** Fim
							SELECT V_PRODUCAO_ORDEM_01_MATERIAIS
							SCAN 							

								IF f_vazio(primeira_reserva)
									replace primeira_reserva WITH reserva_original 
									
									TEXT TO xupdate	NOSHOW TEXTMERGE
										UPDATE  producao_reserva  SET 
										 primeira_reserva=reserva_original 
											where ordem_producao='<<ALLTRIM(V_PRODUCAO_ORDEM_01_MATERIAIS.ordem_producao)>>' 
											and material='<<ALLTRIM(V_PRODUCAO_ORDEM_01_MATERIAIS.material)>>'  
											and cor_material='<<ALLTRIM(V_PRODUCAO_ORDEM_01_MATERIAIS.cor_material)>>' 
									ENDTEXT

									
									f_update(xupdate)
											
								ENDIF 	
							ENDSCAN			  	    									
						
						
							IF thisformset.p_tool_status $ "IA"
							 
	
	
							 	 if type("thisformset.lx_form1.lx_pageframe1.page2.cmb_filial_producao")<>"U"
								  	 f_select("select LTRIM(RTRIM(valor_propriedade)) as TIPO from prop_produtos where propriedade = '00036' and produto = ?V_PRODUCAO_ORDEM_01.produto","xTipoProd")
								     If (thisformset.pp_anm_val_cons_filial_op = .t. AND  xTipoProd.TIPO = 'PRODUTO ACABADO') OR xTipoProd.TIPO = 'PRODUÇAO'
										 SELECT V_PRODUCAO_ORDEM_01_MOV_MAT
										 Go Top

										 xOldFilial = v_producao_ordem_01.filial
										 xFilConsumo= V_PRODUCAO_ORDEM_01_MOV_MAT.filial
									
										 f_select("Select matriz from filiais where filial = ?xFilConsumo","curTemp_mfil_op","v_filiais_00")
										 *f_select("Select filial, inativo from filiais (nolock) a join cadastro_cli_for b (nolock) on a.filial = b.nome_clifor where inativo = 0","xFiliaisAt")
											 								 
										 *Sele v_filiais_00	
										 IF !f_vazio(curTemp_mfil_op.matriz) AND v_producao_ordem_01.tipo_processo <> 1 
										  SET FILTER TO (MATRIZ = curTemp_mfil_op.matriz AND CTRL_PRODUCAO_PRODUTO = .t. and INATIVO = .F.);
										  OR filial = xOldFilial   
										 ELSE
										  SET FILTER TO (CTRL_PRODUCAO_PRODUTO = .t. and INATIVO = .F.) 
										 ENDIF
										  
										 *thisformset.lx_form1.lx_pageframe1.page2.cmb_filial_producao.Enabled = .F.
										 thisformset.lx_form1.lx_pageframe1.page2.Cmb_FILIAL.Enabled = ;
										  iif(thisformset.pp_anm_per_alt_filial_op,.t.,(v_producao_ordem_01.tipo_processo <> 1 and !v_producao_ordem_01.qtde_total > v_producao_ordem_01.qtde_em_producao))
										ELSE
 
										 SELECT v_filiais_00
										 SET FILTER TO
										  
										 *thisformset.lx_form1.lx_pageframe1.page2.cmb_filial_producao.Enabled = .t.
										 thisformset.lx_form1.lx_pageframe1.page2.Cmb_FILIAL.Enabled = .t. 

										ENDIF
									ENDIF 
								Endif
				
				
				 
				
				case upper(xmetodo) == 'USR_SAVE_BEFORE' 


					xalias=alias()
					
					sele v_producao_ordem_01_tarefas  
					go top	
					loca for fase_producao='021'		
					if !found()
						messagebox("É necessário inserir a Fase 021-Recebimento antes da Revisão ",48,"Atenção!!")
						retu .f.		 
					endif	
					
					If Thisformset.p_tool_status = 'A' AND iif(TYPE("Thisformset.pp_Permite_desprogramar_prod")="U",.f.,.t.)

						xProgNaoValida = 0
						xSelect="select * FROM dbo.FX_ANM_PARAMETROS_REDE_LOJAS('GS_PROG_NAO_BLOQ_DESPROG')"
						f_select(xSelect,"CurValidaNomeProg",ALIAS())
						 
						Sele CurValidaNomeProg
						GO top
						SCAN					
							IF ALLTRIM(CurValidaNomeProg.valor_atual) $ ALLTRIM(v_producao_ordem_01.programacao)
								xProgNaoValida = 1
							ENDIF
						ENDSCAN
					
						IF USED("CurValidaNomeProg")
							USE IN CurValidaNomeProg
						ENDIF	
						
						IF USED("CurProgrOp")
							USE IN CurProgrOp
						ENDIF	
						
						IF USED("Cur_ProdOrdem")
							USE IN Cur_ProdOrdem
						ENDIF
						
						IF USED("Cur_Valida")
							USE IN Cur_Valida
						ENDIF
						
						IF USED("Cur_ValidaC")
							USE IN Cur_ValidaC
						ENDIF
						
						IF USED("CurProgrOp")
							USE IN CurProgrOp
						ENDIF
						
						IF USED("Cur_ProdOrdem")
							USE IN Cur_ProdOrdem
						ENDIF

						
						If xProgNaoValida = 0 AND v_producao_ordem_01.tipo_processo = 0
						
							xQtdeOldProg = 1																	
							xCompradora = '.'
							
							Sele v_producao_ordem_01_cores
							Go Top
							
							Scan	
								TEXT TO xSelOP TEXTMERGE NOSHOW
									SELECT *
									FROM PRODUCAO_ORDEM_COR
									WHERE ORDEM_PRODUCAO = '<<v_producao_ordem_01_cores.ordem_producao>>'
									AND PRODUTO = '<<v_producao_ordem_01_cores.produto>>'
									AND COR_PRODUTO = '<<v_producao_ordem_01_cores.cor_produto>>'
								ENDTEXT
										
								f_select(xSelOP,"Cur_ProdOrdem",ALIAS())
								
								Sele Cur_ProdOrdem
								If v_producao_ordem_01_cores.qtde_o < Cur_ProdOrdem.qtde_o
									
									TEXT TO xSelC TEXTMERGE NOSHOW
										Select Count(*) as OK From GS_PROGRAMACAO_SEM_COMPRA (nolock) 
										Where Programacao = '<<v_producao_ordem_01.programacao>>'  and 
										Produto     = '<<v_producao_ordem_01_cores.produto>>' and 
										Cor_Produto = '<<v_producao_ordem_01_cores.cor_produto>>' 
									ENDTEXT
									f_select(xSelC,"Cur_ValidaC",ALIAS())
									
									Sele Cur_ValidaC
									IF Cur_ValidaC.OK = 0
										TEXT TO xSel TEXTMERGE NOSHOW
											SELECT *
											FROM FN_CONSULTA_RESERVA_PROG_008006
											(
												'<<v_producao_ordem_01.programacao>>'			,
												'<<v_producao_ordem_01_cores.produto>>'			,
												'<<v_producao_ordem_01_cores.cor_produto>>'		,
												<<Cur_ProdOrdem.qtde_o>>	,
												<<v_producao_ordem_01_cores.qtde_o>>
											)   
										ENDTEXT
										
										f_select(xSel,"Cur_Valida",ALIAS())
										
										IF RECCOUNT("Cur_Valida")>0 AND ;
											INT(Cur_Valida.PORCENT_ALT) > Thisformset.pp_Permite_desprogramar_prod AND ;
												Cur_Valida.SOBRA_MRP_FINAL < 0 AND ;
												Cur_Valida.valida_prod > 0
									
											MESSAGEBOX("Produto/Cor com pedido de compra de MP já emitido."+CHR(13)+;
												"Favor solicitar o cancelamento com a compradora"+CHR(13)+ALLTRIM(Cur_Valida.usuario_linx),64,+;
												"Alteração de Grade não Permitida")					
											
											Return .F.
										Endif
									Endif
								Endif
							Sele v_producao_ordem_01_cores
							EndScan
						Endif
					Endif	
						
	
					if !f_vazio(xalias)	
						sele &xalias
					endif	




				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE




**************************************************
*-- Class:        lb_filial (c:\temp\lb_filial.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/22/08 05:05:04 PM
*
DEFINE CLASS lb_filial_producao AS lx_label


	Caption = "Filial Ent."
	Height = 15
	Left = 350
	Top = 76
	Width = 20
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_FILIAL_producao"
	Visible = .t.
	Enabled = .t.	
	Alignment=0
	

ENDDEFINE
*
*-- EndDefine: lb_filial
**************************************************



**************************************************
*-- Class:        cmb_filial (c:\temp\cmb_filial.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   10/22/08 05:05:01 PM
*
DEFINE CLASS cmb_filial_producao AS lx_combobox

	RowSource = "v_filiais_001.filial"
	ControlSource = "v_producao_ordem_01.filial_producao"
	Height = 22
	Left = 395
	TabIndex = 1
	Top = 74
	Width = 146
	ZOrderSet = 5
	Name = "cmb_FILIAL_producao"
	Visible = .t.
	Enabled = .t.	

ENDDEFINE
*
*-- EndDefine: cmb_filial
**************************************************





**************************************************
*-- Class:        obs_fin(c:\temp\lb_mata_reserva.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/22/08 05:05:04 PM
*
DEFINE CLASS obs_fin AS editbox


	Caption = "obs_fin"
	Height = 87
	Left = 24
	Top = 226
	Width = 704
	TabIndex = 10
	ZOrderSet = 6
	ControlSource = "v_producao_ordem_01.ANM_OBS_FIN"
	*p_muda_size = .F.
	Name = "obs_fin"
	Visible = .t.
	Enabled = .t.	
	Alignment=0

	
ENDDEFINE
*
*-- EndDefine: obs_fin
**************************************************

**************************************************
*-- Class:        bt_conf_fin (c:\temp\bt_treina.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/30/09 05:21:00 PM
*
DEFINE CLASS bt_conf_fin AS botao


	Top = 207
	Left = 24
	Height = 20 
	Width = 80
	FontBold = .F.
	FontSize = 8
	Caption = "Conf. Financ."
	TabIndex = 13
	p_muda_size = .F.
	Name = "bt_conf_fin"
	Visible=.t.
	Enabled=.t.	

	PROCEDURE Click

		IF this.Caption == "Conf. Financ." AND thisformset.lx_FORM1.lx_pageframe1.Page11.ck_finaliza_fin.value = .F.
			this.Caption = "Salvar"
			thisformset.lx_FORM1.lx_pageframe1.Page11.obs_fin.enabled = .t.
			thisformset.lx_FORM1.lx_pageframe1.Page11.ck_finaliza_fin.enabled = .t.
		ELSE
			IF thisformset.lx_FORM1.lx_pageframe1.Page11.obs_fin.enabled = .t.
				TEXT TO xUpdFin TEXTMERGE NOSHOW
				
					UPDATE PRODUCAO_ORDEM 
					SET ANM_CK_FINANC = REPLACE(REPLACE('<<THISFORMSET.lx_FORM1.lx_pageframe1.Page11.ck_finaliza_fin.value>>','.F.',0),'.T.',1),
					ANM_OBS_FIN= LTRIM(RTRIM('<<THISFORMSET.lx_FORM1.lx_pageframe1.Page11.obs_fin.value>>')) 
					WHERE ORDEM_PRODUCAO = '<<v_producao_ordem_01.ordem_producao>>'
				
				ENDTEXT
				
				f_update(xUpdFin)
				
				this.Caption = "Conf. Financ."
				thisformset.lx_FORM1.lx_pageframe1.Page11.obs_fin.enabled = .f.
				thisformset.lx_FORM1.lx_pageframe1.Page11.ck_finaliza_fin.enabled = .f.
				
				IF v_producao_ordem_01.ANM_CK_FINANC = .T.	
					THISFORMSET.lx_FORM1.lb_Finaliza_Fin.visible = .t.
				ELSE	
					THISFORMSET.lx_FORM1.lb_Finaliza_Fin.visible = .f.
				ENDIF
				
			ENDIF	
		ENDIF		 
	

	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_conf_fin 
**************************************************




**************************************************
*-- Class:        ck_finaliza_fin(c:\temp\bt_treina.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/30/09 05:21:00 PM
*
DEFINE CLASS ck_finaliza_fin AS Lx_checkbox


	Top = 210
	Left = 120
	Height = 20 
	Width = 80
	FontBold = .F.
	FontSize = 8
	Alignment = 0
	BackStyle = 0
	Caption = "Finalizado"
	TabIndex = 13
	ControlSource = "v_producao_ordem_01.ANM_CK_FINANC"
	p_muda_size = .F.
	Name = "ck_finaliza_fin"
	Visible=.t.
	Enabled=.f.	
	 


ENDDEFINE
*
*-- EndDefine: ck_finaliza_fin
**************************************************


**************************************************
*-- Class:        lb_Finaliza_Fin(c:\temp\lb_mata_reserva.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/22/08 05:05:04 PM
*
DEFINE CLASS lb_Finaliza_Fin AS lx_label


	Caption = "OP FINALIZADA"
	Height = 15
	Left = 480
	Top = 103
	Width = 22
	TabIndex = 10
	ForeColor = RGB(255,0,0)
	BackColor = RGB(0,0,0)
	FontBold=.t.
	FontSize=15
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_Finaliza_Fin"
	Visible = .f.
	Enabled = .t.	
	Alignment=0
	

ENDDEFINE
*
*-- EndDefine: lb_Finaliza_Fin
**************************************************



**************************************************
*-- Class:        bt_mata_reserva (c:\temp\bt_treina.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/30/09 05:21:00 PM
*
DEFINE CLASS bt_mata_reserva AS botao


	Top = 64
	Left = 300
	Height = 22 
	Width = 94
	FontBold = .F.
	FontSize = 8
	Caption = "Mata Reserva"
	TabIndex = 13
	p_muda_size = .F.
	Name = "bt_mata_reserva"
	Visible=.t.
	Enabled=.t.	

	PROCEDURE Click


			If V_PRODUCAO_ORDEM_01.STATUS<>'E'
			
				messagebox("A OP não está Encerrada !",48,"Atenção!")
				retu .f. 
				
			Else	

				if messagebox("Deseja Matar Saldo de Reserva desta OP?",4,"Atenção!!!") = 6
				
					text to xupdt noshow textmerge	
						update producao_reserva 
						set diferenca_previsao=reserva,
						reserva=0 
						where ordem_producao='<<V_PRODUCAO_ORDEM_01.ORDEM_PRODUCAO>>' 
						and reserva>0
					endtext
					
					
					if !f_update(xupdt)  
						messagebox("Não foi possível matar saldo desta OP",48,"Atenção!!!")
					endif	
					
					o_toolbar.Botao_refresh.Click()  	
				
				endif	


			Endif


	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_mata_reserva
**************************************************





**************************************************
*-- Class:        bt_altera_reserva (c:\temp\bt_treina.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/30/09 05:21:00 PM
*
DEFINE CLASS bt_altera_reserva AS botao


	Top = 64
	Left = 500
	Height = 22 
	Width = 94
	FontBold = .F.
	FontSize = 8
	Caption = "Altera Reserva"
	TabIndex = 13
	p_muda_size = .F.
	Name = "bt_altera_reserva"
	Visible=.t.
	Enabled=.t.	

	PROCEDURE Click


			If V_PRODUCAO_ORDEM_01.STATUS='E'
			
				messagebox("A OP está Encerrada !",48,"Atenção!")
				retu .f. 
				
			Else	

				if messagebox("Deseja Alterar Reserva desta OP?",4,"Atenção!!!") = 6 

					sele v_producao_ordem_01_materiais
					repla tipo_reserva with 2 

					thisformset.Lx_form1.lx_PAGEFRAME1.page3.lX_PAGEFRAME1.page1.lx_GRID_FILHA1.Refresh()
					xReservaAnterior = V_PRODUCAO_ORDEM_01_MATERIAIS.RESERVA_ORIGINAL
					
				endif	


			Endif


	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_mata_reserva
**************************************************


**************************************************
*-- Class:        lb_filial (c:\temp\lb_mata_reserva.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/22/08 05:05:04 PM
*
DEFINE CLASS lb_mata_reserva AS lx_label


	Caption = "Mata Reserva"
	Height = 15
	Left = 300
	Top = 64
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_mata_reserva"
	Visible = .t.
	Enabled = .t.	
	Alignment=0
	
	Procedure DblClick	
	
		MESSAGEBOX("aprendendo!!",48,"atenção!")
	
	Endproc
	

ENDDEFINE
*
*-- EndDefine: lb_mata_reserva
**************************************************
**************************************************
*-- Class Library:  c:\linx desenv\classes lucas\gs_lbl_agendado.vcx
**************************************************


**************************************************
*-- Class:        gs_lbl_agendado (c:\linx desenv\classes lucas\gs_lbl_agendado.vcx)
*-- ParentClass:  label
*-- BaseClass:    label
*-- Time Stamp:   10/04/17 09:32:08 AM
*
DEFINE CLASS gs_lbl_agendado AS label


	FontBold = .T.
	FontName = "Tahoma"
	FontSize = 8
	BackStyle = 0
	Caption = "O.P. Agendado"
	Height = 14
	Left = 655
	Top = 112
	Width = 105
	ForeColor = RGB(255,0,0)
	Name = "gs_lbl_agendado"
	Visible = .F.

ENDDEFINE
*
*-- EndDefine: gs_lbl_agendado
**************************************************
**#07122018
DEFINE CLASS tx_processado AS lx_textbox_base 

 
	ControlSource = "v_producao_ordem_01.processado"
	Height = 30
	Left = 550
	TabIndex = 11
	Top = 20
	Width = 180
	ZOrderSet = 8
	Name = "tx_processado"
	Enabled=.F.
	Visible=.T.

ENDDEFINE

**************************************************
**#07122018
DEFINE CLASS lb_processado AS lx_label 

 
	Caption = "Log Risco"
	Height = 15
	Left = 550
	Top = 5
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	FontBold = .T.
	Name = "lb_processado"
	Visible = .t.
	Anchor = 0
	Alignment=0

ENDDEFINE

**************************************************



*-- Class:        tx_data_ini_separacao (c:\temp\tx_data_ini_separacao.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS tx_gs_lote AS lx_textbox_base 

 
	ControlSource = "v_producao_ordem_01.gs_lote_op"
	Height = 19
	Left = 620
	TabIndex = 11
	Top = 69
	Width = 40
	ZOrderSet = 8
	Name = "tx_gs_lote"
	Enabled=.T.
	Visible=.T.

ENDDEFINE
*
*-- EndDefine: tx_data_ini_separacao
**************************************************
**************************************************
*-- Class:        lb_data_ini_separacao (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_gs_lote AS lx_label


	Caption = "Lote"
	Height = 15
	Left = 590
	Top = 72
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	FontBold = .T.
	Name = "lb_gs_lote"
	Visible = .t.
	Anchor = 0
	Alignment=0
	
ENDDEFINE
*
*-- EndDefine: lb_data_ini_separacao 
**************************************************

**************************************************
*-- Class:        botaocancelaop (c:\users\julio.cesar.animale\desktop\cancelaop.vcx)
*-- ParentClass:  botao (c:\linx grupo soma\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/19/18 05:03:02 PM
*
DEFINE CLASS botaocancelaop AS botao


	Top = 104
	Left = 644
	Height = 23
	Width = 97
	Caption = "Cancelar OP"
	Name = "CMD"
	Visible = .T.

	PROCEDURE Click

		IF MESSAGEBOX("Deseja realmente cancelar a OP?",32+4+256,"Cancelar OP")=6
			
			f_wait("Cancelando Ordem de Produção ... Aguarde!")
			IF !f_execute("EXEC LX_ANM_GERA_PERDA_OP ?V_PRODUCAO_ORDEM_01.ORDEM_PRODUCAO")
				f_wait()
				MESSAGEBOX("Erro ao tentar cancelar OP.",64,"Erro ao cancelar OP")
				RETURN .F.
			ELSE
				f_wait()
				MESSAGEBOX("OP cancelada com sucesso!",64,"Cancelado com sucesso")
				o_toolbar.Botao_refresh.Click()
			ENDIF

		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: botaocancelaop
**************************************************









