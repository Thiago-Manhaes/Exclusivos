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
					
					* 22/07/2014 - Leandro Rocha (SS): Aumentei tamanho do campo porque é usado como prioridade da distribuição também, e apenas 9 era pouco.
					thisformset.lx_FORM1.lx_pageframe1.page3.sp_PRIORIDADE.SpinnerHighValue = 999
					thisformset.lx_FORM1.lx_pageframe1.page3.sp_PRIORIDADE.InputMask = '999'
					

				
					xalias=alias()
				
						**** INCLUE BOTAO NA TELA ****
						thisformset.lx_FORM1.lx_pageframe1.page1.lx_chkbox_clifor1.Chk_filial.Visible=.f. 
						thisformset.lx_form1.addobject("bt_copia_dados","bt_copia_dados")
						
						** Botão Atualizar dados Cobrança e Entrega
						 ** Lucas Miranda - 06/09/2017
						 	With thisformset.lx_form1.lx_pageframe1.page2
								.AddObject("btn_atu_dados_cob_entr","btn_atu_dados_cob_entr")
							Endwith
						 ** Fim Botão Atualizar dados Cobrança e Entrega
				
				
					if	!f_vazio(xalias)	
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
				
				case upper(xmetodo) == 'USR_REFRESH'

				xalias=alias()
				*** #1 - LUCAS MIRANDA - 25/07/2016 - BLOQUEAR CONDICAO DE PAGAMENTO SE FOR DIFERENTE DE 999
				IF Thisformset.P_TOOl_status $ 'I,A'	
						If Thisformset.pp_anm_bloq_cond_pagamento = .t.
							if v_clientes_01.condicao_pgto <> '999'
								sele v_clientes_01
								replace v_clientes_01.condicao_pgto with '999'
								Thisformset.lx_form1.lx_pageframe1.page3.Cmb_COND_PGTO.Enabled = !Thisformset.pp_anm_bloq_cond_pagamento
								Thisformset.lx_form1.lx_pageframe1.page3.Cmb_COND_PGTO.refresh()
							else
								Thisformset.lx_form1.lx_pageframe1.page3.Cmb_COND_PGTO.Enabled = Thisformset.pp_anm_altera_cond_pagamento
								
							endif
						endif
				Endif
				***
				** Consumo Estoque Terceiro
						** Lucas Miranda - 04/09/2017
						if type("thisformset.lx_form1.lx_pageframe1.page2.btn_atu_dados_cob_entr")<>"U"
							If Thisformset.p_tool_status $ "IA"
								thisformset.lx_form1.lx_pageframe1.page2.btn_atu_dados_cob_entr.Enabled=.t.
							Endif	
						Endif
						** Fim - Consumo Estoque Terceiro	 
				
				if	!f_vazio(xalias)	
					sele &xalias 
				endif
								
				
				case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TV_NOME_CLIFOR'
				
				xalias=alias()
					
					**** EVITA ESPACO ANTES DO NOME CLIFOR NO CADASTRO ****
					thisformset.lx_FORM1.Tv_Nome_clifor.value = LTRIM(UPPER(thisformset.lx_FORM1.Tv_Nome_clifor.value))
					
					**** INSERI MATRIZ CLIENTE IGUAL AO NOME CLIFOR ****
					thisformset.lx_FORM1.Lx_pageframe1.Page3.Tv_Matriz_cliente.value = LTRIM(UPPER(thisformset.lx_FORM1.Tv_Nome_clifor.value))
				
				case upper(xmetodo) == 'USR_SAVE_BEFORE'
				
				xalias=alias()
				
				**** VALIDA SE CONTA CONTABIL FOI CADASTRADA, SENAO RETORNA FALSE ****
				IF f_vazio(thisformset.lx_FORM1.Lx_pageframe1.Page3.Tv_Ctb_Conta_Contabil.value)
					messagebox("É Obrigatorio Cadastrar a Conta Contabil na aba Compl. 2 !",48,"Atenção!!!")
					retu .F.
				ENDIF
				**********************************************************************
				
				

				sele v_Clientes_01

					clicInativo = thisformset.lx_fORM1.lx_pageframe1.page5.Lx_checkbox1.value

						cSQL = "SELECT DISTINCT CLIENTES_ATACADO.COD_CLIENTE, CLIENTES_ATACADO.CLIENTE_ATACADO, CADASTRO_CLI_FOR.IND_REPRESENTANTE " + ;
							       "FROM CLIENTES_ATACADO JOIN CADASTRO_CLI_FOR " + ;
							       "ON CLIENTES_ATACADO.CGC_CPF = CADASTRO_CLI_FOR.CGC_CPF " + ;
								   "AND CLIENTES_ATACADO.CLIENTE_ATACADO = CADASTRO_CLI_FOR.NOME_CLIFOR " + ;
							       "WHERE CLIENTES_ATACADO.CGC_CPF = ?v_Clientes_01.CGC_CPF AND " + ;
							             "CLIENTES_ATACADO.INATIVO = 0 AND CADASTRO_CLI_FOR.IND_REPRESENTANTE = 0 AND CLIENTES_ATACADO.CLIENTE_ATACADO <> ?v_Clientes_01.CLIENTE_ATACADO " + ;
							             "AND CLIENTES_ATACADO.CGC_CPF <> '73147621000176'"

							F_Select(cSQL, "curDup")

							If Used("curDup")

								If Reccount("curDup") > 0 AND thisformset.pp_anm_bloqueia_cnpj_duplica = .T. and v_clientes_01.uf <> 'EX'
									*#2#
										if clicInativo  = .t.
												RETURN .T.
										ENDIF	
										
										if clicInativo  = .F.
											MESSAGEBOX("Já existe um cliente com esse CNPJ/CPF. Verifique!",64,"ATENÇÃO!")
											RETURN .F.
										endif	
								ENDIF
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
*-- Class:        bt_copia_dados (c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   11/20/08 01:37:14 PM
*
DEFINE CLASS bt_copia_dados AS botao


	Top = 29
	Left = 455
	Height = 23
	Width = 47
	*FontBold = .T.
	Caption = "Copiar"
	TabIndex = 48
	Name = "bt_copia_dados"
	Visible = .T.


	PROCEDURE Click

_cliptext = 'CLIENTE: '+UPPER(LTRIM(RTRIM(STRCONV(V_CLIENTES_01.CLIENTE_ATACADO,7))))+CHR(13);
+'RAZÃO SOCIAL: '+UPPER(LTRIM(RTRIM(STRCONV(V_CLIENTES_01.RAZAO_SOCIAL,7))))+CHR(13);
+'CNPJ: '+LTRIM(RTRIM(STRCONV(V_CLIENTES_01.CGC_CPF,7)))+CHR(13);
+'I.E: '+LTRIM(RTRIM(STRCONV(V_CLIENTES_01.RG_IE,7)))+CHR(13);
+'END: '+UPPER(LTRIM(RTRIM(STRCONV(V_CLIENTES_01.ENDERECO,7))))+', '+LTRIM(RTRIM(STRCONV(V_CLIENTES_01.NUMERO,7)))+' '+UPPER(LTRIM(RTRIM(STRCONV(V_CLIENTES_01.COMPLEMENTO,7))))+CHR(13);
+'BAIRRO: '+UPPER(LTRIM(RTRIM(STRCONV(V_CLIENTES_01.BAIRRO,7))))+CHR(13);
+'CIDADE: '+UPPER(LTRIM(RTRIM(STRCONV(V_CLIENTES_01.CIDADE,7))))+'   UF: '+UPPER(LTRIM(RTRIM(STRCONV(V_CLIENTES_01.UF,7))))+CHR(13);
+'CEP: '+LEFT(LTRIM(RTRIM(STRCONV(V_CLIENTES_01.CEP,7))),5)+'-'+RIGHT(LTRIM(RTRIM(STRCONV(V_CLIENTES_01.CEP,7))),3)+CHR(13);
+'CONTATO: '+UPPER(LTRIM(RTRIM(STRCONV(V_CLIENTES_01.CONTATO,7))))+CHR(13);
+'TEL: ('+LTRIM(RTRIM(STRCONV(V_CLIENTES_01.DDD1,7)))+') '+LTRIM(RTRIM(STRCONV(V_CLIENTES_01.TELEFONE1,7)))+' / '+LTRIM(RTRIM(STRCONV(V_CLIENTES_01.TELEFONE2,7)))+CHR(13);
+'EMAIL: '+LTRIM(RTRIM(STRCONV(V_CLIENTES_01.EMAIL,7)))


	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_copia_dados
**************************************************

**************************************************
*-- Class:        btn_atu_dados_cob_entr(c:\linx desenv\classes lucas\btn_atu_dados_cob_entr.vcx)
*-- ParentClass:  botao (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/06/14 05:29:10 PM
*
Define Class btn_atu_dados_cob_entr As botao

	Top = 0
	Left = 429
	Height = 18
	Width = 155
	FontBold = .T. 
	FontName = 'TAHOMA'
	Caption = "Atual. Cobrança/Entrega"
	ForeColor = Rgb(0,0,0)
	Name = "btn_atu_dados_cob_entr"
	Visible = .T.


	Procedure Click
	
		If Thisformset.p_tool_status $ "IA"
			If MESSAGEBOX("Deseja atualizar os dados Cobrança e Entrega ?",4+32) = 6
			
			** Cobrança
				SELECT v_clientes_01
					replace v_clientes_01.cobranca_endereco WITH v_clientes_01.endereco,;
							v_clientes_01.cobranca_cidade WITH v_clientes_01.cidade,;
							v_clientes_01.cobranca_uf WITH v_clientes_01.uf,;
							v_clientes_01.cobranca_bairro WITH v_clientes_01.bairro,;
							v_clientes_01.cobranca_pais WITH v_clientes_01.pais,;
							v_clientes_01.cobranca_cep WITH v_clientes_01.cep,;
							v_clientes_01.cobranca_telefone WITH v_clientes_01.telefone1,;
							v_clientes_01.cobranca_ddd WITH v_clientes_01.ddd1,;
							v_clientes_01.cobranca_cgc WITH v_clientes_01.cgc_cpf,;
							v_clientes_01.cobranca_ie WITH v_clientes_01.rg_ie,;
							v_clientes_01.cobranca_ddi WITH v_clientes_01.ddi,;					
							v_clientes_01.cobranca_numero WITH v_clientes_01.numero,;
							v_clientes_01.cobranca_complemento WITH v_clientes_01.complemento,;
							v_clientes_01.cobranca_razao_social WITH v_clientes_01.razao_social	
			** Entrega
			
				SELECT v_clientes_01
					replace v_clientes_01.entrega_endereco WITH v_clientes_01.endereco,;
							v_clientes_01.entrega_cidade WITH v_clientes_01.cidade,;
							v_clientes_01.entrega_uf WITH v_clientes_01.uf,;
							v_clientes_01.entrega_bairro WITH v_clientes_01.bairro,;
							v_clientes_01.entrega_pais WITH v_clientes_01.pais,;
							v_clientes_01.entrega_cep WITH v_clientes_01.cep,;
							v_clientes_01.entrega_telefone WITH v_clientes_01.telefone1,;
							v_clientes_01.entrega_ddd WITH v_clientes_01.ddd1,;
							v_clientes_01.entrega_cgc WITH v_clientes_01.cgc_cpf,;
							v_clientes_01.entrega_ie WITH v_clientes_01.rg_ie,;
							v_clientes_01.entrega_ddi WITH v_clientes_01.ddi,;					
							v_clientes_01.entrega_numero WITH v_clientes_01.numero,;
							v_clientes_01.entrega_complemento WITH v_clientes_01.complemento,;
							v_clientes_01.entrega_razao_social WITH v_clientes_01.razao_social 			
			
				Thisformset.lx_form1.lx_pageframe1.page2.Refresh()
			
			Endif
			
		Endif
				
Enddefine
*
*-- EndDefine: btn_gs_consumo_terceiro
**************************************************
