* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                        *
* OBJETIVO.: Bloquear botoes de busca ultimo preco compra e alteracao de custo de produto com entrada no estoque                                                                                                     *
* OBJETIVO.: Bloquear Alteracoes apos fases de producao
* OBJETIVO.: Recalculo de Custos
* OBJETIVO.: Recalculo de preco atacado automatico
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
				case UPPER(xmetodo) == 'USR_INIT'
				
				PUBLIC xpreco, xGrupo, xSubGrupo, xCategoria, xDescCategoria, xSubcategoria, xDescSubCategoria,xTipo, xColecao, xDescColecao, ;
	  				   	   xGriffe, xLinha, xDescFiscal, xProdSolucao, xDescProdSolucao, xProdSegmento, xDescProdSegmento, xFabricante, ;
	  				       xStatusProd, xDescStatusProd, xTipoStatusProd, xPeriodoPCP, xComposicao, xDescComposicao, xRestricao, xDescRestricao, xGrade, xSexo, ;
	  				       xPeso, xRedeLojas
				
						
				*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_estoque_sai_mat_00   
				sele v_produtos_00  
				xalias_pai=alias()
				** lucas
*!*	  				oCur = getcursoradapter(xalias_pai)
*!*					oCur.addbufferfield("PRODUTOS.ANM_MARCA", "C(25)",.T., "ANM_MARCA", "PRODUTOS.ANM_MARCA")
*!*					*oCur.addbufferfield("PROP_PRODUTOS.VALOR_PROPRIEDADE", "C(25)",.T., "ANM_PROPRIEDADE", "PROP_PRODUTOS.VALOR_PROPRIEDADE")
*!*					oCur.confirmstructurechanges() 	
				** fim
				**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 
				*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_programa_00
			**** PERIODO COR ** DANIEL FREITAS ***
				Sele v_produtos_00_cores_mat
				xalias_pai=Alias()
 
					oCur = Getcursoradapter(xalias_pai)
					oCur.addbufferfield("PRODUTO_CORES.ANM_PERIODO_COR", "C(25)",.T., "ANM_PERIODO_COR", "PRODUTO_CORES.ANM_PERIODO_COR")
					oCur.addbufferfield("PRODUTO_CORES.LIBERAR_GRADE_WEB", "L",.F., "LIBERAR_GRADE_WEB", "PRODUTO_CORES.LIBERAR_GRADE_WEB")
					oCur.confirmstructurechanges()
				**-Fim Inclusao Campos Novos de Produtos no Cursor Pai
			**** PERIODO COR ** DANIEL FREITAS ***	
				Thisformset.L_limpa()
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
				
				** lucas
					**	thisformset.lx_FORM1.LX_PAGEFRAME1.page1.PgDadosProdutos.page1.addobject("Anm_ComboMarca","Anm_ComboMarca")
					**	thisformset.lx_FORM1.LX_PAGEFRAME1.page1.PgDadosProdutos.page1.Lx_label17.Caption = 'Marca'
						thisformset.lx_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page1.Lx_combobox4.ColumnWidths="600,50"
				** fim
				
				**Adiciona Botao Composição - Lucas Miranda 29/07/2015***
				With thisformset.LX_FORM1.LX_PAGEFRAME1.PAGE1.PgDadosProdutos.Page1
					.AddObject("btn_ccomposicao","btn_ccomposicao")
				Endwith
				
				with thisformset.lx_form1.lx_PAGEFRAME1.page5
					.addobject("bt_tabPreco","bt_tabPreco")								
				endwith	
				
				case UPPER(xmetodo)=='USR_REFRESH' 
				
				
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
								
						IF THISFORMSET.P_tool_status == 'I' AND f_vazio(xGrupo) AND thisformset.pp_anm_preenche_aut_pa = .t.
							thisformset.lx_FORM1.lx_PAGEFRAME1.page_PROPS.l_desenhista_recalculo()
							update a set a.valor_propriedade = NULL from Curpropprodutos a WHERE propriedade <> '00106'
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
				
				
				
				
				case UPPER(xmetodo) == 'USR_INCLUDE_AFTER' 
				
				
						THISFORMSET.lx_form1.lx_PAGEFRAME1.page1.PgDadosProdutos.page4.Tv_CLASSIF_FISCAL.Value=THISFORMSET.pp_cl_fiscal_produto
						THISFORMSET.lx_form1.lx_PAGEFRAME1.page1.PgDadosProdutos.page4.tx_desc_classif_fiscal.Refresh()
						
												
						THISFORMSET.lx_form1.lx_PAGEFRAME1.page1.PgDadosProdutos.page1.lx_combobox4.value = THISFORMSET.pp_composicao_padrao
						THISFORMSET.lx_form1.lx_PAGEFRAME1.page1.PgDadosProdutos.page1.lx_combobox4.refresh()
						
					IF upper(xnome_obj)== 'PRODUTOS_001' 
				
						sele v_produtos_00
						repla envia_loja_varejo with .t.
						
					ENDIF
					
					IF thisformset.pp_anm_preenche_aut_pa = .t.
						if !f_vazio(xGrupo)  
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tvgrupoProduto.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tvgrupoProduto.Value = xGrupo


							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tvsubGrupoProduto.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tvsubGrupoProduto.Value = xSubGrupo

							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.cmb_Categoria_produto.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.cmb_Categoria_produto.Value = xDescCategoria
							replace v_produtos_00.cod_categoria with xCategoria

							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.cmb_SubCategoria_produto.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.cmb_SubCategoria_produto.Value = xDescSubcategoria
							replace v_produtos_00.cod_subcategoria with xSubcategoria


							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tvTipoProduto.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tvTipoProduto.Value = xTipo

							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tv_Colecao.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tv_Colecao.Value = xDescColecao
							replace v_produtos_00.colecao with xColecao
							replace v_produtos_00.desc_colecao WITH xDescColecao

							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.TvGriffe.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.TvGriffe.Value = xGriffe

							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tvLinha.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tvLinha.Value = xLinha

							*thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tx_dESC_PROD_NF.Value = ''
							*thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tx_dESC_PROD_NF.Value = xDescFiscal

							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tv_cod_PRODUTO_SOLUCAO.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tx_DESC_PRODUTO_SOLUCAO.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tv_cod_PRODUTO_SOLUCAO.Value = xProdSolucao
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tx_DESC_PRODUTO_SOLUCAO.Value = xDescProdSolucao
							replace v_produtos_00.cod_produto_solucao with xProdSolucao
							replace v_produtos_00.desc_produto_solucao with xDescProdSolucao

							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tv_coD_PRODUTO_SEGMENTO.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tx_desc_PRODUTO_SEGMENTO.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tv_coD_PRODUTO_SEGMENTO.Value = xProdSegmento
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tx_deSC_PRODUTO_SEGMENTO.Value = xDescProdSegmento
							replace v_produtos_00.cod_produto_segmento with xProdSegmento
							replace v_produtos_00.desc_produto_segmento with xDescProdSegmento

							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tv_FaBRICANTE.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tv_FaBRICANTE.Value = xFabricante

							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.cmb_STATUS_PRODUTO.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.cmb_STATUS_PRODUTO.Value = xDescStatusProd
							replace v_produtos_00.status_produto with xStatusProd

							replace v_produtos_00.tipo_status_produto with xTipoStatusProd

							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tvperiodoPCP.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tvperiodoPCP.Value = xPeriodoPCP
							replace v_produtos_00.periodo_pcp with xPeriodoPCP

							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.lx_combobox4.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.lx_combobox4.Value = xDescComposicao
							replace v_produtos_00.composicao with xComposicao

							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.lx_combobox3.Value = ''
							thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.lx_combobox3.Value = xDescRestricao
							replace v_produtos_00.restricao_lavagem with xRestricao

							replace v_produtos_00.grade with xGrade
							
							replace v_produtos_00.sexo_tipo with xSexo
							
							replace v_produtos_00.peso with xPeso
							
							replace v_produtos_00.rede_lojas with xRedeLojas
							thisformset.Refresh()

							thisformset.lx_FORM1.lx_PAGEFRAME1.page_PROPS.l_desenhista_recalculo()
							update a set a.valor_propriedade = b.valor_propriedade from Curpropprodutos a join xCopProp b on A.Propriedade = B.Propriedade			 
						ENDIF
					ENDIF
				
				case UPPER(xmetodo) == 'USR_WHEN' AND (THISFORMSET.P_tool_status == 'I' OR THISFORMSET.P_tool_status == 'A')
				
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

				case UPPER(xmetodo) == 'USR_INIT' AND upper(xnome_obj)== 'PRODUTOS_001' 

				public curOsBloqueio 
				f_select("select * from fx_producao_ordem_hist_os('1')","curOsBloqueio",alias())
				
				public	xalt_cartela
				xalt_cartela=.f.
				thisformset.lx_FORM1.LX_PAGEFRAME1.page1.PgDadosProdutos.page1.tx_CARTELA.InputMask=[9999]
				thisformset.lx_FORM1.lx_pageframe1.page2.botao1.ENABLED=.F.
				thisformset.lx_FORM1.lx_pageframe1.page2.botao1.VISIBLE=.F.


*!*					WITH thisform.lx_PAGEFRAME1.page1	
*!*						*.addobject("calcula_custo","calcula_custo")
*!*					ENDWITH 
				


				case UPPER(xmetodo) == 'USR_SEARCH_AFTER' AND upper(xnome_obj)== 'PRODUTOS_001' 
				thisformset.lx_FORM1.lx_pageframe1.page2.botao1.ENABLED=.F.
				thisformset.lx_FORM1.lx_pageframe1.page2.botao1.VISIBLE=.F.


				case UPPER(xmetodo) == 'USR_ALTER_AFTER' AND upper(xnome_obj)== 'PRODUTOS_001' 
				thisformset.lx_FORM1.lx_pageframe1.page2.botao1.ENABLED=.F.
				thisformset.lx_FORM1.lx_pageframe1.page2.botao1.VISIBLE=.F.
				
				case UPPER(xmetodo) == 'USR_ALTER_BEFORE' AND upper(xnome_obj)== 'PRODUTOS_001'
				thisformset.p_bloqueia_alteracoes=.f.
				
				case UPPER(xmetodo) == 'USR_VALID' 
					

					*Procedimento para zerar o icms a abater do fornecedor 				
					if	upper(xnome_obj)== 'TV_FABRICANTE' 
						sele v_produtos_00	
						repla fabricante_icms_abater with 0	
						
					endif
					******************************************************									


					*Procedimento para selecionar classif_fiscal de acordo com o grupo do produto
					if	upper(xnome_obj)== 'CMB_GRUPO_PRODUTO' 
						
						if	v_produtos_00.grupo_produto='JÓIAS'
							sele v_produtos_00
							repla classif_fiscal with '71141900'
						endif

*!*							if	v_produtos_00.grupo_produto='SAPATOS'
*!*								sele v_produtos_00
*!*								repla classif_fiscal with '64035190'
*!*							endif

							 
					endif	
					******************************************************		
					
					
					if	upper(xnome_obj)== 'TX_PRECO1' AND upper(v_produtos_00_precos.codigo_tab_preco)='CT'
*!*	--select count(programacao) as teste from producao_prog_prod 
*!*									--where produto = ?v_produtos_00.produto
*!*									--and (qtde_saldo_emitir_op > 0 or qtde_em_op > 0 ) 
							text to xsel noshow	
								select count(a.programacao) as teste from producao_prog_prod a
								join producao_ordem  b
								on a.PRODUTO = b.produto
								and a.programacao = b.programacao
								and b.STATUS ='E'
								join producao_ordem_cor c
								on a.produto = c.produto
								and a.cor_produto = c.cor_produto
								and b.ordem_producao = c.ORDEM_PRODUCAO
								join PROP_PRODUCAO_PROGRAMA d
								on a.PROGRAMACAO = d.PROGRAMACAO
								and d.PROPRIEDADE = '00038' 
								where a.produto = ?v_produtos_00.produto
								and (qtde_saldo_emitir_op > 0 or qtde_em_op > 0 ) 
								and d.VALOR_PROPRIEDADE in ('ATACADO', 'VAREJO') 
							endtext	
							
							f_select(xsel,'curCompras')	 
							
							Sele curCompras	
							if curCompras.teste > 0 
								*coloquei > 0, se encontrar op encerrada não deixar alterar o preço
								sele v_produtos_00_precos	
								
								f_Msg(['Não é possível Alterar esta informação !'+chr(13)+'Produto com Produção Encerrada !!!', 0 + 48, 'Atenção'])
								f_select("select preco1 from produtos_precos where codigo_tab_preco=?v_produtos_00_precos.codigo_tab_preco and produto=?v_produtos_00_precos.produto","cur_preco",alias()) 
								replace	preco1 with cur_preco.preco1	
								thisform.lx_FORM1.lx_pageframe1.page5.lX_GRID_FILHA1.COL_TX_PRECO1.tx_PRECO1.Value=cur_preco.preco1
								replace v_produtos_00_precos.preco_liquido1 WITH null
								
							endif	
						
					endif	
					
					
					
					IF wnivel_acesso > 0 	
						
						If	upper(xnome_obj)== 'TX_PRECO1'   
						
							*** Bloqueio por Entradas
							text to xsel noshow	
								select b.filial,a.nome_clifor,a.nf_entrada,a.produto  
								from entradas_produto a  
								join entradas b  
								on a.nome_clifor=b.nome_clifor and a.nf_entrada=b.nf_entrada   
								join (select distinct pedido,produto from compras_produto )c   
								on a.produto=c.produto and a.pedido=c.pedido
								join produtos d
								on a.produto = d.produto
								where a.total_entradas>0  
								and d.colecao <> 'JOIAS'
								and a.produto=?v_produtos_00.produto  
							endtext	
							
							f_select(xsel,'curEntradas')	
							
							Sele curEntradas	
							if reccount()>0
								
								sele v_produtos_00_precos	
								
								f_Msg(['Não é possível Alterar esta informação !'+chr(13)+'Produto com Entrada no Estoque !!!', 0 + 48, 'Atenção'])
								f_select("select preco1 from produtos_precos where codigo_tab_preco=?v_produtos_00_precos.codigo_tab_preco and produto=?v_produtos_00_precos.produto","cur_preco",alias()) 
								replace	v_produtos_00_precos.preco1 with cur_preco.preco1	
								thisform.lx_FORM1.lx_pageframe1.page5.lX_GRID_FILHA1.COL_TX_PRECO1.tx_PRECO1.Value=cur_preco.preco1
							
							endif	
							*** Bloqueio por Entradas						
						
	
							*** Bloqueio por Compras de Produtos Acabados
							text to xsel noshow	
								select b.produto,a.* from compras a
								join compras_produto b 
								on a.pedido=b.pedido 
								join produtos c
								on b.produto = c.produto
								where a.status_compra='A' 
								and c.colecao <> 'JOIAS'
								and b.produto=?v_produtos_00.produto  
							endtext	
							
							f_select(xsel,'curCompras')	
							
							Sele curCompras	
							if reccount()>0
								
								sele v_produtos_00_precos	
								
								f_Msg(['Não é possível Alterar esta informação !'+chr(13)+'Produto com Compra Aprovada !!!', 0 + 48, 'Atenção'])
								f_select("select preco1 from produtos_precos where codigo_tab_preco=?v_produtos_00_precos.codigo_tab_preco and produto=?v_produtos_00_precos.produto","cur_preco",alias()) 
								replace	v_produtos_00.custo_reposicao1 with cur_preco.preco1	
								thisform.lx_FORM1.lx_pageframe1.page5.lX_GRID_FILHA1.COL_TX_PRECO1.tx_PRECO1.Value=cur_preco.preco1
							
							endif	
							*** Bloqueio por Compras de Produtos Acabados							
							
								
	
						
							*** Bloqueio por Os na fase Faccao						
							f_select(" select distinct ordem_producao from producao_ordem where produto=?v_produtos_00.produto ","curOsBloq",alias())
							
							sele curOsBloq 
							if	reccount()>0
							
								f_select("select * from fx_producao_ordem_hist_os('1')","curOsBloqueio",alias())
							
								sele curOsBloq  
								go top	
								
								scan	
									
									text to	xselOs noshow textmerge	 
										select * from fx_producao_ordem_hist_os('<<allt(curOsBloq.ordem_producao)>>') 
									endtext		

									f_select(xselOs,"curTmpOs",alias())
									
									sele curTmpOs
									scan
										scatter to xmemvar
										sele curOsBloqueio 
										appe blank
										gather from xmemvar
										sele curTmpOs
									endscan

									sele curOsBloq 

								endscan								 
							
								
								sele curOsBloqueio 
								loca for fase_producao1='006'
								if found()
									messagebox("Não é possível Alterar esta informação !"+chr(13)+"A OS nº "+allt(curOsBloqueio.ordem_servico)+" está na fase de Faccao !!!",48,"Atenção !!!" )
									f_select("select preco1 from produtos_precos where codigo_tab_preco=?v_produtos_00_precos.codigo_tab_preco and produto=?v_produtos_00_precos.produto","cur_preco",alias()) 
									replace	v_produtos_00_precos.preco1 with cur_preco.preco1	
									thisform.lx_FORM1.lx_pageframe1.page5.lX_GRID_FILHA1.COL_TX_PRECO1.tx_PRECO1.Value=cur_preco.preco1
								endif
							
							
							
							endif
						
							*** Bloqueio por Os na fase Faccao							
						
						
							
						Endif	
						
					

						if	upper(xnome_obj)== 'LX_TEXTBOX_BASE1'

							text to xsel noshow	
								select b.produto,a.* from compras a
								join compras_produto b 
								on a.pedido=b.pedido 
								where a.status_compra='A' 
								and b.produto=?v_produtos_00.produto  
							endtext	
							
							f_select(xsel,'curCompras')	
							
							Sele curCompras	
							if reccount()>0
								
								sele v_produtos_00_precos	
								
								f_Msg(['Não é possível Alterar esta informação !'+chr(13)+'Produto com Compra Aprovada !!!', 0 + 48, 'Atenção'])
								f_select("select isnull(custo_reposicao1,0) as preco1 from produtos where produto=?v_produtos_00.produto","cur_preco",alias()) 
								replace	v_produtos_00.custo_reposicao1 with cur_preco.preco1	
								thisform.lx_FORM1.lx_pageframe1.page2.lx_textbox_base1.Value=cur_preco.preco1
							
							endif	
						
						endif						
					**** tabela de preço padrão	
					If upper(xnome_obj) = 'TX_PRECO1'
						
								IF thisformset.p_tool_status = 'A'  AND (v_produtos_00.rede_lojas= '2' or v_produtos_00.rede_lojas= '5')
																	
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
					
					ELSE 

							if	upper(xnome_obj)== 'TX_PRECO1'  and	upper(v_produtos_00_precos.codigo_tab_preco)=='VO'
								if messagebox("Deseja Atualizar o Preço da Tabela Atacado ?",4+32,"Atenção!")=6
									xpreco=preco1
									sele v_produtos_00_precos  
									go top	
									loca for codigo_tab_preco='A'
									if found() 
										repla preco1 with iif(nvl(xpreco,0)=0,0,round(xpreco/(2.2),2))
									endif
								endif		
							endif
*!*							endif					
						*fim calcula preco atacado												
							
						ENDIF 	


				
									
				case UPPER(xmetodo) == 'USR_SAVE_BEFORE'
				
				xalias=alias()
				
				IF UPPER(WUSUARIO) <> 'CLAUDIAMELLO'
						if (V_PRODUTOS_00.STATUS_PRODUTO = '04')
							IF f_vazio (V_PRODUTOS_00.PESO)
								messagebox("Não é permitido Salvar Produto sem cadastrar o Peso !!!",48,"Atenção!!!!!")	 
								retu .f.
							ENDIF
							
*!*								IF f_vazio(V_PRODUTOS_00.COD_PRODUTO_SOLUCAO) OR f_vazio(V_PRODUTOS_00.COD_PRODUTO_SEGMENTO)
*!*									messagebox("Não é permitido Salvar Produto Solução ou Seguimento Vazio !!!",48,"Atenção!!!!!")	 
*!*									retu .f.
*!*								ENDIF
							
							IF 	f_vazio(V_PRODUTOS_00.FABRICANTE) OR UPPER(ALLTRIM(V_PRODUTOS_00.FABRICANTE)) == 'INDEFINIDO'
								messagebox("Não é permitido Salvar Produto sem Fabricante ou Fabricante Indefinido !!!",48,"Atenção!!!!!")	 
								retu .f.
							ENDIF
						endif	
				ENDIF
				
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
				
				IF f_vazio(v_produtos_00.desc_prod_nf)
					MESSAGEBOX("Não é permitido salvar Produto sem cadastrar a Desc. Fiscal !!!!","Atenção !!!",48)
					RETURN .f.
				ENDIF	
				
				if !f_vazio(xalias)
					sele &xalias
				endif
				
				
					
				case UPPER(xmetodo) == 'USR_SAVE_AFTER' 
							
				
				xalias=alias()
				
				f_select("select produto from produtos where produto=?v_produtos_00.produto","xProduto")
				xCodProduto=xProduto.produto
				f_update("EXEC SOMA.DBO.LX_ANM_GERA_CUSTO_OP_TRANSFORMACAO ?xCodProduto")
				
				
				IF THISFORMSET.P_TOOL_STATUS == 'A'
				
					SELECT V_PRODUTOS_00
					
					TEXT TO xUpdateNcm NOSHOW TEXTMERGE 		
						UPDATE A SET CLASSIF_FISCAL = '<<LTRIM(RTRIM(V_PRODUTOS_00.CLASSIF_FISCAL))>>'
						FROM(SELECT B.* FROM FATURAMENTO A
						JOIN FATURAMENTO_ITEM B
						ON A.NF_SAIDA = B.NF_SAIDA
						AND A.SERIE_NF = B.SERIE_NF
						AND A.FILIAL = B.FILIAL
						WHERE B.CODIGO_ITEM = '<<LTRIM(RTRIM(V_PRODUTOS_00.PRODUTO))>>'
						AND A.STATUS_NFE NOT IN ('5','49','59','0')) A
					ENDTEXT 
		
					f_update(xUpdateNcm)
				ENDIF
				
				IF Thisformset.pp_anm_preenche_aut_pa = .t.
					IF THISFORMSET.P_TOOL_STATUS == 'I'	
						*** Lucas Copia
						xGrupo 			= v_produtos_00.grupo_produto
						
						xSubGrupo 		= v_produtos_00.subgrupo_produto

						xCategoria  	= v_produtos_00.cod_categoria
						f_select("Select categoria_produto From Produtos_Categoria Where cod_categoria = ?v_produtos_00.cod_categoria","xCopCategoria")  
						xDescCategoria  = xCopCategoria.Categoria_Produto

						xSubcategoria 	= v_produtos_00.cod_subcategoria
						f_select("Select SUBCATEGORIA_PRODUTO From PRODUTOS_SUBCATEGORIA Where cod_subcategoria = ?v_produtos_00.cod_subcategoria and cod_categoria = ?v_produtos_00.cod_categoria","xCopDescCategoria")
						xDescSubCategoria = xCopDescCategoria.SUBCATEGORIA_PRODUTO

						xTipo			= v_produtos_00.tipo_produto

						xColecao		= v_produtos_00.colecao
						f_select("select DESC_COLECAO from colecoes where colecao=?v_produtos_00.colecao","xCopColecao")
						xDescColecao	= xCopColecao.Desc_Colecao

						xGriffe			= v_produtos_00.griffe
						
						xLinha			= v_produtos_00.linha

						*xDescFiscal		= thisformset.LX_FORM1.LX_PAGEFRAME1.Page1.pgDadosProdutos.Page1.tx_dESC_PROD_NF.Value

						xProdSolucao	= v_produtos_00.cod_produto_solucao
						f_select("Select DESC_PRODUTO_SOLUCAO From PRODUTOS_SOLUCAO Where Cod_Produto_Solucao = ?v_produtos_00.cod_produto_solucao","xCopProdSolucao")
						xDescProdSolucao = xCopProdSolucao.DESC_PRODUTO_SOLUCAO

						xProdSegmento	= v_produtos_00.cod_produto_segmento
						f_select("Select DESC_PRODUTO_SEGMENTO From PRODUTOS_SEGMENTO Where Cod_Produto_Segmento = ?v_produtos_00.cod_produto_segmento","xCopProdSegmento")
						xDescProdSegmento = xCopProdSegmento.Desc_Produto_Segmento

						xFabricante		= ALLTRIM(v_produtos_00.fabricante)

						xStatusProd		= v_produtos_00.status_produto
						f_select("Select Desc_Status_Produto From Produtos_Status Where Status_Produto = ?v_produtos_00.status_produto","xCopStatusProd")
						xDescStatusProd = xCopStatusProd.Desc_Status_Produto

						xTipoStatusProd = v_produtos_00.tipo_status_produto

						xPeriodoPCP = v_produtos_00.periodo_pcp
						
						xSexo = v_produtos_00.sexo_tipo

						xComposicao = v_produtos_00.composicao
						f_select("Select Desc_Composicao From MATERIAIS_COMPOSICAO Where Composicao = ?v_produtos_00.composicao","xCopComposicao")
						xDescComposicao = xCopComposicao.Desc_Composicao

						xRestricao = v_produtos_00.restricao_lavagem
						f_select("Select DESC_RESTRICAO_LAVAGEM From MATERIAIS_TIPO_LAVAGEM Where RESTRICAO_LAVAGEM = ?v_produtos_00.restricao_lavagem","xCopRestricao")
						xDescRestricao = xCopRestricao.DESC_RESTRICAO_LAVAGEM
						
						xGrade = v_produtos_00.grade
						
						xPeso = v_produtos_00.peso
						
						xRedeLojas = v_produtos_00.rede_lojas
						**propriedade**
						f_select("select * from prop_produtos where produto = ?v_produtos_00.produto and propriedade <> '00106'","xCopProp")
						sele xCopProp
					ENDIF
				ENDIF
				
				
				if !f_vazio(xalias)
					sele &xalias
				endif	
				
								


				case UPPER(xmetodo) == 'USR_CLEAN_AFTER' AND upper(xnome_obj)== 'PRODUTOS_001' 

				xalt_cartela=.F.
				**** tabela de preço padrão
				IF Thisformset.pp_anm_preenche_aut_pa = .t.
					xGrupo = ''
					xSubGrupo = ''
					xCategoria = ''
					xDescCategoria = '' 
					xSubcategoria = ''
					xDescSubCategoria = ''
					xTipo = ''
					xColecao = ''
					xDescColecao = ''
					xGriffe = ''
					xLinha = ''
					xProdSolucao = ''
					xDescProdSolucao = ''
					xProdSegmento = ''
					xDescProdSegmento = ''
					xFabricante = ''
					xStatusProd = ''
					xDescStatusProd = ''
					xTipoStatusProd = ''
					xPeriodoPCP = ''
					xComposicao = ''
					xDescComposicao = ''
					xRestricao = ''
					xDescRestricao = ''
					xGrade = ''
					xSexo = ''
					xPeso = ''
					xRedeLojas = ''
				ENDIF
*!*					if TYPE('xCopProp')<>'U'
*!*						If RECCOUNT()>0
*!*							USE IN xCopProp
*!*						Endif
*!*					endif
				case upper(xmetodo) == 'USR_ITEN_DELETE_BEFORE'
				
					xalias=alias()
						
						If upper(xnome_obj) = 'PRODUTOS_001'
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
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif

	
			otherwise
				return .t.				
		endcase
	endproc
enddefine


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
	Visible = .t.
	
	Procedure Click
		sele v_produtos_00
		
		F_SELECT("SELECT DESC_COMPOSICAO FROM MATERIAIS_COMPOSICAO (nolock) WHERE COMPOSICAO = ?v_produtos_00.composicao","xComposicao")
		_cliptext=ALLTRIM(NVL(xComposicao.Desc_Composicao,''))
Enddefine
*
*-- EndDefine: btn_ccomposicao 
**************************************************


**************************************************
*-- Class:        lb_confere_entrada(c:\temp\lb_confere_entrada.vcx)
*-- ParentClass:  lx_label (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   04/13/11 01:49:09 PM
*
*!*	DEFINE CLASS Anm_ComboMarca AS lx_combobox

*!*	BoundColumn = 2
*!*	RowSourceType = 0
*!*	ControlSource = "v_produtos_00.anm_marca"
*!*	Height = 22
*!*	TabIndex = 23
*!*	Width = 181
*!*	ZOrderSet = 80
*!*	enabled = .t.


*!*	ENDDEFINE
*
*-- EndDefine: lb_confere_entrada 
**************************************************


**************************************************
*-- Class:        cmb_nf_entrada (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
*!*	DEFINE CLASS anm_ComboMarca AS lx_combobox
*!*		
*!*		RowSourceType = 2
*!*		RowSource = "Cur_anm_marca.anm_marca"
*!*		ControlSource = "v_produtos_00.anm_marca"
*!*		Height = 22
*!*		TabIndex = 23
*!*		Width = 201
*!*		top = 153
*!*		left = 499
*!*		ZOrderSet = 80
*!*		Name = "anm_ComboMarca "
*!*		Anchor = 0
*!*		Visible = .t.
*!*		Enabled = .t.
*!*		
*!*	ENDDEFINE
*
*-- EndDefine: cmb_nf_entrada
**************************************************
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

		xSelCurPercBase = "SELECT RTRIM(LTRIM(VALOR_PROPRIEDADE)) AS PERC_PRECO FROM PROP_TABELAS_PRECO "+;
		                 "WHERE PROPRIEDADE = '00186' "+;
		                 "AND CODIGO_TAB_PRECO = '"+pp_anm_tabelas_preco_produto.ValorParam+"'"
		f_select(xSelCurPercBase,"CurPercBase")

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
			*o_002006.lx_FORM1.lx_pageframe1.page5.lx_GRID_FILHA1.column5.Tv_precos.setfocus()
			GO BOTTOM 
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
*!*	**************************************************
*-- Class:        ck_liberar_grade_web (c:\users\lucas.miranda\desktop\ck_liberar_grade_web.vcx)
*-- ParentClass:  lx_checkbox (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   04/08/16 02:20:05 PM
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
