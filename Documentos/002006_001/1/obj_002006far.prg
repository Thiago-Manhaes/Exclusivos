* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar                                                                                     *
* DATA...........:  01-03-2014                                                                                      *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                               			*
* OBJETIVO.: 					                    																*
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

			do case
				
				case upper(xmetodo) == 'USR_INIT'
				
					xalias=alias()
				
						**** #1# - INICIO ****
						thisformset.lx_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page1.Lx_combobox4.ColumnWidths="600,50"
						**** #1# - FIM ****
						
						**** #2# - INICIO ****
						thisformset.LX_FORM1.LX_PAGEFRAME1.PAge1.PGDADOSPRODUTOS.Page1.TV_REDE_LOJAS.P_Valida_where=;
						thisformset.LX_FORM1.LX_PAGEFRAME1.PAge1.PGDADOSPRODUTOS.Page1.TV_REDE_LOJAS.P_Valida_where+;
						" and rede_lojas < 9 AND rede_lojas IN (SELECT CONVERT(CHAR(6),VALOR_PROPRIEDADE) AS REDE_LOJAS FROM WPROPUSERS WHERE PROPRIEDADE='01000' AND USUARIO=SYSTEM_USER)"
						**** #2# - FIM ****
												
						*** Altera o valor do Label ***
						if type("thisformset.lx_FORM1.lx_PAGEFRAME1.page7.lX_PAGEFRAME1.page1.lx_label14")<>"U"
							
							thisformset.lx_FORM1.lx_pageframe1.page1.pgDadosProdutos.Page4.Lx_label14.Caption="Composição 2"
							thisformset.lx_FORM1.lx_pageframe1.page1.pgDadosProdutos.Page4.Lx_label13.Caption="Composição 3"
						
						endif	
						*** Altera o valor do Label *** FIM ***
						
						**Adiciona Botao Composição - Lucas Miranda 29/07/2015***
						With thisformset.LX_FORM1.LX_PAGEFRAME1.PAGE1.PgDadosProdutos.Page1
							.AddObject("btn_ccomposicao","btn_ccomposicao")
						Endwith
						
						*** Filtra griffe que tenha o valor royalties > 0 ***
						if type("thisformset.lx_FORM1.lx_pageframe1.page1.pgDadosProdutos.Page1.tvGriffe")<>"U"
							
							thisformset.lx_FORM1.lx_pageframe1.page1.pgDadosProdutos.Page1.tvGriffe.p_valida_where="  and ROYALTIES > 0.00001 "
						*** Filtra rede lojas < codigo 9 ***	
							thisformset.lx_FORM1.lx_pageframe1.page1.pgDadosProdutos.page1.Tv_rede_lojas.p_valida_where = ' and rede_lojas < 9'
						
						endif	
						*** Filtra griffe que tenha o valor royalties > 0 *** FIM ***
						
						
						*** Inativa opcoes nao usados na gerar de codigo de barras	*** 		
						WITH thisformset.lx_FORM1.lx_pageframe1.page3.OPT_PADRAO
							.option1.enabled = .F.
							.option2.enabled = .F.
							.option3.enabled = .F.
							.option5.enabled = .F.
							.option6.enabled = .F.
						endwith
						*** Inativa opcoes nao usados na gerar de codigo de barras	*** FIM ***
						
					
						*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_produtos_tamanho_00 
						sele v_produtos_tamanho_00
						xalias_pai=alias()


		  				oCur = getcursoradapter(xalias_pai)
						oCur.addbufferfield("PRODUTOS_TAMANHOS.INATIVO as INATIVO", "L",.F., "INATIVO", "INATIVO")				
						oCur.confirmstructurechanges() 	
						**-Fim Inclusao Campos Novos de Tickets no Cursor Pai 		
						
						with thisformset.lx_form1.lx_PAGEFRAME1.page5
							.addobject("bt_tabPreco","bt_tabPreco")								
						endwith	
						
						**** PERIODO COR ** DANIEL FREITAS ***
						Sele v_produtos_00_cores_mat
						xalias_pai=Alias()

							oCur = Getcursoradapter(xalias_pai)
							oCur.addbufferfield("PRODUTO_CORES.ANM_PERIODO_COR", "C(25)",.T., "ANM_PERIODO_COR", "PRODUTO_CORES.ANM_PERIODO_COR")
							oCur.addbufferfield("PRODUTO_CORES.LIBERAR_GRADE_WEB", "L",.F., "LIBERAR_GRADE_WEB", "PRODUTO_CORES.LIBERAR_GRADE_WEB")
							oCur.confirmstructurechanges()
						**-Fim Inclusao Campos Novos de Produtos no Cursor Pai
					**** PERIODO COR ** DANIEL FREITAS ***
					**** PERIODO COR ** DANIEL FREITAS ***	
					f_select("select PERIODO_PCP from PRODUTOS_PERIODOS_PCP (nolock)","xperiodo_pcp")
					
					WITH ThisFormSet.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.lX_GRID_FILHA1
							lcColumnCount = .ColumnCount
							lcColumnCount = lcColumnCount + 1
							.AddColumn(lcColumnCount )
							.Columns[lcColumnCount].Name = 'col_periodo_cor'
								.col_periodo_cor.Width = 150
								*.col_periodo_cor.BackColor = 15399423
								.col_periodo_cor.ColumnOrder = 7
								.col_periodo_cor.header1.Caption = 'Periodo Cor'
								.col_periodo_cor.header1.Alignment = 2
								.col_periodo_cor.header1.FontSize = 8
								.col_periodo_cor.RemoveObject('text1')
								.col_periodo_cor.AddObject('cmb_periodo_cor','cmb_periodo_cor')
								.col_periodo_cor.Sparse = .F.
								.col_periodo_cor.Refresh()
								.col_periodo_cor.cmb_periodo_cor.RowSource="xperiodo_pcp"
								.col_periodo_cor.ControlSource="v_produtos_00_cores_mat.anm_periodo_cor"
					ENDWITH
					**** PERIODO COR ** DANIEL FREITAS ***
						*** #1 - LUCAS.MIRANDA - 08/04/2016 - INCLUINDO A COLUNA LIBERAR WEB NA ABA CORES 
				WITH ThisFormSet.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.lX_GRID_FILHA1
						.AddColumn(1)
						.Column1.Name='cl_Liberar_Grade'
						WITH .cl_Liberar_Grade
								.BackColor = RGB(251,245,220)
								.Header1.Name='h_Liberar_Grade'
								.h_Liberar_Grade.Caption='Liberar Grade'
								.AddObject('ck_Liberar_Grade_Web','CheckBox')
								.Sparse= .F.
								.CurrentControl = 'ck_Liberar_Grade_Web'
								.ck_Liberar_Grade_Web.Caption=""
								.ColumnOrder = 1
								.CK_LIBERAR_GRADE_WEB.BackStyle = 0
								.ck_Liberar_Grade_web.Visible = .T.
								.ck_Liberar_Grade_web.Enabled = .F.								
								.RemoveObject("text1")
								.ControlSource="V_PRODUTOS_00_CORES_MAT.LIBERAR_GRADE_WEB"
						ENDWITH	
				ENDWITH						
				***FIM - #1 - LUCAS.MIRANDA - 08/04/2016 - INCLUINDO A COLUNA LIBERAR WEB NA ABA CORES 
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
				
						THISFORMSET.L_LIMPA()
				** #1 - LUCAS MIRANDA - 23/03/2016 - CORREÇÃO DO OBJETO PRODUTOS_001 PARA PRODUTOS_999		
				case UPPER(xmetodo) == 'USR_ALTER_BEFORE' AND upper(xnome_obj)== 'PRODUTOS_999'
				thisformset.p_bloqueia_alteracoes=.f.
				** FIM - #1 - LUCAS MIRANDA - 23/03/2016 - CORREÇÃO DO OBJETO PRODUTOS_001 PARA PRODUTOS_999
				
				case upper(xmetodo) == 'USR_SAVE_BEFORE'
				
					xalias=alias()										
					
					*** Não aceitar que o campo rede lojas seja vazio ***********
					IF EMPTY(NVL(Thisformset.LX_FORM1.LX_pageframe1.PAge1.pgDadosProdutos.page1.Tv_rede_lojas.Value,''))
						MESSAGEBOX("Obrigatório o preenchimento do Campo Rede Lojas !!!",0+64)
						Thisformset.LX_FORM1.LX_pageframe1.PAge1.pgDadosProdutos.page1.Tv_rede_lojas.SetFocus()
						RETURN .F.
					ENDIF	
					*** Não aceitar que o campo rede lojas seja vazio *** FIM ***
					****** PERIODO_COR ** DANIEL FREITAS
					IF THISFORMSET.PP_anm_bloq_periodo_cor = .T.
						SELE V_PRODUTOS_00_CORES_MAT
						GO TOP
							SCAN
								IF F_VAZIO(V_PRODUTOS_00_CORES_MAT.anm_periodo_cor) AND V_PRODUTOS_00.STATUS_PRODUTO = '04'
									MESSAGEBOX("FAVOR INFORMAR UM PERÍODO COR PARA A COR: "+V_PRODUTOS_00_CORES_MAT.cor_produto,0+16)
									RETURN .F.
								ENDIF	
							SELE V_PRODUTOS_00_CORES_MAT
							ENDSCAN
						SELE V_PRODUTOS_00_CORES_MAT
					ENDIF
					****** PERIODO_COR ** DANIEL FREITAS
					if	!f_vazio(xalias)	
						sele &xalias 
					endif

				case UPPER(xmetodo) == 'USR_SAVE_AFTER' 
							
				
					xalias=alias()
						
						f_select("select produto from produtos where produto=?v_produtos_00.produto","xProduto")
						xCodProduto=xProduto.produto
						f_update("EXEC SOMA.DBO.LX_ANM_GERA_CUSTO_OP_TRANSFORMACAO ?xCodProduto")
						
				
					if !f_vazio(xalias)
						sele &xalias
					endif					
					
					case UPPER(xmetodo) == 'USR_WHEN' AND (THISFORMSET.P_tool_status == 'I' OR THISFORMSET.P_tool_status == 'A')
						
						xalias=alias()
						
							IF upper(xnome_obj)== 'CMB_PROPRIEDADE'
								
									IF 	ALLTRIM(THISFORMSET.LX_FORM1.LX_pageframe1.PAGE_PROPS.Grid_produtos.COL_tx_valor_propriedade.CMB_propriedade.Value) = 'PRODUÇAO'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL.value = '113301'&&'1.1.3.01.08'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_COMPRA.value = '353104'&&'3.2.1.08.01'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_DEV_COMPRA.value = '353105'&&'3.2.1.08.02'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_VENDA.value = '311101'&&'3.1.1.01.01'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_DEV_VENDA.value = '321101'&&'3.1.2.02.01'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tx_indicador_CFOP.value = '10'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.cmb_tipo_item_sped.value = '04'
									ELSE
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL.value = '113302'&&'1.1.3.01.06'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_COMPRA.value = '352102'&&'3.2.1.06.01'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_DEV_COMPRA.value = '352103'&&'3.2.1.06.02'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_VENDA.value = '311101'&&'3.1.1.01.03'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_DEV_VENDA.value = '321101'&&'3.1.2.02.02'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tx_indicador_CFOP.value = '11'
										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.cmb_tipo_item_sped.value = '00'
									ENDIF					
							ENDIF		
						if !f_vazio(xalias)
							sele &xalias
						endif					
*!*					case upper(xmetodo) == 'USR_WHEN'
*!*					
*!*						xalias=alias()
*!*						
*!*							If upper(xnome_obj) = 'TVTIPOPRODUTO'
*!*							
*!*								IF THISFORMSET.P_tool_status <> 'L'		
*!*						
*!*									*** Preencher conta contabil automaticamente no cadastro ***
*!*									SELE V_PRODUTOS_00
*!*									IF 	'FACCAO' $ ALLTRIM(V_PRODUTOS_00.TIPO_PRODUTO) OR 'BENEFICIADO' $ ALLTRIM(V_PRODUTOS_00.TIPO_PRODUTO)

*!*										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL.value = '113301'
*!*										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_COMPRA.value = '353104'
*!*										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_DEV_COMPRA.value = '353105'
*!*										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_VENDA.value = '311101'
*!*										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_DEV_VENDA.value = '321101'
*!*										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tx_indicador_CFOP.value = '10'
*!*		                                THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.cmb_tipo_item_sped.value = '04'
*!*									ELSE
*!*										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL.value = '113302'
*!*										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_COMPRA.value = '352102'
*!*										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_DEV_COMPRA.value = '352103'
*!*										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_VENDA.value = '311101'
*!*										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tv_CONTA_CONTABIL_DEV_VENDA.value = '321101'
*!*										THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.tx_indicador_CFOP.value = '11'
*!*		                                THISFORMSET.lx_FORM1.lx_pageframe1.Page1.PgDadosProdutos.page4.cmb_tipo_item_sped.value = '00'
*!*									ENDIF					
*!*									*** Preencher conta contabil automaticamente no cadastro *** FIM ***
*!*								ENDIF
*!*							
*!*							Endif
*!*												
*!*						
*!*						if	!f_vazio(xalias)	
*!*							sele &xalias 
*!*						endif
*!*						
					
					case upper(xmetodo) == 'USR_REFRESH'
				
					xalias=alias()
						
						If TYPE('thisformset.lx_form1.lx_PAGEFRAME1.page5.bt_tabPreco')<>'U'
							If ThisFormset.p_tool_status $ "AI"
								Thisformset.lx_FORM1.lx_PAGEFRAME1.page5.bt_tabPreco.caption = "Gerar Tabelas de Preço"
								Thisformset.lx_FORM1.lx_PAGEFRAME1.page5.bt_tabPreco.enabled = .t.	
							ELSE
								Thisformset.lx_FORM1.lx_PAGEFRAME1.page5.bt_tabPreco.caption = "Calcula Custo CT e CA"
								If ThisFormset.p_tool_status = "L"
									Thisformset.lx_FORM1.lx_PAGEFRAME1.page5.bt_tabPreco.enabled = .f.
								ELSE
									Thisformset.lx_FORM1.lx_PAGEFRAME1.page5.bt_tabPreco.enabled = .t.			
								ENDIF
							Endif
						Endif
					
					*** #1 - LUCAS.MIRANDA - 08/04/2016 - INCLUINDO A COLUNA LIBERAR WEB NA ABA CORES  
						If TYPE('thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.lX_GRID_FILHA1.CL_LIBERAR_GRADE.ck_liberar_grade_web')<>'U'
							If THISFORMSET.P_tool_status == 'A'
								thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.lX_GRID_FILHA1.CL_LIBERAR_GRADE.ck_liberar_grade_web.Enabled=.t.
							Else	
								thisformset.lX_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page2.lX_GRID_FILHA1.CL_LIBERAR_GRADE.ck_liberar_grade_web.Enabled=.F.
							Endif	
						Endif
						***FIM - #1 - LUCAS.MIRANDA - 08/04/2016 - INCLUINDO A COLUNA LIBERAR WEB NA ABA CORES 	
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
					
					
					case upper(xmetodo) == 'USR_ITEN_DELETE_BEFORE'
				
					xalias=alias()
					** #1 - LUCAS MIRANDA - 23/03/2016 - CORREÇÃO DO OBJETO PRODUTOS_001 PARA PRODUTOS_999	
						If upper(xnome_obj) = 'PRODUTOS_999'
								IF thisformset.p_tool_status = 'A' AND thisformset.lx_FORM1.lx_PAGEFRAME1.ActivePage = 5
									
									SELECT V_PRODUTOS_00_PRECOS
									f_select("EXEC LX_ANM_BLOQUEIA_PRECO_PRODUTO ?V_PRODUTOS_00_PRECOS.PRODUTO,?V_PRODUTOS_00_PRECOS.CODIGO_TAB_PRECO","CurBloqProd")
										
										f_select("Select preco1 from produtos_precos where produto = ?V_PRODUTOS_00_PRECOS.PRODUTO and codigo_tab_preco =?V_PRODUTOS_00_PRECOS.CODIGO_TAB_PRECO","xTestPreco",ALIAS())
										IF CurBloqProd.permite = .T.
											MESSAGEBOX(NVL(CurBloqProd.MSG_RETORNO,"Tabela de preço sem permissão para alteração!"),64)
											RETURN .F.
										ENDIF									

								ENDIF
						Endif
					** FIM - #1 - LUCAS MIRANDA - 23/03/2016 - CORREÇÃO DO OBJETO PRODUTOS_001 PARA PRODUTOS_999
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
					
					case UPPER(xmetodo) == 'USR_INCLUDE_AFTER' 

					xalias=alias()
					** #1 - LUCAS MIRANDA - 23/03/2016 - CORREÇÃO DO OBJETO PRODUTOS_001 PARA PRODUTOS_999
					IF upper(xnome_obj)== 'PRODUTOS_999' 
				
						sele v_produtos_00
						repla envia_loja_varejo with .t.
						
					ENDIF
					** FIM #1 - LUCAS MIRANDA - 23/03/2016 - CORREÇÃO DO OBJETO PRODUTOS_001 PARA PRODUTOS_999
					if	!f_vazio(xalias)	
						sele &xalias 
					endif

					case upper(xmetodo) == 'USR_VALID'
				
					xalias=alias()
					
						If upper(xnome_obj) = 'TX_PRECO1'
						
								IF thisformset.p_tool_status = 'A'
									
									SELECT V_PRODUTOS_00_PRECOS
									f_select("EXEC LX_ANM_BLOQUEIA_PRECO_PRODUTO ?V_PRODUTOS_00_PRECOS.PRODUTO,?V_PRODUTOS_00_PRECOS.CODIGO_TAB_PRECO","CurBloqProd")
										
										f_select("Select preco1 from produtos_precos where produto = ?V_PRODUTOS_00_PRECOS.PRODUTO and codigo_tab_preco =?V_PRODUTOS_00_PRECOS.CODIGO_TAB_PRECO","xTestPreco")
										IF CurBloqProd.permite = .T. AND xTestPreco.preco1 <> V_PRODUTOS_00_PRECOS.PRECO1 AND xTestPreco.preco1 > 0
											MESSAGEBOX(NVL(CurBloqProd.MSG_RETORNO,"Tabela de preço sem permissão para alteração!"),64)
											SELECT V_PRODUTOS_00_PRECOS
											REPLACE PRECO1 WITH xTestPreco.preco1
											RETURN .F.
										ENDIF									

								ENDIF											
						
								xSelCurTabBase = "SELECT COUNT(*) AS Clica FROM PROP_TABELAS_PRECO "+;
								                 "WHERE PROPRIEDADE = '00185' "+;
								                 "AND VALOR_PROPRIEDADE = '"+V_PRODUTOS_00_PRECOS.CODIGO_TAB_PRECO+"'"
								f_select(xSelCurTabBase,"BotaoGeraTab")
								
								IF BotaoGeraTab.Clica > 0
									IF MESSAGEBOX("Deseja atualizar as tabelas de preço?",32+4)=6
										Thisformset.lx_FORM1.lx_PAGEFRAME1.page5.bt_tabPreco.Click()
									ENDIF
								ENDIF
							
						Endif
					
					
						If upper(xnome_obj) = 'TX_DESC_PRODUTO'
						
							if	len(allt(v_produtos_00.desc_produto))>33
								messagebox("Este Campo aceita somente 33 caracteres !"+chr(13)+"Você registrou "+allt(str(len(allt(v_produtos_00.desc_produto))))+" caracteres ",48,"Atenção!!!" )
								retu .f.
							endif
						
						Endif
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
					
									
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE


**************************************************
*-- Class:        botao_gera_tabela_produto (c:\pastas\work\classes_julio\botao_gera_tabela_produto.vcx)
*-- ParentClass:  botao (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   03/16/15 08:32:04 PM
*
DEFINE CLASS bt_tabPreco AS botao


	Top = 5
	Left = 495
	Height = 24
	Width = 156
	FontBold = .T.
	WordWrap = .T.
	Caption = "Gerar Tabelas de Preço"
	Enabled = .T.
	Visible = .T.
	TabIndex = 11
	Name = "bt_tabPreco"


	PROCEDURE Click
		IF wnivel_acesso > thisformset.pp_permite_alt_tb_preco_prod
			MESSAGEBOX("Usuário sem permissão de Alterar\Gerar Tabela de Preço.",64)
			RETURN .f.
		ENDIF

		IF This.Caption = "Gerar Tabelas de Preço"

		f_prog_bar("Executando comando, aguarde ...")

		f_select("select RTRIM(LTRIM(valores)) as ValorParam from dbo.FXANM_ConsultaVarString (?o_002006.pp_anm_tabelas_preco_produto)","pp_anm_tabelas_preco_produto")
		SELECT pp_anm_tabelas_preco_produto
		GO top
		SCAN

		xSelCurTabBase = "SELECT RTRIM(LTRIM(VALOR_PROPRIEDADE)) AS TABELA_PRECO FROM PROP_TABELAS_PRECO "+;
		                 "WHERE PROPRIEDADE = '00185' "+;
		                 "AND CODIGO_TAB_PRECO = '"+pp_anm_tabelas_preco_produto.ValorParam+"'"
		f_select(xSelCurTabBase,"CurTabBase")

		xSelCurPercBase = "SELECT RIGHT(RTRIM(LTRIM(VALOR_PROPRIEDADE)),LEN(RTRIM(LTRIM(VALOR_PROPRIEDADE)))-2) AS PERC_PRECO "+; 
						  "FROM PROP_TABELAS_PRECO "+;
		                  "WHERE PROPRIEDADE = '00186' "+;
		                  "AND CODIGO_TAB_PRECO = '"+ALLTRIM(pp_anm_tabelas_preco_produto.ValorParam)+"'"+;
		                  " AND LEFT(RTRIM(LTRIM(VALOR_PROPRIEDADE)),1)= "+ALLTRIM(V_PRODUTOS_00.REDE_LOJAS)
		f_select(xSelCurPercBase,"CurPercBase")
		

*!*				xSelCurPercBase =	"	SELECT  ISNULL(SUBSTRING(valores,CHARINDEX('.',valores,1)+1,LEN(valores)),valores_X) AS VALOR_ATUAL 	"+;
*!*									"	FROM FXANM_ConsultaVarString(														"+;
*!*									"		( SELECT RTRIM(LTRIM(VALOR_PROPRIEDADE)) AS PERC_PRECO 							"+;
*!*									"		  FROM PROP_TABELAS_PRECO														"+;
*!*									"		  WHERE PROPRIEDADE = '00186' AND CODIGO_TAB_PRECO = '"+pp_anm_tabelas_preco_produto.ValorParam+"'"+;
*!*									"		  AND LEFT(RTRIM(LTRIM(VALOR_PROPRIEDADE)),1) = "+V_PRODUTOS_00.REDE_LOJAS		 +;
*!*									"		)																				"+;
*!*									"	)	A RIGHT JOIN (SELECT 0 AS valores_X ) B ON 1=1									"
*!*				f_select(xSelCurPercBase,"CurPercBase")
			
		SELECT V_PRODUTOS_00_PRECOS
		LOCATE FOR ALLTRIM(CODIGO_TAB_PRECO) == ALLTRIM(CurTabBase.tabela_preco) 
		IF FOUND()
			xPrecoVO = V_PRODUTOS_00_PRECOS.preco1*VAL(CurPercBase.PERC_PRECO)
		ELSE	
			xPrecoVO = 0
		ENDIF

		LOCATE FOR ALLTRIM(CODIGO_TAB_PRECO) == ALLTRIM(pp_anm_tabelas_preco_produto.ValorParam)
		IF ! FOUND() 
			O_TOOLBAR.Botao_filhas_inserir.Click()
			o_002006.lx_FORM1.lx_pageframe1.page5.lx_GRID_FILHA1.column5.Tv_precos.Value= pp_anm_tabelas_preco_produto.ValorParam
			f_select("Select tabela from tabelas_preco where codigo_tab_preco = ?pp_anm_tabelas_preco_produto.ValorParam","CurTabPreco",alias())
			REPLACE TABELA WITH CurTabPreco.tabela 
		ENDIF

		REPLACE PRECO1 WITH xPrecoVO ;
		FOR PRECO1 = 0 AND ALLTRIM(CODIGO_TAB_PRECO) == ALLTRIM(pp_anm_tabelas_preco_produto.ValorParam)
		o_002006.lx_FORM1.lx_pageframe1.page5.lx_GRID_FILHA1.Refresh()

		SELECT pp_anm_tabelas_preco_produto
		ENDSCAN

		f_prog_bar()
		ENDIF


		IF this.Caption = "Calcula Custo CT e CA"

			f_prog_bar("Executando comando, aguarde ...")

			xseltran=[ SELECT B.MODULO, A.CONTROL_SISTEMA,B.NAVEGACAO ]+;
				 [ FROM TRANSACOES AS A ]+;
				 [ JOIN TRANSACOES_NAVEGA AS B ON (A.COD_TRANSACAO=B.COD_TRANSACAO) ]+;
				 [ WHERE A.CONTROL_SISTEMA LIKE '040004%' ]+;
				 [ ORDER BY B.MODULO, A.CONTROL_SISTEMA,B.NAVEGACAO ]

			IF !f_select(xseltran,[cur_transacao])
				RETURN 
			ENDIF 


			IF RECCOUNT('cur_transacao') = 0
			  f_msg(['A transação lx040004%, ou alguma de suas derivações exclusivas, não está cadastrada. Verifique!!! ',64,'Informação'])
			  return
			ENDIF 


			IF !f_doform(cur_transacao.MODULO, cur_transacao.CONTROL_SISTEMA, cur_transacao.NAVEGACAO)
			   RETURN .f.
			ENDIF 


			o_040004.lx_form1.Show() &&Ativa a tela
			o_040004.lx_form1.windowstate = 0 &&Normal
			o_toolbar.Botao_limpa.Click()
			o_040004.lx_FORM1.tv_Produto.Value = o_002006.lx_FORM1.tv_Produto.Value
			o_toolbar.botao_procura.Click()
			f_prog_bar()
			o_040004.lx_FORM1.Calcula_custo.Click()
			Thisformset.DataEnvironment.cuRSORV_PRODUTOS_00_PRECOS.CursorFill()

		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: botao_gera_tabela_produto
**************************************************
**************************************************
*-- Class:        btn_ccomposicao(c:\linx desenv\classes lucas\btn_ccomposicao.vcx)
*-- ParentClass:  botao (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/06/14 05:29:10 PM
*
Define Class btn_ccomposicao As botao


	Top = 60
	Left = 435
	Height = 15
	Width = 63
	FontBold = .F. 
	FontName = 'TAHOMA'
	Caption = "Composição"
	ForeColor = Rgb(0,0,0)
	Name = "btn_ccomposicao"
	Visible = .T.


	Procedure Click
		sele v_produtos_00
		
		F_SELECT("SELECT DESC_COMPOSICAO FROM MATERIAIS_COMPOSICAO (nolock) WHERE COMPOSICAO = ?v_produtos_00.composicao","xComposicao")
		_cliptext=ALLTRIM(NVL(xComposicao.Desc_Composicao,''))

Enddefine
*
*-- EndDefine: btn_ccomposicao 
**************************************************
**** PERIODO COR ** DANIEL FREITAS ***
**************************************************
*-- Class:        cmb_status_entrada (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_periodo_cor AS lx_combobox


	RowSource = ""
	ControlSource = ""
	Height = 22
	Left = 625
	TabIndex = 1
	Top = 45
	Width = 147
	ZOrderSet = 5
	Name = "cmb_periodo_cor"
	Visible = .t.
	Enabled = .t.
	Anchor = 0

*	PROCEDURE Valid	
	
*	ENDPROC 

ENDDEFINE
**** PERIODO COR ** DANIEL FREITAS ***
**** #1 - LUCAS.MIRANDA - 08/04/2016 - INCLUINDO A COLUNA LIBERAR WEB NA ABA CORES 
DEFINE CLASS ck_liberar_grade_web AS lx_checkbox


	Top = 10
	Left = 18
	Height = 15
	Width = 88
	AutoSize = .T.
	Alignment = 0
	Caption = "Liberar Grade"
	ControlSource = ""
	Name = "ck_Liberar_Grade_web"


ENDDEFINE
*
*-- EndDefine: ck_liberar_grade_web
*** #1 - LUCAS.MIRANDA - 08/04/2016 - INCLUINDO A COLUNA LIBERAR WEB NA ABA CORES 
**************************************************
