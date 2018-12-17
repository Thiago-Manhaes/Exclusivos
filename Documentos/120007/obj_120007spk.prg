* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  06/10/2008                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Inclusao Filtros Custom						                    *
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
					*** lucas *** 16/05/2016
					
					xalias_pai=alias()
					sele v_estoque_produtos_00
						
		  				oCur = getcursoradapter(xalias_pai)
						oCur.addbufferfield("'' AS DESC_PRODUTO_SEGMENTO", "C(25)",.F., "DESC_PRODUTO_SEGMENTO", "DESC_PRODUTO_SEGMENTO")
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
														.col_anm_desc_segmento.ControlSource='v_estoque_produtos_00.desc_produto_segmento'
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
														.col_anm_desc_solucao.ControlSource='v_estoque_produtos_00.DESC_PRODUTO_SOLUCAO'
					endwith
					
					
					*** criação das colunas ***
					
					Thisformset.L_limpa()
					*** lucas *** 16/05/2016
					
					THISFORMSET.lx_FORM1.lx_pageframe1.page2.lx_transito.Value=1
					THISFORMSET.lx_FORM1.lx_pageframe1.page2.lx_transito.l_desenhista_recalculo()
					THISFORMSET.lx_FORM1.lx_pageframe1.page2.tx_Ck_Visualiza.Value=1
					THISFORMSET.lx_FORM1.lx_pageframe1.page2.tx_Ck_Visualiza.l_desenhista_recalculo()
					
					if type("thisformset.lx_FORM1.lx_pageframe1.page2.bt_expnegativo")="U"
						addnewobject(thisformset.lx_FORM1.lx_pageframe1.page2,"bt_expnegativo","bt_expnegativo")
					endif
					
					if !f_vazio(xalias_pai)
						sele &xalias_pai
					endif
				
				case upper(xmetodo) == 'USR_CLEAN_AFTER'
					THISFORMSET.lx_FORM1.lx_pageframe1.page2.lx_transito.Value=1
					THISFORMSET.lx_FORM1.lx_pageframe1.page2.lx_transito.l_desenhista_recalculo()
					THISFORMSET.lx_FORM1.lx_pageframe1.page2.tx_Ck_Visualiza.Value=1
					THISFORMSET.lx_FORM1.lx_pageframe1.page2.tx_Ck_Visualiza.l_desenhista_recalculo()
					
					if type("thisformset.lx_FORM1.lx_pageframe1.page2.bt_expnegativo")="U"
						addnewobject(thisformset.lx_FORM1.lx_pageframe1.page2,"bt_expnegativo","bt_expnegativo")
					endif
				*** lucas *** 16/05/2016
				case upper(xmetodo) == 'USR_SEARCH_AFTER' 
				
					xalias=alias()
						SELE v_estoque_produtos_00
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
									WHERE A.PRODUTO = '<<v_estoque_produtos_00.produto>>'
									
								ENDTEXT

								f_select(xsel,"xTempSelect",ALIAS())
								
								sele v_estoque_produtos_00
								
								replace DESC_PRODUTO_SEGMENTO  	WITH xTempSelect.DESC_PRODUTO_SEGMENTO
								replace DESC_PRODUTO_SOLUCAO	WITH xTempSelect.DESC_PRODUTO_SOLUCAO
**								replace DESC_CATEGORIA  		WITH xTempSelect.DESC_CATEGORIA
**								replace DESC_SUBCATEGORIA  		WITH xTempSelect.DESC_SUBCATEGORIA
								
							ENDSCAN	
					
					if !f_vazio(xalias)
						sele &xalias
					endif
				
					case upper(xmetodo) == 'USR_REFRESH'
					 
						xalias=alias()
						If type("thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.COL_ANM_DESC_SEGMENTO") <> "U" AND type("thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.col_anm_desc_solucao") <> "U"		
							If Thisformset.P_TOOL_STATUS = 'P'
								thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.COL_ANM_DESC_SEGMENTO.Enabled = .f.
								thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.col_anm_desc_solucao.Enabled = .f.
								
								sele v_estoque_produtos_00
								go top
								thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.SetFocus()
							Else
								thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.COL_ANM_DESC_SEGMENTO.Enabled = .T.
								thisformset.lx_form1.lx_pageframe1.page1.lx_GRID_FILHA1.col_anm_desc_solucao.Enabled = .T.
							Endif
						Endif
						if !f_vazio(xalias)
							sele &xalias
						endif
				*** lucas *** 16/05/2016
					
				otherwise
				return .t.				
			endcase

	ENDPROC

ENDDEFINE	

**************************************************
*-- Class:        bt_expnegativo (c:\linx desenv\classes lucas\bt_expnegativo.vcx)
*-- ParentClass:  botao (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   02/12/15 05:58:05 PM
*
DEFINE CLASS bt_expnegativo AS botao


	Top = 104
	Left = 587
	Height = 24
	Width = 148
	Caption = "\<Exporta Estoque Negativo"
	Name = "bt_expnegativo"
	Visible = .t.
	Enabled = .t.

	PROCEDURE CLICK

		xResp = MESSAGEBOX("Deseja Exportar  ?",4+32)
		f_wait("Pesquisando ... AGUARDE !")  
		
		IF xResp = 6
		f_select("SELECT * FROM WANM_ESTOQUE_NEGATIVO_SKU_PRODUTO_TRANSITO","xExporta")
		ELSE
		f_wait()
		RETURN .f.
		endif
		
		f_wait()
			
		sele xExporta
	
		IF MESSAGEBOX("Exportando Estoque Negativo, Salvar como ?",0+46)=1

		xFile = "'"+PUTFILE('','','xls')+"'"

		COPY TO &xFile XLS
		MESSAGEBOX("Exportado com Sucesso Para:"+CHR(13)+xFile,64) 
		RETURN .F.

ENDIF

ENDPROC

ENDDEFINE
*
*-- EndDefine: bt_expnegativo
**************************************************