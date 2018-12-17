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
				
				PUBLIC xpreco
						
				*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_estoque_sai_mat_00   
				sele v_produtos_00  
				xalias_pai=alias()

  				oCur = getcursoradapter(xalias_pai)
				oCur.addbufferfield("PRODUTOS.ANM_MARCA", "C(25)",.T., "ANM_MARCA", "PRODUTOS.ANM_MARCA")
				*oCur.addbufferfield("PROP_PRODUTOS.VALOR_PROPRIEDADE", "C(25)",.T., "ANM_PROPRIEDADE", "PROP_PRODUTOS.VALOR_PROPRIEDADE")
				oCur.confirmstructurechanges() 	
				**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 
				Thisformset.L_limpa()
				
						thisformset.lx_FORM1.LX_PAGEFRAME1.page1.PgDadosProdutos.page1.addobject("Anm_ComboMarca","Anm_ComboMarca")
						thisformset.lx_FORM1.LX_PAGEFRAME1.page1.PgDadosProdutos.page1.Lx_label17.Caption = 'Marca'
						thisformset.lx_FORM1.lx_PAGEFRAME1.page1.pgDadosProdutos.page1.Lx_combobox4.ColumnWidths="600,50"


				
				case UPPER(xmetodo)=='USR_REFRESH' 
				
				
					xalias=alias()
				
						if type("thisformset.lx_FORM1.LX_PAGEFRAME1.page1.PgDadosProdutos.page1.anm_ComboMarca")<>"U"
							if thisformset.p_tool_status = "P" 
								thisformset.lx_FORM1.LX_PAGEFRAME1.page1.PgDadosProdutos.page1.anm_ComboMarca.RowSourceType = 1
								thisformset.lx_FORM1.LX_PAGEFRAME1.page1.PgDadosProdutos.page1.anm_ComboMarca.refresh()
							else	
								thisformset.lx_FORM1.LX_PAGEFRAME1.page1.PgDadosProdutos.page1.anm_ComboMarca.RowSourceType = 2
								thisformset.lx_FORM1.LX_PAGEFRAME1.page1.PgDadosProdutos.page1.anm_ComboMarca.refresh()
							endif												
						endif
						
						
						TEXT TO xsel_marca TEXTMERGE NOSHOW
			
							select convert(varchar(25),' ') as ANM_MARCA 
							union all
							select convert( varchar(25),valor_propriedade) as anm_marca 
							from propriedade_valida where propriedade='00063'		
						
						ENDTEXT
						
						IF USED("Cur_anm_marca")
							SELECT Cur_anm_marca
							USE
						ENDIF	
						
						
						f_select(xsel_marca,"Cur_anm_marca")	
						
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
				
				
				
				
				case UPPER(xmetodo) == 'USR_INCLUDE_AFTER' 
				
					IF upper(xnome_obj)== 'PRODUTOS_001' 
				
						sele v_produtos_00
						repla envia_loja_varejo with .t.
						
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



				case UPPER(xmetodo) == 'USR_VALID' 

				xalias=alias()
				
*!*						if upper(xnome_obj)== 'TX_CARTELA' 				
*!*							xalt_cartela=.T.
*!*						endif	
					

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

							text to xsel noshow	
								select count(programacao) as teste from producao_prog_prod 
								where produto = ?v_produtos_00.produto
								and (qtde_saldo_emitir_op > 0 or qtde_em_op > 0 ) 
							endtext	
							
							f_select(xsel,'curCompras')	
							
							Sele curCompras	
							if curCompras.teste = 0
								
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
						
							
						*calcula preco atacado
*!*							if ALLTRIM(thisformset.lx_FORM1.LX_PAGEFRAME1.page1.PgDadosProdutos.page1.anm_ComboMarca.Value) = 'F.Y.I'
*!*								if	upper(xnome_obj)== 'TX_PRECO1'  and	upper(v_produtos_00_precos.codigo_tab_preco)=='VO'
*!*									if messagebox("Deseja Atualizar o Preço dat Tabela Atacado ?",4+32,"Atenção!")=6
*!*										xpreco=preco1
*!*										sele v_produtos_00_precos  
*!*										go top	
*!*										loca for codigo_tab_preco='A'
*!*										if found() 
*!*											repla preco1 with iif(nvl(xpreco,0)=0,0,round(xpreco/2,2))
*!*										endif
*!*									endif		
*!*								endif
*!*								
*!*							else	
							if	upper(xnome_obj)== 'TX_PRECO1'  and	upper(v_produtos_00_precos.codigo_tab_preco)=='VO'
								if messagebox("Deseja Atualizar o Preço da Tabela Atacado ?",4+32,"Atenção!")=6
									xpreco=v_produtos_00_precos.preco1
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
						
					
					
					ELSE 

						*calcula preco atacado
*!*							if ALLTRIM(thisformset.lx_FORM1.lx_pageframe1.page1.PgDadosProdutos.page1.anm_ComboMarca.Value) = 'F.Y.I'	
*!*								if	upper(xnome_obj)== 'TX_PRECO1'  and	upper(v_produtos_00_precos.codigo_tab_preco)=='VO'
*!*									if messagebox("Deseja Atualizar o Preço dat Tabela Atacado ?",4+32,"Atenção!")=6
*!*										xpreco=preco1
*!*										sele v_produtos_00_precos  
*!*										go top	
*!*										loca for codigo_tab_preco='A'
*!*										if found() 
*!*											if v_produtos_00.desc_colecao = 'FYI INV 13'
*!*												repla preco1 with iif(nvl(xpreco,0)=0,0,round(xpreco/2.2,2))
*!*											else	
*!*												repla preco1 with iif(nvl(xpreco,0)=0,0,round(xpreco/2.2,2))
*!*											endif	
*!*										endif
*!*									endif		
*!*								endif					
*!*							else
							if	upper(xnome_obj)== 'TX_PRECO1'  and	upper(v_produtos_00_precos.codigo_tab_preco)=='VO'
								if messagebox("Deseja Atualizar o Preço dat Tabela Atacado ?",4+32,"Atenção!")=6
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


				if	!f_vazio(xalias)	
					Sele &xalias	
				endif	
									
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
				
				IF f_vazio(v_produtos_00.anm_marca)
					MESSAGEBOX("Não é permitido salvar Produto sem cadastrar a Marca !!!!","Atenção !!!",48)
					RETURN .f.
				ENDIF
				
				IF f_vazio(v_produtos_00.desc_prod_nf)
					MESSAGEBOX("Não é permitido salvar Produto sem cadastrar a Desc. Fiscal !!!!","Atenção !!!",48)
					RETURN .f.
				ENDIF	
				
				if !f_vazio(xalias)
					sele &xalias
				endif
				
				
					
				case UPPER(xmetodo) == 'USR_SAVE_AFTER' AND THISFORMSET.P_TOOL_STATUS = 'A'
							
				
				xalias=alias()
				
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
				
				
				if !f_vazio(xalias)
					sele &xalias
				endif	
				
								


				case UPPER(xmetodo) == 'USR_CLEAN_AFTER' AND upper(xnome_obj)== 'PRODUTOS_001' 

				xalt_cartela=.F.
				
				

	
			otherwise
				return .t.				
		endcase
	endproc
enddefine





**************************************************
*-- Class:        lb_confere_entrada(c:\temp\lb_confere_entrada.vcx)
*-- ParentClass:  lx_label (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   04/13/11 01:49:09 PM
*
DEFINE CLASS Anm_ComboMarca AS lx_combobox

BoundColumn = 2
RowSourceType = 0
ControlSource = "v_produtos_00.anm_marca"
Height = 22
TabIndex = 23
Width = 181
ZOrderSet = 80
enabled = .t.


ENDDEFINE
*
*-- EndDefine: lb_confere_entrada 
**************************************************


**************************************************
*-- Class:        cmb_nf_entrada (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS anm_ComboMarca AS lx_combobox
	
	RowSourceType = 2
	RowSource = "Cur_anm_marca.anm_marca"
	ControlSource = "v_produtos_00.anm_marca"
	Height = 22
	TabIndex = 23
	Width = 201
	top = 153
	left = 499
	ZOrderSet = 80
	Name = "anm_ComboMarca "
	Anchor = 0
	Visible = .t.
	Enabled = .t.
	
ENDDEFINE
*
*-- EndDefine: cmb_nf_entrada
**************************************************