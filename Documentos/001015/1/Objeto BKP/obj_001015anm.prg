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
				
					* 22/07/2014 - Leandro Rocha (SS): Aumentei tamanho do campo porque é usado como prioridade da distribuição também, e apenas 9 era pouco.
					thisformset.lx_FORM1.lx_pageframe1.page3.sp_PRIORIDADE.SpinnerHighValue = 999
					thisformset.lx_FORM1.lx_pageframe1.page3.sp_PRIORIDADE.InputMask = '999'
					

				
					xalias=alias()
				
						**** INCLUE BOTAO NA TELA ****
						thisformset.lx_FORM1.lx_pageframe1.page1.lx_chkbox_clifor1.Chk_filial.Visible=.f. 
						thisformset.lx_form1.addobject("bt_copia_dados","bt_copia_dados")
						thisformset.lx_form1.Lx_pageframe1.Page3.addobject("botao_conceito","botao_conceito")
				
						
						*** Criar aba de calculo conceito ***
						with thisformset.lx_form1
							.lx_pageframe1.PageCount = 11
							.lx_pageframe1.page10.Caption = "Concei\<to"
							.lx_pageframe1.page10.FontSize = 8
							.Lx_pageframe1.page10.addobject("lx_faixa_dt_conceito","lx_faixa_dt_conceito")
							.Lx_pageframe1.page10.addobject("btn_calcular_conceito","btn_calcular_conceito")
						endwith	 
						
						*** Verifica o parametro se o usuário tem permissão para acessar a aba ***
						IF thisformset.PP_anm_permite_calc_conceito = .T.
							thisformset.LX_FORM1.LX_pageframe1.PAGE10.Enabled = .T.
						ELSE
							thisformset.LX_FORM1.LX_pageframe1.PAGE10.Enabled = .F.
						endif
							
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
				
				case upper(xmetodo) == 'USR_SEARCH_BEFORE'
				
				xalias=alias()
					
					**** Comando para o filtro de datas da aba conceito não bloquear pesquisa ****
					Thisformset.lx_FORM1.lx_pageframe1.page10.Lx_faixa_dt_conceito.CMB_DATA.Value=""
					Thisformset.lx_FORM1.lx_pageframe1.page10.Lx_faixa_dt_conceito.CMB_DATA.l_desenhista_recalculo()
					**** Fim - Comando para o filtro de datas da aba conceito não bloquear pesquisa ****				
					
				if	!f_vazio(xalias)	
					sele &xalias 
				endif
				
				
				case upper(xmetodo) == 'USR_CLEAN_AFTER'
				
				xalias=alias()

					
					**** Comando para o filtro de datas da aba conceito não bloquear pesquisa ****
					IF TYPE("o_001015.lx_FORM1.lx_pageframe1.page10.Lx_faixa_dt_conceito.CMB_DATA") = "O"
						Thisformset.lx_FORM1.lx_pageframe1.page10.Lx_faixa_dt_conceito.CMB_DATA.Value="CADASTRAMENTO"
						Thisformset.lx_FORM1.lx_pageframe1.page10.Lx_faixa_dt_conceito.CMB_DATA.l_desenhista_recalculo()
					ENDIF	
					**** Fim - Comando para o filtro de datas da aba conceito não bloquear pesquisa ****				
					
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

*!*						cSQL = "SELECT CLIENTES_ATACADO.COD_CLIENTE, CLIENTES_ATACADO.CLIENTE_ATACADO " + ;
*!*								       "FROM CLIENTES_ATACADO " + ;
*!*								       "WHERE CLIENTES_ATACADO.CGC_CPF = ?v_Clientes_01.CGC_CPF AND " + ;
*!*								             "CLIENTES_ATACADO.INATIVO = 0 AND CLIENTES_ATACADO.CLIENTE_ATACADO <> ?v_Clientes_01.CLIENTE_ATACADO"
						
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
											*IF MESSAGEBOX("Você está inativando um cliente!! Existe outro Cliente Ativo com o mesmo CNPJ."+CHR(13)+"Deseja continuar salvando ?",4+32,"ATENÇÃO!") = 6
												RETURN .T.
											*ELSE
											*	RETURN .F.
											*ENDIF
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
*-- Class:        botao_conceito (c:\pastas\work\classes_julio\botao_conceito.vcx)
*-- ParentClass:  botao (c:\pastas\work\linx_sql_fonte\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/23/14 12:17:04 PM
*
DEFINE CLASS botao_conceito AS botao


	Top = 34
	Left = 73
	Height = 19
	Width = 55
	Caption = "Conceito"
	Visible = .T. 
	Name = "botao_conceito"


	PROCEDURE Click
	
		IF thisformset.p_tool_status = 'P'
			sele v_clientes_01
			f_select("select * from WANM_CLIENTES_ATACADO_FLIMV where cliente_atacado = ?v_clientes_01.cliente_atacado","CurCli_Conceito")

			MESSAGEBOX("Frequência: "+ALLTRIM(STR(CurCli_Conceito.frequencia))         +CHR(13)+;
           			   "Liquidez"+SPACE(5) +": "+ALLTRIM(STR(CurCli_Conceito.liquidez))+CHR(13)+;
                       "Imagem"  +SPACE(6) +": "+ALLTRIM(STR(CurCli_Conceito.imagem))  +CHR(13)+;
           			   "Mix"     +SPACE(13)+": "+ALLTRIM(STR(CurCli_Conceito.mix))     +CHR(13)+;
           			   "Volume"  +SPACE(6) +": "+ALLTRIM(STR(CurCli_Conceito.volume))  +CHR(13)+;
           			   "__________________"                                            +CHR(13)+;
           			   "Total"   +SPACE(12)+": "+ALLTRIM(STR(CurCli_Conceito.frequencia+;
           						 							 CurCli_Conceito.liquidez  +;
           						 							 CurCli_Conceito.imagem    +;
           						 							 CurCli_Conceito.mix       +;
           						 							 CurCli_Conceito.volume    )),64,"Detalhamento do Conceito Cliente: ")
		ENDIF
	
	ENDPROC


ENDDEFINE
*
*-- EndDefine: botao_conceito
**************************************************


**************************************************
*-- Class:        data_conceito (c:\linx desenv\classes lucas\data_conceito.vcx)
*-- ParentClass:  lx_faixa_data (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    container
*-- Time Stamp:   09/23/14 05:46:06 PM
*
DEFINE CLASS lx_faixa_dt_conceito AS lx_faixa_data


	Top = 29
	Left = 21
	Width = 252
	Height = 84
	Name = "lx_faixa_dt_conceito"
	Visible = .T.
	CMB_DATA.Left = 12
	CMB_DATA.Top = 53
	CMB_DATA.Visible = .F.
	CMB_DATA.Name = "CMB_DATA"
	DATA_INICIAL.Left = 24
	DATA_INICIAL.Top = 25
	DATA_INICIAL.Name = "DATA_INICIAL"
	DATA_FINAL.Left = 130
	DATA_FINAL.Top = 25
	DATA_FINAL.Name = "DATA_FINAL"
	Lx_label1.Left = 7
	Lx_label1.Top = 27
	Lx_label1.Name = "Lx_label1"
	Lx_label2.Left = 108
	Lx_label2.Top = 27
	Lx_label2.Name = "Lx_label2"
	Lx_label3.Caption = "Filtro de data"
	Lx_label3.Left = 9
	Lx_label3.Top = 6
	Lx_label3.Name = "Lx_label3"


	PROCEDURE Init
		DODEFAULT()

		this.CMB_DATA.ValuE = "CADASTRAMENTO"
		this.CMB_DATA.l_desenhista_recalculo()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: data_conceito
**************************************************

**************************************************
*-- Class:        btn_calcular1 (c:\linx desenv\classes lucas\btn_calcular1.vcx)
*-- ParentClass:  botao (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/23/14 06:19:10 PM
*
DEFINE CLASS btn_calcular_conceito AS botao


	Top = 79
	Left = 31
	Height = 24
	Width = 96
	Caption = "Calcular Conceito"
	Name = "btn_calcular_conceito"
	Visible = .T.

	PROCEDURE Click
		
		cDtInicial=thisformset.lx_form1.lx_pageframe1.page10.lx_faixa_dt_conceito.DATA_INICIAL.value
		cDtFinal=thisformset.lx_form1.lx_pageframe1.page10.lx_faixa_dt_conceito.DATA_FINAL.Value
		
		IF MESSAGEBOX("Confirma o calculo do conceito de clientes"+CHR(13)+"Entre as datas: "+DTOC(cDtInicial)+" e "+DTOC(cDtFinal)+" ?",4+32+256)=6
			
			F_WAIT("Aguarde ... calculando Conceito dos Clientes"+CHR(13)+"O processo poderá demorar alguns minutos")
			
			IF !f_update("EXEC LX_ANM_ATUALIZA_CONCEITO_CLIENTE ?cDtInicial,?cDtFinal")
				F_WAIT()
				MESSAGEBOX("Ocorreu algum problema no calculo"+CHR(13)+"Favor procurar a equipe de suporte",64)				
			ELSE
				F_WAIT()
				MESSAGEBOX("Calculo do conceito efetuado com sucesso!",64)
			ENDIF
		ENDI			
	ENDPROC


ENDDEFINE
*
*-- EndDefine: btn_calcular1
**************************************************
