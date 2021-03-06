* Cria��o *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar                                                                                     *
* DATA...........:  04/07/2013                                                                                      *
* HOR�RIO........:  11:00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Farm                                                                                                	*
* OBJETIVO.: SELECIONA MATERIAIS ESTOQUE REVIS�O						                    						*
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

Define class obj_entrada as custom
	*- Nome do metodo/fun��o que os objetos linx v�o chamar.

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


		******************** Metodo chamado pelos Objetos na Valida��o
		*   USR_VALID -> Return .f. N�o deixa o Usuario sair do objeto.

		******************** Metodo chamado pelos PageFrames
		*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

		*- Inicio dos procedimentos do Usuario
		*- Testando qual o metodo que esta chamando o metodo entrada

		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

			Do case
				
				case upper(xmetodo) == 'USR_INIT' 
					
					xalias=alias()

					PUBLIC xExec
					
					xExec=0
					*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_os_01   
					sele V_MATERIAIS_02_MATPROG
					xalias_pai=alias()

  					oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("PRODUCAO_PROG_PROD.ANM_ULTIMA_ALTERACAO", "D",.T., "ANM_ULTIMA_ALTERACAO", "PRODUCAO_PROG_PROD.ANM_DATA_INICIO_SEPARACAO")				
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Pai					
*!*						ThisFormSet.LX_FORM1.Label_OUTRAS_FILIAIS.Caption=;
*!*							IIF( ALLTRIM(thisformset.pp_anm_filial_dest_armazem) <> ALLTRIM(thisformset.pp_anm_filial_armazem),;
*!*							     ALLTRIM(thisformset.pp_anm_filial_dest_armazem)+')',;
*!*							     'OUTRAS FILIAIS)';
*!*							    ) 
					ThisFormSet.LX_FORM1.lx_label33.Caption='Em Revis�o'
					*ThisFormSet.lx_FORM1.lx_textbox_base15.ReadOnly=.T.
					ThisFormSet.LX_FORM1.lx_pageframe1.page8.Caption="E\<stoque"
					
					*Bindevent(ThisFormSet.lx_FORM1.lx_textbox_base15, "DblClick", This, "Anm_Seleciona_Revisao", 1)
					Bindevent(ThisFormSet.lx_forM1.lx_pageframe1.page5, "Activate", This, "Anm_FiltraProd", 1)
					Bindevent(ThisFormSet.LX_FORM1.LX_PAGEFRAME1.page5, "Activate", This, "Anm_UltimaAlteracao", 1)
					Bindevent(ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1.COL_tx_PROGRAMACAO.Tx_PROGRAMACAO,"DblClick", This, "Anm_CtrlC_Prog", 1)
					Bindevent(ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1.COL_tx_PRODUTO.TX_PRODUTO,"DblClick", This, "Anm_CtrlC_Prod", 1)
					
					ThisFormSet.lx_FORM1.LX_PAGEFRAME1.page5.AddObject("txanm_ultima_alteracao","txanm_ultima_alteracao")
					ThisFormSet.lx_FORM1.LX_PAGEFRAME1.page5.AddObject("lb_ultalter","lb_ultalter")
					*ThisFormSet.lx_FORM1.tx_OUTRAS_FILIAIS.ReadOnly=.T.
					
					ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page2.LX_GRID_FILHA1.Col_tx_DESC_FASE_PRODUCAO.ControlSource='v_materiais_02_reservas.programacao'
					ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page2.LX_GRID_FILHA1.Col_tx_DESC_FASE_PRODUCAO.h_tx_DESC_FASE_PRODUCAO.Caption='Programa��o'

					if !f_vazio(xalias)	
						sele &xalias
					endif	
					
				
				case upper(xmetodo) == 'USR_REFRESH' 
					
					xalias=alias()
					
*!*							with ThisFormSet.lx_FORM1.lx_textbox_base15
*!*								.Enabled=.t.
*!*								.ReadOnly=.T.
*!*							endwith	 				
*!*							
						thisformset.lx_necessidades()
*!*						
						with ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1
							.Col_tx_PROGRAMACAO.Tx_PROGRAMACAO.ReadOnly = .T.
							.Col_tx_PROGRAMACAO.Tx_PROGRAMACAO.Enabled = .T.
							.COL_tx_PRODUTO.TX_PRODUTO.ReadOnly = .T.
							.COL_tx_PRODUTO.TX_PRODUTO.Enabled = .T.
						endwith	
					* #1 - LUCAS MIRANDA - 08/08/2016 - BLOQUEAR OS CAMPOS NO MODO LIVRE A VISUALIZA��O DOS FILTROS 
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
							

							*f_select("select isnull(SUM(qtde_estoque),0) as em_revisao from ESTOQUE_MATERIAIS where FILIAL = ?xFilRev and MATERIAL =?v_materiais_02.material and COR_MATERIAL =?v_materiais_02.cor_material","xTmpEstoque")
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

	Endproc
		
*!*		Procedure Anm_Seleciona_Revisao

*!*			xalias=alias()
*!*			
*!*			If ThisFormSet.p_Tool_Status == "P"
*!*				
*!*				text to xselRevisao noshow textmerge	
*!*					
*!*				 select b.nf_saida,b.filial_faturamento,b.serie_nf,
*!*						a.material,a.cor_material,
*!*						convert(numeric(14,2),sum(a.qtde)) as qtde_em_revisao,
*!*						convert(numeric(15,5),(sum(a.valor)/sum(a.qtde))) as custo_materia_prima,
*!*						convert(numeric(14,2),sum(a.valor)) as valor,
*!*						isnull(c.anm_status_saida,'EM REVIS�O') as anm_status_saida 
*!*						from estoque_sai1_mat a 
*!*						join estoque_sai_mat b 
*!*						on a.req_material=b.req_material 
*!*						and a.filial=b.filial
*!*						join faturamento c 
*!*						on b.nf_saida=c.nf_saida 
*!*						and b.filial=c.filial
*!*						and b.serie_nf=c.serie_nf  
*!*						where 
*!*						isnull(c.anm_status_saida,'') <> 'FINALIZADO'
*!*						and a.material='<<v_materiais_02.material>>' 
*!*						and a.cor_material='<<v_materiais_02.cor_material>>'
*!*						and b.obs like '%2AAG%'
*!*						group by b.nf_saida,b.filial_faturamento,b.serie_nf,
*!*						b.nome_clifor,a.material,a.cor_material,c.anm_status_saida 

*!*				endtext

*!*				f_select(xselRevisao,"curMatRevisao")
*!*				
*!*				sele curMatRevisao 
*!*				browse normal noedit title  'Materiais em Revis�o por Pedido - Tecle Esc p/ Sair' in screen	
*!*				
*!*			Endif

*!*			if !f_vazio(xalias)	
*!*				sele &xalias
*!*			endif	

*!*		Endproc
	
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
	Caption = "Ultima Altera��o"
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
