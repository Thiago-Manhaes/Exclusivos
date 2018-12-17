* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  15/06/2009                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Grid com resultados por produtos consolidado			                    *
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
		*!* Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017
 		TRY 							
			If TYPE("Thisformset.pp_gs_obj_classes_rl")<>'U' AND Thisformset.pp_gs_obj_classes_rl
				If ! o_gs.l_ver_rede_loja_prod('o_120027',xmetodo, xobjeto ,xnome_obj,Thisformset.p_tool_status)
					RETURN .f.
				Endif
			Endif
		CATCH					
		ENDTRY
		*!* Fim - Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017
			do case
 
				case UPPER(xmetodo) == 'USR_INIT' 

				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
				
				*!* Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017 
				If TYPE("Thisformset.pp_gs_obj_classes_rl")<>'U' AND Thisformset.pp_gs_obj_classes_rl 
					PUBLIC o_gs as Object
					o_gs = NEWOBJECT("obj_gs_classes_rede_loja","linx\exclusivo\obj_gs_classes_rede_loja.prg")
				Endif
				*!* Fim - Declara Função obj_gs_classes_rede_loja ao Iniciar Tela rede loja produto *!* LUCAS MIRANDA 19/12/2017
				
				case UPPER(xmetodo) == 'USR_SAVE_BEFORE'
				
				xalias=alias()		
					
					*!* Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017 
					If TYPE("o_120027.pp_gs_obj_classes_rl")<>'U' AND Thisformset.pp_gs_obj_classes_rl 
						If xSaveBefErroClass = 1
							Return .F.
						Endif	
					Endif			
					***** Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017 	
					*!* Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017 
*!*						If TYPE("o_120027.pp_gs_obj_classes_rl")<>'U' AND Thisformset.pp_gs_obj_classes_rl 
*!*							If !o_gs.l_ver_rede_loja_prod('o_120027',xmetodo, xobjeto ,xnome_obj,Thisformset.p_tool_status)
*!*								Return .f.
*!*							Endif
*!*						Endif	
					***** Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017 
				
				if !f_vazio(xalias)	
					sele &xalias 
				endif	
				
				case UPPER(xmetodo) == 'USR_SAVE_AFTER'
				
					xalias=alias()
					** #1 - LUCAS MIRANDA - 02/06/2016 - GERAR FISICO NO DESTINO AO FAZER TRANSFERENCIA
						If UPPER(Thisformset.p_tool_status) = 'I'
							Text To SelConfEnt TextMerge Noshow
							
								SELECT COUNT(*) AS QTDE_SAI_PA
								FROM (ESTOQUE_PROD1_SAI A 
								JOIN ESTOQUE_PROD_SAI B ON B.ROMANEIO_PRODUTO=A.ROMANEIO_PRODUTO AND B.FILIAL=A.FILIAL
								LEFT JOIN ESTOQUE_PROD_ENT C ON C.ROMANEIO_PRODUTO=B.ROMANEIO_DESTINO AND C.FILIAL=B.FILIAL_DESTINO)
								WHERE B.ROMANEIO_DESTINO IS NOT NULL AND B.FILIAL_DESTINO IS NOT NULL AND C.FILIAL IS NULL
								AND A.ROMANEIO_PRODUTO =  '<<V_ESTOQUE_PROD_SAI_00.ROMANEIO_PRODUTO>>'     

							Endtext
												
							Sele V_ESTOQUE_PROD_SAI_00
							f_select(SelConfEnt,"xConfNfEnt") 

							If xConfNfEnt.QTDE_SAI_PA > 0
								TEXT TO xUpdateData NOSHOW TEXTMERGE
									update a set a.QTDE = a.QTDE
									FROM (ESTOQUE_PROD1_SAI A 
									JOIN ESTOQUE_PROD_SAI B ON B.ROMANEIO_PRODUTO=A.ROMANEIO_PRODUTO AND B.FILIAL=A.FILIAL
									LEFT JOIN ESTOQUE_PROD_ENT C ON C.ROMANEIO_PRODUTO=B.ROMANEIO_DESTINO AND C.FILIAL=B.FILIAL_DESTINO)
									WHERE B.ROMANEIO_DESTINO IS NOT NULL AND B.FILIAL_DESTINO IS NOT NULL AND C.FILIAL IS NULL
									and b.EMISSAO >= '20160601' AND A.ROMANEIO_PRODUTO =  '<<V_ESTOQUE_PROD_SAI_00.ROMANEIO_PRODUTO>>'    
								ENDTEXT
						
								f_update(xUpdateData)
							Endif
						Endif
					**FIM #1 - LUCAS MIRANDA - 02/06/2016 - GERAR FISICO NO DESTINO AO FAZER TRANSFERENCIA

			otherwise
				return .t.				
			endcase
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_exporta_vendas
**************************************************
