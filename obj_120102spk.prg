* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar                                                                                                *
* DATA...........:  20/01/2007                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: validar nota fiscal referente na entrada do estque						                    *
********************************************************************************************************************* 

* Alteração ********************************************************************************************************* 
* PROGRAMADOR(A).:                                                                                                *
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
				     
				
					xalias=alias()
						xVersao = '01.1'
						f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
						f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
						WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 

						with thisformset.lx_form1
							.addobject("cmb_nf_entrada","cmb_nf_entrada")
							.cmb_nf_entrada.ControlSource = "v_estoque_prod_ent_00.nf_entrada" 
							.cmb_nf_entrada.rowsourcetype=2
							.cmb_nf_entrada.enabled=.f.
							.addobject("lb_nf_entrada","lb_nf_entrada") 
						endwith	
					
								
					if	!f_vazio(xalias)	
						sele &xalias 
					endif								
				
				
				
				case UPPER(xmetodo) == 'USR_WHEN' 				
					
					
					xalias=alias()
					
					IF UPPER(xnome_obj) == 'CMB_FILIAL'
					
						if thisformset.p_tool_status = "I" or thisformset.p_tool_status = "A" 
							thisformset.lx_form1.cmb_filial.Enabled= .F.
						endif
					
					ENDIF
					********************************************
					
					IF UPPER(xnome_obj) == 'TV_ORDEM_PRODUCAO_ANM'	
					
						IF thisformset.p_tool_status = "I" or thisformset.p_tool_status = "A" 
							
							TEXT TO xselFilialEnt TEXTMERGE NOSHOW
								
								SELECT TOP 1 
								CASE 
								WHEN A.VALOR_PROPRIEDADE = 'GX NORTE DISTRIBUIDORA' THEN 'ATACADO'
								WHEN A.VALOR_PROPRIEDADE = 'RBX DISTRIBUIDORA' THEN 'ESTOQUE CENTRAL'
								ELSE A.VALOR_PROPRIEDADE END AS FILIAL
								FROM PROP_PRODUCAO_ORDEM_SERVICO A
								JOIN PRODUCAO_OS_TAREFAS B
								ON A.ORDEM_SERVICO = B.ORDEM_SERVICO
								JOIN PRODUCAO_ORDEM C
								ON B.ORDEM_PRODUCAO = C.ORDEM_PRODUCAO
								WHERE A.PROPRIEDADE = '00052'
								AND  ( C.ORDEM_CORTE = '<<V_ESTOQUE_PROD_ENT_00.ORDEM_PRODUCAO>>'
								      OR 'C'+C.ORDEM_PRODUCAO = '<<V_ESTOQUE_PROD_ENT_00.ORDEM_PRODUCAO>>' )
								--AND C.ORDEM_CORTE = '<<V_ESTOQUE_PROD_ENT_00.ORDEM_PRODUCAO>>'
								--AND ORDEM_PRODUCAO = '<<V_ESTOQUE_PROD_ENT_00_PRODUTOS.ORDEM_PRODUCAO>>'      
								AND B.PRODUTO = '<<V_ESTOQUE_PROD_ENT_00_PRODUTOS.PRODUTO>>'
								ORDER BY A.ORDEM_SERVICO
							
							ENDTEXT
							
							f_select(xselFilialEnt,"xFilialEnt",alias())
							
							thisformset.lx_form1.cmb_filial.value = xFilialEnt.FILIAL
							thisformset.lx_form1.cmb_filial.Enabled= .F.
							
						ENDIF
					ENDIF
					********************************************
					
					
					IF UPPER(xnome_obj) == 'CMB_NF_ENTRADA'
						
						
						IF thisformset.p_tool_status = "I" or thisformset.p_tool_status = "A" 
							
							TEXT TO xselFilialEnt TEXTMERGE NOSHOW
							
								SELECT TOP 1 
								CASE 
								WHEN A.VALOR_PROPRIEDADE = 'GX NORTE DISTRIBUIDORA' THEN 'ATACADO'
								WHEN A.VALOR_PROPRIEDADE = 'RBX DISTRIBUIDORA' THEN 'ESTOQUE CENTRAL'
								ELSE A.VALOR_PROPRIEDADE END AS FILIAL
								FROM PROP_PRODUCAO_ORDEM_SERVICO A
								JOIN PRODUCAO_ORDEM_SERVICO B
								ON A.ORDEM_SERVICO = B.ORDEM_SERVICO
								JOIN PRODUCAO_ORDEM C
								ON B.ORDEM_PRODUCAO_OS = C.ORDEM_PRODUCAO
								WHERE A.PROPRIEDADE = '00052'
								AND  ( C.ORDEM_CORTE = '<<V_ESTOQUE_PROD_ENT_00.ORDEM_PRODUCAO>>'
								      OR 'C'+C.ORDEM_PRODUCAO = '<<V_ESTOQUE_PROD_ENT_00.ORDEM_PRODUCAO>>' )
								--AND C.ORDEM_CORTE = '<<V_ESTOQUE_PROD_ENT_00.ORDEM_PRODUCAO>>'
								--AND ORDEM_PRODUCAO = '<<V_ESTOQUE_PROD_ENT_00_PRODUTOS.ORDEM_PRODUCAO>>'
								AND PRODUTO = '<<V_ESTOQUE_PROD_ENT_00_PRODUTOS.PRODUTO>>'
								ORDER BY A.ORDEM_SERVICO
							
							ENDTEXT
							
							f_select(xselFilialEnt,"xFilialEnt",alias())
							
							thisformset.lx_form1.cmb_filial.value = xFilialEnt.FILIAL
							thisformset.lx_form1.cmb_filial.Enabled= .F.
							
						ENDIF
						
						xTmpOP = thisformset.LX_FORM1.LX_pageframe1.PAge1.LX_GRID_FILHA1.Col_tx_ORDEM_PRODUCAO.Tx_ORDEM_PRODUCAO.Value
							
							TEXT TO xsel_nf_entradas TEXTMERGE NOSHOW
							
							
									select convert(varchar(7),' ') as nf_entrada
									union all 
									SELECT DISTINCT NF_ENTRADA 
									FROM W_PRODUCAO_ORDEM_HIST_OS A
									WHERE INDICADOR_TIPO_MOV = '1' 
									AND NF_ENTRADA <> '' 
									AND FASE_PRODUCAO1 = '021'
									AND ORDEM_PRODUCAO = '<<xTmpOP>>'
									AND NF_ENTRADA NOT IN
									(SELECT A.NF_ENTRADA FROM ESTOQUE_PROD_ENT A
									JOIN ESTOQUE_PROD1_ENT B ON A.ROMANEIO_PRODUTO = B.ROMANEIO_PRODUTO
									WHERE B.ORDEM_PRODUCAO = '<<xTmpOP>>'
									AND NF_ENTRADA IS NOT NULL)
							
							ENDTEXT
							
							IF USED("Cur_Ent_Prod_NF")
								SELECT Cur_Ent_Prod_NF
								USE
							ENDIF	
							
							
							f_select(xsel_nf_entradas,"Cur_Ent_Prod_NF")			

							with thisformset.lx_form1
								.cmb_nf_entrada.rowsourcetype=2
								.cmb_nf_entrada.RowSource = "Cur_Ent_Prod_NF.nf_entrada"
								.cmb_nf_entrada.ControlSource = "v_estoque_prod_ent_00.nf_entrada" 
							endwith	
						
							
							thisformset.lx_form1.cmb_filial.Enabled= .F.
					ENDIF
					
						
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
							


				
				case UPPER(xmetodo)=='USR_REFRESH' 
				
				
					xalias=alias()
				
				
						if type("thisformset.lx_FORM1.lb_nf_entrada")<>"U"
							if thisformset.p_tool_status = "I" or thisformset.p_tool_status = "A" 
								thisformset.lx_FORM1.cmb_nf_entrada.enabled=.T.
							else	
								thisformset.lx_FORM1.cmb_nf_entrada.enabled=.F.	
							endif												
						endif
					
					
						if type("thisformset.lx_FORM1.lb_nf_entrada")<>"U"
							if thisformset.p_tool_status = "P" 
								thisformset.lx_FORM1.cmb_nf_entrada.RowSourceType = 1
								thisformset.lx_FORM1.cmb_nf_entrada.refresh()
							else	
								thisformset.lx_FORM1.cmb_nf_entrada.RowSourceType = 2
								thisformset.lx_FORM1.cmb_nf_entrada.refresh()
							endif												
						endif
					
						
						
						
						
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
				
				

				case UPPER(xmetodo)=='USR_ALTER_BEFORE' 
				
				
					xalias=alias()
				
				
						TEXT TO xsel_pgto TEXTMERGE NOSHOW
						
							SELECT ENTRADAS.NF_ENTRADA 
							FROM ENTRADAS 
							INNER JOIN CTB_A_PAGAR_MOV 
							ON ( ENTRADAS.CTB_LANCAMENTO = CTB_A_PAGAR_MOV.LANCAMENTO_MOV 
							OR ENTRADAS.NUMERO_CONFERENCIA = CTB_A_PAGAR_MOV.LANCAMENTO_MOV ) 
							AND ENTRADAS.CTB_ITEM = CTB_A_PAGAR_MOV.ITEM_MOV 
							AND CTB_A_PAGAR_MOV.EMPRESA = '1'
							WHERE ENTRADAS.NF_ENTRADA = '<<V_ESTOQUE_PROD_ENT_00.NF_ENTRADA>>'
							AND ENTRADAS.NOME_CLIFOR = '<<V_ESTOQUE_PROD_ENT_00.NOME_CLIFOR>>'
						
						ENDTEXT					
						
						f_select(xsel_pgto,"xVerifica_pgto")
						
						sele xVerifica_pgto
						IF RECCOUNT()>0
							MESSAGEBOX('Exitem Titulos Pagos, Impossível Continuar!!',0+48)
							RETURN .F.
						ENDIF
					
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
			
				case UPPER(xmetodo) == 'USR_SAVE_BEFORE' 
			
							
					IF THISFORMSET.P_TOOL_STATUS = 'E'
						
						xalias=alias()
						
							TEXT TO xsel_pgto TEXTMERGE NOSHOW
							
								SELECT ENTRADAS.NF_ENTRADA 
								FROM ENTRADAS 
								INNER JOIN CTB_A_PAGAR_MOV 
								ON ( ENTRADAS.CTB_LANCAMENTO = CTB_A_PAGAR_MOV.LANCAMENTO_MOV 
								OR ENTRADAS.NUMERO_CONFERENCIA = CTB_A_PAGAR_MOV.LANCAMENTO_MOV ) 
								AND ENTRADAS.CTB_ITEM = CTB_A_PAGAR_MOV.ITEM_MOV 
								AND CTB_A_PAGAR_MOV.EMPRESA = '1'
								WHERE ENTRADAS.NF_ENTRADA = '<<V_ESTOQUE_PROD_ENT_00.NF_ENTRADA>>'
								AND ENTRADAS.NOME_CLIFOR = '<<V_ESTOQUE_PROD_ENT_00.NOME_CLIFOR>>'
							
							ENDTEXT					
							
							f_select(xsel_pgto,"xVerifica_pgto")
							
							sele xVerifica_pgto
							IF RECCOUNT()>0
								MESSAGEBOX('Exitem Titulos Pagos, Impossível Continuar!!',0+48)
								RETURN .F.
							ENDIF
						
							if	!f_vazio(xalias)	
								sele &xalias 
							endif
					
					ENDIF
			
					xalias=alias()
					
					
					
					PUBLIC xQtdeEntradaNF,xQtdeRet,xTot_entrada,xTmpOP 
					xTot_entrada = 0
					xTmpOP = thisformset.lx_FORM1.lx_PAGEFRAME1.Page1.LX_GRID_FILHA1.COL_TX_ORDEM_PRODUCAO.TX_ORDEM_PRODUCAO.Value
					
					TEXT TO xselqtde_entrada TEXTMERGE NOSHOW					
							
							SELECT SUM(PRODUCAO_OS_ANTERIOR.QTDE_A) AS QTDE_ITEM
							FROM PRODUCAO_OS_ANTERIOR PRODUCAO_OS_ANTERIOR 
							INNER JOIN PRODUCAO_ORDEM_SERVICO PRODUCAO_ORDEM_SERVICO 
							ON PRODUCAO_OS_ANTERIOR.ORDEM_SERVICO = PRODUCAO_ORDEM_SERVICO.ORDEM_SERVICO 
							WHERE PRODUCAO_ORDEM_SERVICO.NF_ENTRADA =  '<<V_ESTOQUE_PROD_ENT_00.NF_ENTRADA>>'  
							AND PRODUCAO_OS_ANTERIOR.PRODUTO = '<<V_ESTOQUE_PROD_ENT_00_PRODUTOS.PRODUTO>>'
							AND PRODUCAO_OS_ANTERIOR.ORDEM_PRODUCAO = '<<xTmpOP>>'
							AND PRODUCAO_ORDEM_SERVICO.FASE_PRODUCAO = '021'  
							
					ENDTEXT
					
					f_select("SELECT ISNULL(SUM(QTDE_A),0) AS QTDE_A FROM (SELECT QTDE_A FROM W_PRODUCAO_ORDEM_HIST_OS WHERE INDICADOR_TIPO_MOV = '5' AND ORDEM_PRODUCAO = ?xTmpOP AND NF_ENTRADA = ?V_ESTOQUE_PROD_ENT_00.NF_ENTRADA) A","xQtdeRet")
								
					f_select(xselqtde_entrada,"xQtdeEntradaNF")
					
					
					
					IF !f_vazio(V_ESTOQUE_PROD_ENT_00.NF_ENTRADA)
							if (thisformset.px_total_geral+xQtdeRet.Qtde_a) <> xQtdeEntradaNF.qtde_item
								MESSAGEBOX('QTDE DA ENTRADA DIFERENTE DA QTDE DA NF',0+48)
								RETURN .F.
							endif	
					ENDIF
							
				
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
					
					
					
				
				case UPPER(xmetodo) == 'USR_SAVE_AFTER' 
					
					xalias=alias()
						
						
						
						TEXT TO xupdt TEXTMERGE NOSHOW
							UPDATE ESTOQUE_PROD_ENT 
							SET NOME_CLIFOR =
							(SELECT DISTINCT NOME_CLIFOR
							FROM W_PRODUCAO_ORDEM_HIST_OS A
							JOIN PRODUCAO_RECURSOS B
							ON A.DESC_RECURSO = B.DESC_RECURSO
							WHERE INDICADOR_TIPO_MOV = '1' 
							AND NF_ENTRADA <> '' 
							AND FASE_PRODUCAO1 = '021'
							AND ORDEM_PRODUCAO = '<<V_ESTOQUE_PROD_ENT_00_PRODUTOS.ORDEM_PRODUCAO>>'
							AND NF_ENTRADA = '<<V_ESTOQUE_PROD_ENT_00.NF_ENTRADA>>')
							WHERE ROMANEIO_PRODUTO = '<<V_ESTOQUE_PROD_ENT_00.ROMANEIO_PRODUTO>>'
						ENDTEXT

						f_update(xupdt) 	
			
					*****************************
					xProduto=''	
					sele v_estoque_prod_ent_00_produtos
					GO TOP 
						scan 
							
							SELE v_estoque_prod_ent_00_produtos
							if  !ALLTRIM(v_estoque_prod_ent_00_produtos.produto) $ ALLTRIM(xProduto)
									f_update("EXEC SOMA.DBO.LX_CALCULA_CUSTO_EFETIVO_PRODUTO ?v_estoque_prod_ent_00_produtos.produto")							
									xProduto = xProduto + ALLTRIM(v_estoque_prod_ent_00_produtos.produto)
								
							endif		
								
							sele v_estoque_prod_ent_00_produtos
						endscan			
			
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
						
				
				
				
				case UPPER(xmetodo) == 'USR_VALID' 
				
				xalias=alias()
				
				
				IF UPPER(xnome_obj) == 'CMB_NF_ENTRADA' AND THISFORMSET.P_TOOL_STATUS="P"
								
					if messagebox("Confirma a inclusão da NF "+allt(v_estoque_prod_ent_00.nf_entrada)+" ?",4+32+256,"Atenção!")=6
						
						PUBLIC xQtdeEntradaNF,xQtdeRet,xTot_entrada,xTmpOP 
						xTot_entrada = 0
						xTmpOP = thisformset.LX_FORM1.LX_pageframe1.Page1.LX_GRID_FILHA1.Col_tx_ORDEM_PRODUCAO.Tx_ORDEM_PRODUCAO.Value
						
						TEXT TO xselqtde_entrada TEXTMERGE NOSHOW					
							
							SELECT SUM(PRODUCAO_OS_ANTERIOR.QTDE_A) AS QTDE_ITEM
							FROM PRODUCAO_OS_ANTERIOR PRODUCAO_OS_ANTERIOR 
							INNER JOIN PRODUCAO_ORDEM_SERVICO PRODUCAO_ORDEM_SERVICO 
							ON PRODUCAO_OS_ANTERIOR.ORDEM_SERVICO = PRODUCAO_ORDEM_SERVICO.ORDEM_SERVICO 
							WHERE PRODUCAO_ORDEM_SERVICO.NF_ENTRADA =  '<<V_ESTOQUE_PROD_ENT_00.NF_ENTRADA>>'  
							AND PRODUCAO_OS_ANTERIOR.PRODUTO = '<<V_ESTOQUE_PROD_ENT_00_PRODUTOS.PRODUTO>>'
							AND PRODUCAO_OS_ANTERIOR.ORDEM_PRODUCAO = '<<xTmpOP>>'
							AND PRODUCAO_ORDEM_SERVICO.FASE_PRODUCAO = '021'  
						
						ENDTEXT
						
						f_select("SELECT ISNULL(SUM(QTDE_A),0) AS QTDE_A FROM (SELECT QTDE_A FROM W_PRODUCAO_ORDEM_HIST_OS WHERE INDICADOR_TIPO_MOV = '5' AND ORDEM_PRODUCAO = ?xTmpOP AND NF_ENTRADA = ?V_ESTOQUE_PROD_ENT_00.NF_ENTRADA) A","xQtdeRet")
								
						f_select(xselqtde_entrada,"xQtdeEntradaNF")
												
						
						IF !f_vazio(V_ESTOQUE_PROD_ENT_00.NF_ENTRADA)
								if (thisformset.px_total_geral+xQtdeRet.Qtde_a) <> xQtdeEntradaNF.qtde_item
									MESSAGEBOX('QTDE DA ENTRADA DIFERENTE DA QTDE DA NF',0+48)
									RETURN .F.
								endif	
						ENDIF
												
						
						TEXT TO xupdt1 TEXTMERGE NOSHOW
							UPDATE ESTOQUE_PROD_ENT 
							SET NF_ENTRADA = '<<V_ESTOQUE_PROD_ENT_00.NF_ENTRADA>>',
							NOME_CLIFOR =
							(SELECT DISTINCT NOME_CLIFOR
							FROM W_PRODUCAO_ORDEM_HIST_OS A
							JOIN PRODUCAO_RECURSOS B
							ON A.DESC_RECURSO = B.DESC_RECURSO
							WHERE INDICADOR_TIPO_MOV = '1' 
							AND NF_ENTRADA <> '' 
							AND FASE_PRODUCAO1 = '021'
							AND ORDEM_PRODUCAO = '<<xTmpOP>>'
							AND NF_ENTRADA = '<<V_ESTOQUE_PROD_ENT_00.NF_ENTRADA>>')
							WHERE ROMANEIO_PRODUTO = '<<V_ESTOQUE_PROD_ENT_00.ROMANEIO_PRODUTO>>'
						ENDTEXT
						
						f_update(xupdt1) 	
						
						thisformset.lx_FORM1.cmb_nf_entrada.enabled=.F.
						
						endif
					ENDIF	


					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
																					
																	
				otherwise
				return .t.				
			endcase

	endproc
ENDDEFINE


**************************************************
*-- Class:        lb_nf_entrada (p:\tmpsid\entradas_rbx\lb_nf_entrada.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_nf_entrada AS lx_label


	Caption = "NF Entrada"
	Height = 15
	Left = 669
	Top = 105
	Width = 22
	FontBold = .T.
	FontSize = 8
	FontName = "Tahoma"
	TabIndex = 10
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_nf_entrada"
	Visible = .t.
	Anchor = 0


	PROCEDURE DblClick	
		
		If thisformset.p_tool_status="P" and f_vazio(v_estoque_prod_ent_00.nf_entrada) 
				thisformset.lx_form1.Lx_pageframe1.page1.LX_GRID_FILHA1.SetFocus()
				thisformset.lx_form1.cmb_nf_entrada.enabled=.T.		
		Endif
	
	ENDPROC 

ENDDEFINE
*
*-- EndDefine: lb_status_entrada 
**************************************************

**************************************************
*-- Class:        cmb_nf_entrada (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_nf_entrada AS lx_combobox

	RowSource = ""
	ControlSource = ""
	TabIndex = 1
	Height = 22
	Left = 694
	Top = 102
	Width = 81
	Name = "cmb_nf_entrada"
	Anchor = 0
	Visible = .t.
	Enabled = .f.
	
ENDDEFINE
*
*-- EndDefine: cmb_nf_entrada
**************************************************

