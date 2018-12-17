* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  06/10/2008                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Fase 021 Obrigatoria						                    *
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

	**	=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

			do case
				
				case upper(xmetodo) == 'USR_SAVE_BEFORE' 
					
					xalias=alias()
					
					sele v_produto_operacoes_00_rotas 
					go top	
					loca for fase_producao='021'		
					if !found()
						messagebox("É necessário inserir a Fase 021-Recebimento antes da Revisão ",48,"Atenção!!")
						retu .f.		 
					endif	
					
*!*						if thisformset.p_tool_status $ ('IA') 
*!*							f_select("select produto from produtos where produto=?v_produtos_tab_operacoes_00.tabela_operacoes","curTmpProd")
*!*							sele curTmpProd
*!*							if reccount()=0
*!*								messagebox("Produto não existe !"+chr(13)+"Verifique !",48,"Atenção!!")
*!*								retu .f.		 
*!*							endif	
*!*						endif						

					if !f_vazio(xalias)	
						sele &xalias
					endif	
					
				    
				    
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
					
					
						SELECT CUR_FASE
						
							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' 
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

				
						SELECT CUR_FASE
				
							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' 
								SELECT v_Produto_Operacoes_00_Rotas
									IF v_Produto_Operacoes_00_Rotas.recurso_produtivo<>'99'
										MESSAGEBOX("O USUÁRIO TEM PERMISSÃO PARA INCLUIR NESTA FASE SOMENTE O RECURSO '99' - 'AGUARDANDO DEFINIÇAO''!!",48) 
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

				
						SELECT CUR_FASE
				
							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' 
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





*!*					case upper(xmetodo) == 'USR_SAVE_AFTER' 
*!*					
*!*						if thisformset.p_tool_status $ ('IA') 
*!*							f_update("update produtos set tabela_operacoes=NULL where produto=?v_produtos_tab_operacoes_00.tabela_operacoes")
*!*							f_update("update produtos set tabela_operacoes=?v_produtos_tab_operacoes_00.tabela_operacoes where produto=?v_produtos_tab_operacoes_00.tabela_operacoes")
*!*						endif	
*!*		
	
					
				otherwise
				return .t.				
			endcase

	endproc
ENDDEFINE	



