
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
				
				case upper(xmetodo) == 'USR_INIT'  
				
					public xPai_Filtro,xTempACP	
					xPai_Filtro=thisformset.p_pai_filtro
					xTempACP=0
					xalias=alias()
					
						thisform.dataEnvironment.cUR_V_CTB_ACOMPANHAMENTO_00.KeyFieldList="EMPRESA, LANCAMENTO, ITEM, SUB_ITEM, DATA_DIGITACAO, DATA_ACOMPANHAMENTO, OCORRENCIA"    
					
						text to xsel_ocorrencia noshow textmerge	
							select convert(varchar(50),'') as desc_ocorrencia,'' as ocorrencia
							union all
							select desc_ocorrencia,ocorrencia from ctb_ocorrencia
						endtext
					

						f_select(xsel_ocorrencia ,"curOcorrencias",alias())
					

			             with thisformset.lx_filtro_bordero.frame_tipo_titulo.page_a_receber_cheque 	
								
								.addObject("cmb_acompanhamento","lx_combobox")
								.cmb_acompanhamento.visible=.t.
								.cmb_acompanhamento.top=145
								.cmb_acompanhamento.left=9
								.cmb_acompanhamento.width=144
								.cmb_acompanhamento.controlsource=curOcorrencias.desc_ocorrencia 
								.cmb_acompanhamento.rowsource='curOcorrencias.desc_ocorrencia'
								.cmb_acompanhamento.enabled=.t.
								.cmb_acompanhamento.rowsourcetype=2
								.cmb_acompanhamento.value='' 
								.cmb_acompanhamento.Anchor=0
							
			              endwith	

					
					if !f_vazio(xalias)
						sele &xalias
					endif	




				case upper(xmetodo) == 'USR_SEARCH_BEFORE'  
					
					xalias=alias()

					If type("thisformset.lx_form1.lx_PAGEFRAME1.page2.cmb_acompanhamento")<>"U"
						
						if 	!f_vazio(thisformset.lx_form1.lx_PAGEFRAME1.page2.cmb_acompanhamento.value)
							
							text to xFiltroObj noshow textmerge	
								and ctb_lancamento.lancamento in		
								(select lancamento from ctb_acompanhamento where ocorrencia in 
								(select ocorrencia from ctb_ocorrencia where desc_ocorrencia='<<thisformset.lx_form1.lx_PAGEFRAME1.page2.cmb_acompanhamento.value>>'))						
							endtext	
							
							thisformset.p_pai_filtro=thisformset.p_pai_filtro+xFiltroObj 
								
						endif	
						
					Endif	


					if !f_vazio(xalias)
						sele &xalias
					endif	

				


				case upper(xmetodo) == 'USR_CLEAN_AFTER'  

					If type("thisformset.lx_form1.lx_PAGEFRAME1.page2.cmb_acompanhamento")<>"U"
						thisformset.lx_form1.lx_PAGEFRAME1.page2.cmb_acompanhamento.value=""
						thisformset.p_pai_filtro=xPai_Filtro
					Endif	

				
					
		


				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE