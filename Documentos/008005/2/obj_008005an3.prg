* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar                                                                                     *
* DATA...........:  04/07/2013                                                                                      *
* HORÁRIO........:  11:00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Farm                                                                                                	*
* OBJETIVO.: SELECIONA MATERIAIS ESTOQUE REVISÃO						                    						*
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

Define class obj_entrada as custom
	*- Nome do metodo/função que os objetos linx vão chamar.

	Procedure metodo_usuario
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

			Do case
				
				** #GS02 - Desenvolvedor: Lucas Miranda - Solicitante: Maria Fernanda (Dep. Internacional) - 05/01/2016 - Criação das colunas Necessidade e Fabricante
				
				
				
				case upper(xmetodo) == 'USR_INIT' 
					
					xalias=alias()
					
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
					
					PUBLIC xExec
					
					xExec=0
					*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_os_01   
					sele V_MATERIAIS_02_MATPROG
					xalias_pai=alias()

  					oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("PRODUCAO_PROG_PROD.ANM_ULTIMA_ALTERACAO", "D",.T., "ANM_ULTIMA_ALTERACAO", "PRODUCAO_PROG_PROD.ANM_DATA_INICIO_SEPARACAO")				
					*** #GS02
					oCur.addbufferfield("0 AS ANM_NECESSIDADE", "N(10,3)",.T., "ANM_NECESSIDADE", "ANM_NECESSIDADE")
					oCur.addbufferfield("SPACE(25) AS ANM_FABRICANTE", "C(25)",.T., "ANM_FABRICANTE", "ANM_FABRICANTE")
					** Fim #GS02
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Pai					

					ThisFormSet.LX_FORM1.lx_label33.Caption='Em Revisão'
					ThisFormSet.LX_FORM1.lx_pageframe1.page8.Caption="E\<stoque"
					
					Bindevent(ThisFormSet.lx_forM1.lx_pageframe1.page5, "Activate", This, "Anm_FiltraProd", 1)
					Bindevent(ThisFormSet.LX_FORM1.LX_PAGEFRAME1.page5, "Activate", This, "Anm_UltimaAlteracao", 1)
					*** #GS02
					Bindevent(ThisFormSet.LX_FORM1.LX_PAGEFRAME1.page5, "Activate", This, "Anm_BidNecessidade", 1)
					Bindevent(ThisFormSet.LX_FORM1.LX_PAGEFRAME1.page5, "Activate", This, "Anm_BidFabricante", 1)
					*** Fim #GS02
					Bindevent(ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1.COL_tx_PROGRAMACAO.Tx_PROGRAMACAO,"DblClick", This, "Anm_CtrlC_Prog", 1)
					Bindevent(ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1.COL_tx_PRODUTO.TX_PRODUTO,"DblClick", This, "Anm_CtrlC_Prod", 1)
					
					ThisFormSet.lx_FORM1.LX_PAGEFRAME1.page5.AddObject("txanm_ultima_alteracao","txanm_ultima_alteracao")
					ThisFormSet.lx_FORM1.LX_PAGEFRAME1.page5.AddObject("lb_ultalter","lb_ultalter")
					
					ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page2.LX_GRID_FILHA1.Col_tx_DESC_FASE_PRODUCAO.ControlSource='v_materiais_02_reservas.programacao'
					ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page2.LX_GRID_FILHA1.Col_tx_DESC_FASE_PRODUCAO.h_tx_DESC_FASE_PRODUCAO.Caption='Programação'
 					
 						** #GS02
						with ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1 
												xcColumnCount = .columncount
												xcColumnCount = xcColumnCount + 1 
									.addcolumn(xcColumnCount)
									.columns[xcColumnCount].name = 'col_necessidade'
									.col_necessidade.width = 100
									.col_necessidade.Header1.name='h_necessidade'
									.col_necessidade.width = ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1.col_tx_neCESSIDADE_PROG.Width
									.col_necessidade.BackColor = ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1.col_tx_neCESSIDADE_PROG.BackColor 
									.col_necessidade.FontSize = ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1.col_tx_neCESSIDADE_PROG.FontSize 
									.col_necessidade.FontName = ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1.col_tx_neCESSIDADE_PROG.FontName 
									.col_necessidade.h_necessidade.caption = 'Necessidade'
									.col_necessidade.h_necessidade.alignment = 2
									.col_necessidade.h_necessidade.FONTSIZE = 8
									.col_necessidade.h_necessidade.FontName = "Tahoma"
									.col_necessidade.refresh()
									.col_necessidade.ControlSource="v_materiais_02_matprog.anm_necessidade"
						endwith
 						
 						with ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1 
												xcColumnCount = .columncount
												xcColumnCount = xcColumnCount + 1 
									.addcolumn(xcColumnCount)
									.columns[xcColumnCount].name = 'col_fabricante'
									.col_fabricante.width = ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1.Col_tx_DESC_MATERIAL.Width
									.col_fabricante.BackColor = ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1.Col_tx_DESC_MATERIAL.BackColor 
									.col_fabricante.FontSize = ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1.Col_tx_DESC_MATERIAL.FontSize 
									.col_fabricante.FontName = ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1.Col_tx_DESC_MATERIAL.FontName 
									.col_fabricante.Header1.name='h_fabricante'
									.col_fabricante.h_fabricante.caption = 'Fabricante'
									.col_fabricante.h_fabricante.alignment = 2
									.col_fabricante.h_fabricante.FONTSIZE = 8
									.col_fabricante.h_fabricante.FontName = "Tahoma"
									.col_fabricante.refresh()
									.col_fabricante.ControlSource="v_materiais_02_matprog.anm_fabricante"
						endwith
						** Fim #GS02
					if !f_vazio(xalias)	
						sele &xalias
					endif	
					
				
				case upper(xmetodo) == 'USR_REFRESH' 
					
					xalias=alias()
							
						thisformset.lx_necessidades()					
						with ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1
							.Col_tx_PROGRAMACAO.Tx_PROGRAMACAO.ReadOnly = .T.
							.Col_tx_PROGRAMACAO.Tx_PROGRAMACAO.Enabled = .T.
							.COL_tx_PRODUTO.TX_PRODUTO.ReadOnly = .T.
							.COL_tx_PRODUTO.TX_PRODUTO.Enabled = .T.
						endwith	
					
					* #1 - LUCAS MIRANDA - 08/08/2016 - BLOQUEAR OS CAMPOS NO MODO LIVRE A VISUALIZAÇÃO DOS FILTROS 
					If ThisFormSet.p_tool_status = 'L'
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox1.Enabled = .f.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox2.Enabled = .f.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox3.Enabled = .f.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox4.Enabled = .f.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox5.Enabled = .f.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox6.Enabled = .f.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox7.Enabled = .f.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox8.Enabled = .f.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox9.Enabled = .f.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox10.Enabled = .f.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox11.Enabled = .f.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox12.Enabled = .f.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox13.Enabled = .f.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox14.Enabled = .f.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox15.Enabled = .f.
					Else
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox1.Enabled = .t.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox2.Enabled = .t.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox3.Enabled = .t.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox4.Enabled = .t.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox5.Enabled = .t.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox6.Enabled = .t.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox7.Enabled = .t.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox8.Enabled = .t.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox9.Enabled = .t.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox10.Enabled = .t.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox11.Enabled = .t.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox12.Enabled = .t.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox13.Enabled = .t.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox14.Enabled = .t.
						ThisFormSet.lx_form1.lx_pageframe1.page4.Pageframe1.page2.lx_checkbox15.Enabled = .t.
					Endif	
						

					if !f_vazio(xalias)	
						sele &xalias
					endif	
				
				case upper(xmetodo) == 'USR_CLEAN_AFTER' 
				
					xalias=alias()
					
						xExec = 0
					
					if !f_vazio(xalias)	
						sele &xalias
					endif				
									
				case upper(xmetodo) == 'USR_SEARCH_AFTER' 
				
					xalias=alias()
						

						xFilRev = ALLTRIM(thisformset.pp_anm_filial_revisao_mp)					
						
						SELE v_materiais_02
						
						GO top
						SCAN
							
							SELE v_materiais_02
							
						
							TEXT TO xSelRevisao TEXTMERGE NOSHOW
							
								SELECT isnull(SUM(qtde_estoque),0) as em_revisao 
								FROM ESTOQUE_MATERIAIS A
								JOIN W_FILIAIS B ON A.FILIAL = B.FILIAL
								WHERE 
								LEFT(REDE_LOJAS,1) = LEFT((SELECT REDE_LOJAS FROM FILIAIS WHERE FILIAL =   
														   (SELECT DBO.FX_ANM_PARAMETRO_USER('FILTRO_FILIAL_ESTOQUE_MAT')) 
														   )  ,1) AND B.FILIAL LIKE '%REVISAO%' AND B.INATIVO = 0
							
								AND MATERIAL ='<<v_materiais_02.material>>' and COR_MATERIAL ='<<v_materiais_02.cor_material>>'
							ENDTEXT
							f_select(xSelRevisao,"xTmpEstoque")
							
							SELE v_materiais_02
							replace v_materiais_02.requisicao  with xTmpEstoque.em_revisao 
							
							thisformset.lx_necessidades()
						ENDSCAN
						
						SELE v_materiais_02
						GO top
						
						IF xExec = 0
							sele V_MATERIAIS_02_MATPROG
							GO top
							
							SCAN
								
								TEXT TO xSel TEXTMERGE NOSHOW
									SELECT  
									  CASE 
										WHEN ISNULL(A.ANM_ULTIMA_ALTERACAO,'19000101') > ISNULL(B.ANM_ULTIMA_ALTERACAO,'19000101') THEN A.ANM_ULTIMA_ALTERACAO
										ELSE ISNULL(B.ANM_ULTIMA_ALTERACAO,'19000101') END AS ANM_ULTIMA_ALTERACAO
									FROM PRODUCAO_PROG_PROD A JOIN PRODUTO_VERSAO_MATERIAL_COR B
									ON A.PRODUTO = B.PRODUTO AND A.COR_PRODUTO = B.COR_PRODUTO 
									WHERE A.PROGRAMACAO = '<<V_MATERIAIS_02_MATPROG.PROGRAMACAO>>' AND B.PRODUTO = '<<V_MATERIAIS_02_MATPROG.PRODUTO>>'
									AND B.COR_PRODUTO = '<<V_MATERIAIS_02_MATPROG.COR_PRODUTO>>' AND B.MATERIAL = '<<V_MATERIAIS_02_MATPROG.MATERIAL>>'
									AND B.COR_MATERIAL = '<<V_MATERIAIS_02_MATPROG.COR_MATERIAL>>'
								ENDTEXT

								f_select(xSel,"xUtima_Alteracao")	
								
								sele V_MATERIAIS_02_MATPROG
								replace ANM_ULTIMA_ALTERACAO with  xUtima_Alteracao.ANM_ULTIMA_ALTERACAO
							
							ENDSCAN
						
							xExec = 1
						ENDIF	

					if !f_vazio(xalias)	
						sele &xalias
					endif				
					
				otherwise
				return .t.				
			endcase

	endproc	
	
	
	Procedure Anm_FiltraProd

		xalias=alias()
	
		If ThisFormSet.p_Tool_Status == "P"
		
			IF !f_vazio(Thisformset.Lx_form1.Lx_pageframe1.Page4.PageFrame1.Page1.Lx_filtro_produtos1.p_material_in_produto)

				x_filtro_prodProg = STRTRAN(Thisformset.Lx_form1.Lx_pageframe1.Page4.PageFrame1.Page1.Lx_filtro_produtos1.p_material_in_produto,"produtos_ficha.material","produtos.produto")
				x_filtro_prodProg = "SELECT PRODUTO FROM PRODUTOS WHERE PRODUTO "+x_filtro_prodProg
				f_select(x_filtro_prodProg,"CurTmpFiltroProd")	
				
				Select V_Materiais_02_MatProg
				GO TOP
				
				DELETE FROM V_MATERIAIS_02_MATPROG WHERE PRODUTO NOT IN (SELECT produto FROM CurTmpFiltroProd)
				Go Top
				
				Thisformset.lx_forM1.lx_pageframe1.page5.Lx_checkbox2.Value=1

				Thisformset.lx_forM1.lx_pageframe1.page5.LX_GRID_FILHA1.Refresh()

			ENDIF
		
		Endif
	
		if !f_vazio(xalias)	
			sele &xalias
		endif	

	Endproc
	

	
	Procedure Anm_CtrlC_Prog
	
		xalias=alias()
			
			_cliptext = ALLTRIM(V_MATERIAIS_02_MATPROG.Programacao)	
		
		if !f_vazio(xalias)	
			sele &xalias
		endif	
		
	
	Procedure Anm_CtrlC_Prod
	
		xalias=alias()
			
			_cliptext = ALLTRIM(V_MATERIAIS_02_MATPROG.Produto)	
		
		if !f_vazio(xalias)	
			sele &xalias
		endif		
	
	
	
	Procedure Anm_UltimaAlteracao

		xalias=alias()
					
					sele V_MATERIAIS_02_MATPROG
					GO top
					
					SCAN
						
						TEXT TO xSel TEXTMERGE NOSHOW
							SELECT  
							  CASE 
								WHEN ISNULL(A.ANM_ULTIMA_ALTERACAO,'19000101') > ISNULL(B.ANM_ULTIMA_ALTERACAO,'19000101') THEN A.ANM_ULTIMA_ALTERACAO
								ELSE ISNULL(B.ANM_ULTIMA_ALTERACAO,'19000101') END AS ANM_ULTIMA_ALTERACAO
							FROM PRODUCAO_PROG_PROD A JOIN PRODUTO_VERSAO_MATERIAL_COR B
							ON A.PRODUTO = B.PRODUTO AND A.COR_PRODUTO = B.COR_PRODUTO 
							WHERE A.PROGRAMACAO = '<<V_MATERIAIS_02_MATPROG.PROGRAMACAO>>' AND B.PRODUTO = '<<V_MATERIAIS_02_MATPROG.PRODUTO>>'
							AND B.COR_PRODUTO = '<<V_MATERIAIS_02_MATPROG.COR_PRODUTO>>' AND B.MATERIAL = '<<V_MATERIAIS_02_MATPROG.MATERIAL>>'
							AND B.COR_MATERIAL = '<<V_MATERIAIS_02_MATPROG.COR_MATERIAL>>'
						ENDTEXT

						f_select(xSel,"xUtima_Alteracao")	
						
						sele V_MATERIAIS_02_MATPROG
						replace ANM_ULTIMA_ALTERACAO with  xUtima_Alteracao.ANM_ULTIMA_ALTERACAO
					
					ENDSCAN
					
					SELECT V_MATERIAIS_02_MATPROG
					INDEX ON ANM_ULTIMA_ALTERACAO TAG iUA DESC
					GO TOP
					
		if !f_vazio(xalias)	
			sele &xalias
		endif	
*** #GS02		
	Procedure Anm_BidNecessidade

		xalias=alias()
			sele V_MATERIAIS_02_MATPROG
			GO top
			
			UPDATE A SET A.ANM_NECESSIDADE = B.NECESSIDADE FROM V_MATERIAIS_02_MATPROG A ;
			JOIN V_MATERIAIS_02 B ON A.MATERIAL = B.MATERIAL AND A.COR_MATERIAL = B.COR_MATERIAL 
			
			sele V_MATERIAIS_02_MATPROG
			GO top	
					
		if !f_vazio(xalias)	
			sele &xalias
		endif	
	Endproc
		
	Procedure Anm_BidFabricante
		
		xalias=alias()
			sele V_MATERIAIS_02_MATPROG
			GO top
					
			UPDATE A SET A.ANM_FABRICANTE = B.FABRICANTE FROM V_MATERIAIS_02_MATPROG A ;
			JOIN V_MATERIAIS_02 B ON A.MATERIAL = B.MATERIAL AND A.COR_MATERIAL = B.COR_MATERIAL 
			
			sele V_MATERIAIS_02_MATPROG
			GO top		
		if !f_vazio(xalias)	
			sele &xalias
		endif	
*** Fim #GS02	
ENDDEFINE	

**************************************************
*-- Class:        txanm_ultima_alteracao (c:\pastas\work\txanm_ultima_alteracao.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   12/04/13 07:46:05 PM
*
DEFINE CLASS txanm_ultima_alteracao AS lx_textbox_base


	FontName = "Tahoma"
	controlsource = "V_MATERIAIS_02_MATPROG.anm_ultima_alteracao"
	FontSize = 7
	Height = 15
	Left = 664
	TabIndex = 22
	Top = 74
	Width = 94
	ZOrderSet = 11
	Visible = .t.
	Enabled = .f.
	Name = "TxAnm_Ultima_Alteracao"


ENDDEFINE
*
*-- EndDefine: txanm_ultima_alteracao
**************************************************

**************************************************
*-- Class:        lable_ultalter (c:\pastas\work\lable_ultalter.vcx)
*-- ParentClass:  label
*-- BaseClass:    label
*-- Time Stamp:   12/05/13 03:25:13 PM
*
DEFINE CLASS lb_ultalter AS label


	FontBold = .T.
	FontSize = 8
	BackStyle = 0
	Caption = "Ultima Alteração"
	Height = 13
	Left = 664
	Top = 61
	Width = 97
	Visible = .t.
	Name = "lb_ultalter"


ENDDEFINE
*
*-- EndDefine: lable_ultalter
**************************************************
