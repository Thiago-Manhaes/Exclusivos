* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar                                                                                     *
* DATA...........:  01-03-2014                                                                                      *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                               			*
* OBJETIVO.: 					                    																*
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
				
				case upper(xmetodo) == 'USR_VALID'
				
					xalias=alias()
					
						If upper(xnome_obj) = 'TX_NF_ENTRADA'

							sele v_producao_os_01_tarefas
							go top	
							xOP=v_producao_os_01_tarefas.ordem_producao 
						
							text to xsel noshow textmerge	 
								select * from FX_PRODUCAO_ORDEM_HIST_OS('<<xOP>>') where nf_entrada='<<v_producao_os_01.nf_entrada>>'
							endtext				
							
							f_select(xsel,'curNF')
							
							sele curNF
							if	reccount()=0
								messagebox("Esta Nota Fiscal não está registrada para esta OP."+chr(13)+"Verifique!",48,"Atenção!!!")
								retu .f.
							endif	

						
						Endif
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
				
				
				case upper(xmetodo) == 'USR_ALTER_BEFORE'
				
					xalias=alias()
				
						TEXT TO xsel_pgto TEXTMERGE NOSHOW				
								
								SELECT ENTRADAS.NF_ENTRADA 
								FROM ENTRADAS 
								INNER JOIN CTB_A_PAGAR_MOV 
								ON ( ENTRADAS.CTB_LANCAMENTO = CTB_A_PAGAR_MOV.LANCAMENTO_MOV 
								OR ENTRADAS.NUMERO_CONFERENCIA = CTB_A_PAGAR_MOV.LANCAMENTO_MOV ) 
								AND ENTRADAS.CTB_ITEM = CTB_A_PAGAR_MOV.ITEM_MOV 
								AND CTB_A_PAGAR_MOV.EMPRESA = '1'
								JOIN PRODUCAO_RECURSOS C
								ON ENTRADAS.NOME_CLIFOR = C.NOME_CLIFOR
								WHERE ENTRADAS.NF_ENTRADA = '<<V_PRODUCAO_OS_01.NF_ENTRADA>>'
								AND C.DESC_RECURSO = '<<V_PRODUCAO_OS_01.DESC_RECURSO>>'
						
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
				
				
				case upper(xmetodo) == 'USR_SAVE_BEFORE'
				
					xalias=alias()

						IF thisformset.p_tool_status $'IA'

										if f_vazio(v_producao_os_01.nf_entrada) 	
											messagebox("É Obrigatório a digitação da Nota Fiscal de Entrada"+chr(13)+"Verifique!",48,"Atenção!!!")
											retu .f.
										endif	
									
										sele v_producao_os_01_tarefas
										go top	
										xOP=v_producao_os_01_tarefas.ordem_producao 

									
										text to xsel noshow textmerge	 
											select * from FX_PRODUCAO_ORDEM_HIST_OS('<<xOP>>') where nf_entrada='<<v_producao_os_01.nf_entrada>>'
										endtext				
										
										f_select(xsel,'curNF')
										
										sele curNF
										if	reccount()=0
											messagebox("Esta Nota Fiscal não está registrada para esta OP."+chr(13)+"Verifique!",48,"Atenção!!!")
											retu .f.
										endif	
										
										if !f_vazio('xalias') 	
											sele &xalias
										endif
										
									ENDIF		
									
									IF thisformset.p_tool_status = 'E'
									
										xalias=alias()
									
										TEXT TO xsel_pgto TEXTMERGE NOSHOW				
												
												SELECT ENTRADAS.NF_ENTRADA 
												FROM ENTRADAS 
												INNER JOIN CTB_A_PAGAR_MOV 
												ON ( ENTRADAS.CTB_LANCAMENTO = CTB_A_PAGAR_MOV.LANCAMENTO_MOV 
												OR ENTRADAS.NUMERO_CONFERENCIA = CTB_A_PAGAR_MOV.LANCAMENTO_MOV ) 
												AND ENTRADAS.CTB_ITEM = CTB_A_PAGAR_MOV.ITEM_MOV 
												AND CTB_A_PAGAR_MOV.EMPRESA = '1'
												JOIN PRODUCAO_RECURSOS C
												ON ENTRADAS.NOME_CLIFOR = C.NOME_CLIFOR
												WHERE ENTRADAS.NF_ENTRADA = '<<V_PRODUCAO_OS_01.NF_ENTRADA>>'
												AND C.DESC_RECURSO = '<<V_PRODUCAO_OS_01.DESC_RECURSO>>'
										
										ENDTEXT
										
										f_select(xsel_pgto,"xVerifica_pgto")
											
											sele xVerifica_pgto
											IF RECCOUNT()>0
												MESSAGEBOX('Exitem Titulos Pagos, Impossível Continuar!!',0+48)
												RETURN .F.
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


