* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  26/02/2009                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Inclusao campo Filial Estoque em funcao das entradas RBX/TRIMIX					                    *
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
			
				case UPPER(xmetodo) == 'USR_INIT' 

				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
				
				case upper(xmetodo) == 'USR_ALTER_AFTER'
					xalias=alias()
					
						**-habilita/desabita objetos de acordo c/ paramêtros-**
						If Thisformset.p_tool_status $ [IA]
							Thisformset.lx_form1.pageframe1.page1.cmb_condicao_pgto.enabled     = Thisformset.pp_permite_alt_cond_pgto
							Thisformset.lx_form1.pageframe1.page1.tv_transportadora.enabled     = Thisformset.pp_permite_alt_transport
							Thisformset.lx_form1.pageframe1.page1.tv_tab_precos.Enabled 		= Thisformset.pp_permite_alt_tabela
							Thisformset.lx_form1.pageframe1.page1.tx_tabela_preco.Enabled 		= Thisformset.pp_permite_alt_tabela	
							Thisformset.lx_form1.pageframe1.page1.lx_textbox_base3.enabled      = Thisformset.pp_permite_alt_prioridade
							Thisformset.lx_form1.pageframe1.page1.cmb_colecao.enabled           = Thisformset.pp_permite_alt_colecao
							Thisformset.lx_form1.pageframe1.page1.cmb_moeda.enabled             = Thisformset.pp_permite_alt_moeda
							Thisformset.lx_form1.pageframe1.page1.cmb_tipo.enabled              = Thisformset.pp_permite_alt_tipo_venda
							Thisformset.lx_form1.pageframe1.page1.cmb_filial.enabled            = Thisformset.pp_permite_alt_filial
							Thisformset.lx_form1.pageframe1.page1.cmb_filial_digitacao.enabled  = Thisformset.pp_permite_alt_filial
							Thisformset.lx_form1.pageframe1.page1.tx_cadastramento.enabled      = Thisformset.pp_permite_alt_data_cad
							Thisformset.lx_form1.pageframe1.page2.tx_comissao.enabled           = Thisformset.pp_permite_alt_comissao_rep
							Thisformset.lx_form1.pageframe1.page2.tx_comissao_gerente.enabled   = Thisformset.pp_permite_alt_comissao_ger
							Thisformset.lx_form1.pageframe1.page2.tx_desconto.enabled           = Thisformset.pp_permite_alt_desc_total
							Thisformset.lx_form1.pageframe1.page2.tx_per_desconto.enabled       = Thisformset.pp_permite_alt_desc_total
							Thisformset.lx_form1.pageframe1.page2.tx_encargo.enabled            = Thisformset.pp_permite_alt_encargo
							Thisformset.lx_form1.pageframe1.page2.tx_per_encargo.enabled        = Thisformset.pp_permite_alt_encargo
							Thisformset.lx_form1.pageframe1.page1.spn_entrega_aceitavel.enabled = Thisformset.pp_permite_alt_ent_aceitavel
							Thisformset.lx_form1.pageframe1.page2.tx_porcentagem_acerto.enabled = Thisformset.pp_permite_alt_perc_acerto
							Thisformset.lx_form1.pageframe1.page1.ck_ctrl_mult_entregas.enabled = Thisformset.pp_permite_alt_mult_entrega
							Thisformset.lx_form1.pageframe1.page1.cmb_entrega_cif.enabled       = Thisformset.pp_permite_alt_entrega_cif
							Thisformset.lx_form1.pageframe1.page1.ck_conferido.enabled          = Thisformset.pp_permite_alt_conferido
							Thisformset.lx_form1.pageframe1.page1.tx_conferido_por.enabled      = Thisformset.pp_permite_alt_conf_por
							Thisformset.lx_form1.pageframe1.page1.tx_emissao.enabled = iif(type('Thisformset.pp_permite_alt_emissao')<>'U', Thisformset.pp_permite_alt_emissao, .t.)
							Thisformset.lx_form1.pageframe1.page2.cmb_representante.enabled = iif(type('Thisformset.pp_permite_alt_representante')<>'U', Thisformset.pp_permite_alt_representante, .t.)
							Thisformset.lx_form1.tv_pedido.enabled = iif (Thisformset.pp_pedido_sequencial or Thisformset.pp_ped_p_representante, .f., .t.)
							Thisformset.lx_FORM1.pageframe1.page2.Enabled = .t.
							Thisformset.lx_FORM1.pageframe1.page12.Enabled = .t.
							Thisformset.lx_form1.pageframe1.page1.cmb_aprovacao.Enabled = .t.
							Thisformset.lx_form1.pageframe1.page1.cmb_tipo_frete.Enabled = .t.
						Else
							If Thisformset.p_tool_status = 'L'
								Thisformset.lx_form1.pageframe1.page1.cmb_condicao_pgto.enabled      					= .t.
								Thisformset.lx_form1.pageframe1.page1.tv_transportadora.enabled     					= .t.
								Thisformset.lx_form1.pageframe1.page1.tv_tab_precos.Enabled	      					= .t.
								Thisformset.lx_form1.pageframe1.page1.tx_tabela_preco.Enabled	      					= .t.
								Thisformset.lx_form1.pageframe1.page1.lx_textbox_base3.enabled      					= .t.
								Thisformset.lx_form1.pageframe1.page1.cmb_colecao.enabled           					= .t.
								Thisformset.lx_form1.pageframe1.page1.cmb_moeda.enabled             					= .t.
								Thisformset.lx_form1.pageframe1.page1.cmb_tipo.enabled              					= .t.
								Thisformset.lx_form1.pageframe1.page1.cmb_filial.enabled            					= .t.
								Thisformset.lx_form1.pageframe1.page1.tx_cadastramento.enabled      					= .t.
								Thisformset.lx_form1.pageframe1.page2.tx_comissao.enabled           					= .t.
								Thisformset.lx_form1.pageframe1.page2.tx_comissao_gerente.enabled   					= .t.
								Thisformset.lx_form1.pageframe1.page2.tx_desconto.enabled           					= .t.
								Thisformset.lx_form1.pageframe1.page2.tx_encargo.enabled            					= .t.
								Thisformset.lx_form1.pageframe1.page2.tx_per_desconto.enabled       					= .t.
								Thisformset.lx_form1.pageframe1.page2.tx_per_encargo.enabled        					= .t.
								Thisformset.lx_form1.pageframe1.page1.spn_entrega_aceitavel.enabled 					= .t.
								Thisformset.lx_form1.pageframe1.page2.tx_porcentagem_acerto.enabled 					= .t.
								Thisformset.lx_form1.pageframe1.page1.ck_ctrl_mult_entregas.enabled 					= .t.
								Thisformset.lx_form1.pageframe1.page1.cmb_entrega_cif.enabled        					= .t.
								Thisformset.lx_form1.pageframe1.page1.ck_conferido.enabled          					= .t.
								Thisformset.lx_form1.pageframe1.page1.tx_conferido_por.enabled      					= .t.
								Thisformset.lx_form1.pageframe1.page1.tx_emissao.enabled								= .t.
								Thisformset.lx_form1.pageframe1.page1.cmb_aprovacao.enabled 		 					= .t.
								Thisformset.lx_form1.pageframe1.page1.tx_aprovado_por.enabled 		 					= .t.
								Thisformset.lx_form1.tv_pedido.enabled 							 					= .t.
							EndIf
						EndIf


					if	!f_vazio(xalias)	
						sele &xalias 
					endif

				case UPPER(xmetodo) == 'USR_SAVE_AFTER' 
					xsql = ""
					xalias=alias()
					IF (v_vendas_00.comissao = 0.00)
						TEXT TO xSql TEXTMERGE NOSHOW 
							SELECT COMISSAO 
							FROM 
							CLIENTE_REPRE 
							WHERE REPRESENTANTE='<<v_vendas_00.REPRESENTANTE>>' AND 
							CLIENTE_ATACADO='<<v_vendas_00.CLIENTE_ATACADO>>' 	
						ENDTEXT
						
						IF !F_SELECT(xSql,"TMP_COMISSAO")
							MESSAGEBOX("Representante não associado ao cliente e/ou sem comissão",64,"Informação")
						ELSE
							xsql = ""
							TEXT TO xSql TEXTMERGE NOSHOW
								UPDATE VENDAS SET COMISSAO=<<TMP_COMISSAO.COMISSAO>>,COMISSAO_VALOR=CAST((TOT_VALOR_ORIGINAL*<<TMP_COMISSAO.COMISSAO>>)/100 AS NUMERIC(14,2)) 
								WHERE
								PEDIDO = '<<v_vendas_00.PEDIDO>>'
							ENDTEXT
							
							IF !F_UPDATE(xsql)
								MESSAGEBOX("Erro ao atualizar comissão neste pedido.",64,"Atenção")
							endif
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


