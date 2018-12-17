* Cria��o *********************************************************************************************************** 
* PROGRAMADOR(A).:  Wallace Pacheco                                                                                               *
* DATA...........:  24/08/2015                                                                                            *
* HOR�RIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Bloquear campos impedindo edi��o pelo usu�rio 						                    *
********************************************************************************************************************* 

* Altera��o ********************************************************************************************************* 
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HOR�RIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                                        *
* OBJETIVO.:                                                                                                        *
********************************************************************************************************************* 


********************************************************************************************************************* 
*- Programa Base de Cria��o de Objeto de Entrada                                                                    *
********************************************************************************************************************* 
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela                                      *
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos                                            *
********************************************************************************************************************* 
*- Existem 2 parametros que influem nos objetos de Entrada:                                                         *
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos                       *
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execu��o para facilitar o desenvolvimento *
********************************************************************************************************************* 
* - Atencao !!!!!!!!!!!														                                        *
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP                                      *
********************************************************************************************************************* 

define class obj_entrada as custom
	*- Nome do metodo/fun��o que os objetos linx v�o chamar.

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


		******************** Metodo chamado pelos Objetos na Valida��o
		*   USR_VALID -> Return .f. N�o deixa o Usuario sair do objeto.

		******************** Metodo chamado pelos PageFrames
		*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

		*- Inicio dos procedimentos do Usuario
		*- Testando qual o metodo que esta chamando o metodo entrada

		 *=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

			do case
								
					case upper(xmetodo) == 'USR_INIT'

*!*								thisformset.lx_form1.pageframe1.page1.tx_DATA_SISTEMA.Enabled = .F.
*!*								thisformset.lx_form1.pageframe1.page1.tx_DATA_FISCAL.Enabled = .F.
*!*								thisformset.lx_form1.pageframe1.page1.TX_DATA_HORA_REDUCAO_Z.Enabled = .F.

*!*												
*							PUBLIC xTemp 
							
*							xTemp = 1
*!*					
*!*					
					case upper(xmetodo) == 'USR_ALTER_AFTER'
*!*					
*!*						xalias=alias()
*							xTemp = 0
							
							IF UPPER (WUSUARIO) != 'SA'
					
								thisformset.lx_form1.pageframe1.page1.tx_DATA_SISTEMA.Enabled = .F.
								thisformset.lx_form1.pageframe1.page1.tx_DATA_FISCAL.Enabled = .F.
								thisformset.lx_form1.pageframe1.page1.TX_DATA_HORA_REDUCAO_Z.Enabled = .F.
								
							ENDIF
							
*!*						if !f_vazio(xalias)
*!*							sele &xalias
*!*						endif

				
*!*						case upper(xmetodo) == 'USR_WHEN'
*!*							
*!*							xalias=alias()
*!*							
*!*							IF UPPER (WUSUARIO) != 'SA' OR xtemp != 0
*!*					
*!*								IF UPPER (WUSUARIO) != 'SA'
*!*								
*!*									thisformset.lx_form1.pageframe1.page1.tx_DATA_SISTEMA.Enabled = .F.
*!*									thisformset.lx_form1.pageframe1.page1.tx_DATA_FISCAL.Enabled = .F.
*!*									thisformset.lx_form1.pageframe1.page1.TX_DATA_HORA_REDUCAO_Z.Enabled = .F.
*!*								
*!*								ENDIF
*!*								
*!*							ENDIF
											
						
						
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE