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
		lparam xmetodo, xobjeto ,xnome_obj,xFoto
		
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
				 
				case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj)== 'TX_NUMERO_FOTO'
*SET STEP ON
						IF !f_vazio(thisformset.lx_FORM1.lx_pageframe1.page2.lx_GRID_FILHA2.col_TX_NUMERO_FOTO.tx_NUMERO_FOTO.value)
							xFoto = '['+ alltrim(STR(thisformset.lx_FORM1.lx_pageframe1.page2.lx_GRID_FILHA2.col_TX_NUMERO_FOTO.tx_NUMERO_FOTO.value))+']'

							xArquivo = ''
							STORE ADIR(laFiles,ALLTRIM(WGS_LINX_PATH) + "\Modos de Lavagens\*.jpg*") TO lnFiles 
							*_cliptext = WGS_LINX_PATH + "\Modos de Lavagens\*.jpg*"
								FOR ln = 1 TO lnFiles   
								      IF alltrim(xFoto) $ ALLTRIM(laFiles[ln,1])
								            *MESSAGEBOX('ACHOU')
								            xArquivo = laFiles[ln,1]
								            *MESSAGEBOX(xArquivo)
								            replace v_materiais_tipo_lavagem_00_fotos.path_foto WITH  ALLTRIM(WGS_LINX_PATH) + "\Modos de Lavagens\" + xArquivo
								            RETURN .t.
								            EXIT
*!*									      ELSE
*!*										    	*MESSAGEBOX('NÃO ACHOU')
*!*									            ?laFiles[ln,1]
								      ENDIF       
								NEXT 
						
						ENDIF
						
						IF !f_vazio(v_materiais_tipo_lavagem_00_fotos.NUMERO_FOTO)
							DODEFAULT()
							thisformset.lx_FORM1.lx_pageframe1.page2.lx_GRID_FILHA2.Refresh()
						ELSE
							RETURN .F.
						ENDIF

			endcase

	
	endproc
ENDDEFINE


