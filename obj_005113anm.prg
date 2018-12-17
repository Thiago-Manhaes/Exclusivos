* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar                                                                                     *
* DATA...........:  07/02/2012                                                                                      *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: PREENCHE NA VIWER O CAMPO REPRESENTANTE COM O REPRESENTANTE DO FATURAMENTO
*						                    *
********************************************************************************************************************* 
******************************************************
*- Programa Base de Criação de Objeto de Entrada
********************************************************************
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos 
*******************************************************************************
*- Existem 2 parametros que influem nos objetos de Entrada:  
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execução para facilitar o desenvolvimento
*********************************************************************************


*********************************************************************************
* - Atencao !!!!!!!!!!!														   -*
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP -*
*********************************************************************************

*
*                 Abaixo segue Programa objeto sem Codigo 
*
*
*- Definindo a classe do objeto de entrada que sera criado na Form.
define class obj_entrada as custom
	*- Nome do metodo/função que os objetos linx vão chamar.
	procedure metodo_usuario
		*- Parametros do metodo:
		*- Xmetodo= nome do metodo
		*- Xobjeto= variavel com a referencia ao objeto
		*- Xnome_obj  = nome do objeto
		lparam xmetodo, xobjeto ,xnome_obj
		
		******************** Metodos chamados pelo FORMSET
		*	USR_INIT
		*	USR_ALTER_BEFORE  ->Return .f. Para o Metodo
		*	USR_ALTER_AFTER    
		*	USR_INCLUDE_AFTER
		*	USR_SEARCH_BEFORE ->Return .f. Para o Metodo
		*	USR_SEARCH_AFTER
		*	USR_CLEAN_AFTER
		*	USR_REFRESH
		*	USR_SAVE_BEFORE   ->Return .f. Para o Metodo 
		*	USR_SAVE_AFTER
		*	USR_ITEN_DELETE_BEFORE ->Return .f. Para o Metodo
		*	USR_ITEN_DELETE_AFTER
		*	USR_ITEN_INCLUDE_BEFORE ->Return .f. Para o Metodo
		*	USR_ITEN_INCLUDE_AFTER
		*
		***************** Metodos que ocorrem dentro da Transaction do Banco de Dados
		*	USR_TRIGGER_AFTER ->Return .f. Para o Salvamento e da Rollback
		*	USR_TRIGGER_BEFORE ->Return .f. Para o Salvamento e da Rollback


		******************** Metodo chamado pelos Objetos na Validação
		*   USR_VALID -> Return .f. Não deixa o Usuario sair do objeto.

		******************** Metodo chamado pelos PageFrames
		*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

		*- Inicio dos procedimentos do Usuario
		*- Testando qual o metodo que esta chamando o metodo entrada
		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
		do case
			*- metodo do inicio da form
				
				case UPPER(xmetodo) == 'USR_INIT' 

					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
			    
			   case UPPER(xmetodo) == 'USR_SEARCH_AFTER' 
			
			
				xalias=alias()
	
		
					SELE V_ENTRADAS_PRODUTO_AC_00
					GO TOP
					
					SCAN
						SELE V_ENTRADAS_PRODUTO_AC_00
						
						TEXT TO xSelRepre TEXTMERGE NOSHOW
						
							SELECT DISTINCT B.REPRESENTANTE 
							FROM FATURAMENTO_ENTRADA_DEVOLUCAO A
							JOIN FATURAMENTO B
							ON A.FILIAL = B.FILIAL
							AND A.NF_SAIDA = B.NF_SAIDA
							AND A.SERIE_NF = B.SERIE_NF
							WHERE A.NF_ENTRADA = '<<V_ENTRADAS_PRODUTO_AC_00.NF_ENTRADA>>'
							AND B.NOME_CLIFOR = '<<V_ENTRADAS_PRODUTO_AC_00.NOME_CLIFOR>>'
							AND A.SERIE_NF_ENTRADA = '<<V_ENTRADAS_PRODUTO_AC_00.SERIE_NF_ENTRADA>>'
						
						ENDTEXT
						
						f_select(xSelRepre,"xTempReplaRep",ALIAS())
						
						sele V_ENTRADAS_PRODUTO_AC_00
						replace representante WITH xTempReplaRep.representante
						
					ENDSCAN	
					
					sele V_ENTRADAS_PRODUTO_AC_00
					GO top
						
				if	!f_vazio(xalias)	
					  sele &xalias 
				endif
				
				

				
				otherwise
					return .t.				
		endcase
	endproc
enddefine
