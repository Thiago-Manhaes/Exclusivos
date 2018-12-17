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
					
					*** Bloqueio ficha tecnica - Lucas Miranda - 16/08/2016
						with Thisformset.lx_form1
							.AddObject("btn_anm_finaliza_ft","btn_anm_finaliza_ft")
						endwith
						
						
						Sele v_produtos_00
						xalias_pai=alias()
						oCur = getcursoradapter(xalias_pai)
						oCur.addbufferfield("SPACE(25) AS DATA_FINALIZACAO" , "C(25)",.T., "ANM_DATA_FINALIZACAO", "ANM_DATA_FINALIZACAO")
						oCur.addbufferfield("SPACE(3) AS FINALIZA" , "C(3)",.T., "ANM_FINALIZA", "ANM_FINALIZA")
						oCur.confirmstructurechanges()	
						Thisformset.l_limpa()
					
						with thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1
							.addobject("Tx_data_finalizacao","Tx_data_finalizacao") 
							.Tx_data_finalizacao.controlsource="v_produtos_00.DATA_FINALIZACAO"
							.addobject("Tx_qtd_finalizacao","Tx_qtd_finalizacao") 
							.Lx_optiongroup1.left = 405
						endwith
						
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
											
****** Bloqueio de alocação de recursos - Silvio Luiz - 27042016 ***********************	
				case upper(xmetodo) == 'USR_ALTER_AFTER'
					xalias=alias()
						f_select("select * from ANM_TB_BLOQ_FICHA_TECNICA_PA where produto = ?v_produtos_00.produto","xFinFT1")
						If xFinFT1.finaliza = .T.
							Thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Col_cmb_COR_MATERIAL.Enabled = .f.
							Release xFinFT1
						Else
							Thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Col_cmb_COR_MATERIAL.Enabled = .T.
						Endif
					If !f_vazio(xalias)	
					  sele &xalias 
				    Endif
				
				case upper(xmetodo) == 'USR_WHEN' AND (upper(xnome_obj) == 'TX_C1' OR upper(xnome_obj) == 'TX_1' OR upper(xnome_obj) == 'TX_2' OR upper(xnome_obj) == 'TX_3' OR upper(xnome_obj) == 'TX_4' OR upper(xnome_obj) == 'TX_5' OR upper(xnome_obj) == 'TX_CONSUMO_AUX' OR upper(xnome_obj) == 'TX_PORC_CONSUMO' OR upper(xnome_obj) == 'TX_PORCENTAGEM_CONSUMO')
					xalias=alias()
						f_select("select * from ANM_TB_BLOQ_FICHA_TECNICA_PA where produto = ?v_produtos_00.produto","xFinFT")
						If xFinFT.finaliza = .T.
							f_select("select * from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_MATERIAL_FT_PA') where valor_atual = ?v_produtos_ficha_01.tipo","xGrupoMat")
							sele xGrupoMat
							If F_Vazio(xGrupoMat.valor_atual)
								Messagebox("FT está finalizada, Tipo do Material Bloqueado para alteração de Consumo !!!",0+16,"Bloqueio Ficha Técnica")
								Release xFinFT
								RETURN .f.
							Else
								If thisformset.pp_anm_alterar_consumo_ft = .F.
									Messagebox("Usuário bloqueado para alteração de consumo desse Tipo do Material !!!",0+16,"Bloqueio Ficha Técnica")
									Release xFinFT
									Return .F.
								Endif
							Endif
						Endif
					
					IF !f_vazio(xalias)	
					  sele &xalias 
				    ENDIF
				
				
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
								
							ENDIF

						Endif	
						
							
					**** BLOQUEIO FICHA TECNICA - LUCAS MIRANDA - 16/08/2016	
					thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.Lx_optiongroup1.left = 405
					
						If type('Thisformset.lx_form1.btn_anm_finaliza_ft')<>'U'		
							If Thisformset.P_tool_status == 'P'					
								f_select("select finaliza from anm_tb_bloq_ficha_tecnica_pa Where produto = ?v_produtos_00.produto","curFinalizaFT")
								Sele curFinalizaFT
									If curFinalizaFT.finaliza = .F.
										Thisformset.lx_form1.btn_anm_finaliza_ft.BackColor = RGB(255,0,0)
										Thisformset.lx_form1.btn_anm_finaliza_ft.ToolTipText = "Finalizar FT"
										Thisformset.lx_form1.btn_anm_finaliza_ft.Caption = 'F'
									Else	
										Thisformset.lx_form1.btn_anm_finaliza_ft.BackColor = RGB(0,255,0)
										Thisformset.lx_form1.btn_anm_finaliza_ft.ToolTipText = "Liberar FT"
										Thisformset.lx_form1.btn_anm_finaliza_ft.Caption = 'L'
									Endif									
							Else
								Thisformset.lx_form1.btn_anm_finaliza_ft.BackColor = RGB(171,92,84) 			
								Thisformset.lx_form1.btn_anm_finaliza_ft.Caption   = "F\L"
							Endif		
						Endif
						
						If type('thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.Tx_data_finalizacao')<>'U'
							If Thisformset.P_tool_status == 'P'	
								f_select("select * from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_VERIFICA_FIN_FT_PA')","xRedeLoja")
								sele xRedeLoja
								scan
									If ALLTRIM(v_produtos_00.rede_lojas) = alltrim(xRedeLoja.rede_lojas) 
										If !F_Vazio(xRedeLoja.rede_lojas)
											If xRedeLoja.valor_atual = 'SIM'		
												Text To xSelLogFichaBotao TextMerge Noshow
													SELECT top 1 CONVERT(VARCHAR(10),DATA_FINALIZA_NOVO,103) as data_finaliza_novo 
													FROM ANM_FICHA_TECNICA_LOG_FINALIZACAO(nolock) 
													WHERE PRODUTO = LTRIM(RTRIM('<<v_produtos_00.produto>>'))
													and FINALIZA_NOVO = 1
													order by DATA_HORA_ALTERACAO desc
												Endtext
												f_select(xSelLogFichaBotao,"xLogFichaBotao")
												IF !F_Vazio(xLogFichaBotao.data_finaliza_novo)
													replace v_produtos_00.data_finalizacao with xLogFichaBotao.data_finaliza_novo
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.tx_data_finalizacao.Value = xLogFichaBotao.data_finaliza_novo
												Endif	
							    			Endif
							    		Endif
							    	Endif
						    	endscan
						    Endif
						Endif
					
					If type('thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.Tx_qtd_finalizacao')<>'U'
						If Thisformset.P_tool_status == 'P'	
							f_select("select * from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_VERIFICA_FIN_FT_PA')","xRedeLoja")
							sele xRedeLoja
							scan
				   				If ALLTRIM(v_produtos_00.rede_lojas) = alltrim(xRedeLoja.rede_lojas) 
									If !F_Vazio(xRedeLoja.rede_lojas)
										If xRedeLoja.valor_atual = 'SIM'		
											Text To xSelQtdFin TextMerge Noshow
												select count(*) as QTDE_FINALIZADA 
												from ANM_FICHA_TECNICA_LOG_FINALIZACAO (nolock)
												where PRODUTO = LTRIM(RTRIM('<<v_produtos_00.produto>>'))
												and FINALIZA_NOVO = 1
											Endtext
											f_select(xSelQtdFin,"xQtdFinalizada")
											IF F_Vazio(xQtdFinalizada.qtde_finalizada)
												thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.tx_qtd_finalizacao.Value = 0
											Else	
												thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.tx_qtd_finalizacao.Value = xQtdFinalizada.qtde_finalizada
											Endif	
										Endif
									Endif	
								Endif			
							endscan									
						Endif
				    Endif	
				    
				    if	!f_vazio(xalias)	
					  sele &xalias 
				    ENDIF
					
				case UPPER(xmetodo) == 'USR_SEARCH_AFTER'
					xalias=alias()
					sele v_produtos_00
						go	top
						Scan	
							f_select("select * from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_VERIFICA_FIN_FT_PA')","xRedeLoja")
							sele xRedeLoja
							scan
								If ALLTRIM(v_produtos_00.rede_lojas) = alltrim(xRedeLoja.rede_lojas) 
									If !F_Vazio(xRedeLoja.rede_lojas)
										If xRedeLoja.valor_atual = 'SIM'	
											f_prog_bar("Verificando Data Finalização da Ficha Tecnica...",recno(),reccount())
											Text To xSelFinFicha TextMerge Noshow
												SELECT TOP 1 convert(varchar,(CONVERT(date,DATA_FINALIZACAO,103)),103) as DATA_FINALIZACAO, 
												CASE WHEN FINALIZA = 1 THEN 'SIM' ELSE 'NAO' END AS FINALIZA
												from ANM_TB_BLOQ_FICHA_TECNICA_PA (nolock) 
												where produto =	LTRIM(RTRIM('<<v_produtos_00.produto>>'))
											Endtext
											f_select(xSelFinFicha,"xFinFicha")

											sele v_produtos_00
											replace	 data_finalizacao With NVL(xFinFicha.data_finalizacao,'')
											replace	 finaliza         With NVL(xFinFicha.finaliza,'')
										ENDIF
									ENDIF
								ENDIF
							endscan
						Endscan	
						sele v_produtos_00
						GO top				

					 if	!f_vazio(xalias)	
					  sele &xalias 
				    ENDIF
			*INCLUSÃO E EXCLUSÃO--------------	
				case upper(xmetodo) == 'USR_ITEN_INCLUDE_BEFORE'
				IF thisformset.lx_form1.optBarra.Option1.VALUE = 1
					IF thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.ActivePage=2 OR thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.ActivePage=3
						f_select("select finaliza from anm_tb_bloq_ficha_tecnica_pa Where produto = ?v_produtos_00.produto","curIncFT")
						Sele curIncFT
						If curIncFT.finaliza = .T.
							release curIncFT
							MESSAGEBOX("Ficha Técnica Finalizada!!",0+16,"Bloqueio Ficha Técnica")
							RETURN .F.
						Endif	
					Endif
				ENDIF

				case UPPER(xmetodo) == 'USR_CLEAN_AFTER'
					
					If type('thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.Tx_qtd_finalizacao')<>'U'
						thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.tx_qtd_finalizacao.Value = ''
					Endif
			
			otherwise
			return .t.				
		endcase
	endproc
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
*-- Class:        btn_anm_finaliza_ft (c:\users\lucas.miranda\desktop\projetos\desenvolvimento\2016\produção\ft\btn_anm_finaliza_ft.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/16/16 10:07:13 AM
*
DEFINE CLASS btn_anm_finaliza_ft AS commandbutton


	Top = 33
	Left = 676
	Height = 28
	Width = 26
	Caption = "F\L"
	BackColor = RGB(171,92,84)
	Visible = .T.
	Name = "btn_anm_finaliza_ft"


	PROCEDURE Click
		If Thisformset.p_tool_status = 'P'
			f_select("select * from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_VERIFICA_FIN_FT_PA')","xRedeLoja")
			sele xRedeLoja
			scan
				If ALLTRIM(v_produtos_00.rede_lojas) = alltrim(xRedeLoja.rede_lojas) 
					If !F_Vazio(xRedeLoja.rede_lojas)
						If xRedeLoja.valor_atual = 'SIM'
								f_select("select finaliza from anm_tb_bloq_ficha_tecnica_pa Where produto = ?v_produtos_00.produto","curProdFinaliza")
								Sele curProdFinaliza
								If curProdFinaliza.finaliza = .F.
											If Messagebox("Deseja Finalizar a Ficha Técnica ?",4+32,"Bloqueio Ficha Técnica") = 6
												If Thisformset.pp_anm_bloq_ft_pa = .t.
													f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza=1, data_finalizacao=CONVERT(VARCHAR(10),getdate(),112) where produto=?v_produtos_00.produto")
													Messagebox("Finalizada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")
													thisformset.lx_form1.btn_anm_finaliza_ft.BackColor = RGB(0,255,0)
													thisformset.lx_form1.btn_anm_finaliza_ft.ToolTipText = "Liberar FT"
													thisformset.lx_form1.btn_anm_finaliza_ft.Caption = 'L'
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.Tx_data_finalizacao.Value = DATE()
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.tx_qtd_finalizacao.Value = thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.tx_qtd_finalizacao.Value + 1
												Else		
													MESSAGEBOX("Você não tem permissão para finalizar a Ficha Técnica !",0+16,"Bloqueio Ficha Técnica")
													Return .F.
												Endif
											Else
												Return .F.
											Endif
								Else
										If Messagebox("Deseja Liberar a Ficha Técnica ?",4+32,"Bloqueio Ficha Técnica") = 6
											If Thisformset.pp_anm_desbloq_ft_pa = .t.
												f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza = 0 where produto = ?v_produtos_00.produto")
												Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")	
												thisformset.lx_form1.btn_anm_finaliza_ft.BackColor = RGB(255,0,0)
												thisformset.lx_form1.btn_anm_finaliza_ft.ToolTipText = "Finalizar FT"	
												thisformset.lx_form1.btn_anm_finaliza_ft.Caption = 'F'	
												
												Text To xSelLogFichaBotao TextMerge Noshow
													SELECT top 1 CONVERT(VARCHAR(10),DATA_FINALIZA_NOVO,103) as data_finaliza_novo 
													FROM ANM_FICHA_TECNICA_LOG_FINALIZACAO(nolock) 
													WHERE PRODUTO = LTRIM(RTRIM('<<v_produtos_00.produto>>'))
													and FINALIZA_NOVO = 1
													order by DATA_HORA_ALTERACAO desc
												Endtext
												f_select(xSelLogFichaBotao,"xLogFichaBotao")
												
												replace v_produtos_00.data_finalizacao with xLogFichaBotao.data_finaliza_novo
												thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.tx_data_finalizacao.Value = xLogFichaBotao.data_finaliza_novo
											Else
												MESSAGEBOX("Você não tem permissão para liberar a Ficha Técnica !",0+16,"Bloqueio Ficha Técnica")
												Return .F.
											Endif
											*o_040001.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.Tx_data_finalizacao.Value = ''			
										Else
											Return .F.
										Endif
								Endif
						Else
							MESSAGEBOX("Rede Loja não habilitada !!!",0+16,"Bloqueio Ficha Técnica")
							Return .F.
						Endif
					Endif
				Endif	
			endscan
		Endif
	ENDPROC


ENDDEFINE
*
*-- EndDefine: btn_anm_finaliza_ft
**************************************************
**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_data_finalizacao AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .t.
	Enabled = .F.
	Height = 18
	Left = 315
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 11
	Width = 65
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_data_finalizacao"


ENDDEFINE
*
*-- EndDefine: Tx_data_finalizacao
**************************************************
**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_qtd_finalizacao AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .t.
	Enabled = .F.
	Height = 18
	Left = 379
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 11
	Width = 23
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_qtd_finalizacao"


ENDDEFINE
*
*-- EndDefine: Tx_data_finalizacao
**************************************************
**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_data_finalizacao AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .t.
	Enabled = .F.
	Height = 18
	Left = 315
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 11
	Width = 65
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_data_finalizacao"


ENDDEFINE
*
*-- EndDefine: Tx_data_finalizacao
**************************************************
**************************************************