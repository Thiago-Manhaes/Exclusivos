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
				
				case UPPER(xmetodo) == 'USR_INIT' 

				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
				
				****** Bloqueio de alocação de recursos - Silvio Luiz - 27042016 ***********************			    
				case upper(xmetodo) == 'USR_WHEN' AND upper(xnome_obj) == 'TX_CUSTO_SUGERIDO'  
				 
				 						
					IF THISFORMSET.pp_ANM_BLOQUEIO_RECURSO=.T.
					
						SELECT v_Produto_Operacoes_00_Rotas
						
						SELECT tabela_operacoes, fase_producao, sequencia_produtiva, recurso_produtivo, desc_recurso FROM v_Produto_Operacoes_00_Rotas INTO CURSOR  vtmp_Produto_Operacoes_00_Rotas
						
						SELECT vtmp_Produto_Operacoes_00_Rotas

						TEXT TO XFASE NOSHOW TEXTMERGE
							SELECT FASE_PRODUCAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_FASE
							WHERE PROPRIEDADE='00210'
							AND FASE_PRODUCAO=?v_Produto_Operacoes_00_Rotas.Fase_Producao
						ENDTEXT
						
						F_SELECT(XFASE, 'CUR_FASE')
						
						TEXT TO XPRODUTO NOSHOW TEXTMERGE
							SELECT PRODUTO, VALOR_PROPRIEDADE FROM PROP_PRODUTOS
							WHERE PROPRIEDADE='50016'
							AND PRODUTO=LTRIM(RTRIM('<<vtmp_Produto_Operacoes_00_Rotas.tabela_operacoes>>'))
						ENDTEXT
						
						F_SELECT(XPRODUTO, 'CUR_PRODUTO')
					
						SELECT CUR_FASE
						SELECT CUR_PRODUTO
						
							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' AND CUR_PRODUTO.VALOR_PROPRIEDADE='INTERNO' 
								MESSAGEBOX("O USUÁRIO NÃO TEM PERMISSÃO PARA ALTERAR O CUSTO DESTA FASE!!",48) 
				    			THISFORM.LX_FORM1.LX_pageframe1.PAge1.LX_PAGEFRAME2.PAge1.LX_GRID_FILHA1.COL_tx_CUSTO_SUGERIDO.Tx_CUSTO_SUGERIDO.Enabled= .F.
				    			RETURN .f.
							ENDIF
					ENDIF
					
				
				case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TV_RECURSO_PRODUTIVO'
				
				**** Lucas Miranda - 16/03/2017 - Bloqueia Programação *****
					TEXT TO xBloqProg NOSHOW TEXTMERGE
						SELECT A.*
						FROM PRODUCAO_RECURSOS (nolock) A
						JOIN CADASTRO_CLI_FOR (nolock) B
						ON A.NOME_CLIFOR = B.NOME_CLIFOR
						JOIN PROP_FORNECEDORES (nolock) C
						ON B.NOME_CLIFOR = C.FORNECEDOR
						AND PROPRIEDADE = '00465'
						WHERE C.VALOR_PROPRIEDADE = 'SIM' 
						AND	A.RECURSO_PRODUTIVO = ?v_Produto_Operacoes_00_Rotas.recurso_produtivo 
					ENDTEXT
					F_SELECT(xBloqProg,"Cur_BloqProd")
					Sele Cur_BloqProd
					
					If !F_Vazio(Cur_BloqProd.recurso_produtivo)
						TEXT TO XDADOSANTERIOR NOSHOW TEXTMERGE
							select A.RECURSO_PRODUTIVO, B.DESC_RECURSO, A.SEQUENCIA_PRODUTIVA 
							from PRODUTO_OPERACOES_ROTAS (nolock) A
							JOIN PRODUCAO_RECURSOS (nolock) B
							ON A.RECURSO_PRODUTIVO=B.RECURSO_PRODUTIVO 
							where A.TABELA_OPERACOES=?v_Produto_Operacoes_00_Rotas.tabela_operacoes
							and A.SEQUENCIA_PRODUTIVA=?v_Produto_Operacoes_00_Rotas.SEQUENCIA_PRODUTIVA
						ENDTEXT
									
						F_SELECT(XDADOSANTERIOR, 'CUR_DADO_ANTERIOR_BD')

						sele v_Produto_Operacoes_00_Rotas
						replace recurso_produtivo WITH IIF(F_VAZIO(CUR_DADO_ANTERIOR_BD.recurso_produtivo),'22264',CUR_DADO_ANTERIOR_BD.recurso_produtivo)
						replace desc_recurso WITH IIF(F_VAZIO(CUR_DADO_ANTERIOR_BD.desc_recurso),'INDEFINIDO',CUR_DADO_ANTERIOR_BD.desc_recurso)
						*o_040001.LX_FORM1.PGPrincipal.PAGe5.LX_pageframe1.PAge2.LX_pageframe1.PAge2.LX_GRID_FILHA2.col_tv_RECURSO_PRODUTIVO.SetFocus()
						MESSAGEBOX("Fornecedor bloqueado programação !!",0+16,"Bloqueia Programação")
						USE IN Cur_BloqProd
						USE IN CUR_DADO_ANTERIOR_BD
						RETURN .F.
					Endif
				**** Bloqueia Programação *****
						
					IF THISFORMSET.pp_ANM_BLOQUEIO_RECURSO=.T.
						
						SELECT v_Produto_Operacoes_00_Rotas
						
						SELECT tabela_operacoes, fase_producao, sequencia_produtiva, recurso_produtivo, desc_recurso FROM v_Produto_Operacoes_00_Rotas INTO CURSOR  vtmp_Produto_Operacoes_00_Rotas
						
						SELECT vtmp_Produto_Operacoes_00_Rotas

							TEXT TO XDADOS NOSHOW TEXTMERGE
								select A.RECURSO_PRODUTIVO, B.DESC_RECURSO, A.SEQUENCIA_PRODUTIVA 
								from PRODUTO_OPERACOES_ROTAS A
								JOIN PRODUCAO_RECURSOS B
								ON A.RECURSO_PRODUTIVO=B.RECURSO_PRODUTIVO 
								where A.TABELA_OPERACOES=?vtmp_Produto_Operacoes_00_Rotas.tabela_operacoes
								and A.SEQUENCIA_PRODUTIVA=?v_Produto_Operacoes_00_Rotas.SEQUENCIA_PRODUTIVA
							ENDTEXT

						F_SELECT(XDADOS, 'CUR_DADO_ANTERIOR')
						
						TEXT TO XFASE NOSHOW TEXTMERGE
							SELECT FASE_PRODUCAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_FASE
							WHERE PROPRIEDADE='00210'
							AND FASE_PRODUCAO=?v_Produto_Operacoes_00_Rotas.Fase_Producao
						ENDTEXT
						
						F_SELECT(XFASE, 'CUR_FASE')

						TEXT TO XPRODUTO NOSHOW TEXTMERGE
							SELECT PRODUTO, VALOR_PROPRIEDADE FROM PROP_PRODUTOS
							WHERE PROPRIEDADE='50016'
							AND PRODUTO=LTRIM(RTRIM('<<vtmp_Produto_Operacoes_00_Rotas.tabela_operacoes>>'))
						ENDTEXT
						
						F_SELECT(XPRODUTO, 'CUR_PRODUTO')

				
						SELECT CUR_FASE
						SELECT CUR_DADO_ANTERIOR
						SELECT CUR_PRODUTO

							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' AND CUR_PRODUTO.VALOR_PROPRIEDADE='INTERNO' 
								SELECT v_Produto_Operacoes_00_Rotas
										MESSAGEBOX("O USUÁRIO NÃO TEM PERMISSÃO PARA ALTERAR O RECURSO NESTA FASE!!",48)
											IF !F_VAZIO(CUR_DADO_ANTERIOR.RECURSO_PRODUTIVO)
										REPLACE recurso_produtivo WITH CUR_DADO_ANTERIOR.RECURSO_PRODUTIVO
										REPLACE desc_recurso WITH CUR_DADO_ANTERIOR.DESC_RECURSO
										RETURN .f.
											ELSE
										REPLACE recurso_produtivo WITH '99'
										REPLACE desc_recurso WITH 'AGUARDANDO DEFINIÇAO'
										RETURN .f.
											ENDIF 
							ENDIF                                                       
					ENDIF			    
					
					
					case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TV_FASE_PRODUCAO'
			
						
					IF THISFORMSET.pp_ANM_BLOQUEIO_RECURSO=.T.
						
						SELECT v_Produto_Operacoes_00_Rotas
						
						SELECT tabela_operacoes, fase_producao, sequencia_produtiva, recurso_produtivo, desc_recurso FROM v_Produto_Operacoes_00_Rotas INTO CURSOR  vtmp_Produto_Operacoes_00_Rotas
						
						SELECT vtmp_Produto_Operacoes_00_Rotas

						TEXT TO XFASE NOSHOW TEXTMERGE
							SELECT FASE_PRODUCAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_FASE
							WHERE PROPRIEDADE='00210'
							AND FASE_PRODUCAO=?v_Produto_Operacoes_00_Rotas.Fase_Producao
						ENDTEXT
						
						F_SELECT(XFASE, 'CUR_FASE')

						TEXT TO XPRODUTO NOSHOW TEXTMERGE
							SELECT PRODUTO, VALOR_PROPRIEDADE FROM PROP_PRODUTOS
							WHERE PROPRIEDADE='50016'
							AND PRODUTO=LTRIM(RTRIM('<<vtmp_Produto_Operacoes_00_Rotas.tabela_operacoes>>'))
						ENDTEXT
						
						F_SELECT(XPRODUTO, 'CUR_PRODUTO')


						SELECT CUR_FASE
						SELECT CUR_PRODUTO

							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' AND CUR_PRODUTO.VALOR_PROPRIEDADE='INTERNO' 
								SELECT v_Produto_Operacoes_00_Rotas
										MESSAGEBOX("O USUÁRIO TEM PERMISSÃO PARA INCLUIR NESTA FASE SOMENTE O RECURSO '99' - 'AGUARDANDO DEFINIÇAO'!!",48) 
										REPLACE recurso_produtivo WITH '99'
										REPLACE desc_recurso WITH 'AGUARDANDO DEFINIÇAO'
										THISFORM.LX_FORM1.LX_pageframe1.PAge1.LX_PAGEFRAME2.PAge1.LX_GRID_FILHA1.COL_tv_SETOR_PRODUCAO.TV_Setor_Producao.SetFocus
					
							ENDIF                                                       
					ENDIF			    	
					
				otherwise
				return .t.				
			endcase

	endproc
ENDDEFINE	



