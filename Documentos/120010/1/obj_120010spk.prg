* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  28/10/2009                                                                                            *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: 					                    *
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
				
				   	XALIAS=ALIAS()
				   	
						PUBLIC CURTMPSAIDAS 
						F_SELECT("SELECT PRODUTO, COR_PRODUTO, ROMANEIO_PRODUTO, FILIAL,PRECO1 FROM LOJA_SAIDAS_PRODUTO WHERE 1=2","CURTMPSAIDAS")


				
						*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_programa_00  
						sele V_LOJA_SAIDAS_00 
						xalias_pai=alias()

		  				oCur = getcursoradapter(xalias_pai)
						oCur.addbufferfield("ANM_COD_CLIENTE", "C(6)",.T., "ANM_COD_CLIENTE", "LOJA_SAIDAS.ANM_COD_CLIENTE")										
						oCur.addbufferfield("ANM_OBS", "M",.T., "ANM_OBS", "LOJA_SAIDAS.ANM_OBS")							
						oCur.confirmstructurechanges() 	
						**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 				
						
						with thisformset.lx_FORM1.lx_pageframe1.page1
							.Ed_OBS.left=125
							.Ed_OBS.top =230
							.Ed_OBS.height=100
							.Ed_OBS.Anchor=0
							.label_OBS.Left=27
							.label_OBS.top=230 
							.label_OBS.Anchor=0 
							.label_OBS.Caption="Observação1:"
							.addobject("ed_obs_anm","ed_obs_anm") 
							.addobject("lb_obs_anm","lb_obs_anm")
						endwith	
						
						*Criado botão para executar a entrada
						with thisformset.LX_FORM1.LX_pageframe1.PAGE1
							.AddObject("bt_executar_entrada","bt_executar_entrada")
						endwith	
				   
						thisformset.l_limpa()		
						
								

					IF F_VAZIO(XALIAS)
						SELECT &XALIAS
					ENDIF 
				




				*case upper(xmetodo) == 'USR_REFRESH' 
				

						
*!*							with thisformset.lx_FORM1.lx_pageframe1.page1
*!*								.Ed_OBS.left=125
*!*								.Ed_OBS.top =230
*!*								.Ed_OBS.height=100
*!*								.Ed_OBS.Anchor=0
*!*								.label_OBS.Left=27
*!*								.label_OBS.top=230 
*!*								.label_OBS.Anchor=0 
*!*							endwith	
*!*							


				case UPPER(xmetodo) == 'USR_REFRESH'
				
					xalias=alias() 
						
						F_SELECT("SELECT COUNT(*) TESTE  FROM LOJA_ENTRADAS WHERE ROMANEIO_NF_SAIDA =?V_LOJA_SAIDAS_00.ROMANEIO_PRODUTO AND FILIAL_ORIGEM =?V_LOJA_SAIDAS_00.FILIAL","xRom",ALIAS())
						
						IF type("thisformset.LX_FORM1.LX_pageframe1.PAGE1.bt_executar_entrada")<>"U"
							IF xRom.TESTE=0 and THISFORMSET.p_tool_status = 'P'
								thisformset.LX_FORM1.LX_pageframe1.PAGE1.bt_executar_entrada.visible = .T.
							ELSE
								thisformset.LX_FORM1.LX_pageframe1.PAGE1.bt_executar_entrada.visible = .F.	
							ENDIF
						ENDIF
						
					if	!f_vazio(xalias)	
						sele &xalias 
					ENDIF
					
**-------- impossibilita a troca das filiais na alteração - 31/03/2016 - silvio luiz -----------**	
					IF THISFORMSET.P_TOOL_STATUS ='A'
					
						thisformset.lx_FORM1.tv_FILIAL.Enabled= .F.
						thisformset.lx_FORM1.lx_pageframe1.page1.tv_FILIAL_DESTINO.Enabled= .F.

					endif
					
					
*-------------------------------------------------------------------------------------------------					

				case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) =='TX_PRECO1'
				   	
				   	XALIAS=ALIAS()
										   
					IF V_LOJA_SAIDAS_00.TIPO_ENTRADA_SAIDA='03'


						SELECT CURTMPSAIDAS 
						GO TOP
						LOCATE FOR PRODUTO=V_LOJA_SAIDAS_00_PRODUTOS.PRODUTO ;
						AND COR_PRODUTO=V_LOJA_SAIDAS_00_PRODUTOS.COR_PRODUTO ;
						AND ROMANEIO_PRODUTO=V_LOJA_SAIDAS_00_PRODUTOS.ROMANEIO_PRODUTO ;
						AND FILIAL=V_LOJA_SAIDAS_00_PRODUTOS.FILIAL 		
						
						IF !FOUND()

							SELECT V_LOJA_SAIDAS_00_PRODUTOS 
							SCAN
								SELECT CURTMPSAIDAS
								APPEND BLANK 
								REPLACE PRODUTO WITH V_LOJA_SAIDAS_00_PRODUTOS.PRODUTO  
								REPLACE COR_PRODUTO WITH V_LOJA_SAIDAS_00_PRODUTOS.COR_PRODUTO						
								REPLACE ROMANEIO_PRODUTO WITH V_LOJA_SAIDAS_00_PRODUTOS.ROMANEIO_PRODUTO						
								REPLACE FILIAL WITH V_LOJA_SAIDAS_00_PRODUTOS.FILIAL 						
								REPLACE PRECO1 WITH V_LOJA_SAIDAS_00_PRODUTOS.PRECO1 
							ENDSCAN 

						ELSE 	
							
							SELECT CURTMPSAIDAS
							REPLACE PRECO1 WITH V_LOJA_SAIDAS_00_PRODUTOS.PRECO1 
							
						ENDIF 
					
					ENDIF 

					IF F_VAZIO(XALIAS)
						SELECT &XALIAS
					ENDIF 
					
					

				
				case upper(xmetodo) == 'USR_SAVE_BEFORE' 

				   	XALIAS=ALIAS()

					IF V_LOJA_SAIDAS_00.TIPO_ENTRADA_SAIDA='03'
										   						
						IF THISFORMSET.P_TOOL_STATUS <>'E'

							SELECT V_LOJA_SAIDAS_00_PRODUTOS 
							GO TOP
							SCAN
								SELECT CURTMPSAIDAS
								GO TOP
								LOCATE FOR PRODUTO=V_LOJA_SAIDAS_00_PRODUTOS.PRODUTO ;
								AND COR_PRODUTO=V_LOJA_SAIDAS_00_PRODUTOS.COR_PRODUTO ;
								AND ROMANEIO_PRODUTO=V_LOJA_SAIDAS_00_PRODUTOS.ROMANEIO_PRODUTO ;
								AND FILIAL=V_LOJA_SAIDAS_00_PRODUTOS.FILIAL 

								IF FOUND()
									SELECT V_LOJA_SAIDAS_00_PRODUTOS 
									REPLACE PRECO1 WITH CURTMPSAIDAS.PRECO1
								ENDIF 

								SELECT V_LOJA_SAIDAS_00_PRODUTOS 
								
							ENDSCAN 

						ENDIF				
					
					ENDIF 

					IF F_VAZIO(XALIAS)
						SELECT &XALIAS
					ENDIF 
					
					
**-------- Saida destino somente da mesma matriz fiscal - 04/03/2016 - silvio luiz -----------**	
		*case upper(xmetodo) == 'USR_WHEN' AND upper(xnome_obj) =='TV_COR_PRODUTO'
				IF THISFORMSET.P_TOOL_STATUS ='I'
				
					IF THISFORMSET.pp_120010_matriz_fiscal=.F.
							
						xFilial =(thisformset.lx_form1.tv_filial.value)
						xFilialDestino=(thisformset.lx_form1.lx_pageframe1.page1.tv_filial_destino.value)
		
						TEXT TO xsel NOSHOW TEXTMERGE
							SELECT filial, matriz_fiscal FROM filiais
							where filial=?xfilial
						ENDTEXT
						f_select(xsel, 'curMatriz')
			
						TEXT TO xsel1 NOSHOW TEXTMERGE
							SELECT filial, matriz_fiscal FROM filiais
							where filial=?xfilialDestino
						ENDTEXT
						f_select(xsel1, 'curMatrizDestino')
			
							IF curMatriz.matriz_fiscal<>curMatrizDestino.matriz_fiscal
								MESSAGEBOX("As Filiais não pertencem a mesma Matriz Fiscal!!!",16)
								RETURN .f.
							ENDIF
					ENDIF
				ENDIF
					
				
**----------------------------------------------------------------------------------------------**				
							
							
							



				case upper(xmetodo) == 'USR_SAVE_AFTER' 


				   	XALIAS=ALIAS()

								TEXT TO xAlterNumNF NOSHOW TEXTMERGE
									UPDATE LOJA_SAIDAS SET NUMERO_NF_TRANSFERENCIA = ROMANEIO_PRODUTO
									WHERE SERIE_NF = 'E1' AND ROMANEIO_PRODUTO ='<<V_LOJA_SAIDAS_00.ROMANEIO_PRODUTO>>'
								ENDTEXT 
								
								F_UPDATE(xAlterNumNF)
								

					THISFORMSET.lx_FORM1.LX_PAGEFRAME1.Page1.tX_NUMERO_NF_TRANSFERENCIA.Value=V_LOJA_SAIDAS_00.ROMANEIO_PRODUTO
					O_TOOLBAR.botao_refresh.Click()  
					

					IF V_LOJA_SAIDAS_00.TIPO_ENTRADA_SAIDA='03'
				   	
						IF THISFORMSET.P_TOOL_STATUS <>'E'				   	
	
						   	SELECT CURTMPSAIDAS
							GO TOP
							SCAN 
								TEXT TO XUPDT NOSHOW TEXTMERGE
									UPDATE LOJA_SAIDAS_PRODUTO SET PRECO1=<<CURTMPSAIDAS.PRECO1>> ,
									VALOR=QTDE_SAIDA*<<CURTMPSAIDAS.PRECO1>> 
									WHERE PRODUTO='<<CURTMPSAIDAS.PRODUTO>>' 
									AND COR_PRODUTO='<<CURTMPSAIDAS.COR_PRODUTO>>' 
									AND ROMANEIO_PRODUTO='<<CURTMPSAIDAS.ROMANEIO_PRODUTO>>' 
									AND FILIAL='<<CURTMPSAIDAS.FILIAL>>'  
								ENDTEXT 
								
								IF !F_UPDATE(XUPDT)
									MESSAGEBOX("NÃO FOI POSSÍVEL AJUSTAR PRECO DE TRANSFERENCIA",48,"ATENÇÃO!")
								ENDIF 						
													
							ENDSCAN 
						   	
							
						ENDIF 

				
					F_SELECT("SELECT PRODUTO, COR_PRODUTO, ROMANEIO_PRODUTO, FILIAL,PRECO1 FROM LOJA_SAIDAS_PRODUTO WHERE 1=2","CURTMPSAIDAS")

					THISFORMSET.REFRESH()
					O_TOOLBAR.botao_refresh.Click()  

					ENDIF 


					IF F_VAZIO(XALIAS)
						SELECT &XALIAS
					ENDIF 
	

				otherwise
				return .t.				
			endcase

	
	ENDPROC
	
ENDDEFINE



**************************************************
*-- Class:        ed_obs_anm (c:\temp\ed_obs_anm.vcx)
*-- ParentClass:  lx_editbox (e:\work\bkp_sidnei-arquivos\desenv\desenv7_00\linx_sql\desenv\lib\lx_class.vcx)
*-- BaseClass:    editbox
*-- Time Stamp:   10/13/10 10:48:00 AM
*
DEFINE CLASS ed_obs_anm AS lx_editbox


	Height = 160
	Left = 477
	TabIndex = 22
	Top = 171
	Width = 288
	ZOrderSet = 12
	ControlSource = "v_loja_saidas_00.anm_obs"
	Name = "ed_OBS"
	Visible = .T.
	Enabled = .T.


ENDDEFINE
*
*-- EndDefine: ed_obs_anm
**************************************************
**************************************************
*-- Class:        lb_obs_anm (c:\temp\lb_obs_anm.vcx)
*-- ParentClass:  lx_label (e:\work\bkp_sidnei-arquivos\desenv\desenv7_00\linx_sql\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/13/10 10:48:05 AM
*
DEFINE CLASS lb_obs_anm AS lx_label


	AutoSize = .F.
	Caption = "Observação2:"
	Height = 15
	Left = 381
	Top = 171
	Width = 92
	TabIndex = 21
	ZOrderSet = 13
	p_muda_size = .F.
	Name = "lb_obs_anm"
	Visible = .T.	


ENDDEFINE
*
*-- EndDefine: lb_obs_anm
**************************************************
**************************************************
*-- Class:        bt_altera_data (c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/08/10 01:37:14 PM
*
DEFINE CLASS bt_executar_entrada AS botao

	Top = 45
	Left = 608
	Height = 23
	Width = 121
	FontBold = .T.
	Caption = "Executar Entrada"
	TabIndex = 40
	Name = "bt_executar_entrada"
	Visible = .F.

	PROCEDURE Click
 		
 		TEXT TO xExecProcedure TEXTMERGE NOSHOW
 		
 			DECLARE @COMANDO VARCHAR(MAX) =
			(SELECT TOP 1 COMANDO FROM LX_PROCESSO_LOG WHERE  PROCESSO LIKE '%LX_GERA_TRANSFERENCIA_AUTOMATICA%'    AND 
			                                                  COMANDO  LIKE '%<<V_LOJA_SAIDAS_00.ROMANEIO_PRODUTO>>%' AND 
			                                                  ORIGEM   = 'LXU_LOJA_SAIDAS')
			EXECUTE(@COMANDO)
 		
 		ENDTEXT
 		
		IF F_UPDATE(ALLTRIM(xExecProcedure))	
			MESSAGEBOX("Entrada Gerada, FAVOR VERIFICAR!!!",0+64)	
			
			O_TOOLBAR.BOTAO_REFresh.Click()	
		ENDIF								
	
	ENDPROC
	
	
ENDDEFINE