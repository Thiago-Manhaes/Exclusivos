* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  06/10/2008                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: SELECIONA MATERIAIS ESTOQUE REVISÃO						                    *
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
					
					
					PUBLIC xExec
					
					xExec=0
					*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_os_01   
					sele V_MATERIAIS_02_MATPROG
					xalias_pai=alias()

  					oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("PRODUCAO_PROG_PROD.ANM_ULTIMA_ALTERACAO", "D",.T., "ANM_ULTIMA_ALTERACAO", "PRODUCAO_PROG_PROD.ANM_DATA_INICIO_SEPARACAO")				
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Pai
					
					
					Bindevent(ThisFormSet.LX_FORM1.tx_OUTRAS_FILIAIS, "DblClick", This, "Anm_Seleciona_Revisao", 1)
					Bindevent(ThisFormSet.LX_FORM1.LX_PAGEFRAME1.page5, "Activate", This, "Anm_FiltraProd", 1)
					Bindevent(ThisFormSet.LX_FORM1.LX_PAGEFRAME1.page5, "Activate", This, "Anm_UltimaAlteracao", 1)
					Bindevent(ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1.COL_tx_PROGRAMACAO.Tx_PROGRAMACAO,"DblClick", This, "Anm_CtrlC_Prog", 1)
					Bindevent(ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1.COL_tx_PRODUTO.TX_PRODUTO,"DblClick", This, "Anm_CtrlC_Prod", 1)
					
					ThisFormSet.lx_FORM1.tx_OUTRAS_FILIAIS.ReadOnly=.T.
					ThisFormSet.lx_FORM1.LX_PAGEFRAME1.page5.AddObject("txanm_ultima_alteracao","txanm_ultima_alteracao")
					ThisFormSet.lx_FORM1.LX_PAGEFRAME1.page5.AddObject("lb_ultalter","lb_ultalter")
					
					ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page2.LX_GRID_FILHA1.Col_tx_DESC_FASE_PRODUCAO.ControlSource='v_materiais_02_reservas.programacao'
					ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page2.LX_GRID_FILHA1.Col_tx_DESC_FASE_PRODUCAO.h_tx_DESC_FASE_PRODUCAO.Caption='Programação'
					
					
	
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
					
				
				case upper(xmetodo) == 'USR_REFRESH' 
					
					with ThisFormSet.lx_FORM1.tx_OUTRAS_FILIAIS 
						.Enabled=.t.
						.ReadOnly=.T.
					endwith	 
								
					with ThisFormSet.LX_FORM1.LX_PAGEFRAME1.Page5.LX_GRID_FILHA1
						.Col_tx_PROGRAMACAO.Tx_PROGRAMACAO.ReadOnly = .T.
						.Col_tx_PROGRAMACAO.Tx_PROGRAMACAO.Enabled = .T.
						.COL_tx_PRODUTO.TX_PRODUTO.ReadOnly = .T.
						.COL_tx_PRODUTO.TX_PRODUTO.Enabled = .T.
					endwith	 
					
				otherwise
				return .t.				
			endcase

	endproc	
	
	
	
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
	
	
	Procedure Anm_Seleciona_Revisao

		xalias=alias()
		
		If ThisFormSet.p_Tool_Status == "P"
			
			text to xselRevisao noshow textmerge	

				select a.*,(b.qtde_entregar+a.qtde_em_revisao) as qtde_entregar_pedido 
				from 
					(select a.pedido,b.nf_entrada,
					a.material,a.cor_material,
					convert(numeric(14,2),sum(a.qtde)) as qtde_em_revisao,
					convert(numeric(15,5),(sum(a.valor)/sum(a.qtde))) as custo_materia_prima,
					convert(numeric(14,2),sum(a.valor)) as valor,
					c.anm_status_entrada 
					from estoque_ret1_mat a 
					join estoque_ret_mat b 
					on a.req_material=b.req_material 
					and a.filial=b.filial
					join entradas c 
					on b.nf_entrada=c.nf_entrada 
					and b.nome_clifor=c.nome_clifor 
					and b.serie_nf_entrada=c.serie_nf_entrada  
					where 
					c.anm_status_entrada in 
						(select convert(varchar(25),valor_propriedade) as anm_status_entrada 
						from propriedade_valida 
						where propriedade='00054' 
						and valor_propriedade <>'4-FINALIZADO')
					and a.material='<<v_materiais_02.material>>' 
					and a.cor_material='<<v_materiais_02.cor_material>>'
					group by a.pedido,b.nf_entrada,b.nome_clifor,a.material,
				a.cor_material,c.anm_status_entrada ) a
				join 
					(select pedido,material,cor_material,
					sum(qtde_entregar) as qtde_entregar 
					from compras_material  
					group by pedido,material,cor_material) b 
				on  a.pedido=b.pedido
				and a.material=b.material
				and a.cor_material=b.cor_material 

			endtext

			f_select(xselRevisao,"curMatRevisao")
			
			sele curMatRevisao 
			browse normal noedit title  'Materiais em Revisão por Pedido - Tecle Esc p/ Sair' in screen	
			
		Endif

		if !f_vazio(xalias)	
			sele &xalias
		endif	
					


	Endproc




	
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


