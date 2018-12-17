* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar                                                                                     *
* DATA...........:  14/02/2010                                                                                      *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Inclusao campo Filial Estoque em funcao das entradas RBX/TRIMIX
*TRATAMENTO PARA FATURAMENTO RBX/TRIMIX E MOVIMENTACAO ESTOQUE ATAACDO/ESTOQUE CENTRAL						                    *
********************************************************************************************************************* 
******************************************************
*- Programa Base de Criação de Objeto de Entrada
********************************************************************
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos 
*******************************************************************************
*- Existem 2 parametros que influem nos objetos de Entrada:  
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execução para facilitar o desenvolvimento
*********************************************************************************
 

*********************************************************************************
* - Atencao !!!!!!!!!!!														   -*
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP -*
*********************************************************************************

*
*                 Abaixo segue Programa objeto sem Codigo 
*
*
*- Definindo a classe do objeto de entrada que sera criado na Form.
define class obj_entrada as custom
	*- Nome do metodo/função que os objetos linx vão chamar.
	procedure metodo_usuario
		*- Parametros do metodo:
		*- Xmetodo= nome do metodo
		*- Xobjeto= variavel com a referencia ao objeto
		*- Xnome_obj  = nome do objeto
		lparam xmetodo, xobjeto ,xnome_obj
		
		******************** Metodos chamados pelo FORMSET
		*	USR_INIT
		*	USR_ALTER_BEFORE  ->Return .f. Para o Metodo
		*	USR_ALTER_AFTER    
		*	USR_INCLUDE_AFTER
		*	USR_SEARCH_BEFORE ->Return .f. Para o Metodo
		*	USR_SEARCH_AFTER
		*	USR_CLEAN_AFTER
		*	
		*	USR_SAVE_BEFORE   ->Return .f. Para o Metodo 
		*	USR_SAVE_AFTER
		*	USR_ITEN_DELETE_BEFORE ->Return .f. Para o Metodo
		*	USR_ITEN_DELETE_AFTER
		*	USR_ITEN_INCLUDE_BEFORE ->Return .f. Para o Metodo
		*	USR_ITEN_INCLUDE_AFTER
		*
		***************** Metodos que ocorrem dentro da Transaction do Banco de Dados
		*	USR_TRIGGER_AFTER ->Return .f. Para o Salvamento e da Rollback
		*	USR_TRIGGER_BEFORE ->Return .f. Para o Salvamento e da Rollback


		******************** Metodo chamado pelos Objetos na Validação
		*   USR_VALID -> Return .f. Não deixa o Usuario sair do objeto.

		******************** Metodo chamado pelos PageFrames
		*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

		*- Inicio dos procedimentos do Usuario
		*- Testando qual o metodo que esta chamando o metodo entrada
		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
		do case
			*- metodo do inicio da form
			
 
				case UPPER(xmetodo) == 'USR_INIT' 
				
					xalias=alias()
					
			     	 	with thisformset.lx_form1.PgPrincipal.page1.lx_PAGEFRAME1.page2.LX_PAGEFRAME1.page2
							.addobject("lb_alterado_por","lb_alterado_por")
							.addobject("Tx_alterado_por","Tx_alterado_por") 
						endwith	

						*** Bloqueio ficha tecnica**
						Sele v_produtos_00
						xalias_pai=alias()
						oCur = getcursoradapter(xalias_pai)
						oCur.addbufferfield("SPACE(3)  AS TEC_FINALIZADO" 	    , "C(3)" ,.T., "Tec Final."      , "TEC_FINALIZADO")
						oCur.addbufferfield("SPACE(25) AS DATA_FINALIZA_TEC"    , "C(25)",.T., "Data Final. Tec" , "DATA_FINALIZA_TEC")
						oCur.addbufferfield("0         AS QTDE_FINALIZADA_TEC"  , "N"    ,.T., "Qtde Final. Tec" , "QTDE_FINALIZADA_TEC")
						
						oCur.addbufferfield("SPACE(3)  AS AV_FINALIZADO"        , "C(3)" ,.T., "Av Final."       , "AV_FINALIZADO")
						oCur.addbufferfield("SPACE(25) AS DATA_FINALIZA_AV"     , "C(25)",.T., "Data Final. Av"  , "DATA_FINALIZA_AV")
						oCur.addbufferfield("0  	   AS QTDE_FINALIZADA_AV"   , "N"    ,.T., "Qtde Final. Av"  , "QTDE_FINALIZADA_AV")
						
						oCur.addbufferfield("SPACE(3)  AS MOST_FINALIZADO"      , "C(3)" ,.T., "Most Final."     , "MOST_FINALIZADO")
						oCur.addbufferfield("SPACE(25) AS DATA_FINALIZA_MOST"   , "C(25)",.T., "Data Final. Most", "DATA_FINALIZA_MOST")						
						oCur.addbufferfield("0         AS QTDE_FINALIZADA_MOST" , "N"    ,.T., "Qtde Final. Most", "QTDE_FINALIZADA_MOST")
						
						oCur.confirmstructurechanges()	
						Thisformset.l_limpa()
					
						with thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1
							.AddObject("btn_anm_finaliza_most","btn_anm_finaliza_most")
							.addobject("Tx_data_final_most","Tx_data_final_most") 
							.Tx_data_final_most.controlsource="v_produtos_00.DATA_FINALIZA_MOST"
							.addobject("Tx_qtd_final_most","Tx_qtd_final_most") 
							.Tx_qtd_final_most.controlsource="v_produtos_00.QTDE_FINALIZADA_MOST"
							
							.AddObject("btn_anm_finaliza_pan","btn_anm_finaliza_pan")
							.addobject("Tx_data_final_pan","Tx_data_final_pan") 
							.Tx_data_final_pan.controlsource="v_produtos_00.DATA_FINALIZA_TEC"
							.addobject("Tx_qtd_final_pan","Tx_qtd_final_pan") 
							.Tx_qtd_final_pan.controlsource="v_produtos_00.QTDE_FINALIZADA_TEC"
							
							.AddObject("btn_anm_finaliza_av","btn_anm_finaliza_av")
							.addobject("Tx_data_final_av","Tx_data_final_av") 
							.Tx_data_final_av.controlsource="v_produtos_00.DATA_FINALIZA_AV"
							.addobject("Tx_qtd_final_av","Tx_qtd_final_av") 
							.Tx_qtd_final_av.controlsource="v_produtos_00.QTDE_FINALIZADA_AV"
						
							.lx_grid_filha1.Height 	= 315
					    	.lx_grid_filha1.Top 	= 53
							.lx_grid_filha1.Anchor	= 10 &&Mudo antes para 10 e volto para 15 pois não estava gravando a posição
							.lx_grid_filha1.Anchor	= 15
						endwith

						* Inicio Views Exclusivas **
						f_select("select * from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_VERIFICA_FIN_FT_PA')","ppRL_ANM_VERIFICA_FIN_FT_PA")
						f_select("select * from materiais_tipo","CurMaterialTipo")
						
						 * Inclui Nova Procedure na Classe da Tela >> Dentro de Activate da Guia Materiais
				 		Bindevent(thisformset.LX_FORM1.pgPrincipal.page1.lx_pageframe1.page2, "Activate", This, "ANM_USR_ACTIVATE_PAG2", 1)
						
						*** Bloqueio ficha tecnica**
						
						*** Inclusão do CheckBox Rota de Conserto ***
						*** Lucas Miranda 16/03/2016 ***
						sele V_PRODUTOS_TAB_OPERACOES_00
						xalias_pai=alias()
						
		  				oCur = getcursoradapter(xalias_pai)
						oCur.addbufferfield("ROTA_CONSERTO", "L",.T., "ROTA_CONSERTO", "PRODUTOS_TAB_OPERACOES.ROTA_CONSERTO")	
						oCur.confirmstructurechanges()
						
						Thisformset.LX_FORM1.PGPrincipal.Page5.Lx_pageframe1.PAge2.AddObject("ck_anm_rota_conserto","ck_anm_rota_conserto")
						*** Fim Inclusão do CheckBox Rota de Conserto ***
					
				    if	!f_vazio(xalias)	
					  sele &xalias 
				    ENDIF

				 ****** Bloqueio de alocação de recursos - Silvio Luiz - 27042016 ***********************			    
				 case upper(xmetodo) == 'USR_WHEN' AND upper(xnome_obj) == 'TX_CUSTO_SUGERIDO'  
				 
				 						
					IF THISFORMSET.pp_ANM_BLOQUEIO_RECURSO=.T.
						
						SELECT v_Produto_Operacoes_00_Rotas
						
						TEXT TO XFASE NOSHOW TEXTMERGE
							SELECT FASE_PRODUCAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_FASE
							WHERE PROPRIEDADE='00210'
							AND FASE_PRODUCAO=?v_Produto_Operacoes_00_Rotas.Fase_Producao
						ENDTEXT
						
						F_SELECT(XFASE, 'CUR_FASE')
						
						TEXT TO XPRODUTO NOSHOW TEXTMERGE
							SELECT PRODUTO, VALOR_PROPRIEDADE FROM PROP_PRODUTOS
							WHERE PROPRIEDADE='50016'
							AND PRODUTO=?v_Produto_Operacoes_00_Rotas.tabela_operacoes
						ENDTEXT
						
						F_SELECT(XPRODUTO, 'CUR_PRODUTO')
					
					
						SELECT CUR_FASE
						SELECT CUR_PRODUTO
						
							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' AND CUR_PRODUTO.VALOR_PROPRIEDADE='INTERNO'   
								MESSAGEBOX("O USUÁRIO NÃO TEM PERMISSÃO PARA ALTERAR O CUSTO DESTA FASE!!",48) 
				    			thisform.LX_FORM1.PGPrincipal.PAGe5.LX_pageframe1.PAge2.LX_pageframe1.PAge2.LX_GRID_FILHA2.col_tx_CUSTO_SUGERIDO.tx_CUSTO_SUGERIDO.Enabled= .F.
				    			RETURN .f.
							ENDIF
					ENDIF
					
				
				case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TV_RECURSO_PRODUTIVO'

						
					IF THISFORMSET.pp_ANM_BLOQUEIO_RECURSO=.T.
						
						SELECT v_Produto_Operacoes_00_Rotas
						
						SELECT tabela_operacoes, fase_producao, sequencia_produtiva, recurso_produtivo, desc_recurso FROM v_Produto_Operacoes_00_Rotas INTO CURSOR  vtmp_Produto_Operacoes_00_Rotas
						
						SELECT vtmp_Produto_Operacoes_00_Rotas

							TEXT TO XDADOS NOSHOW TEXTMERGE
								select A.RECURSO_PRODUTIVO, B.DESC_RECURSO, A.SEQUENCIA_PRODUTIVA 
								from PRODUTO_OPERACOES_ROTAS A
								JOIN PRODUCAO_RECURSOS B
								ON A.RECURSO_PRODUTIVO=B.RECURSO_PRODUTIVO 
								where A.TABELA_OPERACOES=?vtmp_Produto_Operacoes_00_Rotas.tabela_operacoes
								and A.SEQUENCIA_PRODUTIVA=?v_Produto_Operacoes_00_Rotas.SEQUENCIA_PRODUTIVA
							ENDTEXT
							
						F_SELECT(XDADOS, 'CUR_DADO_ANTERIOR')
						
						TEXT TO XFASE NOSHOW TEXTMERGE
							SELECT FASE_PRODUCAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_FASE
							WHERE PROPRIEDADE='00210'
							AND FASE_PRODUCAO=?v_Produto_Operacoes_00_Rotas.Fase_Producao
						ENDTEXT
						
						F_SELECT(XFASE, 'CUR_FASE')
						
						TEXT TO XPRODUTO NOSHOW TEXTMERGE
							SELECT PRODUTO, VALOR_PROPRIEDADE FROM PROP_PRODUTOS
							WHERE PROPRIEDADE='50016'
							AND PRODUTO=?v_Produto_Operacoes_00_Rotas.tabela_operacoes
						ENDTEXT
						
						F_SELECT(XPRODUTO, 'CUR_PRODUTO')
					
					
						SELECT CUR_FASE
						SELECT CUR_PRODUTO
						SELECT CUR_DADO_ANTERIOR

						
							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' AND CUR_PRODUTO.VALOR_PROPRIEDADE='INTERNO'  
								SELECT v_Produto_Operacoes_00_Rotas
										MESSAGEBOX("O USUÁRIO NÃO TEM PERMISSÃO PARA ALTERAR O RECURSO NESTA FASE!!",48) 
										thisform.LX_FORM1.PGPrincipal.PAGe5.LX_pageframe1.PAge2.LX_pageframe1.PAge2.LX_GRID_FILHA2.col_tv_RECURSO_PRODUTIVO.tv_RECURSO_PRODUTIVO.Enabled= .F.
										REPLACE recurso_produtivo WITH CUR_DADO_ANTERIOR.RECURSO_PRODUTIVO
										REPLACE desc_recurso WITH CUR_DADO_ANTERIOR.DESC_RECURSO
							ENDIF                                                       
					ENDIF		
					
					
					case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TV_FASE_PRODUCAO'
				
					IF THISFORMSET.pp_ANM_BLOQUEIO_RECURSO=.T.
						
						SELECT v_Produto_Operacoes_00_Rotas
						
						TEXT TO XFASE NOSHOW TEXTMERGE
							SELECT FASE_PRODUCAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_FASE
							WHERE PROPRIEDADE='00210'
							AND FASE_PRODUCAO=?v_Produto_Operacoes_00_Rotas.Fase_Producao
						ENDTEXT
						
						F_SELECT(XFASE, 'CUR_FASE')
						
						TEXT TO XPRODUTO NOSHOW TEXTMERGE
							SELECT PRODUTO, VALOR_PROPRIEDADE FROM PROP_PRODUTOS
							WHERE PROPRIEDADE='50016'
							AND PRODUTO=?v_Produto_Operacoes_00_Rotas.tabela_operacoes
						ENDTEXT
						
						F_SELECT(XPRODUTO, 'CUR_PRODUTO')
					
					
						SELECT CUR_FASE
						SELECT CUR_PRODUTO

							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' AND CUR_PRODUTO.VALOR_PROPRIEDADE='INTERNO'  
								SELECT v_Produto_Operacoes_00_Rotas
										MESSAGEBOX("O USUÁRIO TEM PERMISSÃO PARA INCLUIR NESTA FASE SOMENTE O RECURSO '99' - 'AGUARDANDO DEFINIÇAO'!!",48) 
										REPLACE recurso_produtivo WITH '99'
										REPLACE desc_recurso WITH 'AGUARDANDO DEFINIÇAO'
										thisform.LX_FORM1.PGPrincipal.PAGe5.LX_pageframe1.PAge2.LX_pageframe1.PAge2.LX_GRID_FILHA2.col_tv_SETOR_PRODUCAO.SetFocus
							ENDIF  
						                                              
					ENDIF		
					
					case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TV_MATERIAL'
						
						xalias=alias()
							
							*** Bloqueio ficha tecnica**
							Sele CurMaterialTipo
							LOCATE FOR tipo = v_produtos_ficha_01.tipo
								
								If !(Cur_ProgMost_S_OP.Qtde_prog_s_OP > 0 AND v_produtos_00.MOST_FINALIZADO= 'SIM')
								
									If thisformset.pp_ANM_ALT_CONS_PAN = .F. AND CurMaterialTipo.indica_tecido = .T. AND v_produtos_00.TEC_FINALIZADO = 'SIM'
										Messagebox("Usuário bloqueado para alteração de consumo do Tipo Panos!!!",0+16,"Bloqueio Ficha Técnica")
										*Return .F. ** Excluo Item **
											ThisFormSet.lx_Form1.pgPrincipal.Page1.lx_PageFrame1.ActivePage = 1
											ThisFormSet.l_desenhista_filhas_exclui_antes 

											select v_Produtos_Ficha_01

											if recno()!= 0 and !eof() and !deleted()
												tablerevert()
												if recno() > 0
													delete
												endif
											ENDIF

											ThisFormSet.l_desenhista_filhas_exclui_apos
											Return .t.
									Else
										If thisformset.pp_ANM_ALT_CONS_PAN = .F. AND CurMaterialTipo.indica_tecido = .F. AND v_produtos_00.AV_FINALIZADO= 'SIM'
											Messagebox("Usuário bloqueado para alteração de consumo do Tipo Aviamentos!!!",0+16,"Bloqueio Ficha Técnica")
											*Return .F. ** Excluo Item **
											ThisFormSet.lx_Form1.pgPrincipal.Page1.lx_PageFrame1.ActivePage = 1
											ThisFormSet.l_desenhista_filhas_exclui_antes 

											select v_Produtos_Ficha_01

											if recno()!= 0 and !eof() and !deleted()
												tablerevert()
												if recno() > 0
													delete
												endif
											ENDIF

											ThisFormSet.l_desenhista_filhas_exclui_apos
											Return .t.
										Endif
									Endif
								Else
									Messagebox("Usuário bloqueado para alteração."+CHR(13)+"OP de mostruário não emitida!!!",0+16,"Bloqueio Ficha Técnica")
									*Return .F. ** Excluo Item **
									ThisFormSet.lx_Form1.pgPrincipal.Page1.lx_PageFrame1.ActivePage = 1
									ThisFormSet.l_desenhista_filhas_exclui_antes 

									select v_Produtos_Ficha_01

									if recno()!= 0 and !eof() and !deleted()
										tablerevert()
										if recno() > 0
											delete
										endif
									ENDIF

									ThisFormSet.l_desenhista_filhas_exclui_apos
									Return .t.
								Endif
								*** Bloqueio ficha tecnica**
								
						IF !f_vazio(xalias)	
						  sele &xalias 
					    ENDIF
											

				*** Bloqueio ficha tecnica**				
				case upper(xmetodo) == 'USR_WHEN' AND (upper(xnome_obj) == 'TX_C1' OR upper(xnome_obj) == 'TX_1' OR upper(xnome_obj) == 'TX_2' OR ;
													   upper(xnome_obj) == 'TX_3'  OR upper(xnome_obj) == 'TX_4' OR upper(xnome_obj) == 'TX_5' OR ;
													   upper(xnome_obj) == 'TX_CONSUMO_AUX' OR upper(xnome_obj) == 'TX_PORC_CONSUMO' OR upper(xnome_obj) == 'TX_PORCENTAGEM_CONSUMO')
					xalias=alias()
						
								Sele CurMaterialTipo
								LOCATE FOR tipo = v_produtos_ficha_01.tipo
									
									If !(Cur_ProgMost_S_OP.Qtde_prog_s_OP > 0 AND v_produtos_00.MOST_FINALIZADO= 'SIM')
										
										If thisformset.pp_ANM_ALT_CONS_PAN= .F. AND CurMaterialTipo.indica_tecido= .T. AND v_produtos_00.TEC_FINALIZADO= 'SIM'
											Return .F.
										Endif
											
										If thisformset.pp_ANM_ALT_CONS_AV= .F. AND CurMaterialTipo.indica_tecido= .F. AND v_produtos_00.AV_FINALIZADO= 'SIM'
											Return .F.
										Endif
									Else
										Return .F.
									Endif	
									
					If !f_vazio(xalias)	
					  sele &xalias 
				    Endif
				*** Bloqueio ficha tecnica**
				
				case UPPER(xmetodo) == 'USR_REFRESH' 
					xalias=alias()
						IF Thisformset.P_tool_status = 'P'
							If type('thisformset.lx_form1.PgPrincipal.page1.lx_PAGEFRAME1.page2.LX_PAGEFRAME1.page2.Tx_alterado_por')<>'U'
							
								Text To xSelLogFicha TextMerge Noshow
																	
									Select top 1 USUARIO 
									from MIT_LOG_FICHA_TECNICA 
									where produto =	LTRIM(RTRIM('<<v_produtos_00.produto>>'))
									order by data_hora desc
									 	
								Endtext
								f_select(xSelLogFicha,"xLogFicha")
								
								thisformset.lx_form1.PgPrincipal.page1.lx_PAGEFRAME1.page2.LX_PAGEFRAME1.page2.Tx_alterado_por.Value       = UPPER(ALLTRIM(xLogFicha.USUARIO)) 
								thisformset.lx_form1.PgPrincipal.page1.lx_PAGEFRAME1.page2.LX_PAGEFRAME1.page2.Tx_alterado_por.ToolTipText = UPPER(ALLTRIM(xLogFicha.USUARIO)) 
								
							Endif

						ENDIF	
						
							
						*** Bloqueio ficha tecnica**	
						If type('thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan')<>'U'		
							
							If Thisformset.P_tool_status $ 'PA'					
										
										TEXT TO xSelProgSemOP TEXTMERGE NOSHOW
								
											Select count(*) Qtde_prog_s_OP 
											from producao_prog_prod a
												join prop_producao_programa b on a.PROGRAMACAO = b.PROGRAMACAO and b.PROPRIEDADE = '00038'

											WHERE B.VALOR_PROPRIEDADE = 'MOSTRUARIO' and 
												  a.QTDE_SALDO_EMITIR_OP > 0 and a.ANM_MATAR_SALDO = 0 and
												  a.PRODUTO = LTRIM(RTRIM('<<v_produtos_00.produto>>')) 
										ENDTEXT
										f_select(xSelProgSemOP,"Cur_ProgMost_S_OP",ALIAS()) && PRODUTO COM OP DE MOSTRUÁRIO PENDENTE EMISSÃO
										
										f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

										sele v_produtos_00
										replace  DATA_FINALIZA_TEC 		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS,xFinFichaMost.DATA_FINAL_PANOS,''),'')
										replace	 TEC_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS,'SIM','NAO'),'')
										replace  QTDE_FINALIZADA_TEC 	With NVL(xFinFichaMost.QTDE_FINALIZADA_PANOS,0)
										
										replace  DATA_FINALIZA_AV 		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS,xFinFichaMost.DATA_FINAL_AV,''),'')
										replace	 AV_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS,'SIM','NAO'),'')
										replace  QTDE_FINALIZADA_AV 	With NVL(xFinFichaMost.QTDE_FINALIZADA_AVIAMENTOS,0)
										
										replace  DATA_FINALIZA_MOST 	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO,xFinFichaMost.DATA_FINAL_MOST,''),'')
										replace	 MOST_FINALIZADO    	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO,'SIM','NAO'),'')
										replace  QTDE_FINALIZADA_MOST 	With NVL(xFinFichaMost.QTDE_FINALIZADA_MOST,0)
									
										With thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan
											.BackColor 		= Iif(v_produtos_00.TEC_FINALIZADO='SIM', RGB(0,255,0)      , RGB(255,0,0) )
											.ToolTipText 	= Iif(v_produtos_00.TEC_FINALIZADO='SIM', "Liberar FT Panos", "Finalizar FT Panos" )
											.Caption 		= Iif(v_produtos_00.TEC_FINALIZADO='SIM', "Lib. Panos"      , "Fin. Panos" )
										EndWith

										With thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av
											.BackColor 		= Iif(v_produtos_00.AV_FINALIZADO='SIM', RGB(0,255,0)           , RGB(255,0,0) )
											.ToolTipText 	= Iif(v_produtos_00.AV_FINALIZADO='SIM', "Liberar FT Aviamentos", "Finalizar FT Aviamentos" )
											.Caption 		= Iif(v_produtos_00.AV_FINALIZADO='SIM', "Lib. Avia."           , "Fin. Avia." )
										EndWith

										With thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most
											.BackColor 		= Iif(v_produtos_00.MOST_FINALIZADO='SIM', RGB(0,255,0)        , RGB(255,0,0) )
											.BackColor 		= Iif(v_produtos_00.MOST_FINALIZADO='SIM' and Cur_ProgMost_S_OP.Qtde_prog_s_OP>0,RGB(255,255,0),.BackColor)
											.ToolTipText 	= Iif(v_produtos_00.MOST_FINALIZADO='SIM', "Liberar Mostruario", "Finalizar Mostruario" )
											.Caption 		= Iif(v_produtos_00.MOST_FINALIZADO='SIM', "Lib. Mostr."       , "Fin. Mostr." )
										EndWith
							Else
								With thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1
									.btn_anm_finaliza_pan.BackColor = RGB(171,92,84) 			
									.btn_anm_finaliza_pan.Caption   = "F\L Panos"	
								
									.btn_anm_finaliza_av.BackColor = RGB(171,92,84) 			
									.btn_anm_finaliza_av.Caption   = "F\L Avia."
								
									.btn_anm_finaliza_most.BackColor = RGB(171,92,84) 			
									.btn_anm_finaliza_most.Caption   = "F\L Mostr."
								EndWith
							Endif		

						Endif
						*** Bloqueio ficha tecnica**

				    if	!f_vazio(xalias)	
					  sele &xalias 
				    ENDIF
					
					
					case UPPER(xmetodo) == 'USR_SEARCH_AFTER'
						
						xalias=alias()
						
							*** Bloqueio ficha tecnica**
							sele v_produtos_00
							go	top
								Scan	
									sele ppRL_ANM_VERIFICA_FIN_FT_PA
									LOCATE FOR REDE_LOJAS = v_produtos_00.rede_lojas
									If FOUND() AND ppRL_ANM_VERIFICA_FIN_FT_PA.valor_atual = 'SIM'
										
										f_prog_bar("Verificando Finalizações da Ficha Tecnica...",recno(),reccount())
										
										f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

										sele v_produtos_00
										replace  DATA_FINALIZA_TEC 		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS,xFinFichaMost.DATA_FINAL_PANOS,''),'')
										replace	 TEC_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS,'SIM','NAO'),'')
										replace  QTDE_FINALIZADA_TEC 	With NVL(xFinFichaMost.QTDE_FINALIZADA_PANOS,0)
										
										replace  DATA_FINALIZA_AV 		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS,xFinFichaMost.DATA_FINAL_AV,''),'')
										replace	 AV_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS,'SIM','NAO'),'')
										replace  QTDE_FINALIZADA_AV 	With NVL(xFinFichaMost.QTDE_FINALIZADA_AVIAMENTOS,0)
										
										replace  DATA_FINALIZA_MOST 	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO,xFinFichaMost.DATA_FINAL_MOST,''),'')
										replace	 MOST_FINALIZADO    	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO,'SIM','NAO'),'')
										replace  QTDE_FINALIZADA_MOST 	With NVL(xFinFichaMost.QTDE_FINALIZADA_MOST,0)

									Endif
								Endscan	
								
								Release xFinFichaMost
								f_prog_bar()	
								
								sele v_produtos_00
								Go Top
								Thisformset.Refresh()
							*** Bloqueio ficha tecnica**
							
						if	!f_vazio(xalias)	
						  sele &xalias 
					    endif

			
					case upper(xmetodo) == 'USR_ITEN_DELETE_BEFORE'
						
						xalias=alias()
							
							*** Bloqueio ficha tecnica**
							sele ppRL_ANM_VERIFICA_FIN_FT_PA
							LOCATE FOR REDE_LOJAS = v_produtos_00.rede_lojas
							If FOUND() AND ppRL_ANM_VERIFICA_FIN_FT_PA.valor_atual = 'SIM'
								
								If !(Cur_ProgMost_S_OP.Qtde_prog_s_OP > 0 AND v_produtos_00.MOST_FINALIZADO= 'SIM')
									
										Sele CurMaterialTipo
										LOCATE FOR tipo = v_produtos_ficha_01.tipo
									
										If v_produtos_00.TEC_FINALIZADO = 'SIM' AND CurMaterialTipo.indica_tecido AND !Thisformset.pp_ANM_ALT_CONS_PAN
											MESSAGEBOX("Tecido Finalizado !"+CHR(13)+"Você não tem permissão para excluir este item.",0+16,"Bloqueio Ficha Técnica")
											
											** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
											Local xFiltro
			
											Select v_Produtos_Ficha_01_Cor

											xFiltro = Set("Filter")
											Set Filter To 
											Go top 

											REPLACE All APAGADO WITH 0 For Item = v_Produtos_Ficha_01.Item
											Set Filter To &xFiltro
											Go top 
											Thisformset.lx_Form1.LockScreen = .F.
											Thisformset.l_desenhista_filhas_exclui_apos()
											** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
											
											Return .F.
										Endif
							
										If v_produtos_00.AV_FINALIZADO = 'SIM' AND !CurMaterialTipo.indica_tecido AND !Thisformset.pp_ANM_ALT_CONS_AV
											MESSAGEBOX("Aviamento Finalizado !"+CHR(13)+"Você não tem permissão para excluir este item.",0+16,"Bloqueio Ficha Técnica")
											
											** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
											Local xFiltro
			
											Select v_Produtos_Ficha_01_Cor

											xFiltro = Set("Filter")
											Set Filter To 
											Go top 

											REPLACE All APAGADO WITH 0 For Item = v_Produtos_Ficha_01.Item
											Set Filter To &xFiltro
											Go top 
											Thisformset.lx_Form1.LockScreen = .F.
											Thisformset.l_desenhista_filhas_exclui_apos()
											** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
											
											Return .F.
										Endif
								Else
									MESSAGEBOX("OP de mostruário não emitida!"+CHR(13)+"Você não tem permissão para excluir este item.",0+16,"Bloqueio Ficha Técnica")
											
									** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
									Local xFiltro
	
									Select v_Produtos_Ficha_01_Cor

									xFiltro = Set("Filter")
									Set Filter To 
									Go top 

									REPLACE All APAGADO WITH 0 For Item = v_Produtos_Ficha_01.Item
									Set Filter To &xFiltro
									Go top 
									Thisformset.lx_Form1.LockScreen = .F.
									Thisformset.l_desenhista_filhas_exclui_apos()
									** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
								
									Return .F.
								Endif
							Endif
							*** Bloqueio ficha tecnica**
								
						if	!f_vazio(xalias)	
						  sele &xalias 
					    endif
										
			otherwise
			return .t.				
		endcase
	endproc
	
	* Cria Procedure para chamar métódo no activate da Pag2
	*** Bloqueio ficha tecnica**
	Procedure ANM_USR_ACTIVATE_PAG2 
		
		IF o_040001.p_tool_status = 'A'
		
			IF !f_vazio(v_produtos_ficha_01.material)	
				thisformset.LX_FORM1.pgPrincipal.page1.lx_pageframe1.page2.Lx_pageframe1.page1.Tv_MATERIAL.Enabled = .F. 
			ELSE
				thisformset.LX_FORM1.pgPrincipal.page1.lx_pageframe1.page2.Lx_pageframe1.page1.Tv_MATERIAL.Enabled = .T. 	
			ENDIF	

		ENDIF
		
	Endproc
	*** Bloqueio ficha tecnica**
	
enddefine

**************************************************
*-- Class:        lb_alterado_por(c:\pastas\anm_class\lb_conferido_por.vcx)
*-- ParentClass:  label
*-- BaseClass:    label
*-- Time Stamp:   03/07/14 10:37:02 AM
*
DEFINE CLASS lb_alterado_por AS lx_label


	FontName = "Tahoma"
	FontSize = 8
	BackStyle = 0
	Caption = "Modificado por:"
	Visible = .t.
	Height = 14
	Left = 291
	Top = 30
	Width = 71
	Name = "lb_alterado_por"


ENDDEFINE
*
*-- EndDefine: lb_alterado_por
**************************************************

**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS tx_alterado_por AS lx_textbox_base 


	FontName = "Tahoma"
	FontSize = 8
	Visible = .t.
	Enabled = .F.
	Height = 19
	Left = 370
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 29
	Width = 140
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "tx_alterado_por"


ENDDEFINE
*
*-- EndDefine: tx_alterado_por
**************************************************
**************************************************
*-- Class:        ck_anm_rota_conserto (c:\linx desenv\classes lucas\ck_anm_rota_conserto.vcx)
*-- ParentClass:  lx_checkbox (c:\linx spk novo lucas\linx\exclusivos\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   03/16/16 04:54:11 PM
*
DEFINE CLASS ck_anm_rota_conserto AS lx_checkbox

 
	Top = 120
	Left = 550
	Width = 116
	FontBold = .T.
	Alignment = 0
	Caption = "Rota de Conserto"
	ControlSource = "V_produtos_tab_operacoes_00.ROTA_CONSERTO"
	Name = "CK_ANM_ROTA_CONSERTO"
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: ck_anm_rota_conserto
**************************************************

**************************************************
*-- Class:        btn_anm_finaliza_pan (c:\users\lucas.miranda\desktop\projetos\desenvolvimento\2016\produção\ft\btn_anm_finaliza_pan.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/16/16 10:07:13 AM
*
DEFINE CLASS btn_anm_finaliza_pan AS commandbutton


	Top = 32
	Left = 250
	Height = 20
	Width = 62
	FontSize = 7
	Caption = "F\L Panos"
	BackColor = RGB(171,92,84)
	Visible = .T.
	Name = "btn_anm_finaliza_pan"


	PROCEDURE Click
		If Thisformset.p_tool_status = 'P'

								sele ppRL_ANM_VERIFICA_FIN_FT_PA
								LOCATE FOR REDE_LOJAS = v_produtos_00.rede_lojas
								If FOUND() AND ppRL_ANM_VERIFICA_FIN_FT_PA.valor_atual = 'SIM'
									
									If v_produtos_00.TEC_FINALIZADO = 'NAO'
											
											If Thisformset.pp_anm_bloq_ft_pa
												If Messagebox("Deseja Finalizar a Ficha Técnica do tipo Panos?",4+32,"Bloqueio Ficha Técnica") = 6 
												
													f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_panos=1, data_final_panos=CONVERT(VARCHAR(10),getdate(),112) where produto=?v_produtos_00.produto")
													Messagebox("Finalizada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.BackColor = RGB(0,255,0)
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.ToolTipText = "Liberar FT Panos"
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.Caption = 'Lib. Panos'
													
													f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

													sele v_produtos_00
													replace  DATA_FINALIZA_TEC 		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS= .T.,xFinFichaMost.DATA_FINAL_PANOS,''),'')
													replace	 TEC_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS= .T.,'SIM','NAO'),'')
													replace  QTDE_FINALIZADA_TEC 	With NVL(xFinFichaMost.QTDE_FINALIZADA_PANOS,0)
												
													Thisformset.Refresh()
												Else
													Return .F.
												Endif
											Else		
												MESSAGEBOX("Você não tem permissão para finalizar Tecido na Ficha Técnica !",0+16,"Bloqueio Ficha Técnica")
												Return .F.
											Endif
									
									Else
											If Thisformset.pp_anm_desbloq_ft_pa	
												If Messagebox("Deseja Liberar a Ficha Técnica ?",4+32,"Bloqueio Ficha Técnica") = 6
													f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_panos = 0 where produto = ?v_produtos_00.produto")
													Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")	
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.BackColor = RGB(255,0,0)
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.ToolTipText = "Finalizar FT Panos"	
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.Caption = 'Fin. Panos'	

													f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

													sele v_produtos_00
													replace  DATA_FINALIZA_TEC 		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS= .T.,xFinFichaMost.DATA_FINAL_PANOS,''),'')
													replace	 TEC_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS= .T.,'SIM','NAO'),'')
													replace  QTDE_FINALIZADA_TEC 	With NVL(xFinFichaMost.QTDE_FINALIZADA_PANOS,0)
												
													Thisformset.Refresh()		
												Else
													Return .F.
												Endif
											Else
												MESSAGEBOX("Você não tem permissão para liberar Tecido na Ficha Técnica !",0+16,"Bloqueio Ficha Técnica")
												Return .F.
											Endif
									Endif
							Else
								MESSAGEBOX("Rede Loja não habilitada !!!",0+16,"Bloqueio Ficha Técnica")
								Return .F.
							Endif
		Endif
	ENDPROC


ENDDEFINE
*
*-- EndDefine: btn_anm_finaliza_pan
**************************************************

**************************************************
*-- Class:        btn_anm_finaliza_av(c:\users\lucas.miranda\desktop\projetos\desenvolvimento\2016\produção\ft\btn_anm_finaliza_av.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/16/16 10:07:13 AM
*
DEFINE CLASS btn_anm_finaliza_av AS commandbutton


	Top = 32
	Left = 450
	Height = 20
	Width = 62
	FontSize = 7
	Caption = "F\L Avia."
	BackColor = RGB(171,92,84)
	Visible = .T.
	Name = "btn_anm_finaliza_av"


	PROCEDURE Click
		If Thisformset.p_tool_status = 'P'

						sele ppRL_ANM_VERIFICA_FIN_FT_PA
						LOCATE FOR REDE_LOJAS = v_produtos_00.rede_lojas
						If FOUND() AND ppRL_ANM_VERIFICA_FIN_FT_PA.valor_atual = 'SIM'
									
									If v_produtos_00.AV_FINALIZADO = 'NAO'
											
											If Thisformset.pp_anm_bloq_ft_av	
												If Messagebox("Deseja Finalizar a Ficha Técnica do tipo Aviamentos?",4+32,"Bloqueio Ficha Técnica") = 6
													f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_aviamentos=1, data_final_av=CONVERT(VARCHAR(10),getdate(),112) where produto=?v_produtos_00.produto")
													Messagebox("Finalizada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.BackColor = RGB(0,255,0)
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.ToolTipText = "Liberar FT Aviamentos"
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.Caption = 'Lib. Avia.'
													
													f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

													sele v_produtos_00
													replace  DATA_FINALIZA_AV 		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS= .T.,xFinFichaMost.DATA_FINAL_AV,''),'')
													replace	 AV_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS= .T.,'SIM','NAO'),'')
													replace  QTDE_FINALIZADA_AV 	With NVL(xFinFichaMost.QTDE_FINALIZADA_AVIAMENTOS,0)
												
													Thisformset.Refresh()
												Else
													Return .F.
												Endif
											Else		
												MESSAGEBOX("Você não tem permissão para finalizar Aviam. na Ficha Técnica !",0+16,"Bloqueio Ficha Técnica")
												Return .F.
											Endif
									Else
											If Thisformset.pp_anm_desbloq_ft_av
												If Messagebox("Deseja Liberar a Ficha Técnica ?",4+32,"Bloqueio Ficha Técnica") = 6
													f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_aviamentos = 0 where produto = ?v_produtos_00.produto")
													Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")	
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.BackColor = RGB(255,0,0)
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.ToolTipText = "Finalizar FT Aviamentos"	
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.Caption = 'Fin. Avia.'	
													
													f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

													sele v_produtos_00
													replace  DATA_FINALIZA_AV 		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS= .T.,xFinFichaMost.DATA_FINAL_AV,''),'')
													replace	 AV_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS= .T.,'SIM','NAO'),'')
													replace  QTDE_FINALIZADA_AV 	With NVL(xFinFichaMost.QTDE_FINALIZADA_AVIAMENTOS,0)
													
													Thisformset.Refresh()	
												Else
													Return .F.
												Endif
											Else
												MESSAGEBOX("Você não tem permissão para liberar Aviam. na Ficha Técnica !",0+16,"Bloqueio Ficha Técnica")
												Return .F.
											Endif
									Endif
						Else
							MESSAGEBOX("Rede Loja não habilitada !!!",0+16,"Bloqueio Ficha Técnica")
							Return .F.
						Endif
		Endif
	ENDPROC


ENDDEFINE
*
*-- EndDefine: btn_anm_finaliza_av
**************************************************

**************************************************
*-- Class:        btn_anm_finaliza_most(c:\users\lucas.miranda\desktop\projetos\desenvolvimento\2016\produção\ft\btn_anm_finaliza_most.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/16/16 10:07:13 AM
*
DEFINE CLASS btn_anm_finaliza_most AS commandbutton


	Top = 32
	Left = 50
	Height = 20
	Width = 62
	FontSize = 7
	Caption = "F\L Mostr."
	BackColor = RGB(171,92,84)
	Visible = .T.
	Name = "btn_anm_finaliza_most"

	PROCEDURE Click
		If Thisformset.p_tool_status = 'P'

						sele ppRL_ANM_VERIFICA_FIN_FT_PA
						LOCATE FOR REDE_LOJAS = v_produtos_00.rede_lojas
						If FOUND() AND ppRL_ANM_VERIFICA_FIN_FT_PA.valor_atual = 'SIM'
									
									If v_produtos_00.MOST_FINALIZADO = 'NAO'
										
										If Thisformset.pp_ANM_BLOQ_FT_MOST	
											If Messagebox("Deseja Finalizar o Mostruário ?",4+32,"Bloqueio Ficha Técnica") = 6
													f_update("update anm_tb_bloq_ficha_tecnica_pa set FT_MOST_PRONTO=1, data_final_most=CONVERT(VARCHAR(10),getdate(),112) where produto=?v_produtos_00.produto")
													Messagebox("Finalizada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")
													
													TEXT TO xSelProgSemOP TEXTMERGE NOSHOW
								
														Select count(*) Qtde_prog_s_OP 
														from producao_prog_prod a
															join prop_producao_programa b on a.PROGRAMACAO = b.PROGRAMACAO and b.PROPRIEDADE = '00038'

														WHERE B.VALOR_PROPRIEDADE = 'MOSTRUARIO' and 
															  a.QTDE_SALDO_EMITIR_OP > 0 and a.ANM_MATAR_SALDO = 0 and
															  a.PRODUTO = LTRIM(RTRIM('<<v_produtos_00.produto>>')) 
													ENDTEXT
													f_select(xSelProgSemOP,"Cur_ProgMost_S_OP",ALIAS()) && PRODUTO COM OP DE MOSTRUÁRIO PENDENTE EMISSÃO
													
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.BackColor = Iif(Cur_ProgMost_S_OP.Qtde_prog_s_OP>0,RGB(255,255,0),RGB(0,255,0))
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.ToolTipText = "Liberar Mostruario"
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.Caption = 'Lib. Mostr.'
													
													f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

													sele v_produtos_00
													replace  DATA_FINALIZA_MOST 	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO = .T.,xFinFichaMost.DATA_FINAL_MOST,''),'')
													replace	 MOST_FINALIZADO    	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO = .T.,'SIM','NAO'),'')
													replace  QTDE_FINALIZADA_MOST 	With NVL(xFinFichaMost.QTDE_FINALIZADA_MOST,0)
												
													Thisformset.Refresh()
											Else
												Return .F.
											Endif
										Else		
											MESSAGEBOX("Você não tem permissão para finalizar Most. na Ficha Técnica !",0+16,"Bloqueio Ficha Técnica")
											Return .F.
										Endif
									Else
										If Thisformset.pp_ANM_DESBLOQ_FT_MOST	
											If Messagebox("Deseja Liberar a Ficha Técnica ?",4+32,"Bloqueio Ficha Técnica") = 6
													f_update("update anm_tb_bloq_ficha_tecnica_pa set ft_most_pronto = 0 where produto = ?v_produtos_00.produto")
													Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")	
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.BackColor = RGB(255,0,0)
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.ToolTipText = "Finalizar Mostruário"	
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.Caption = 'Fin. Mostr.'	
													
													f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

													sele v_produtos_00
													replace  DATA_FINALIZA_MOST 	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO = .T.,xFinFichaMost.DATA_FINAL_MOST,''),'')
													replace	 MOST_FINALIZADO    	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO = .T.,'SIM','NAO'),'')
													replace  QTDE_FINALIZADA_MOST 	With NVL(xFinFichaMost.QTDE_FINALIZADA_MOST,0)
												
													Thisformset.Refresh()	
											Else
												Return .F.
											Endif
										Else
											MESSAGEBOX("Você não tem permissão para liberar Most. na Ficha Técnica !",0+16,"Bloqueio Ficha Técnica")
											Return .F.
										Endif
									Endif
							Else
								MESSAGEBOX("Rede Loja não habilitada !!!",0+16,"Bloqueio Ficha Técnica")
								Return .F.
							Endif
		Endif
	ENDPROC


ENDDEFINE
*
*-- EndDefine: btn_anm_finaliza_most
**************************************************

**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_data_final_most AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .T.
	Enabled = .F.
	Height = 19
	Left = 115
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 32
	Width = 65
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_data_final_most"


ENDDEFINE
*
*-- EndDefine: Tx_data_final_most
**************************************************
**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_qtd_final_most AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .T.
	Enabled = .F.
	Height = 19
	Left = 180
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 32
	Width = 23
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_qtd_final_most"


ENDDEFINE
*
*-- EndDefine: Tx_qtd_final_most
**************************************************

**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_data_final_pan AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .T.
	Enabled = .F.
	Height = 19
	Left = 315
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 32
	Width = 65
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_data_final_pan"


ENDDEFINE
*
*-- EndDefine: Tx_data_final_pan
**************************************************
**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_qtd_final_pan AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .T.
	Enabled = .F.
	Height = 19
	Left = 380
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 32
	Width = 23
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_qtd_final_pan"


ENDDEFINE
*
*-- EndDefine: Tx_qtd_final_pan
**************************************************

**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_data_final_av AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .T.
	Enabled = .F.
	Height = 19
	Left = 515
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 32
	Width = 65
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_data_final_av"


ENDDEFINE
*
*-- EndDefine: Tx_data_final_av
**************************************************
**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_qtd_final_av AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .T.
	Enabled = .F.
	Height = 19
	Left = 580
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 32
	Width = 23
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_qtd_final_av"


ENDDEFINE
*
*-- EndDefine: Tx_qtd_final_av
**************************************************