* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesae                                                                                                *
* DATA...........:  07/02/2011                                                                                               *
* HORÁRIO........:  12:16                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Retirar espaços antes do nome clifor e bloquear cadastro sem conta contabil					                    *
********************************************************************************************************************* 

* Alteração ********************************************************************************************************* 
* PROGRAMADOR(A).:   Julio                                                                                               *
* DATA...........:   28-06-2013                                                                                               *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                                        *
* OBJETIVO.:  Só recalcular os materiais se responder sim na pergunta "deseja recalcular materaiais?"                                                                                                       *
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

				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT
					
				case upper(xmetodo) == 'USR_SAVE_BEFORE'
				
				xalias=alias()
				
				X = MESSAGEBOX("Deseja recalcular a Reserva?",4+32+256)
					IF X = 6 
						Thisformset.Px_Tipo_Mov = 2
					ENDIF
					
					IF X = 7
						Thisformset.Px_Tipo_Mov = 0
					ENDIF


				If Thisformset.p_tool_status $ 'I,A'
					If iif(TYPE("Thisformset.pp_Permite_desprogramar_prod")="U",.f.,.t.)
						
						Sele v_producao_os_01_tarefas
							Go Top
							
							Scan	
								f_select("select * from producao_ordem where ordem_producao=?v_producao_os_01_tarefas.ordem_producao","CurProgrOp")	
								
								xProgNaoValida = 0
								xSelect="select * FROM dbo.FX_ANM_PARAMETROS_REDE_LOJAS('GS_PROG_NAO_BLOQ_DESPROG')"
								f_select(xSelect,"CurValidaNomeProg")
								
								GO top
								SCAN					
									IF ALLTRIM(CurValidaNomeProg.valor_atual) $ ALLTRIM(CurProgrOp.programacao)
										xProgNaoValida = 1
									ENDIF
								ENDSCAN
							Sele v_producao_os_01_tarefas
							ENDSCAN
					
						IF TYPE("CurValidaNomeProg")<>"U"
							USE IN CurValidaNomeProg
						ENDIF	
						
						IF TYPE("CurProgrOp")<>"U"
							USE IN CurProgrOp
						ENDIF	
						
						IF TYPE("Cur_ProdOrdem")<>"U"
							USE IN Cur_ProdOrdem
						ENDIF
						
						IF TYPE("Cur_Valida")<>"U"
							USE IN Cur_Valida
						ENDIF
						
						IF TYPE("CurProgrOp")<>"U"
							USE IN CurProgrOp
						ENDIF
						
						IF TYPE("Cur_ProdOrdem")<>"U"
							USE IN Cur_ProdOrdem
						ENDIF
						
						IF TYPE("CurConsumo")<>"U"
							USE IN CurConsumo
						ENDIF
						
						If xProgNaoValida = 0 AND CurProgrOp.tipo_processo = 0
			
							xQtdeOldProg = 1																	
							xCompradora = '.'
							
							Sele v_producao_os_01_tarefas
							Go Top
							
							Scan	
								TEXT TO xSelCons TEXTMERGE NOSHOW
									SELECT TOP 1 A.* FROM PRODUCAO_ORDEM A
									JOIN PRODUCAO_ORDEM_COR B 
									ON A.ORDEM_PRODUCAO = B.ORDEM_PRODUCAO 
									AND A.PRODUTO = B.PRODUTO
									JOIN PRODUCAO_RESERVA C
									ON B.ORDEM_PRODUCAO = C.ORDEM_PRODUCAO
									AND C.CONSUMIDA > 0
									WHERE A.ORDEM_PRODUCAO = '<<v_producao_os_01_tarefas.ordem_producao>>'
									AND B.PRODUTO = '<<v_producao_os_01_tarefas.produto>>'
									AND B.COR_PRODUTO = '<<v_producao_os_01_tarefas.cor_produto>>'
								ENDTEXT
										
								f_select(xSelCons,"CurConsumo")
							 
								If RECCOUNT("CurConsumo")=0
									TEXT TO xSelOP TEXTMERGE NOSHOW
										SELECT A.PROGRAMACAO, B.* FROM PRODUCAO_ORDEM A
										JOIN PRODUCAO_ORDEM_COR B 
										ON A.ORDEM_PRODUCAO = B.ORDEM_PRODUCAO 
										AND A.PRODUTO = B.PRODUTO
										WHERE A.ORDEM_PRODUCAO = '<<v_producao_os_01_tarefas.ordem_producao>>'
										AND B.PRODUTO = '<<v_producao_os_01_tarefas.produto>>'
										AND B.COR_PRODUTO = '<<v_producao_os_01_tarefas.cor_produto>>'
									ENDTEXT
											
									f_select(xSelOP,"Cur_ProdOrdem")
									
									TEXT TO xSel TEXTMERGE NOSHOW
										Select Count(*) as OK From GS_PROGRAMACAO_SEM_COMPRA (nolock) 
										Where Programacao = '<<Cur_ProdOrdem.programacao>>'  and 
										Produto     = '<<v_producao_os_01_tarefas.produto>>' and 
										Cor_Produto = '<<v_producao_os_01_tarefas.cor_produto>>' 
									ENDTEXT
									f_select(xSel,"Cur_Valida")
									
									IF Cur_Valida.OK = 0
										TEXT TO xSel TEXTMERGE NOSHOW
											SELECT *
											FROM FN_CONSULTA_RESERVA_PROG_008006
											(
												'<<Cur_ProdOrdem.programacao>>'			,
												'<<v_producao_os_01_tarefas.produto>>'			,
												'<<v_producao_os_01_tarefas.cor_produto>>'		,
												 '<<Cur_ProdOrdem.qtde_o>>'	,
												 '<<Cur_ProdOrdem.qtde_o+v_producao_os_01_tarefas.qtde_o>>'
											)   
										ENDTEXT
										 
										f_select(xSel,"Cur_Valida")
										
										IF RECCOUNT()>0 AND ;
											INT(Cur_Valida.PORCENT_ALT) > Thisformset.pp_Permite_desprogramar_prod AND ;
												Cur_Valida.SOBRA_MRP_FINAL < 0 AND ;
													Cur_Valida.valida_prod > 0
									
											MESSAGEBOX("Produto/Cor com pedido de compra de MP já emitido."+CHR(13)+;
												"Favor solicitar o cancelamento com a compradora"+CHR(13)+ALLTRIM(Cur_Valida.usuario_linx),64,+;
												"Alteração de Grade não Permitida")					
											
											Return .F.
										Endif
									Endif
								Endif
							Sele v_producao_os_01_tarefas
							EndScan
						Endif
					Endif
				Endif

				if	!f_vazio(xalias)	
					sele &xalias 
				endif 

				case upper(xmetodo) == 'USR_SAVE_AFTER'
				xalias=alias()	
									
					DODEFAULT()

					Thisformset.Px_Tipo_Mov = 2	
					
				if	!f_vazio(xalias)	
					sele &xalias 
				endif 
					
					
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE




