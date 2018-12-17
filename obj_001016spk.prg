* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesae                                                                                                *
* DATA...........:  07/02/2011                                                                                               *
* HORÁRIO........:  12:16                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Retirar espaços antes do nome clifor e bloquear cadastro sem conta contabil					                    *
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
					
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
					
					*** "BLOQUEAR" FILIAL
					*thisformset.lx_FORM1.lx_pageframe1.page1.lx_chkbox_clifor1.chk_filial.Visible= .F.
					
					with thisformset.lx_form1.lx_PAGEFRAME1.PAGE3
						.addobject("lb_criado_por","lb_criado_por")
						.addobject("Tx_criado_por","Tx_criado_por") 
					endwith		
					
					
				case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TV_FORNECEDOR'
				
				xalias=alias()
					
					**** EVITA SALVAR COM ESPACO ANTES DO NOME DO FORNECEDOR ****
					thisformset.lx_FORM1.Tv_Fornecedor.value = LTRIM(UPPER(thisformset.lx_FORM1.Tv_Fornecedor.value))
				
				if	!f_vazio(xalias)	
					sele &xalias 
				ENDIF		
				
				case UPPER(xmetodo) == 'USR_REFRESH'
					
					xalias=alias()
					
						IF Thisformset.P_tool_status = 'P'
							If type('thisformset.lx_form1.lx_PAGEFRAME1.page3.Tx_criado_por')<>'U'
							
								Text To xSelLogForn TextMerge Noshow
																	
									SELECT TOP 1 USUARIO FROM ANM_FORNECEDORES_LOG
									WHERE TRIGGER_ORIGEM = 'I'
									AND FORNECEDOR = LTRIM(RTRIM('<<v_fornecedores_01.fornecedor>>'))
									ORDER BY DATA_ALTERACAO
									 	
								Endtext
								f_select(xSelLogForn,"xLogFornecedor")
								
								thisformset.lx_form1.lx_PAGEFRAME1.page3.Tx_criado_por.Value       = UPPER(ALLTRIM(xLogFornecedor.USUARIO)) 
								thisformset.lx_form1.lx_PAGEFRAME1.page3.Tx_criado_por.ToolTipText = UPPER(ALLTRIM(xLogFornecedor.USUARIO)) 
								
							Endif
						ENDIF
						
						** Início controle de alteração do pageframe dados bancários ***
						IF thisformset.p_tool_status $ 'A' AND type("thisformset.pp_anm_per_alt_banco_forn")<>"U"
							thisformset.lx_FORM1.lx_pageframe1.page2.lx_pageframe1.Enabled = thisformset.pp_anm_per_alt_banco_forn
						ELSE
							thisformset.lx_FORM1.lx_pageframe1.page2.lx_pageframe1.Enabled = .T.
						ENDIF	
						** Fim controle de alteração do pageframe dados bancários ***
						
						If thisformset.p_tool_status $ 'IA'
							thisformset.lx_form1.lx_pageframe1.page1.lx_chkbox_clifor1.chk_filial.Enabled=thisformset.pp_anm_permite_filial_forn
						Endif

					if !f_vazio(xalias)
						sele &xalias
					endif						
					 
				case upper(xmetodo) == 'USR_ALTER_AFTER'
				xalias=alias()	
				
					Thisformset.lx_form1.lx_pageframe1.page1.tx_CGC_CPF_A.Enabled		= !Thisformset.pp_anm_bloq_campo_cnpj
					Thisformset.lx_form1.lx_pageframe1.page2.tx_COBRANCA_CGC.Enabled	= !Thisformset.pp_anm_bloq_campo_cnpj
					Thisformset.lx_form1.lx_pageframe1.page2.tx_enTREGA_CGC.Enabled		= !Thisformset.pp_anm_bloq_campo_cnpj

				if	!f_vazio(xalias)	
					sele &xalias 
				ENDIF				
				
				
				case UPPER(ALLT(xmetodo)) == 'USR_SAVE_BEFORE'
			
				xalias=alias()
					
					
					If !f_vazio(v_fornecedores_01.nome_banco)
					xSel="SELECT * FROM CTB_LX_METODO_PAGAMENTO WHERE METODO_PAGAMENTO LIKE '%"+ALLTRIM(v_fornecedores_01.nome_banco)+"%' AND ANM_N_VALIDA_PAGAMENTO=1"
						F_Select(xSel,"xMetodoPagamento")
						If RECCOUNT()>0
							if alltrim(v_fornecedores_01.METODO_PAGAMENTO) <> ALLTRIM(xMetodoPagamento.metodo_pagamento)
								Messagebox("Método do Pagamento incompatível com o banco !!!",0+16,"Método Pagamento")
								Return .F.
							Endif
						Endif
					Endif

					*** VALIDA SE CONTA CONTABIL FOI CADASTRADA, SENAO RETORNA FALSE ****
					IF f_vazio(thisformset.lx_FORM1.Lx_pageframe1.Page3.Tv_Ctb_Conta_Contabil.value)
						messagebox("É Obrigatorio Cadastrar a Conta Contabil na aba Compl. 2 !",48,"Atenção!!!")
						retu .F.	
					ENDIF

					sele v_Fornecedores_01

					forInativo = Thisformset.lx_form1.lx_pageframe1.page3.ck_INATIVO.value

					cSQL = "SELECT FORNECEDORES.COD_FORNECEDOR, FORNECEDORES.FORNECEDOR " + ;
							       "FROM FORNECEDORES " + ;
							       "WHERE FORNECEDORES.CGC_CPF = ?v_Fornecedores_01.CGC_CPF AND " + ;
							             "FORNECEDORES.INATIVO = 0 AND FORNECEDORES.FORNECEDOR <> ?v_Fornecedores_01.FORNECEDOR"

							F_Select(cSQL, "curDup")
							
							If Used("curDup")

								If Reccount("curDup") > 0 AND Thisformset.pp_anm_bloqueia_cnpj_duplica = .T. and v_Fornecedores_01.uf <> 'EX'
																
										if forInativo = .F.
											MESSAGEBOX("Já existe um fornecedor com esse CNPJ/CPF. Verifique!",64,"ATENÇÃO!")
											RETURN .F.
										endif	
								ENDIF
							Endif
				
				if	!f_vazio(xalias)	
					sele &xalias 
				endif
				
				case upper(xmetodo) == 'USR_CLEAN_AFTER' 
					If type('thisformset.lx_form1.lx_PAGEFRAME1.page3.Tx_criado_por')<>'U'
						thisformset.lx_form1.lx_PAGEFRAME1.page3.Tx_criado_por.Value       = ''
					Endif				
					 
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE

*-- Class:        lb_criado_por(c:\pastas\anm_class\lb_conferido_por.vcx)
*-- ParentClass:  label
*-- BaseClass:    label
*-- Time Stamp:   03/07/14 10:37:02 AM
*
DEFINE CLASS lb_criado_por AS lx_label


	FontName = "Tahoma"
	FontSize = 8
	BackStyle = 0
	Caption = "Criado por:"
	Visible = .t.
	Height = 14
	Left = 460
	Top = 235
	Width = 71
	Name = "lb_criado_por"


ENDDEFINE
*
*-- EndDefine: lb_criado_por
**************************************************

**************************************************
*-- Class:        Tx_criado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_criado_por AS lx_textbox_base 


	FontName = "Tahoma"
	FontSize = 8
	Visible = .t.
	Enabled = .F.
	Height = 19
	Left = 520
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 235
	Width = 140
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_criado_por"


ENDDEFINE
*
*-- EndDefine: Tx_criado_por
**************************************************

