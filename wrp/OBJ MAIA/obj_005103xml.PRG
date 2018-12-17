* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                        *
* OBJETIVO.: Consulta Entradas por colecao propriedade                                                                                                     *
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
		
		*!* Chama a função disponível na classe criada para tratar xml *!* #XML_2015
 		TRY 							
			If TYPE("Thisformset.pp_anm_obj_entrada_xml")<>'U' AND Thisformset.pp_anm_obj_entrada_xml
				If ! o_anm.l_Obj_entrada_xml('o_005103',xmetodo, xobjeto ,xnome_obj,Thisformset.p_tool_status)
					RETURN .f.
				Endif
			Endif
		CATCH					
		ENDTRY
		*!* Fim - Instancia um objeto da classe "Obj_Entrada_XML" #XML_2015
		
		do case
			
			case UPPER(xmetodo) == 'USR_INIT' 
				xalias=alias()
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT
					*!* Declara Função Obj_Entrada_XML ao Iniciar Tela *!* #XML_2015
					If TYPE("Thisformset.pp_anm_obj_entrada_xml")<>'U' AND Thisformset.pp_anm_obj_entrada_xml
						PUBLIC o_anm as Object
						o_anm = NEWOBJECT("Obj_Entrada_XML","linx\exclusivo\obj_entrada_xml.prg")
					Endif
					*!* Fim - Declara Função Obj_Entrada_XML ao Iniciar Tela *!* #XML_2015
				
				if	!f_vazio(xalias)	
					sele &xalias 
				endif
				
			case UPPER(xmetodo) == 'USR_VALID'
			
			
				xalias=alias()
											
					sele v_entradas_00	
	         		thisformset.lx_FORM1.lx_PAGEFRAME1.Page1.Pageframe1.Page1.Tv_RATEIO_FILIAL.Value = THISFORMSET.lx_FORM1.Tx_CliFor1.VALUE	
					f_select("select desc_rateio_filial from CTB_FILIAL_RATEIO where rateio_filial=?v_entradas_00.rateio_filial","curRATEIO",alias())
					thisformset.lx_FORM1.lx_PAGEFRAME1.Page1.Pageframe1.Page1.tx_desc_filial_rateio.Value = curRATEIO.desc_rateio_filial
		
					** Passa numero da NF para inteiro ** #XML_2015
					IF Thisformset.p_tool_status = 'I' AND upper(xnome_obj)=='TX_NF_ENTRADA'
					
						Thisformset.lx_FORM1.TX_NF_ENTRADA.VALUE = INT(VAL(Thisformset.lx_FORM1.TX_NF_ENTRADA.VALUE))

					ENDIF
					** FIM - Passa numero da NF para inteiro ** #XML_2015
					
				if	!f_vazio(xalias)	
					sele &xalias 
				ENDIF
				
				
			 case UPPER(xmetodo) == 'USR_INCLUDE_AFTER'
 			
 				**** INÍCIO #12 - BLOQUEIO DO CAMPO CONDIÇÃO PGTO - SILVIO LUIZ - 22/11/2016 ****
					if thisformset.p_tool_status $ 'IA'	
						If thisformset.pp_anm_blq_cond_pgto_005103 = .f.
								thisformset.lx_forM1.lx_pageframe1.page1.pageframe1.page1.tv_condicao_pgto.Enabled= .F.
						ENDIF
					ENDIF 
				**** FIM #12
			
			
				
			case UPPER(xmetodo) == 'USR_SAVE_BEFORE' 
				*-MIT 13/09/2017 - nao permitir excluir com aceite do financeiro
				VLC_Select = "select VALOR_ATUAL_USER from PARAMETROS_USERS where PARAMETRO = 'csm_permite_apagar' and usuario = '" + wusuario + "'"
				F_Select(VLC_Select, 'cur_param')
				
				GO TOP IN cur_param
				
				IF !cur_param.VALOR_ATUAL_USER = '.T.' OR EOF('cur_param')
					IF !f_vazio(V_ENTRADAS_00.ctb_lancamento)
						VLC_Select = "select COUNT(1) as num from CTB_ACOMPANHAMENTO where LANCAMENTO = ?V_ENTRADAS_00.ctb_lancamento and item = ?V_ENTRADAS_00.ctb_item and ocorrencia = 900"
						F_Select(VLC_Select, 'cur_ac')
						
						IF NVL(cur_ac.num,0) > 0
							USE IN cur_ac
							USE IN cur_param
							MESSAGEBOX("Nota fiscal ja foi aceita pelo financeiro. Nao e possivel sua exclusao!",48,wusuario)
							RETURN .f.
						ENDIF
					endif
				ENDIF
				
				USE IN cur_param

				* Fim Mit
								
				xalias=alias()
					
					*!* Chama a função disponível na classe criada para tratar xml *!* #XML_2015
					If TYPE("o_005103.pp_anm_obj_entrada_xml")<>'U' AND Thisformset.pp_anm_obj_entrada_xml
						If ! o_anm.l_anm_valida_xml('o_005103',xmetodo, xobjeto ,xnome_obj,Thisformset.p_tool_status)
							Return .f.
						Endif
					Endif	
					***** Saida Automática dos materiais comprados para Pilotagem **** #XML_2015

					
					sele v_entradas_00
					replace filial_cobranca WITH v_entradas_00.filial

				if	!f_vazio(xalias)	
					sele &xalias 
				endif	 				
 
		** Bloquear condição pagamento caso o fornecedor esteja marcado como nao valida pagamento
				case UPPER(xmetodo) == 'USR_WHEN' 
					xalias=alias()
						If upper(xnome_obj)=='TV_CONDICAO_PGTO'
						 
							TEXT TO xMetodoPagamento NOSHOW textmerge
								select a.*, isnull(b.ANM_N_VALIDA_PAGAMENTO,0) ANM_N_VALIDA_PAGAMENTO 
								from fornecedores a 
								left join CTB_LX_METODO_PAGAMENTO b 
								on a.LX_METODO_PAGAMENTO = b.LX_METODO_PAGAMENTO 
								where fornecedor = '<<V_ENTRADAS_00.NOME_CLIFOR>>'
							Endtext
							F_select(xMetodoPagamento,"CurMetodoPagamento")

							Sele CurMetodoPagamento

							If !F_Vazio(CurMetodoPagamento.anm_n_valida_pagamento) AND CurMetodoPagamento.anm_n_valida_pagamento = .T.
							 	Thisformset.lx_forM1.lx_pageframe1.page1.pageframe1.page1.tv_condicao_pgto.Enabled= .F.
							Endif	
						Endif
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
				** Fim
			otherwise
				return .t.				
		endcase
	endproc
enddefine


