* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  26/02/2009                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Ajuste layout propriedades clientes varejo		/ tel celular			                    *
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

		* =messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

			do case
					
				
				case UPPER(xmetodo) == 'USR_SAVE_AFTER' 	 
					&&22/10/2015 - BRUNO SILVA (SS) : Atualiza a tabela ANM_CLIENTES_VAREJO_DETALHE
					&& #1 - Julio Cesar - 05/04/2016: Atualiza a tabela ANM_CLIENTES_VAREJO_DETALHE, Incluido colunas que estavam faltando

					TEXT TO cSqL TEXTMERGE
						UPDATE ANM_CLIENTES_VAREJO_DETALHE 
								SET CONCEITO = ?V_CLIENTES_VAREJO_00.CONCEITO,
									PONTUALIDADE = ?V_CLIENTES_VAREJO_00.PONTUALIDADE,
									TIPO_BLOQUEIO = ?V_CLIENTES_VAREJO_00.TIPO_BLOQUEIO,
									ENDERECO = ?V_CLIENTES_VAREJO_00.ENDERECO,
									RG_IE = ?V_CLIENTES_VAREJO_00.RG_IE,
									CIDADE = ?V_CLIENTES_VAREJO_00.CIDADE,
									COMPLEMENTO = ?V_CLIENTES_VAREJO_00.COMPLEMENTO,
									CEP = ?V_CLIENTES_VAREJO_00.CEP,
									TELEFONE = ?V_CLIENTES_VAREJO_00.TELEFONE,
									FAX = ?V_CLIENTES_VAREJO_00.FAX,
									ANIVERSARIO = ?V_CLIENTES_VAREJO_00.ANIVERSARIO,
									SEM_CREDITO = ?V_CLIENTES_VAREJO_00.SEM_CREDITO,
									DDD = ?V_CLIENTES_VAREJO_00.DDD,
									SEXO = ?V_CLIENTES_VAREJO_00.SEXO,
									ESTADO_CIVIL = ?V_CLIENTES_VAREJO_00.ESTADO_CIVIL,
									TIPO_TELEFONE = ?V_CLIENTES_VAREJO_00.TIPO_TELEFONE,
									UF = ?V_CLIENTES_VAREJO_00.UF,
									EMAIL = ?V_CLIENTES_VAREJO_00.EMAIL,
									BAIRRO = ?V_CLIENTES_VAREJO_00.BAIRRO,
									NAO_CONSULTA_CHEQUE = ?V_CLIENTES_VAREJO_00.NAO_CONSULTA_CHEQUE,
									OBS = ?V_CLIENTES_VAREJO_00.OBS,
									NUMERO = ?V_CLIENTES_VAREJO_00.NUMERO,
									PAIS = ?V_CLIENTES_VAREJO_00.PAIS,
									TIPO_LOGRADOURO = ?V_CLIENTES_VAREJO_00.TIPO_LOGRADOURO,
									DDD_CELULAR = ?V_CLIENTES_VAREJO_00.DDD_CELULAR,
									CELULAR  = ?V_CLIENTES_VAREJO_00.CELULAR
							WHERE CODIGO_CLIENTE = ?V_CLIENTES_VAREJO_00.CODIGO_CLIENTE
					ENDTEXT
					
					IF !F_UPDATE (cSql)
						MESSAGEBOX("Não foi possivel alterar a tabela detalhe de clientes!",0+64,"Atenção")					
					endif
										
																
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE



