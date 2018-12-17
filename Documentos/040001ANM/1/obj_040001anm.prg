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
									IF v_Produto_Operacoes_00_Rotas.recurso_produtivo<>'99'
										MESSAGEBOX("O USUÁRIO TEM PERMISSÃO PARA INCLUIR NESTA FASE SOMENTE O RECURSO '99' - 'AGUARDANDO DEFINIÇAO'!!",48) 
										REPLACE recurso_produtivo WITH '99'
										REPLACE desc_recurso WITH 'AGUARDANDO DEFINIÇAO'
										RETURN .f.
									ENDIF 
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
									IF v_Produto_Operacoes_00_Rotas.recurso_produtivo<>'99'
										MESSAGEBOX("O USUÁRIO TEM PERMISSÃO PARA INCLUIR NESTA FASE SOMENTE O RECURSO '99' - 'AGUARDANDO DEFINIÇAO'!!",48) 
										REPLACE recurso_produtivo WITH '99'
										REPLACE desc_recurso WITH 'AGUARDANDO DEFINIÇAO'
										RETURN .f.
									ENDIF 
							ENDIF                                                       
					ENDIF		
											

****** Bloqueio de alocação de recursos - Silvio Luiz - 27042016 ***********************	

			

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
								
							Endif
						ENDIF
					
					if	!f_vazio(xalias)	
					  sele &xalias 
				    endif
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