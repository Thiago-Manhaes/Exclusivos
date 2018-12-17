* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  15/06/2009                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Grid com resultados por produtos consolidado			                    *
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

		* =messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

			do case


				case upper(xmetodo) == 'USR_INIT' 
					
					xalias=alias()
				
*!*						*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- V_LOJA_RESUMO_OPERACAO_01   
*!*						sele V_LOJA_RESUMO_PRODUTO_00   
*!*						xalias_pai=alias()

*!*		  				oCur = getcursoradapter(xalias_pai)
*!*						oCur.addbufferfield("LOJA_VENDA_PGTO.CODIGO_FILIAL", "C(25)",.F., "CODIGO_FILIAL", "")				
*!*						oCur.confirmstructurechanges() 	
*!*						*-Fim Inclusao Campos Novos de Produtos no Cursor Pai 
					
					*** lucas *** 16/05/2016
					
				
						sele V_LOJA_RESUMO_PRODUTO_00
							
			  				oCur = getcursoradapter(xalias)
							oCur.addbufferfield("'' AS DESC_PRODUTO_SEGMENTO", "C(25)",.F., "DESC_PRODUTO_SEGMENTO", "DESC_PRODUTO_SEGMENTO")
							oCur.addbufferfield("'' AS DESC_CATEGORIA", "C(25)",.F., "DESC_PRODUTO_SEGMENTO", "DESC_CATEGORIA")
							oCur.addbufferfield("'' AS DESC_SUBCATEGORIA", "C(25)",.F., "DESC_SUBCATEGORIA", "DESC_SUBCATEGORIA")	
							oCur.addbufferfield("'' AS DESC_PRODUTO_SOLUCAO", "C(25)",.F., "DESC_PRODUTO_SOLUCAO", "DESC_PRODUTO_SOLUCAO")			
							oCur.confirmstructurechanges() 
								
								*** criação das colunas ***
							with	thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1
											xcColumnCount = .columncount
																xcColumnCount = xcColumnCount + 1 
																.addcolumn(xcColumnCount)
																.columns[xcColumnCount].name = 'col_anm_desc_segmento'
																.col_anm_desc_segmento.width = 100
																.col_anm_desc_segmento.columnorder = 41
																.col_anm_desc_segmento.header1.caption = 'Desc. Segmento'
																.col_anm_desc_segmento.header1.alignment = 2
																.col_anm_desc_segmento.header1.FONTSIZE = 8
																.col_anm_desc_segmento.refresh()
																.col_anm_desc_segmento.ControlSource='v_loja_resumo_produto_00.desc_produto_segmento'
							endwith
											
							with	thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1
											xcColumnCount = .columncount
																xcColumnCount = xcColumnCount + 1 
																.addcolumn(xcColumnCount)
																.columns[xcColumnCount].name = 'col_anm_desc_solucao'
																.col_anm_desc_solucao.width = 100
																.col_anm_desc_solucao.columnorder = 42
																.col_anm_desc_solucao.header1.caption = 'Desc. Solução'
																.col_anm_desc_solucao.header1.alignment = 2
																.col_anm_desc_solucao.header1.FONTSIZE = 8
																.col_anm_desc_solucao.refresh()
																.col_anm_desc_solucao.ControlSource='v_loja_resumo_produto_00.DESC_PRODUTO_SOLUCAO'
							endwith
							
							with	thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1
											xcColumnCount = .columncount
																xcColumnCount = xcColumnCount + 1 
																.addcolumn(xcColumnCount)
																.columns[xcColumnCount].name = 'col_anm_desc_categoria'
																.col_anm_desc_categoria.width = 100
																.col_anm_desc_categoria.columnorder = 43
																.col_anm_desc_categoria.header1.caption = 'Desc. Categoria'
																.col_anm_desc_solucao.header1.alignment = 2
																.col_anm_desc_categoria.header1.FONTSIZE = 8
																.col_anm_desc_categoria.refresh()
																.col_anm_desc_categoria.ControlSource='v_loja_resumo_produto_00.DESC_CATEGORIA'
							endwith
							
							with	thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1
											xcColumnCount = .columncount
																xcColumnCount = xcColumnCount + 1 
																.addcolumn(xcColumnCount)
																.columns[xcColumnCount].name = 'col_anm_desc_subcategoria'
																.col_anm_desc_subcategoria.width = 100
																.col_anm_desc_subcategoria.columnorder = 44
																.col_anm_desc_subcategoria.header1.caption = 'Desc. SubCategoria'
																.col_anm_desc_subcategoria.header1.alignment = 2
																.col_anm_desc_subcategoria.header1.FONTSIZE = 8
																.col_anm_desc_subcategoria.refresh()
																.col_anm_desc_subcategoria.ControlSource='v_loja_resumo_produto_00.DESC_SUBCATEGORIA'
							endwith
							*** criação das colunas ***

					*** lucas *** 16/05/2016

				*Criando Novo Cursor de Produtos Sinteticos (v_loja_resumo_produto_00_sintetico)
					With thisformset.dataenvironment 
					  if Type(".Cursorv_loja_resumo_produto_00_sintetico")="U" 
					      *AddNewObject(thisformset.dataenvironment, "Cursorv_loja_resumo_produto_00_sintetico","ccursoradapter") 
					     .addobject("Cursorv_loja_resumo_produto_00_sintetico","ccursoradapter") 
						.Cursorv_loja_resumo_produto_00_sintetico.DataSourceType			="NATIVE"
						Text to .Cursorv_loja_resumo_produto_00_sintetico.SelectCmd TextMerge NoShow
						SELECT V_LOJA_RESUMO_PRODUTO_00.filial, V_LOJA_RESUMO_PRODUTO_00.produto, V_LOJA_RESUMO_PRODUTO_00.cor_produto,V_LOJA_RESUMO_PRODUTO_00.clifor,V_LOJA_RESUMO_PRODUTO_00.filial_propria,V_LOJA_RESUMO_PRODUTO_00.matriz,V_LOJA_RESUMO_PRODUTO_00.regiao,
						V_LOJA_RESUMO_PRODUTO_00.tabela_operacoes,V_LOJA_RESUMO_PRODUTO_00.tabela_medidas,V_LOJA_RESUMO_PRODUTO_00.tipo_produto,V_LOJA_RESUMO_PRODUTO_00.desc_produto,V_LOJA_RESUMO_PRODUTO_00.grupo_produto,V_LOJA_RESUMO_PRODUTO_00.subgrupo_produto,
						V_LOJA_RESUMO_PRODUTO_00.colecao,V_LOJA_RESUMO_PRODUTO_00.grade,V_LOJA_RESUMO_PRODUTO_00.linha,V_LOJA_RESUMO_PRODUTO_00.griffe,V_LOJA_RESUMO_PRODUTO_00.cartela,V_LOJA_RESUMO_PRODUTO_00.unidade,V_LOJA_RESUMO_PRODUTO_00.revenda,
						V_LOJA_RESUMO_PRODUTO_00.refer_fabricante,V_LOJA_RESUMO_PRODUTO_00.modelagem,V_LOJA_RESUMO_PRODUTO_00.fabricante,V_LOJA_RESUMO_PRODUTO_00.estilista,V_LOJA_RESUMO_PRODUTO_00.modelista,V_LOJA_RESUMO_PRODUTO_00.periodo_pcp,
						V_LOJA_RESUMO_PRODUTO_00.cor_fabricante,V_LOJA_RESUMO_PRODUTO_00.desc_cor_produto,V_LOJA_RESUMO_PRODUTO_00.tinturaria_lavagem,V_LOJA_RESUMO_PRODUTO_00.cor,V_LOJA_RESUMO_PRODUTO_00.material,V_LOJA_RESUMO_PRODUTO_00.cor_material,
						V_LOJA_RESUMO_PRODUTO_00.etiqueta,V_LOJA_RESUMO_PRODUTO_00.tipo_lavagem_tinturaria,V_LOJA_RESUMO_PRODUTO_00.empresa,
						SUM(V_LOJA_RESUMO_PRODUTO_00.total_custo) AS TOTAL_CUSTO, SUM(V_LOJA_RESUMO_PRODUTO_00.total_venda) AS TOTAL_VENDA,
					  	SUM(V_LOJA_RESUMO_PRODUTO_00.total_desconto) AS TOTAL_DESCONTO, SUM(V_LOJA_RESUMO_PRODUTO_00.total_qtde_venda) AS TOTAL_QTDE_DE_VENDA, SUM(V_LOJA_RESUMO_PRODUTO_00.ve1) AS VE1,SUM(V_LOJA_RESUMO_PRODUTO_00.ve2) AS VE3,SUM(V_LOJA_RESUMO_PRODUTO_00.ve1) AS VE3,
					  	SUM(V_LOJA_RESUMO_PRODUTO_00.ve4) AS VE4,SUM(V_LOJA_RESUMO_PRODUTO_00.ve5) AS VE5,SUM(V_LOJA_RESUMO_PRODUTO_00.ve6) AS VE6,
					 	SUM(V_LOJA_RESUMO_PRODUTO_00.margem) AS MARGEM,  000000000.00 AS PRECO_MEDIO, SUM(V_LOJA_RESUMO_PRODUTO_00.porcentagem_valor) AS PORCENTAGEM_VALOR,
					  	SUM(V_LOJA_RESUMO_PRODUTO_00.porcentagem_qtde) AS PORCENTAGEM_QTDE, SUM(V_LOJA_RESUMO_PRODUTO_00.qtde_troca) AS QTDE_TROCA,SUM(V_LOJA_RESUMO_PRODUTO_00.valor_troca) AS VALOR_TROCA,  
					 	SUM(V_LOJA_RESUMO_PRODUTO_00.desconto_troca) AS DESCONTO_TROCA,  SUM(V_LOJA_RESUMO_PRODUTO_00.custo_troca) AS CUSTO_TROCA,SUM(V_LOJA_RESUMO_PRODUTO_00.qtde_liquida) AS QTDE_LIQUIDA, 
					 	SUM(V_LOJA_RESUMO_PRODUTO_00.valor_liquido) AS VALOR_LIQUIDO, SUM(V_LOJA_RESUMO_PRODUTO_00.valor_liq_sem_vale) AS VALOR_LIQ_SEM_VALE, 
					 	SUM(V_LOJA_RESUMO_PRODUTO_00.vales_recebidos) AS VALOR_LIQ_SEM_VALE, 0000000000.00 as PERC_VALOR_LIQ_SEM_VALE, 0000000000.00 as PERC_QTDE
					 	FROM V_LOJA_RESUMO_PRODUTO_00  GROUP BY  V_LOJA_RESUMO_PRODUTO_00.filial, V_LOJA_RESUMO_PRODUTO_00.produto, V_LOJA_RESUMO_PRODUTO_00.cor_produto,V_LOJA_RESUMO_PRODUTO_00.clifor,V_LOJA_RESUMO_PRODUTO_00.filial_propria,V_LOJA_RESUMO_PRODUTO_00.matriz,V_LOJA_RESUMO_PRODUTO_00.regiao,
						V_LOJA_RESUMO_PRODUTO_00.tabela_operacoes,V_LOJA_RESUMO_PRODUTO_00.tabela_medidas,V_LOJA_RESUMO_PRODUTO_00.tipo_produto,V_LOJA_RESUMO_PRODUTO_00.desc_produto,V_LOJA_RESUMO_PRODUTO_00.grupo_produto,V_LOJA_RESUMO_PRODUTO_00.subgrupo_produto,
						V_LOJA_RESUMO_PRODUTO_00.colecao,V_LOJA_RESUMO_PRODUTO_00.grade,V_LOJA_RESUMO_PRODUTO_00.linha,V_LOJA_RESUMO_PRODUTO_00.griffe,V_LOJA_RESUMO_PRODUTO_00.cartela,V_LOJA_RESUMO_PRODUTO_00.unidade,V_LOJA_RESUMO_PRODUTO_00.revenda,
						V_LOJA_RESUMO_PRODUTO_00.refer_fabricante,V_LOJA_RESUMO_PRODUTO_00.modelagem,V_LOJA_RESUMO_PRODUTO_00.fabricante,V_LOJA_RESUMO_PRODUTO_00.estilista,V_LOJA_RESUMO_PRODUTO_00.modelista,V_LOJA_RESUMO_PRODUTO_00.periodo_pcp,
						V_LOJA_RESUMO_PRODUTO_00.cor_fabricante,V_LOJA_RESUMO_PRODUTO_00.desc_cor_produto,V_LOJA_RESUMO_PRODUTO_00.tinturaria_lavagem,V_LOJA_RESUMO_PRODUTO_00.cor,V_LOJA_RESUMO_PRODUTO_00.material,V_LOJA_RESUMO_PRODUTO_00.cor_material,
						V_LOJA_RESUMO_PRODUTO_00.etiqueta,V_LOJA_RESUMO_PRODUTO_00.tipo_lavagem_tinturaria,V_LOJA_RESUMO_PRODUTO_00.empresa ORDER BY 1,2,3 DESC 

						EndText
						Text to .Cursorv_loja_resumo_produto_00_sintetico.CursorSchema TextMerge NoShow
						FILIAL C(25), PRODUTO C(12), COR_PRODUTO C(10), CLIFOR C(6), FILIAL_PROPRIA L, MATRIZ C(25), REGIAO C(25), TABELA_OPERACOES C(25), TABELA_MEDIDAS C(25), TIPO_PRODUTO C(25), DESC_PRODUTO C(40),
					 	GRUPO_PRODUTO C(25), SUBGRUPO_PRODUTO C(25), COLECAO C(6), GRADE C(25), LINHA C(25), GRIFFE C(25), CARTELA C(4),
					  	UNIDADE C(5), REVENDA L, REFER_FABRICANTE C(10), MODELAGEM C(10), FABRICANTE C(25),
					 	ESTILISTA C(25), MODELISTA C(25), PERIODO_PCP C(25), COR_FABRICANTE C(8),
					 	DESC_COR_PRODUTO C(40),TINTURARIA_LAVAGEM L,COR C(10), MATERIAL C(11),COR_MATERIAL C(10),
					 	ETIQUETA C(4),TIPO_LAVAGEM_TINTURARIA C(25),EMPRESA I, TOTAL_CUSTO N(14,2), TOTAL_VENDA N(14,2), 
					 	TOTAL_DESCONTO N(14,2), TOTAL_QTDE_VENDA I, VE1 I, VE2 I, VE3 I, VE4 I, VE5 I, VE6 I,
					 	MARGEM N(16,2), PRECO_MEDIO N(16,2), PORCENTAGEM_VALOR N(16,2), PORCENTAGEM_QTDE N(16,2),QTDE_TROCA N(11),
					 	VALOR_TROCA N(16,2), DESCONTO_TROCA N(16,2), CUSTO_TROCA N(16,2),QTDE_LIQUIDA N(16),VALOR_LIQUIDO N(16,2),
					 	VALOR_LIQ_SEM_VALE N(14,2),VALES_RECEBIDOS N(14,2), PERC_VALOR_LIQ_SEM_VALE N(10,2), PERC_QTDE N(10,2)

						EndText
						Text to .Cursorv_loja_resumo_produto_00_sintetico.UpdateNameList TextMerge NoShow
						
						EndText
						Text to .Cursorv_loja_resumo_produto_00_sintetico.UpdatableFieldList TextMerge NoShow
						
						EndText
						.Cursorv_loja_resumo_produto_00_sintetico.Tables				=""
						.Cursorv_loja_resumo_produto_00_sintetico.KeyFieldList		=""
						Text to .Cursorv_loja_resumo_produto_00_sintetico.QueryList TextMerge NoShow
						
						EndText
						Text to .Cursorv_loja_resumo_produto_00_sintetico.CaptionList TextMerge NoShow
						FILIAL , PRODUTO , COR_PRODUTO , CLIFOR , FILIAL_PROPRIA , MATRIZ , REGIAO , 
						TABELA_OPERACOES , TABELA_MEDIDAS , TIPO_PRODUTO , DESC_PRODUTO ,
						GRUPO_PRODUTO , SUBGRUPO_PRODUTO , COLECAO , GRADE , LINHA , GRIFFE , CARTELA ,
						UNIDADE , REVENDA , REFER_FABRICANTE , MODELAGEM , FABRICANTE ,
						ESTILISTA , MODELISTA , PERIODO_PCP , COR_FABRICANTE ,
						DESC_COR_PRODUTO ,TINTURARIA_LAVAGEM ,COR , MATERIAL ,COR_MATERIAL ,
						ETIQUETA ,TIPO_LAVAGEM_TINTURARIA ,EMPRESA , TOTAL_CUSTO , TOTAL_VENDA , 
						TOTAL_DESCONTO , TOTAL_QTDE_VENDA , VE1 , VE2 , VE3 , VE4 , VE5 , VE6 ,
						MARGEM , PRECO_MEDIO , PORCENTAGEM_VALOR , PORCENTAGEM_QTDE,QTDE_TROCA ,
						VALOR_TROCA , DESCONTO_TROCA , CUSTO_TROCA ,QTDE_LIQUIDA ,VALOR_LIQUIDO ,
						VALOR_LIQ_SEM_VALE ,VALES_RECEBIDOS , PERC_VALOR_LIQ_SEM_VALE, PERC_QTDE

						EndText
						Text to .Cursorv_loja_resumo_produto_00_sintetico.DefaultsValuesList TextMerge NoShow
						
						EndText
						.Cursorv_loja_resumo_produto_00_sintetico.FTableList		=""
						.Cursorv_loja_resumo_produto_00_sintetico.Alias				="v_loja_resumo_produto_00_sintetico"
						.Cursorv_loja_resumo_produto_00_sintetico.ParentCursor		=""
						.Cursorv_loja_resumo_produto_00_sintetico.BufferModeOverride	=3
						.Cursorv_loja_resumo_produto_00_sintetico.NoDataOnLoad		=.T.
						.Cursorv_loja_resumo_produto_00_sintetico.IsUpdateCursor		=.F.
						.Cursorv_loja_resumo_produto_00_sintetico.IsMaster		=.F.
						.Cursorv_loja_resumo_produto_00_sintetico.UpdateType			=1
						.Cursorv_loja_resumo_produto_00_sintetico.WhereType			=3
						.Cursorv_loja_resumo_produto_00_sintetico.FetchMemo			=.T.
						.Cursorv_loja_resumo_produto_00_sintetico.SendUpdates		=.F.
						.Cursorv_loja_resumo_produto_00_sintetico.UseMemoSize		=255
						.Cursorv_loja_resumo_produto_00_sintetico.FetchSize			=-1
						.Cursorv_loja_resumo_produto_00_sintetico.MaxRecords			=-1
						.Cursorv_loja_resumo_produto_00_sintetico.Prepared			=.F.
						.Cursorv_loja_resumo_produto_00_sintetico.CompareMemo		=.F.
						.Cursorv_loja_resumo_produto_00_sintetico.BatchUpdateCount	=1
						.Cursorv_loja_resumo_produto_00_sintetico.OpenCursor() 
					  EndIf 
					EndWith 
				**-Fim Criacao Cursor v_loja_resumo_produto_00_sintetico 

					with thisform.LX_pageframe1
						.PageCount=thisform.LX_pageframe1.PageCount+1
						.page6.caption='Produtos Sintetico'
						.page6.fontsize=8 
						.page6.addobject("lx_grid_produtos_sintetico","lx_grid_produtos_sintetico")	
						.page6.lx_grid_produtos_sintetico.width=705
						.page6.lx_grid_produtos_sintetico.height=370
						.page2.addobject("bt_exporta_vendas","bt_exporta_vendas")
					endwith	
					


				
					*.lx_grid_precos_praticados.col_tx_preco1.width=80				


					
					Thisformset.L_Limpa() 
					
					

					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
				




				case upper(xmetodo) == 'USR_SEARCH_AFTER' 
					xalias=alias()
						thisform.LX_pageframe1.page6.fontbold = .t.
						sele v_loja_resumo_produto_00_sintetico 
						if recc() = 0
							requery()
							thisform.LX_pageframe1.page6.lx_grid_produtos_sintetico.refresh()
						ENDIF
						
						replace all	PERC_VALOR_LIQ_SEM_VALE with (PERC_VALOR_LIQ_SEM_VALE/thisformset.px_vendas_sem_vales)*100 
						
						*replace all venda_m2 with (IIF(f_vazio(total_venda_pgto), 0, total_venda_pgto) / iif(area_m2 = 0 .or. f_vazio(area_m2), 1, area_m2)),;
									Custo with (IIF(f_vazio(Custo_Venda), 0, Custo_Venda)) - IIF(f_vazio(Custo_Troca), 0, Custo_Troca),;
									Previsao_Qtde with (iif(f_vazio(Previsao_Qtde), 0, Previsao_Qtde)),;
									Previsao_Valor with iif(f_vazio(Previsao_Valor), 0, Previsao_Valor),;
									Lucro_Bruto with (IIF(f_vazio(total_venda_pgto), 0, total_venda_pgto) - Custo),;
									Porc_Lucro_Bruto with ((Lucro_Bruto * 100) / iif(Total_Venda_Pgto = 0, 1, Total_Venda_Pgto)),;
									Custo_Medio with (Custo / iif(Qtde_Liquida = 0, 1, Qtde_liquida))
						thisform.LX_pageframe1.page6.lx_grid_produtos_sintetico.UpdateKpis()				

						
						*** lucas *** 16/05/2016
					
				
						sele V_LOJA_RESUMO_PRODUTO_00
							GO TOP
							SCAN
								
								TEXT TO XSEL TEXTMERGE NOSHOW
								
									select A.PRODUTO, ISNULL(B.DESC_PRODUTO_SEGMENTO,'') AS DESC_PRODUTO_SEGMENTO, 
									ISNULL(C.CATEGORIA_PRODUTO,'') AS DESC_CATEGORIA,
									ISNULL(D.SUBCATEGORIA_PRODUTO,'') AS DESC_SUBCATEGORIA,
									ISNULL(E.DESC_PRODUTO_SOLUCAO,'') AS DESC_PRODUTO_SOLUCAO
									from PRODUTOS (NOLOCK) A
									LEFT JOIN PRODUTOS_SEGMENTO (NOLOCK) B
									ON A.COD_PRODUTO_SEGMENTO = B.COD_PRODUTO_SEGMENTO
									LEFT JOIN PRODUTOS_CATEGORIA (NOLOCK) C
									ON A.COD_CATEGORIA = C.COD_CATEGORIA
									LEFT JOIN PRODUTOS_SUBCATEGORIA (NOLOCK) D
									ON C.COD_CATEGORIA = D.COD_CATEGORIA
									LEFT JOIN PRODUTOS_SOLUCAO (NOLOCK) E
									ON A.COD_PRODUTO_SOLUCAO = E.COD_PRODUTO_SOLUCAO
									WHERE A.PRODUTO = '<<V_LOJA_RESUMO_PRODUTO_00.produto>>'
									
								ENDTEXT

								f_select(xsel,"xTempSelect",ALIAS())
								
								sele V_LOJA_RESUMO_PRODUTO_00 
								
								replace DESC_PRODUTO_SEGMENTO  	WITH xTempSelect.DESC_PRODUTO_SEGMENTO
								replace DESC_PRODUTO_SOLUCAO	WITH xTempSelect.DESC_PRODUTO_SOLUCAO
								replace DESC_CATEGORIA  		WITH xTempSelect.DESC_CATEGORIA
								replace DESC_SUBCATEGORIA  		WITH xTempSelect.DESC_SUBCATEGORIA
								
							ENDSCAN	
						
						if !f_vazio(xalias)
							sele &xalias
						endif
						case upper(xmetodo) == 'USR_REFRESH'
				
						xalias=alias()
							If type("thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.COL_ANM_DESC_SEGMENTO") <> "U" AND ;
							   type("thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.col_anm_desc_solucao") <> "U" AND ;
							   type("thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.col_anm_desc_categoria") <> "U" AND ;
							   type("thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.col_anm_desc_subcategoria") <> "U"		
								If Thisformset.P_TOOL_STATUS = 'P'
									thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.COL_ANM_DESC_SEGMENTO.Enabled = .f.
									thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.col_anm_desc_solucao.Enabled = .f.
									thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.col_anm_desc_categoria.Enabled = .f.
									thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.col_anm_desc_subcategoria.Enabled = .f.
								Else
									thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.COL_ANM_DESC_SEGMENTO.Enabled = .T.
									thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.col_anm_desc_solucao.Enabled = .T.
									thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.col_anm_desc_categoria.Enabled = .T.
									thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.col_anm_desc_subcategoria.Enabled = .T.
								Endif
							Endif
	 
						
						*** lucas *** 16/05/2016
					if !f_vazio(xalias)
						sele &xalias
					endif				
																
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE





**************************************************
*-- Class:        lx_grid_produtos_sintetico (c:\work\cientes\imaginarium\lx_grid_produtos_sintetico.vcx)
*-- ParentClass:  lx_grid_filha (c:\work\desenv7\linx_sql\desenv\lib\lx_class.vcx)
*-- BaseClass:    grid
*-- Time Stamp:   03/07/07 04:54:09 PM
*
DEFINE CLASS lx_grid_produtos_sintetico AS lx_grid_filha

	Visible = .T.
	Enabled = .T.	
	ColumnCount = 0
	RecordSource = "v_loja_resumo_produto_00_sintetico"
	Name = "lx_grid_produtos_sintetico"
	Top = 15
	P_mostra_botao_incluir=.T.
	P_mostra_botao_excluir=.T.	

PROCEDURE INIT 

	DODEFAULT()

	with this	
		.Height = 410
		.Left = 40
		.Panel = 1
		.Width = 630
		.Anchor=0
	endwith	
	
	Afields(AFldsCur, this.Recordsource)

	For intCnt = 1 To Alen(AFldsCur, 1) 

	            This.ColumnCount = intCnt 

	            strColumn = AFldsCur[intCnt, 1]

	            If !Empty(strColumn) And Type(this.Recordsource+"."+strColumn) <> "U"
	                  This.ConfigColumn(This.Columns(intCnt), strColumn, Proper(Strtran(strColumn, "_", " ")))
	            Endif

	Endfor

	Release AFldsCur

	this.Col_tx_PRODUTO.Visible=.f.
	this.Refresh()
			
ENDPROC 


PROCEDURE ConfigColumn 

	Lparameters oColumn As Column, strField As String, strCaption As String

	Local strType As String

	strType = Type(oColumn.Parent.RecordSource+"."+strField)


	If Type('oColumn') = 'O'

	      oColumn.Sparse = !(strType = "L")
	      oColumn.Name = Iif(strType = "L", "col_ck_", "col_tx_") + strField
	      oColumn.RemoveObject(oColumn.Objects(2).Name)

	      If strType = "L"
	            oColumn.NewObject("ck_" + strField, "lx_checkbox", "", "")
	      Else
	            oColumn.NewObject("tx_" + strField, "lx_Textbox_base")
	      EndIf       

	      oColumn.Objects(2).Visible = .t.
	      oColumn.Objects(1).Alignment = 2
	      oColumn.Objects(1).FontName = 'Tahoma'
	      oColumn.Objects(1).FontSize = 8
	      oColumn.Objects(1).Caption = "  "+string.translate(strCaption)+"  "
	      oColumn.Objects(1).Name = 'h_tx_'+strField
	      oColumn.Objects(1).BackColor = Rgb(248,248,248)      
	      oColumn.CurrentControl = oColumn.Objects(2).Name
	      oColumn.ReadOnly = .F.
	      oColumn.ControlSource = oColumn.Parent.RecordSource+'.'+strField


	      If strType = "L"
	            oColumn.Objects(2).Caption = ""
	      EndIf


	      If Type("oColumn.Objects(2).p_dragdrop") == "L"
	            oColumn.Objects(2).p_dragdrop = .f.
	      EndIf 

	      oColumn.AutoFit()
	 
	Endif

		
ENDPROC 


ENDDEFINE
*
*-- EndDefine: lx_grid_produtos_sintetico 
**************************************************



**************************************************
*-- Class:        bt_exporta_vendas (c:\temp\bt_exporta_vendas.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   06/10/10 05:30:10 PM
*
DEFINE CLASS bt_exporta_vendas AS botao


	Top = 360
	Left = 530
	Height = 27
	Width = 180
	FontBold = .F.
	FontSize = 8
	Caption = "\<Exportação Vendas Excel"
	TabIndex = 13
	p_muda_size = .F.
	Name = "bt_exporta_vendas" 
	Enabled=.t.
	Visible=.t.


	PROCEDURE Click

		 
		xdata_ini='19800101'  
		xdata_fim='20201231'

*MESSAGEBOX(o_300012.lx_FORM1.lx_pageframe1.page2.Lx_faixa_data1.DATA_INICIAL.Value  )
*MESSAGEBOX(o_300012.lx_FORM1.lx_pageframe1.page2.Lx_faixa_data1.DATA_final.Value  )

		if	!f_vazio(thisform.lx_pageframe1.page2.Lx_faixa_data1.DATA_INICIAL.Value)
			xdata_ini=dtos(thisform.lx_pageframe1.page2.Lx_faixa_data1.DATA_INICIAL.Value)
		endif


		if	!f_vazio(thisform.lx_pageframe1.page2.Lx_faixa_data1.DATA_final.Value)
			xdata_fim=dtos(thisform.lx_pageframe1.page2.Lx_faixa_data1.DATA_final.Value)
		endif


		xlabel_arq1=left(xdata_ini,4)+substr(xdata_ini,5,2)+substr(xdata_ini,7,2)+"_a_"+left(xdata_fim,4)+substr(xdata_fim,5,2)+substr(xdata_fim,7,2)+"DETALHADO"
		xlabel_arq2=left(xdata_ini,4)+substr(xdata_ini,5,2)+substr(xdata_ini,7,2)+"_a_"+left(xdata_fim,4)+substr(xdata_fim,5,2)+substr(xdata_fim,7,2)+"FILIAL_PRODUTO"
		xlabel_arq3=left(xdata_ini,4)+substr(xdata_ini,5,2)+substr(xdata_ini,7,2)+"_a_"+left(xdata_fim,4)+substr(xdata_fim,5,2)+substr(xdata_fim,7,2)+"PRODUTO"


		*!*			* Inicio Exportacao Vendas
		 
				text to	xsel1 noshow	textmerge

	

					IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='TMPANM_RESUMO_VENDAS_PERIODO')
					DROP TABLE TMPANM_RESUMO_VENDAS_PERIODO
				
					IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='TMPANM_RESUMO_TROCAS_PERIODO')
					DROP TABLE TMPANM_RESUMO_TROCAS_PERIODO
					
					select a.produto,a.cor_produto,
					a.filial,sum(a.numero_tickets) as numero_tickets,sum(a.total_venda) as total_venda,
					sum(a.total_qtde_venda) as total_qtde_venda,
					sum(a.ve1) as ve1,sum(a.ve2) as ve2,sum(a.ve3) as ve3,sum(a.ve4) as ve4,sum(a.ve5) as ve5,
					sum(a.ve6) as ve6,sum(a.ve7) as ve7,sum(a.ve8) as ve8,sum(a.ve9) as ve9,sum(a.ve10) as ve10,
					sum(a.ve11) as ve11,sum(a.ve12) as ve12,sum(a.ve13) as ve13,sum(a.ve14) as ve14,sum(a.ve15) as ve15,sum(a.ve16) as ve16 
					INTO TMPANM_RESUMO_VENDAS_PERIODO
					from loja_resumo_produto a 
					join produtos b 
					on a.produto=b.produto 
					where a.data_venda between '<<xdata_ini>>' and '<<xdata_fim>>' 
					and <<STRTRAN(STRTRAN( IIF(EMPTY(o_300012.lx_FORM1.lx_pageframe1.page2.Lx_filtro_produtos1.Lx_filtro_1.p_where),' 1=1', o_300012.lx_FORM1.lx_pageframe1.page2.Lx_filtro_produtos1.Lx_filtro_1.p_where),'produtos.','b.'),'PRODUTOS.','b.' )>>
					group by a.produto,a.cor_produto,
					a.filial
					
					select a.produto,a.cor_produto,
					a.filial,sum(a.numero_tickets) as numero_tickets_troca,sum(total_troca) as total_troca,
					sum(a.total_qtde_troca) as total_qtde_troca,
					sum(a.tr1) as tr1,sum(a.tr2) as tr2,sum(a.tr3) as tr3,sum(a.tr4) as tr4,sum(a.tr5) as tr5,
					sum(a.tr6) as tr6,sum(a.tr7) as tr7,sum(a.tr8) as tr8,sum(a.tr9) as tr9,sum(a.tr10) as tr10,
					sum(a.tr11) as tr11,sum(a.tr12) as tr12,sum(a.tr13) as tr13,sum(a.tr14) as tr14,sum(a.tr15) as tr15,sum(a.tr16) as tr16 
					INTO TMPANM_RESUMO_TROCAS_PERIODO
					from loja_resumo_troca a 
					join produtos b 
					on a.produto=b.produto 
					where a.data_venda between '<<xdata_ini>>' and '<<xdata_fim>>'
					and <<STRTRAN(STRTRAN( IIF(EMPTY(o_300012.lx_FORM1.lx_pageframe1.page2.Lx_filtro_produtos1.Lx_filtro_1.p_where),' 1=1', o_300012.lx_FORM1.lx_pageframe1.page2.Lx_filtro_produtos1.Lx_filtro_1.p_where),'produtos.','b.'),'PRODUTOS.','b.' )>>
					group by a.produto,a.cor_produto,
					a.filial



					SELECT A.* FROM 
					(select b.linha,b.grupo_produto,b.colecao,a.produto,b.desc_produto,a.cor_produto,c.desc_cor_produto,a.filial,a.numero_tickets as numero_tickets_venda,
					isnull(T.numero_tickets_troca,0) as numero_tickets_troca,isnull(a.total_venda,0) as total_venda,  isnull(t.total_troca*-1,0) as total_troca,
					isnull(a.total_venda,0)-isnull(t.total_troca,0) as valor_venda_liq,
					a.total_qtde_venda,isnull(T.total_qtde_troca*-1,0) as total_qtde_troca,a.total_qtde_venda-isnull(T.total_qtde_troca,0) as total_qtde_liq,
					ISNULL(preco_ct.preco1,0) as preco_custo,ISNULL(preco_v.preco1,0) as preco_varejo,
					ISNULL(preco_vo.preco1,0) as preco_varejo_original,
					a.ve1,a.ve2,a.ve3,a.ve4,a.ve5,a.ve6,a.ve7,a.ve8,
					a.ve9,a.ve10,a.ve11,a.ve12,a.ve13,a.ve14,a.ve15,a.ve16 ,
					isnull(T.tr1*-1,0) as tr1,isnull(T.tr2*-1,0) as tr2,isnull(T.tr3*-1,0) as tr3,isnull(T.tr4*-1,0) as tr4,isnull(T.tr5*-1,0) as tr5,
					isnull(T.tr6*-1,0) as tr6,isnull(T.tr7*-1,0) as tr7,isnull(T.tr8*-1,0) as tr8,isnull(T.tr9*-1,0) as tr9,isnull(T.tr10*-1,0) as tr10,
					isnull(T.tr11*-1,0) as tr11,
					isnull(T.tr12*-1,0) as tr12,isnull(T.tr13*-1,0) as tr13,isnull(T.tr14*-1,0) as tr14,isnull(T.tr15*-1,0) as tr15,isnull(T.tr16*-1,0) as tr16,
					isnull(d.estoque,0) as estoque,
					isnull(d.es1,0) as es1,isnull(d.es2,0) as es2,isnull(d.es3,0) as es3,isnull(d.es4,0) as es4,
					isnull(d.es5,0) as es5,isnull(d.es6,0) as es6,isnull(d.es7,0) as es7,isnull(d.es8,0) as es8,
					isnull(d.es9,0) as es9,isnull(d.es10,0) as es10,isnull(d.es11,0) as es11,isnull(d.es12,0) as es12,
					isnull(d.es13,0) as es13,isnull(d.es14,0) as es14,isnull(d.es15,0) as es15,isnull(d.es16,0) as es16 , 
					isnull(e.qtde_transito,0) as qtde_transito,
					isnull(e.t1,0) as t1,isnull(e.t2,0) as t2,isnull(e.t3,0) as t3,isnull(e.t4,0) as t4,
					isnull(e.t5,0) as t5,isnull(e.t6,0) as t6,isnull(e.t7,0) as t7,isnull(e.t8,0) as t8,
					isnull(e.t9,0) as t9,isnull(e.t10,0) as t10,isnull(e.t11,0) as t11,isnull(e.t12,0) as t12,
					isnull(e.t13,0) as t13,isnull(e.t14,0) as t14,isnull(e.t15,0) as t15,isnull(e.t16,0) as t16 ,
					isnull(f.estoque_disponivel,0) as estoque_disponivel,
					isnull(f.es1,0) as ds1,isnull(f.es2,0) as ds2,isnull(f.es3,0) as ds3,isnull(f.es4,0) as ds4,
					isnull(f.es5,0) as ds5,isnull(f.es6,0) as ds6,isnull(f.es7,0) as ds7,isnull(f.es8,0) as ds8,
					isnull(f.es9,0) as ds9,isnull(f.es10,0) as ds10,isnull(f.es11,0) as ds11,isnull(f.es12,0) as ds12,
					isnull(f.es13,0) as ds13,isnull(f.es14,0) as ds14,isnull(f.es15,0) as ds15,isnull(f.es16,0) as ds16 
					from 
					TMPANM_RESUMO_VENDAS_PERIODO a
					left join 
					TMPANM_RESUMO_TROCAS_PERIODO T
					on a.filial=T.filial
					and a.produto=T.produto	
					and a.cor_produto=T.cor_produto

					join produtos b 
					on a.produto=b.produto 
					join produto_cores c 
					on a.produto=c.produto
					and a.cor_produto=c.cor_produto 
					left join 
						(select a.produto,a.primeira_entrada,a.cor_produto,filial,a.estoque,
						a.es1,a.es2,a.es3,a.es4,a.es5,a.es6,a.es7,a.es8,
						a.es9,a.es10,a.es11,a.es12,a.es13,a.es14,a.es15,a.es16  
						from estoque_produtos a) d 
					on  a.produto=d.produto 
					and a.cor_produto=d.cor_produto 
					and a.filial=d.filial 
					left join 
						(select a.produto,a.cor_produto,filial,a.qtde_transito,
						a.t1,a.t2,a.t3,a.t4,a.t5,a.t6,a.t7,a.t8,
						a.t9,a.t10,a.t11,a.t12,a.t13,a.t14,a.t15,a.t16 
						from w_estoque_em_transito a) e 
					on  a.produto=e.produto 
					and a.cor_produto=e.cor_produto 
					and a.filial=e.filial 
					left join 
						(select a.produto,a.cor_produto,filial,a.estoque_disponivel,
						a.es1 ,a.es2 ,a.es3 ,a.es4 ,
						a.es5 ,a.es6 ,a.es7 ,a.es8 ,
						a.es9 ,a.es10 ,a.es11 ,a.es12 ,
						a.es13 ,a.es14 ,a.es15 ,a.es16 
						from w_estoque_produtos_transito a ) f 
					on  a.produto=f.produto 
					and a.cor_produto=f.cor_produto 
					and a.filial=f.filial 
					
					left join (select produto,preco1 from produtos_precos where codigo_tab_preco='CT') preco_ct
					ON a.produto=preco_ct.produto
					
					left join (select produto,preco1 from produtos_precos where codigo_tab_preco='V') preco_v
					ON a.produto=preco_v.produto

					left join (select produto,preco1 from produtos_precos where codigo_tab_preco='VO') preco_vo
					ON a.produto=preco_vo.produto

					UNION ALL


					select b.linha,b.grupo_produto,b.colecao,a.produto,b.desc_produto,a.cor_produto,c.desc_cor_produto,a.filial,a.numero_tickets as numero_tickets_venda,
					isnull(T.numero_tickets_troca,0) as numero_tickets_troca, isnull(a.total_venda,0) as total_venda,  isnull(t.total_troca*-1,0) as total_troca, 
					isnull(a.total_venda,0)-isnull(t.total_troca,0) as valor_venda_liq,
					a.total_qtde_venda,isnull(T.total_qtde_troca*-1,0) as total_qtde_troca,a.total_qtde_venda-isnull(T.total_qtde_troca,0) as total_qtde_liq,
					ISNULL(preco_ct.preco1,0) as preco_custo,ISNULL(preco_v.preco1,0) as preco_varejo,
					ISNULL(preco_vo.preco1,0) as preco_varejo_original,
					a.ve1,a.ve2,a.ve3,a.ve4,a.ve5,a.ve6,a.ve7,a.ve8,
					a.ve9,a.ve10,a.ve11,a.ve12,a.ve13,a.ve14,a.ve15,a.ve16 ,
					isnull(T.tr1*-1,0) as tr1,isnull(T.tr2*-1,0) as tr2,isnull(T.tr3*-1,0) as tr3,isnull(T.tr4*-1,0) as tr4,isnull(T.tr5*-1,0) as tr5,
					isnull(T.tr6*-1,0) as tr6,isnull(T.tr7*-1,0) as tr7,isnull(T.tr8*-1,0) as tr8,isnull(T.tr9*-1,0) as tr9,isnull(T.tr10*-1,0) as tr10,
					isnull(T.tr11*-1,0) as tr11,
					isnull(T.tr12*-1,0) as tr12,isnull(T.tr13*-1,0) as tr13,isnull(T.tr14*-1,0) as tr14,isnull(T.tr15*-1,0) as tr15,isnull(T.tr16*-1,0) as tr16,
					isnull(d.estoque,0) as estoque,
					isnull(d.es1,0) as es1,isnull(d.es2,0) as es2,isnull(d.es3,0) as es3,isnull(d.es4,0) as es4,
					isnull(d.es5,0) as es5,isnull(d.es6,0) as es6,isnull(d.es7,0) as es7,isnull(d.es8,0) as es8,
					isnull(d.es9,0) as es9,isnull(d.es10,0) as es10,isnull(d.es11,0) as es11,isnull(d.es12,0) as es12,
					isnull(d.es13,0) as es13,isnull(d.es14,0) as es14,isnull(d.es15,0) as es15,isnull(d.es16,0) as es16 , 
					isnull(e.qtde_transito,0) as qtde_transito,
					isnull(e.t1,0) as t1,isnull(e.t2,0) as t2,isnull(e.t3,0) as t3,isnull(e.t4,0) as t4,
					isnull(e.t5,0) as t5,isnull(e.t6,0) as t6,isnull(e.t7,0) as t7,isnull(e.t8,0) as t8,
					isnull(e.t9,0) as t9,isnull(e.t10,0) as t10,isnull(e.t11,0) as t11,isnull(e.t12,0) as t12,
					isnull(e.t13,0) as t13,isnull(e.t14,0) as t14,isnull(e.t15,0) as t15,isnull(e.t16,0) as t16 ,
					isnull(f.estoque_disponivel,0) as estoque_disponivel,
					isnull(f.es1,0) as ds1,isnull(f.es2,0) as ds2,isnull(f.es3,0) as ds3,isnull(f.es4,0) as ds4,
					isnull(f.es5,0) as ds5,isnull(f.es6,0) as ds6,isnull(f.es7,0) as ds7,isnull(f.es8,0) as ds8,
					isnull(f.es9,0) as ds9,isnull(f.es10,0) as ds10,isnull(f.es11,0) as ds11,isnull(f.es12,0) as ds12,
					isnull(f.es13,0) as ds13,isnull(f.es14,0) as ds14,isnull(f.es15,0) as ds15,isnull(f.es16,0) as ds16 
					from 


					(SELECT A.PRODUTO,A.COR_PRODUTO,A.FILIAL,0 as numero_tickets,0 as total_venda,
					0 as total_qtde_venda,
					0 as ve1,0 as ve2,0 as ve3,0 as ve4,0 as ve5,
					0 as ve6,0 as ve7,0 as ve8,0 as ve9,0 as ve10,
					0 as ve11,0 as ve12,0 as ve13,0 as ve14,0 as ve15,0 as ve16  
					FROM TMPANM_RESUMO_TROCAS_PERIODO A 
					LEFT JOIN TMPANM_RESUMO_VENDAS_PERIODO B 
					ON A.FILIAL=B.FILIAL
					AND A.PRODUTO=B.PRODUTO
					AND A.COR_PRODUTO=B.COR_PRODUTO
					WHERE B.PRODUTO IS NULL	) a
					join 
					TMPANM_RESUMO_TROCAS_PERIODO T
					on a.filial=T.filial
					and a.produto=T.produto	
					and a.cor_produto=T.cor_produto

					join produtos b 
					on a.produto=b.produto 
					join produto_cores c 
					on a.produto=c.produto
					and a.cor_produto=c.cor_produto 
					left join 
						(select a.produto,a.primeira_entrada,a.cor_produto,filial,a.estoque,
						a.es1,a.es2,a.es3,a.es4,a.es5,a.es6,a.es7,a.es8,
						a.es9,a.es10,a.es11,a.es12,a.es13,a.es14,a.es15,a.es16  
						from estoque_produtos a) d 
					on  a.produto=d.produto 
					and a.cor_produto=d.cor_produto 
					and a.filial=d.filial 
					left join 
						(select a.produto,a.cor_produto,filial,a.qtde_transito,
						a.t1,a.t2,a.t3,a.t4,a.t5,a.t6,a.t7,a.t8,
						a.t9,a.t10,a.t11,a.t12,a.t13,a.t14,a.t15,a.t16 
						from w_estoque_em_transito a) e 
					on  a.produto=e.produto 
					and a.cor_produto=e.cor_produto 
					and a.filial=e.filial 
					left join 
						(select a.produto,a.cor_produto,filial,a.estoque_disponivel,
						a.es1 ,a.es2 ,a.es3 ,a.es4 ,
						a.es5 ,a.es6 ,a.es7 ,a.es8 ,
						a.es9 ,a.es10 ,a.es11 ,a.es12 ,
						a.es13 ,a.es14 ,a.es15 ,a.es16 
						from w_estoque_produtos_transito a ) f 
					on  a.produto=f.produto 
					and a.cor_produto=f.cor_produto 
					and a.filial=f.filial 
					
					left join (select produto,preco1 from produtos_precos where codigo_tab_preco='CT') preco_ct
					ON a.produto=preco_ct.produto
					
					left join (select produto,preco1 from produtos_precos where codigo_tab_preco='V') preco_v
					ON a.produto=preco_v.produto

					left join (select produto,preco1 from produtos_precos where codigo_tab_preco='VO') preco_vo
					ON a.produto=preco_vo.produto ) A

					
					
					order by a.produto,a.cor_produto,a.filial
	

				endtext



				text to	xsel2 noshow	textmerge

					IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='TMPANM_RESUMO_VENDAS_PERIODO')
					DROP TABLE TMPANM_RESUMO_VENDAS_PERIODO
				
					IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='TMPANM_RESUMO_TROCAS_PERIODO')
					DROP TABLE TMPANM_RESUMO_TROCAS_PERIODO
					
					select a.produto,a.cor_produto,
					a.filial,sum(a.numero_tickets) as numero_tickets,sum(a.total_venda) as total_venda,
					sum(a.total_qtde_venda) as total_qtde_venda,
					sum(a.ve1) as ve1,sum(a.ve2) as ve2,sum(a.ve3) as ve3,sum(a.ve4) as ve4,sum(a.ve5) as ve5,
					sum(a.ve6) as ve6,sum(a.ve7) as ve7,sum(a.ve8) as ve8,sum(a.ve9) as ve9,sum(a.ve10) as ve10,
					sum(a.ve11) as ve11,sum(a.ve12) as ve12,sum(a.ve13) as ve13,sum(a.ve14) as ve14,sum(a.ve15) as ve15,sum(a.ve16) as ve16 
					INTO TMPANM_RESUMO_VENDAS_PERIODO
					from loja_resumo_produto a 
					join produtos b 
					on a.produto=b.produto 					
					where a.data_venda between '<<xdata_ini>>' and '<<xdata_fim>>'
					and <<STRTRAN(STRTRAN( IIF(EMPTY(o_300012.lx_FORM1.lx_pageframe1.page2.Lx_filtro_produtos1.Lx_filtro_1.p_where),' 1=1', o_300012.lx_FORM1.lx_pageframe1.page2.Lx_filtro_produtos1.Lx_filtro_1.p_where),'produtos.','b.'),'PRODUTOS.','b.' )>>					
					group by a.produto,a.cor_produto,
					a.filial
					
					select a.produto,a.cor_produto,
					a.filial,sum(a.numero_tickets) as numero_tickets_troca,sum(total_troca) as total_troca,
					sum(a.total_qtde_troca) as total_qtde_troca,
					sum(a.tr1) as tr1,sum(a.tr2) as tr2,sum(a.tr3) as tr3,sum(a.tr4) as tr4,sum(a.tr5) as tr5,
					sum(a.tr6) as tr6,sum(a.tr7) as tr7,sum(a.tr8) as tr8,sum(a.tr9) as tr9,sum(a.tr10) as tr10,
					sum(a.tr11) as tr11,sum(a.tr12) as tr12,sum(a.tr13) as tr13,sum(a.tr14) as tr14,sum(a.tr15) as tr15,sum(a.tr16) as tr16 
					INTO TMPANM_RESUMO_TROCAS_PERIODO
					from loja_resumo_troca a 
					join produtos b 
					on a.produto=b.produto 					
					where a.data_venda between '<<xdata_ini>>' and '<<xdata_fim>>'
					and <<STRTRAN(STRTRAN( IIF(EMPTY(o_300012.lx_FORM1.lx_pageframe1.page2.Lx_filtro_produtos1.Lx_filtro_1.p_where),' 1=1', o_300012.lx_FORM1.lx_pageframe1.page2.Lx_filtro_produtos1.Lx_filtro_1.p_where),'produtos.','b.'),'PRODUTOS.','b.' )>>					
					group by a.produto,a.cor_produto,
					a.filial
					
					SELECT A.COLECAO,A.LINHA,A.GRUPO_PRODUTO,FILIAL,PRODUTO,DESC_PRODUTO,SUM(total_qtde_venda) AS total_qtde_venda,SUM(total_qtde_troca) AS total_qtde_troca,
					SUM(total_qtde_liq) AS total_qtde_liq,SUM(total_venda) AS TOTAL_VENDA,SUM(total_TROCA) AS TOTAL_TROCA,
					SUM(valor_venda_liq) AS VALOR_VENDA_LIQ,
					MAX(preco_custo) AS preco_custo,MAX(preco_varejo) AS preco_varejo,MAX(preco_varejo_original) AS preco_varejo_original,
					SUM(estoque) AS ESTOQUE	
					FROM 
					(
						SELECT A.* FROM 
						(select b.linha,b.grupo_produto,b.colecao,a.produto,b.desc_produto,a.cor_produto,c.desc_cor_produto,a.filial,a.numero_tickets as numero_tickets_venda,
						isnull(T.numero_tickets_troca,0) as numero_tickets_troca,  
						isnull(a.total_venda,0) as total_venda,  isnull(t.total_troca*-1,0) as total_troca,
						isnull(a.total_venda,0)-isnull(t.total_troca,0) as valor_venda_liq,
						a.total_qtde_venda,isnull(T.total_qtde_troca*-1,0) as total_qtde_troca,a.total_qtde_venda-isnull(T.total_qtde_troca,0) as total_qtde_liq,
						ISNULL(preco_ct.preco1,0) as preco_custo,ISNULL(preco_v.preco1,0) as preco_varejo,
						ISNULL(preco_vo.preco1,0) as preco_varejo_original,
						a.ve1,a.ve2,a.ve3,a.ve4,a.ve5,a.ve6,a.ve7,a.ve8,
						a.ve9,a.ve10,a.ve11,a.ve12,a.ve13,a.ve14,a.ve15,a.ve16 ,
						isnull(T.tr1*-1,0) as tr1,isnull(T.tr2*-1,0) as tr2,isnull(T.tr3*-1,0) as tr3,isnull(T.tr4*-1,0) as tr4,isnull(T.tr5*-1,0) as tr5,
						isnull(T.tr6*-1,0) as tr6,isnull(T.tr7*-1,0) as tr7,isnull(T.tr8*-1,0) as tr8,isnull(T.tr9*-1,0) as tr9,isnull(T.tr10*-1,0) as tr10,
						isnull(T.tr11*-1,0) as tr11,
						isnull(T.tr12*-1,0) as tr12,isnull(T.tr13*-1,0) as tr13,isnull(T.tr14*-1,0) as tr14,isnull(T.tr15*-1,0) as tr15,isnull(T.tr16*-1,0) as tr16,
						isnull(d.estoque,0) as estoque,
						isnull(d.es1,0) as es1,isnull(d.es2,0) as es2,isnull(d.es3,0) as es3,isnull(d.es4,0) as es4,
						isnull(d.es5,0) as es5,isnull(d.es6,0) as es6,isnull(d.es7,0) as es7,isnull(d.es8,0) as es8,
						isnull(d.es9,0) as es9,isnull(d.es10,0) as es10,isnull(d.es11,0) as es11,isnull(d.es12,0) as es12,
						isnull(d.es13,0) as es13,isnull(d.es14,0) as es14,isnull(d.es15,0) as es15,isnull(d.es16,0) as es16 , 
						isnull(e.qtde_transito,0) as qtde_transito,
						isnull(e.t1,0) as t1,isnull(e.t2,0) as t2,isnull(e.t3,0) as t3,isnull(e.t4,0) as t4,
						isnull(e.t5,0) as t5,isnull(e.t6,0) as t6,isnull(e.t7,0) as t7,isnull(e.t8,0) as t8,
						isnull(e.t9,0) as t9,isnull(e.t10,0) as t10,isnull(e.t11,0) as t11,isnull(e.t12,0) as t12,
						isnull(e.t13,0) as t13,isnull(e.t14,0) as t14,isnull(e.t15,0) as t15,isnull(e.t16,0) as t16 ,
						isnull(f.estoque_disponivel,0) as estoque_disponivel,
						isnull(f.es1,0) as ds1,isnull(f.es2,0) as ds2,isnull(f.es3,0) as ds3,isnull(f.es4,0) as ds4,
						isnull(f.es5,0) as ds5,isnull(f.es6,0) as ds6,isnull(f.es7,0) as ds7,isnull(f.es8,0) as ds8,
						isnull(f.es9,0) as ds9,isnull(f.es10,0) as ds10,isnull(f.es11,0) as ds11,isnull(f.es12,0) as ds12,
						isnull(f.es13,0) as ds13,isnull(f.es14,0) as ds14,isnull(f.es15,0) as ds15,isnull(f.es16,0) as ds16 
						from 
						TMPANM_RESUMO_VENDAS_PERIODO a
						left join 
						TMPANM_RESUMO_TROCAS_PERIODO T
						on a.filial=T.filial
						and a.produto=T.produto	
						and a.cor_produto=T.cor_produto

						join produtos b 
						on a.produto=b.produto 
						join produto_cores c 
						on a.produto=c.produto
						and a.cor_produto=c.cor_produto 
						left join 
							(select a.produto,a.primeira_entrada,a.cor_produto,filial,a.estoque,
							a.es1,a.es2,a.es3,a.es4,a.es5,a.es6,a.es7,a.es8,
							a.es9,a.es10,a.es11,a.es12,a.es13,a.es14,a.es15,a.es16  
							from estoque_produtos a) d 
						on  a.produto=d.produto 
						and a.cor_produto=d.cor_produto 
						and a.filial=d.filial 
						left join 
							(select a.produto,a.cor_produto,filial,a.qtde_transito,
							a.t1,a.t2,a.t3,a.t4,a.t5,a.t6,a.t7,a.t8,
							a.t9,a.t10,a.t11,a.t12,a.t13,a.t14,a.t15,a.t16 
							from w_estoque_em_transito a) e 
						on  a.produto=e.produto 
						and a.cor_produto=e.cor_produto 
						and a.filial=e.filial 
						left join 
							(select a.produto,a.cor_produto,filial,a.estoque_disponivel,
							a.es1 ,a.es2 ,a.es3 ,a.es4 ,
							a.es5 ,a.es6 ,a.es7 ,a.es8 ,
							a.es9 ,a.es10 ,a.es11 ,a.es12 ,
							a.es13 ,a.es14 ,a.es15 ,a.es16 
							from w_estoque_produtos_transito a ) f 
						on  a.produto=f.produto 
						and a.cor_produto=f.cor_produto 
						and a.filial=f.filial 
						
						left join (select produto,preco1 from produtos_precos where codigo_tab_preco='CT') preco_ct
						ON a.produto=preco_ct.produto
						
						left join (select produto,preco1 from produtos_precos where codigo_tab_preco='V') preco_v
						ON a.produto=preco_v.produto

						left join (select produto,preco1 from produtos_precos where codigo_tab_preco='VO') preco_vo
						ON a.produto=preco_vo.produto


				UNION ALL


					select b.linha,b.grupo_produto,b.colecao,a.produto,b.desc_produto,a.cor_produto,c.desc_cor_produto,a.filial,a.numero_tickets as numero_tickets_venda,
					isnull(T.numero_tickets_troca,0) as numero_tickets_troca,  
					isnull(a.total_venda,0) as total_venda,  isnull(t.total_troca*-1,0) as total_troca,
					isnull(a.total_venda,0)-isnull(t.total_troca,0) as valor_venda_liq,
					a.total_qtde_venda,isnull(T.total_qtde_troca*-1,0) as total_qtde_troca,a.total_qtde_venda-isnull(T.total_qtde_troca,0) as total_qtde_liq,
					ISNULL(preco_ct.preco1,0) as preco_custo,ISNULL(preco_v.preco1,0) as preco_varejo,
					ISNULL(preco_vo.preco1,0) as preco_varejo_original,
					a.ve1,a.ve2,a.ve3,a.ve4,a.ve5,a.ve6,a.ve7,a.ve8,
					a.ve9,a.ve10,a.ve11,a.ve12,a.ve13,a.ve14,a.ve15,a.ve16 ,
					isnull(T.tr1*-1,0) as tr1,isnull(T.tr2*-1,0) as tr2,isnull(T.tr3*-1,0) as tr3,isnull(T.tr4*-1,0) as tr4,isnull(T.tr5*-1,0) as tr5,
					isnull(T.tr6*-1,0) as tr6,isnull(T.tr7*-1,0) as tr7,isnull(T.tr8*-1,0) as tr8,isnull(T.tr9*-1,0) as tr9,isnull(T.tr10*-1,0) as tr10,
					isnull(T.tr11*-1,0) as tr11,
					isnull(T.tr12*-1,0) as tr12,isnull(T.tr13*-1,0) as tr13,isnull(T.tr14*-1,0) as tr14,isnull(T.tr15*-1,0) as tr15,isnull(T.tr16*-1,0) as tr16,
					isnull(d.estoque,0) as estoque,
					isnull(d.es1,0) as es1,isnull(d.es2,0) as es2,isnull(d.es3,0) as es3,isnull(d.es4,0) as es4,
					isnull(d.es5,0) as es5,isnull(d.es6,0) as es6,isnull(d.es7,0) as es7,isnull(d.es8,0) as es8,
					isnull(d.es9,0) as es9,isnull(d.es10,0) as es10,isnull(d.es11,0) as es11,isnull(d.es12,0) as es12,
					isnull(d.es13,0) as es13,isnull(d.es14,0) as es14,isnull(d.es15,0) as es15,isnull(d.es16,0) as es16 , 
					isnull(e.qtde_transito,0) as qtde_transito,
					isnull(e.t1,0) as t1,isnull(e.t2,0) as t2,isnull(e.t3,0) as t3,isnull(e.t4,0) as t4,
					isnull(e.t5,0) as t5,isnull(e.t6,0) as t6,isnull(e.t7,0) as t7,isnull(e.t8,0) as t8,
					isnull(e.t9,0) as t9,isnull(e.t10,0) as t10,isnull(e.t11,0) as t11,isnull(e.t12,0) as t12,
					isnull(e.t13,0) as t13,isnull(e.t14,0) as t14,isnull(e.t15,0) as t15,isnull(e.t16,0) as t16 ,
					isnull(f.estoque_disponivel,0) as estoque_disponivel,
					isnull(f.es1,0) as ds1,isnull(f.es2,0) as ds2,isnull(f.es3,0) as ds3,isnull(f.es4,0) as ds4,
					isnull(f.es5,0) as ds5,isnull(f.es6,0) as ds6,isnull(f.es7,0) as ds7,isnull(f.es8,0) as ds8,
					isnull(f.es9,0) as ds9,isnull(f.es10,0) as ds10,isnull(f.es11,0) as ds11,isnull(f.es12,0) as ds12,
					isnull(f.es13,0) as ds13,isnull(f.es14,0) as ds14,isnull(f.es15,0) as ds15,isnull(f.es16,0) as ds16 
					from 


					(SELECT A.PRODUTO,A.COR_PRODUTO,A.FILIAL,0 as numero_tickets,
					0 as total_qtde_venda,0 AS TOTAL_VENDA,
					0 as ve1,0 as ve2,0 as ve3,0 as ve4,0 as ve5,
					0 as ve6,0 as ve7,0 as ve8,0 as ve9,0 as ve10,
					0 as ve11,0 as ve12,0 as ve13,0 as ve14,0 as ve15,0 as ve16  
					FROM TMPANM_RESUMO_TROCAS_PERIODO A 
					LEFT JOIN TMPANM_RESUMO_VENDAS_PERIODO B 
					ON A.FILIAL=B.FILIAL
					AND A.PRODUTO=B.PRODUTO
					AND A.COR_PRODUTO=B.COR_PRODUTO
					WHERE B.PRODUTO IS NULL	) a
					join 
					TMPANM_RESUMO_TROCAS_PERIODO T
					on a.filial=T.filial
					and a.produto=T.produto	
					and a.cor_produto=T.cor_produto

					join produtos b 
					on a.produto=b.produto 
					join produto_cores c 
					on a.produto=c.produto
					and a.cor_produto=c.cor_produto 
					left join 
						(select a.produto,a.primeira_entrada,a.cor_produto,filial,a.estoque,
						a.es1,a.es2,a.es3,a.es4,a.es5,a.es6,a.es7,a.es8,
						a.es9,a.es10,a.es11,a.es12,a.es13,a.es14,a.es15,a.es16  
						from estoque_produtos a) d 
					on  a.produto=d.produto 
					and a.cor_produto=d.cor_produto 
					and a.filial=d.filial 
					left join 
						(select a.produto,a.cor_produto,filial,a.qtde_transito,
						a.t1,a.t2,a.t3,a.t4,a.t5,a.t6,a.t7,a.t8,
						a.t9,a.t10,a.t11,a.t12,a.t13,a.t14,a.t15,a.t16 
						from w_estoque_em_transito a) e 
					on  a.produto=e.produto 
					and a.cor_produto=e.cor_produto 
					and a.filial=e.filial 
					left join 
						(select a.produto,a.cor_produto,filial,a.estoque_disponivel,
						a.es1 ,a.es2 ,a.es3 ,a.es4 ,
						a.es5 ,a.es6 ,a.es7 ,a.es8 ,
						a.es9 ,a.es10 ,a.es11 ,a.es12 ,
						a.es13 ,a.es14 ,a.es15 ,a.es16 
						from w_estoque_produtos_transito a ) f 
					on  a.produto=f.produto 
					and a.cor_produto=f.cor_produto 
					and a.filial=f.filial 
					
					left join (select produto,preco1 from produtos_precos where codigo_tab_preco='CT') preco_ct
					ON a.produto=preco_ct.produto
					
					left join (select produto,preco1 from produtos_precos where codigo_tab_preco='V') preco_v
					ON a.produto=preco_v.produto

					left join (select produto,preco1 from produtos_precos where codigo_tab_preco='VO') preco_vo
					ON a.produto=preco_vo.produto ) A
					
					) A
					GROUP BY A.COLECAO,A.LINHA,A.GRUPO_PRODUTO,A.PRODUTO,A.FILIAL,DESC_PRODUTO

					order by A.COLECAO,A.LINHA,A.GRUPO_PRODUTO,a.produto,a.filial




				ENDTEXT 


				TEXT TO XSEL3 NOSHOW TEXTMERGE
				
					IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='TMPANM_RESUMO_VENDAS_PERIODO')
					DROP TABLE TMPANM_RESUMO_VENDAS_PERIODO
				
					IF EXISTS (SELECT 1 FROM SYSOBJECTS WHERE NAME ='TMPANM_RESUMO_TROCAS_PERIODO')
					DROP TABLE TMPANM_RESUMO_TROCAS_PERIODO
					
					select a.produto,a.cor_produto,
					a.filial,sum(a.numero_tickets) as numero_tickets,sum(a.total_venda) as total_venda,
					sum(a.total_qtde_venda) as total_qtde_venda,
					sum(a.ve1) as ve1,sum(a.ve2) as ve2,sum(a.ve3) as ve3,sum(a.ve4) as ve4,sum(a.ve5) as ve5,
					sum(a.ve6) as ve6,sum(a.ve7) as ve7,sum(a.ve8) as ve8,sum(a.ve9) as ve9,sum(a.ve10) as ve10,
					sum(a.ve11) as ve11,sum(a.ve12) as ve12,sum(a.ve13) as ve13,sum(a.ve14) as ve14,sum(a.ve15) as ve15,sum(a.ve16) as ve16 
					INTO TMPANM_RESUMO_VENDAS_PERIODO
					from loja_resumo_produto a 
					join produtos b 
					on a.produto=b.produto 					
					where a.data_venda between '<<xdata_ini>>' and '<<xdata_fim>>'
					and <<STRTRAN(STRTRAN( IIF(EMPTY(o_300012.lx_FORM1.lx_pageframe1.page2.Lx_filtro_produtos1.Lx_filtro_1.p_where),' 1=1', o_300012.lx_FORM1.lx_pageframe1.page2.Lx_filtro_produtos1.Lx_filtro_1.p_where),'produtos.','b.'),'PRODUTOS.','b.' )>>										
					group by a.produto,a.cor_produto,
					a.filial
					
					select a.produto,a.cor_produto,
					a.filial,sum(a.numero_tickets) as numero_tickets_troca,sum(total_troca) as total_troca,
					sum(a.total_qtde_troca) as total_qtde_troca,
					sum(a.tr1) as tr1,sum(a.tr2) as tr2,sum(a.tr3) as tr3,sum(a.tr4) as tr4,sum(a.tr5) as tr5,
					sum(a.tr6) as tr6,sum(a.tr7) as tr7,sum(a.tr8) as tr8,sum(a.tr9) as tr9,sum(a.tr10) as tr10,
					sum(a.tr11) as tr11,sum(a.tr12) as tr12,sum(a.tr13) as tr13,sum(a.tr14) as tr14,sum(a.tr15) as tr15,sum(a.tr16) as tr16 
					INTO TMPANM_RESUMO_TROCAS_PERIODO
					from loja_resumo_troca a 
					join produtos b 
					on a.produto=b.produto 					
					where a.data_venda between '<<xdata_ini>>' and '<<xdata_fim>>'
					and <<STRTRAN(STRTRAN( IIF(EMPTY(o_300012.lx_FORM1.lx_pageframe1.page2.Lx_filtro_produtos1.Lx_filtro_1.p_where),' 1=1', o_300012.lx_FORM1.lx_pageframe1.page2.Lx_filtro_produtos1.Lx_filtro_1.p_where),'produtos.','b.'),'PRODUTOS.','b.' )>>					
					group by a.produto,a.cor_produto,
					a.filial
					
					SELECT A.COLECAO,A.LINHA,A.GRUPO_PRODUTO,PRODUTO,DESC_PRODUTO,SUM(total_qtde_venda) AS total_qtde_venda,SUM(total_qtde_troca) AS total_qtde_troca,
					SUM(total_qtde_liq) AS total_qtde_liq,SUM(total_venda) AS TOTAL_VENDA,SUM(total_TROCA) AS TOTAL_TROCA,
					SUM(valor_venda_liq) AS VALOR_VENDA_LIQ,
					MAX(preco_custo) AS preco_custo,MAX(preco_varejo) AS preco_varejo,MAX(preco_varejo_original) AS preco_varejo_original,
					SUM(estoque) AS ESTOQUE	
					FROM 
					(
						SELECT A.* FROM 
						(
						select b.linha,b.grupo_produto,b.colecao,a.produto,b.desc_produto,a.cor_produto,c.desc_cor_produto,a.filial,a.numero_tickets as numero_tickets_venda,
						isnull(T.numero_tickets_troca,0) as numero_tickets_troca, 
						isnull(a.total_venda,0) as total_venda,  isnull(t.total_troca*-1,0) as total_troca,
						isnull(a.total_venda,0)-isnull(t.total_troca,0) as valor_venda_liq, 
						a.total_qtde_venda,isnull(T.total_qtde_troca*-1,0) as total_qtde_troca,a.total_qtde_venda-isnull(T.total_qtde_troca,0) as total_qtde_liq,
						ISNULL(preco_ct.preco1,0) as preco_custo,ISNULL(preco_v.preco1,0) as preco_varejo,
						ISNULL(preco_vo.preco1,0) as preco_varejo_original,
						a.ve1,a.ve2,a.ve3,a.ve4,a.ve5,a.ve6,a.ve7,a.ve8,
						a.ve9,a.ve10,a.ve11,a.ve12,a.ve13,a.ve14,a.ve15,a.ve16 ,
						isnull(T.tr1*-1,0) as tr1,isnull(T.tr2*-1,0) as tr2,isnull(T.tr3*-1,0) as tr3,isnull(T.tr4*-1,0) as tr4,isnull(T.tr5*-1,0) as tr5,
						isnull(T.tr6*-1,0) as tr6,isnull(T.tr7*-1,0) as tr7,isnull(T.tr8*-1,0) as tr8,isnull(T.tr9*-1,0) as tr9,isnull(T.tr10*-1,0) as tr10,
						isnull(T.tr11*-1,0) as tr11,
						isnull(T.tr12*-1,0) as tr12,isnull(T.tr13*-1,0) as tr13,isnull(T.tr14*-1,0) as tr14,isnull(T.tr15*-1,0) as tr15,isnull(T.tr16*-1,0) as tr16,
						isnull(d.estoque,0) as estoque,
						isnull(d.es1,0) as es1,isnull(d.es2,0) as es2,isnull(d.es3,0) as es3,isnull(d.es4,0) as es4,
						isnull(d.es5,0) as es5,isnull(d.es6,0) as es6,isnull(d.es7,0) as es7,isnull(d.es8,0) as es8,
						isnull(d.es9,0) as es9,isnull(d.es10,0) as es10,isnull(d.es11,0) as es11,isnull(d.es12,0) as es12,
						isnull(d.es13,0) as es13,isnull(d.es14,0) as es14,isnull(d.es15,0) as es15,isnull(d.es16,0) as es16 , 
						isnull(e.qtde_transito,0) as qtde_transito,
						isnull(e.t1,0) as t1,isnull(e.t2,0) as t2,isnull(e.t3,0) as t3,isnull(e.t4,0) as t4,
						isnull(e.t5,0) as t5,isnull(e.t6,0) as t6,isnull(e.t7,0) as t7,isnull(e.t8,0) as t8,
						isnull(e.t9,0) as t9,isnull(e.t10,0) as t10,isnull(e.t11,0) as t11,isnull(e.t12,0) as t12,
						isnull(e.t13,0) as t13,isnull(e.t14,0) as t14,isnull(e.t15,0) as t15,isnull(e.t16,0) as t16 ,
						isnull(f.estoque_disponivel,0) as estoque_disponivel,
						isnull(f.es1,0) as ds1,isnull(f.es2,0) as ds2,isnull(f.es3,0) as ds3,isnull(f.es4,0) as ds4,
						isnull(f.es5,0) as ds5,isnull(f.es6,0) as ds6,isnull(f.es7,0) as ds7,isnull(f.es8,0) as ds8,
						isnull(f.es9,0) as ds9,isnull(f.es10,0) as ds10,isnull(f.es11,0) as ds11,isnull(f.es12,0) as ds12,
						isnull(f.es13,0) as ds13,isnull(f.es14,0) as ds14,isnull(f.es15,0) as ds15,isnull(f.es16,0) as ds16 
						from 
						TMPANM_RESUMO_VENDAS_PERIODO a
						left join 
						TMPANM_RESUMO_TROCAS_PERIODO T
						on a.filial=T.filial
						and a.produto=T.produto	
						and a.cor_produto=T.cor_produto

						join produtos b 
						on a.produto=b.produto 
						join produto_cores c 
						on a.produto=c.produto
						and a.cor_produto=c.cor_produto 
						left join 
							(select a.produto,a.primeira_entrada,a.cor_produto,filial,a.estoque,
							a.es1,a.es2,a.es3,a.es4,a.es5,a.es6,a.es7,a.es8,
							a.es9,a.es10,a.es11,a.es12,a.es13,a.es14,a.es15,a.es16  
							from estoque_produtos a) d 
						on  a.produto=d.produto 
						and a.cor_produto=d.cor_produto 
						and a.filial=d.filial 
						left join 
							(select a.produto,a.cor_produto,filial,a.qtde_transito,
							a.t1,a.t2,a.t3,a.t4,a.t5,a.t6,a.t7,a.t8,
							a.t9,a.t10,a.t11,a.t12,a.t13,a.t14,a.t15,a.t16 
							from w_estoque_em_transito a) e 
						on  a.produto=e.produto 
						and a.cor_produto=e.cor_produto 
						and a.filial=e.filial 
						left join 
							(select a.produto,a.cor_produto,filial,a.estoque_disponivel,
							a.es1 ,a.es2 ,a.es3 ,a.es4 ,
							a.es5 ,a.es6 ,a.es7 ,a.es8 ,
							a.es9 ,a.es10 ,a.es11 ,a.es12 ,
							a.es13 ,a.es14 ,a.es15 ,a.es16 
							from w_estoque_produtos_transito a ) f 
						on  a.produto=f.produto 
						and a.cor_produto=f.cor_produto 
						and a.filial=f.filial 
						
						left join (select produto,preco1 from produtos_precos where codigo_tab_preco='CT') preco_ct
						ON a.produto=preco_ct.produto
						
						left join (select produto,preco1 from produtos_precos where codigo_tab_preco='V') preco_v
						ON a.produto=preco_v.produto

						left join (select produto,preco1 from produtos_precos where codigo_tab_preco='VO') preco_vo
						ON a.produto=preco_vo.produto
					

				UNION ALL


					select b.linha,b.grupo_produto,b.colecao,a.produto,b.desc_produto,a.cor_produto,c.desc_cor_produto,a.filial,a.numero_tickets as numero_tickets_venda,
					isnull(T.numero_tickets_troca,0) as numero_tickets_troca,  
					isnull(a.total_venda,0) as total_venda,  isnull(t.total_troca*-1,0) as total_troca,
					isnull(a.total_venda,0)-isnull(t.total_troca,0) as valor_venda_liq, 
					a.total_qtde_venda,isnull(T.total_qtde_troca*-1,0) as total_qtde_troca,a.total_qtde_venda-isnull(T.total_qtde_troca,0) as total_qtde_liq,
					ISNULL(preco_ct.preco1,0) as preco_custo,ISNULL(preco_v.preco1,0) as preco_varejo,
					ISNULL(preco_vo.preco1,0) as preco_varejo_original,
					a.ve1,a.ve2,a.ve3,a.ve4,a.ve5,a.ve6,a.ve7,a.ve8,
					a.ve9,a.ve10,a.ve11,a.ve12,a.ve13,a.ve14,a.ve15,a.ve16 ,
					isnull(T.tr1*-1,0) as tr1,isnull(T.tr2*-1,0) as tr2,isnull(T.tr3*-1,0) as tr3,isnull(T.tr4*-1,0) as tr4,isnull(T.tr5*-1,0) as tr5,
					isnull(T.tr6*-1,0) as tr6,isnull(T.tr7*-1,0) as tr7,isnull(T.tr8*-1,0) as tr8,isnull(T.tr9*-1,0) as tr9,isnull(T.tr10*-1,0) as tr10,
					isnull(T.tr11*-1,0) as tr11,
					isnull(T.tr12*-1,0) as tr12,isnull(T.tr13*-1,0) as tr13,isnull(T.tr14*-1,0) as tr14,isnull(T.tr15*-1,0) as tr15,isnull(T.tr16*-1,0) as tr16,
					isnull(d.estoque,0) as estoque,
					isnull(d.es1,0) as es1,isnull(d.es2,0) as es2,isnull(d.es3,0) as es3,isnull(d.es4,0) as es4,
					isnull(d.es5,0) as es5,isnull(d.es6,0) as es6,isnull(d.es7,0) as es7,isnull(d.es8,0) as es8,
					isnull(d.es9,0) as es9,isnull(d.es10,0) as es10,isnull(d.es11,0) as es11,isnull(d.es12,0) as es12,
					isnull(d.es13,0) as es13,isnull(d.es14,0) as es14,isnull(d.es15,0) as es15,isnull(d.es16,0) as es16 , 
					isnull(e.qtde_transito,0) as qtde_transito,
					isnull(e.t1,0) as t1,isnull(e.t2,0) as t2,isnull(e.t3,0) as t3,isnull(e.t4,0) as t4,
					isnull(e.t5,0) as t5,isnull(e.t6,0) as t6,isnull(e.t7,0) as t7,isnull(e.t8,0) as t8,
					isnull(e.t9,0) as t9,isnull(e.t10,0) as t10,isnull(e.t11,0) as t11,isnull(e.t12,0) as t12,
					isnull(e.t13,0) as t13,isnull(e.t14,0) as t14,isnull(e.t15,0) as t15,isnull(e.t16,0) as t16 ,
					isnull(f.estoque_disponivel,0) as estoque_disponivel,
					isnull(f.es1,0) as ds1,isnull(f.es2,0) as ds2,isnull(f.es3,0) as ds3,isnull(f.es4,0) as ds4,
					isnull(f.es5,0) as ds5,isnull(f.es6,0) as ds6,isnull(f.es7,0) as ds7,isnull(f.es8,0) as ds8,
					isnull(f.es9,0) as ds9,isnull(f.es10,0) as ds10,isnull(f.es11,0) as ds11,isnull(f.es12,0) as ds12,
					isnull(f.es13,0) as ds13,isnull(f.es14,0) as ds14,isnull(f.es15,0) as ds15,isnull(f.es16,0) as ds16 
					from 


					(SELECT A.PRODUTO,A.COR_PRODUTO,A.FILIAL,0 as numero_tickets,
					0 as total_qtde_venda,0 AS TOTAL_VENDA,
					0 as ve1,0 as ve2,0 as ve3,0 as ve4,0 as ve5,
					0 as ve6,0 as ve7,0 as ve8,0 as ve9,0 as ve10,
					0 as ve11,0 as ve12,0 as ve13,0 as ve14,0 as ve15,0 as ve16  
					FROM TMPANM_RESUMO_TROCAS_PERIODO A 
					LEFT JOIN TMPANM_RESUMO_VENDAS_PERIODO B 
					ON A.FILIAL=B.FILIAL
					AND A.PRODUTO=B.PRODUTO
					AND A.COR_PRODUTO=B.COR_PRODUTO
					WHERE B.PRODUTO IS NULL	) a
					join 
					TMPANM_RESUMO_TROCAS_PERIODO T
					on a.filial=T.filial
					and a.produto=T.produto	
					and a.cor_produto=T.cor_produto

					join produtos b 
					on a.produto=b.produto 
					join produto_cores c 
					on a.produto=c.produto
					and a.cor_produto=c.cor_produto 
					left join 
						(select a.produto,a.primeira_entrada,a.cor_produto,filial,a.estoque,
						a.es1,a.es2,a.es3,a.es4,a.es5,a.es6,a.es7,a.es8,
						a.es9,a.es10,a.es11,a.es12,a.es13,a.es14,a.es15,a.es16  
						from estoque_produtos a) d 
					on  a.produto=d.produto 
					and a.cor_produto=d.cor_produto 
					and a.filial=d.filial 
					left join 
						(select a.produto,a.cor_produto,filial,a.qtde_transito,
						a.t1,a.t2,a.t3,a.t4,a.t5,a.t6,a.t7,a.t8,
						a.t9,a.t10,a.t11,a.t12,a.t13,a.t14,a.t15,a.t16 
						from w_estoque_em_transito a) e 
					on  a.produto=e.produto 
					and a.cor_produto=e.cor_produto 
					and a.filial=e.filial 
					left join 
						(select a.produto,a.cor_produto,filial,a.estoque_disponivel,
						a.es1 ,a.es2 ,a.es3 ,a.es4 ,
						a.es5 ,a.es6 ,a.es7 ,a.es8 ,
						a.es9 ,a.es10 ,a.es11 ,a.es12 ,
						a.es13 ,a.es14 ,a.es15 ,a.es16 
						from w_estoque_produtos_transito a ) f 
					on  a.produto=f.produto 
					and a.cor_produto=f.cor_produto 
					and a.filial=f.filial 
					
					left join (select produto,preco1 from produtos_precos where codigo_tab_preco='CT') preco_ct
					ON a.produto=preco_ct.produto
					
					left join (select produto,preco1 from produtos_precos where codigo_tab_preco='V') preco_v
					ON a.produto=preco_v.produto

					left join (select produto,preco1 from produtos_precos where codigo_tab_preco='VO') preco_vo
					ON a.produto=preco_vo.produto ) A

				) A

					GROUP BY A.COLECAO,A.LINHA,A.GRUPO_PRODUTO,A.PRODUTO,DESC_PRODUTO
					
					order by A.COLECAO,A.LINHA,A.GRUPO_PRODUTO,a.produto

					
				ENDTEXT 
				



				*Abertura do arquivo de exportacao
				
				f_prog_bar("Exportando Itens...")
				
				
				f_select(xsel1,"curVendasExp")


				xarq = 'c:\temp\vendas_'+xlabel_arq1+'.xls'
				if empty(xarq)
					return (.f.)
				endif

				SELECT curVendasExp
				COPY TO &xarq XLS 

				if File('c:\temp\vendas_'+xlabel_arq1+'.xls')
					f_Msg(['O arquivo '+xarq+' foi gerado com sucesso!', 0 + 48, 'Atenção'])
				Else
					f_Msg(['Falha na exportação do arquivo ', 0 + 48, 'Atenção'])	
				Endif



				f_select(xsel2,"curVendasExp")


				xarq = 'c:\temp\vendas_'+xlabel_arq2+'.xls'
				if empty(xarq)
					return (.f.)
				endif

				SELECT curVendasExp
				COPY TO &xarq XLS 

				if File('c:\temp\vendas_'+xlabel_arq2+'.xls')
					f_Msg(['O arquivo '+xarq+' foi gerado com sucesso!', 0 + 48, 'Atenção'])
				Else
					f_Msg(['Falha na exportação do arquivo ', 0 + 48, 'Atenção'])	
				Endif



				f_select(xsel3,"curVendasExp")


				xarq = 'c:\temp\vendas_'+xlabel_arq3+'.xls'
				if empty(xarq)
					return (.f.)
				endif

				SELECT curVendasExp
				COPY TO &xarq XLS 

				if File('c:\temp\vendas_'+xlabel_arq3+'.xls')
					f_Msg(['O arquivo '+xarq+' foi gerado com sucesso!', 0 + 48, 'Atenção'])
				Else
					f_Msg(['Falha na exportação do arquivo ', 0 + 48, 'Atenção'])	
				Endif



				f_prog_bar()


		*!*			* Fim Exportacao Vendas



	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_exporta_vendas
**************************************************
