* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                        *
* OBJETIVO.: Geracao Custo medio materiais na entrada e Consulta Entradas por colecao propriedade                                                                                                     *
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
		
		do case
			
			case UPPER(xmetodo) == 'USR_INIT' 
				WAIT WINDOW 'OBJ-SS' NOWAIT
				with ThisFormset.Lx_form1.Lx_pageframe1.page7.lx_grid_filha1
					.COL_ETIQUETA.VISIBLE = .F.
					.PARENT.BT_TODAS_ETQ.visible = .F.
					.PARENT.BT_TODAS_ETQ.enabled = .F.					
					lcColumnCount = .columncount 
					lcColumnCount = lcColumnCount + 1 
				    .addcolumn(lcColumnCount )
					.columns[lcColumnCount].name = 'col_etiqueta_peca'
					.col_etiqueta_peca.width = 70
					.col_etiqueta_peca.BackColor = 15399423
					.col_etiqueta_peca.columnorder = 7
					.col_etiqueta_peca.header1.caption = 'Etiqueta'
					.col_etiqueta_peca.header1.alignment = 2
					.col_etiqueta_peca.header1.FONTSIZE = 8
					.col_etiqueta_peca.addobject('bt_etiqueta_peca','bt_etiqueta_peca')
					.col_etiqueta_peca.currentcontrol = 'bt_etiqueta_peca'
					.col_etiqueta_peca.removeobject('text1')
					.col_etiqueta_peca.currentcontrol = 'bt_etiqueta_peca'
					.col_etiqueta_peca.sparse = .F.
					.col_etiqueta_peca.refresh()
				ENDWITH 
			
					*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_programa_00  
					sele v_entradas_00   
					xalias_pai=alias()

	  				oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("ENTRADAS.ANM_RATEIO_PRODUCAO", "N(15,5)",.T., "ANM_RATEIO_PRODUCAO", "Entradas.ANM_RATEIO_PRODUCAO")	
					oCur.addbufferfield("ENTRADAS.ANM_FRETE_ADICIONAL", "N(14,2)",.T., "ANM_FRETE_ADICIONAL", "Entradas.ANM_FRETE_ADICIONAL")
					oCur.addbufferfield("ENTRADAS.ANM_STATUS_ENTRADA", "C(25)",.T., "ANM_STATUS_ENTRADA", "Entradas.ANM_STATUS_ENTRADA")								
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 			
					
					*Inicio Inclusao Campos Novos de Produtos no Cursor Filha -- v_producao_programa_00 #XML
					sele v_entradas_00_ret1_mat
					xalias_pai=alias()
					oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("ESTOQUE_RET1_MAT.ANM_STATUS_SAIDA_ITEM", "L",.T., "Status Sai Mat. Rev.", "ESTOQUE_RET1_MAT.ANM_STATUS_SAIDA_ITEM")																
					oCur.confirmstructurechanges() 
					**-Fim Inclusao Campos Novos de Produtos no Cursor Filha #XML
					
					*** #XML inclusão da coluna comcheckbox na aba materiais ****
					IF Type('Thisformset.pp_anm_hab_finalizar_revisao') <> 'U' AND Thisformset.pp_anm_hab_finalizar_revisao
					
						WITH Thisformset.lX_FORM1.lx_PAGEFRAME1.page6.lx_grid_filha1
									.parent.addobject("bt_finaliza_revisao","bt_finaliza_revisao")
			                        .AddColumn(1)
			                        .Column1.Name='col_Liberar_revisao'
			                 WITH .col_Liberar_revisao
	                                       .RemoveObject("text1")
					            .BackColor = RGB(251,245,220)
					            .Header1.Name='h_check_revisao'
					            .h_check_revisao.Caption=' '
				                   .AddObject('ck_Liberar_revisao','CheckBox')
					            .Sparse= .F.
					            .CurrentControl = 'ck_Liberar_revisao'
					            .ck_Liberar_revisao.Caption=""
					            .ck_Liberar_revisao.Visible = .T.
	                            .Width=16
	                            .ControlSource="v_entradas_00_ret1_mat.ANM_STATUS_SAIDA_ITEM"
			                ENDWITH	
	                    ENDWITH	
						
						Bindevent(Thisformset.lX_FORM1.lx_PAGEFRAME1.page6.LX_GRID_FILHA1.col_Liberar_revisao.ck_Liberar_revisao, "Click", This, "Anm_Ctrl_Check", 1)
					ENDIF	
					*** FIM #XML ***
					
					xalias=alias()
					
					*** Declaração de variaveis ***
					public xnf_entrada,xserie_nf_entrada,xnome_clifor,xfilial,xvalor_producao,xmotivo_exclusao,xstatus_entrada
					
					*** Seleciona as filiais de armazenagem ***
					f_select("select filial from filiais where indica_armazem = 1","xFilialPedido")
					xvalor_producao=0
					
					*** Adiciona objeitos e propriedades destes na tela ****
					with thisformset.lx_form1.lx_PAGEFRAME1.page1
						.parent.page6.removeobject("Botao_Pedido")
						.parent.page6.addobject("Botao_Pedido","Botao_Pedido")	
						.pageframe1.page2.addobject("lb_anm_rateio_producao","lb_anm_rateio_producao")
						.pageframe1.page2.addobject("tx_anm_rateio_producao","tx_anm_rateio_producao")
						.pageframe1.page2.addobject("tx_valor_producao","tx_valor_producao")	
						.pageframe1.page2.addobject("tx_anm_frete_adicional","tx_anm_frete_adicional")						
						.pageframe1.page2.addobject("lb_anm_frete_adicional","lb_anm_frete_adicional")
						.pageframe1.page1.addobject("lx_entrada_revisao","lx_entrada_revisao")
						.parent.page6.addobject("bt_gera_pedido","bt_gera_pedido")
						.parent.page6.addobject("cmb_filial_pedido","cmb_filial_pedido")
						.parent.page6.cmb_filial_pedido.RowSource = "xFilialPedido"
						.parent.page6.Botao2.Visible= .F.
						.parent.page6.addobject("lb_Pedido_Gerado","lb_Pedido_Gerado")				
					endwith	
					
					Bindevent(thisformset.lx_form1.lx_PAGEFRAME1.page6, "Activate", This, "Anm_Consulta_fin", 1)	
					
					**Adiciona Botao Etiqueta - Lucas Miranda 06/10/2014***
					with thisformset.lx_form1.lx_PAGEFRAME1.page7
						.addobject("btn_etiqueta","btn_etiqueta")
					endwith	
					
				if !f_vazio(xalias)
					sele &xalias
				endif	
				
				
				Thisformset.L_limpa()
				
			
			&&ismara - 27/09/2013 - criar o botão para imprimir etiquetas de MP
			thisformset.lx_FORM1.lx_pageframe1.page1.addobject("imprime_etq_mp","imprime_etq_mp") 

		*** LUCAS MIRANDA ****		
 			case UPPER(xmetodo) == 'USR_INCLUDE_AFTER'
 				xalias=alias()
 				
 					IF  thisformset.pp_anm_especie_serie_padrao <>'0'
					
					thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.tv_Desc_Especie_Serie.Value = 'NF-E'
					thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.tv_Desc_Especie_Serie.Enabled = .F.
					thisformset.lx_form1.lx_pageframe1.page1.pageframe1.page_nfe.txt_chave_nfe.Enabled= .T.
					
 					SELE V_ENTRADAS_00
 						 xEspecie_Serie = 5
						 xModelo_Fiscal = '55'
						 
					REPLACE ESPECIE_SERIE 		 WITH xEspecie_Serie
					REPLACE NUMERO_MODELO_FISCAL WITH xModelo_Fiscal 
					
					else
					thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.tv_Desc_Especie_Serie.Enabled = .T.
					endif
 		*** LUCAS MIRANDA REVISÃO 20/02/2015, AJUSTE PARA ENTRAR NA 
 		***	FILIAL REVISAO DE ACORDO COM O PARAMETRO ANM_FILIAL_REVISAO_MP
 				THISFORMSET.lx_form1.lx_pageframe1.page1.pageframe1.page1.lx_entrada_revisao.Value = 0
 				
				if !f_vazio(xalias)
					sele &xalias
				ENDIF
		*** FIM LUCAS MIRANDA REVISÃO 20/02/2015 ***		
 		*********************		
			*** #XML *****
			case UPPER(xmetodo) == 'USR_CLEAN_AFTER' 
				
				xalias=alias()
					
					   thisformset.p_pai_filtro_query = ""
			
				if !f_vazio(xalias)
					sele &xalias
				endif	
			*** FIMM - #XML *****
			
			
			case UPPER(xmetodo) == 'USR_WHEN'
				
				xalias=alias()
					
					*** #XML *** ALTERADO IF ABAIXO ****
					IF THISFORMSET.p_tool_status = 'I' AND (upper(xnome_obj)=='BOTAO1' OR upper(xnome_obj)=='BOTAO2')
							
						xEntDeposito = "Pedido \ Material - Cor Material, sem Entrada no Deposito"+CHR(13)
						xPedidoMat = ""
						xwhere = ""
						
						sele v_entradas_00_ret1_mat
						GO top 

							Scan
								
								**** #XML -- ALTERADO ****
								F_SELECT("SELECT FILIAL_A_ENTREGAR FROM COMPRAS WHERE PEDIDO = ?v_entradas_00_ret1_mat.PEDIDO","xFilDesposito")
								IF ALLTRIM(v_entradas_00.Filial) $ thisformset.pp_ANM_FILIAL_REVISAO_MP AND ;
								   ALLTRIM(xFilDesposito.FILIAL_A_ENTREGAR) $ thisformset.pp_ANM_FILIAL_ARMAZEM
								*** #XML -- FIM ALTERADO ---
									
									sele v_entradas_00_ret1_mat
									REPLACE FILIAL WITH V_ENTRADAS_00.filial
								
								ENDIF
								
							sele v_entradas_00_ret1_mat
							EndScan
									
								
					ENDIF
					
			
					
				if !f_vazio(xalias)
					sele &xalias
				endif					
				
				

			case UPPER(xmetodo) == 'USR_VALID'
			
			
				xalias=alias()
											
					sele v_entradas_00	
	         		thisformset.lx_FORM1.lx_PAGEFRAME1.Page1.Pageframe1.Page1.Tv_RATEIO_FILIAL.Value = THISFORMSET.lx_FORM1.Tx_CliFor1.VALUE	
					f_select("select desc_rateio_filial from CTB_FILIAL_RATEIO where rateio_filial=?v_entradas_00.rateio_filial","curRATEIO",alias())
					thisformset.lx_FORM1.lx_PAGEFRAME1.Page1.Pageframe1.Page1.tx_desc_filial_rateio.Value = curRATEIO.desc_rateio_filial
				
				**** Julio - Veficica junto ao parâmetro ANM_NATUREZAS_IMPORTACAO as naturezas Permitidas para entrada de importação. ****
				If upper(xnome_obj)=='CK_IMPORTACAO'
					
					sele v_entradas_00	
					xSelImp = "SELECT COUNT(*) AS EntImpOK  FROM PARAMETROS WHERE PARAMETRO = 'ANM_NATUREZAS_IMPORTACAO' AND ( VALOR_ATUAL LIKE '%"+ALLT(v_Entradas_00.NATUREZA)+"%' OR VALOR_ATUAL = 'LIBERADO' )"
					f_select(xSelImp,"xteste")	
					
					If xteste.EntImpOK = 0
					    Thisformset.lx_FORM1.lx_pageframe1.page1.pageframe1.page1.Ck_importacao.value=0
					    MESSAGEBOX('Não é permitido Entrada de Importação com essa natureza'+CHR(13)+'Favor Procurar o Dpto. Fiscal.',64)
					Endif
						
				Endif					

*** LUCAS MIRANDA REVISÃO 20/02/2015, AJUSTE PARA ENTRAR NA 
***	FILIAL REVISAO DE ACORDO COM O PARAMETRO ANM_FILIAL_REVISAO_MP
					sele v_entradas_00_ret1_mat
					IF RECCOUNT()>0
						IF THISFORMSET.lx_form1.lx_pageframe1.page1.pageframe1.page1.lx_entrada_revisao.Value = 1
							SELE v_entradas_00_ret1_mat
								GO TOP
									SCAN
										replace v_entradas_00_ret1_mat.filial WITH THISFORMSET.pp_anm_filial_revisao_mp
									ENDSCAN
						endif
					endif					
*** LUCAS MIRANDA REVISÃO 20/02/2015						
					
				*** Bloqueia alterar a natureza após a verificação caso o checkbox importação esteja marcado na tela em modo de inclusão ou alteraçao **	
					If v_entradas_00.importacao=.T.
						if Thisformset.p_tool_status $ 'I,A'
							Thisformset.lx_FORM1.tv_operacao.ReadOnly= .T.
						endif
					Else 
						Thisformset.lx_FORM1.tv_operacao.ReadOnly= .F.
					Endif	
				*** Fim do exclusivo de validação da natureza na entrada de importação ******
				*****************************************************************************
								
				If upper(xnome_obj)=='TX_CUSTO_MATERIA_PRIMA'
					
							*f_select("select convert(numeric(8,2),valor_atual) as dif_max from parametros where parametro='ANM_DIF_MAX_VALOR_ENT_MAT'","curDifmax",alias())
							*if (o_005104.lx_FORM1.lx_pageframe1.page6.lx_grid_filha1.Col_tx_custo_materia_prima.tx_custo_materia_prima.OldValue-nvl(o_005104.lx_FORM1.lx_pageframe1.page6.lx_grid_filha1.Col_tx_custo_materia_prima.tx_custo_materia_prima.Value,0))<curDifmax.dif_max
							if ABS(   NVL(o_005104.lx_FORM1.lx_pageframe1.page6.lx_grid_filha1.Col_tx_custo_materia_prima.tx_custo_materia_prima.OldValue,0)- ;
							          NVL(o_005104.lx_FORM1.lx_pageframe1.page6.lx_grid_filha1.Col_tx_custo_materia_prima.tx_custo_materia_prima.Value,0) ;
							      ) > NVL(Thisformset.pp_anm_dif_max_valor_ent_mat,0)
							      
								messagebox("Não é possível alterar esta Informação!"+chr(13)+"A Alteração Excedeu o Limite de Diferença.",48,"Atenção")
								o_005104.lx_FORM1.lx_pageframe1.page6.lx_grid_filha1.Col_tx_custo_materia_prima.tx_custo_materia_prima.Value=o_005104.lx_FORM1.lx_pageframe1.page6.lx_grid_filha1.Col_tx_custo_materia_prima.tx_custo_materia_prima.OldValue
								o_005104.lx_FORM1.lx_pageframe1.page6.lx_grid_filha1.Col_tx_custo_materia_prima.tx_custo_materia_prima.l_desenhista_recalculo()
								o_005104.lx_FORM1.lx_pageframe1.page6.lx_grid_filha1.Refresh()
							
							endif		
						
				Endif	

			****lucas colocar especie serie padrao ao inserir a chave***
				If upper(xnome_obj)=='TXT_CHAVE_NFE' 
					parametro_chave=THISFORMSET.pp_valida_chave_nfe_entrada
					serie_nf_desc=thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.tv_Desc_Especie_Serie.Value
					
					IF parametro_chave = .T. and serie_nf_desc = 'NF-E' 
						  SELE V_ENTRADAS_00
	 						 xEspecie_Serie = 5
							
						   REPLACE ESPECIE_SERIE 		 WITH xEspecie_Serie
					ENDIF
				
				ENDIF
				
				If upper(xnome_obj)=='TX_PERDA'
					
								
					If thisformset.p_tool_status="P" and v_entradas_00.anm_status_entrada <>"4-FINALIZADO"    
						
						TEXT TO xupdtPerda NOSHOW textmerge
							
							UPDATE ESTOQUE_RET1_MAT SET 
							PERDA=<<v_entradas_00_ret1_mat.perda>> 
							WHERE REQ_MATERIAL='<<v_entradas_00_ret1_mat.req_material>>'  
							AND FILIAL='<<v_entradas_00_ret1_mat.filial>>' 
							AND MATERIAL='<<v_entradas_00_ret1_mat.material>>'  
							AND COR_MATERIAL='<<v_entradas_00_ret1_mat.cor_material>> ' 
							AND ITEM='<<v_entradas_00_ret1_mat.item>> '

						ENDTEXT 
						
						IF !f_update(xupdtPerda)
							MESSAGEBOX("Não foi Possível Alterar a Perda!!!")
						ELSE 
							MESSAGEBOX("Alteração com Sucesso!!!")
							o_005104.LX_FORM1.Lx_PageFrame1.Page6.Lx_grid_filha1.Col_tx_perda.Enabled = .F.
						ENDIF 						
												
												
					Endif

				Endif

				
				IF THISFORMSET.p_tool_status = 'I' AND upper(xnome_obj)=='TX_NF_ENTRADA'
					
						thisformset.lx_FORM1.TX_NF_ENTRADA.VALUE = RIGHT(STR(VAL(thisformset.lx_FORM1.TX_NF_ENTRADA.VALUE)+10000000),7)
					
				ENDIF
				
			if	!f_vazio(xalias)	
				sele &xalias 
			endif

			
			case UPPER(xmetodo) == 'USR_REFRESH' 
			
				xalias=alias()
					
					*** Trata o caption do botão - #XML *****
					If type("thisformset.lx_form1.lx_PAGEFRAME1.page6.bt_finaliza_revisao")<>"U"
						IF THISFORMSET.p_tool_status <> 'L'		
								thisformset.lx_FORM1.lx_pageframe1.page6.bt_finaliza_revisao.Caption = "Finalizar Revisão"
								thisformset.lx_FORM1.lx_pageframe1.page6.bt_finaliza_revisao.enabled = .t.
						ELSE
							thisformset.lx_FORM1.lx_pageframe1.page6.bt_finaliza_revisao.Caption = "Pendente Finalizar"
							thisformset.lx_FORM1.lx_pageframe1.page6.bt_finaliza_revisao.enabled = .t.
						ENDIF	
					Endif
					
					SELECT * FROM v_entradas_00_ret1_mat INTO CURSOR vOLD_v_entradas_00_ret1_mat READWRITE
					*** Fim - Trata o caption do botão - #XML *****
					
						
					if type("o_005104.lx_form_rateios")<>"U"
						o_005104.lx_form_rateios.Width=700			
					endif	

					if type("thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.Cnt_producao.tx_valor_tempo")<>"U"
						xtempo_producao = thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.Cnt_producao.tx_valor_tempo.Value 
					else	
						xtempo_producao = 0
					endif		

					If type("thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.tx_anm_rateio_producao")<>"U"
						xvalor_producao = (round( v_entradas_00.valor_total/(1-(xtempo_producao/100)) ,2))-nvl(v_entradas_00.anm_rateio_producao,0)	
						if thisformset.p_tool_status = "P"
							thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.tx_anm_rateio_producao.Enabled = .F.
						endif	

							thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.tx_valor_producao.visible=.t.

					Endif	
					
					** Volta Valor do campo para default **
					Thisformset.lx_FORM1.tv_operacao.ReadOnly= .F.
*** LUCAS MIRANDA REVISÃO 20/02/2015, AJUSTE PARA ENTRAR NA 
***	FILIAL REVISAO DE ACORDO COM O PARAMETRO ANM_FILIAL_REVISAO_MP			
					IF TYPE("THISFORMSET.lx_form1.lx_pageframe1.page1.pageframe1.page1.lx_entrada_revisao") <> "U"
							IF Thisformset.p_tool_status = "I" 
								THISFORMSET.lx_form1.lx_pageframe1.page1.pageframe1.page1.lx_entrada_revisao.enabled = .T.
								ELSE
								THISFORMSET.lx_form1.lx_pageframe1.page1.pageframe1.page1.lx_entrada_revisao.enabled = .F.
							ENDIF
					ENDIF				
*** LUCAS MIRANDA REVISÃO 20/02/2015
				
				if	!f_vazio(xalias)	
					sele &xalias 
				endif

	
				case UPPER(xmetodo) == 'USR_SAVE_BEFORE' 
			
				xalias=alias()
					
					***** Saida Automática dos materiais comprados para Pilotagem ****
					IF Thisformset.pp_anm_saida_auto_piloto AND Thisformset.P_TOOL_status = 'E'

						SELECT Distinct PEDIDO,FILIAL,NF_ENTRADA,NOME_CLIFOR,SERIE_NF_ENTRADA FROM v_entradas_00_ret1_mat INTO CURSOR xTMP_EPed
						sele xTMP_EPed
						GO Top

						SCAN
							f_update("EXEC LX_ANM_GERA_SAIDA_PILOTO ?xTMP_EPed.PEDIDO,?xTMP_EPed.FILIAL,?xTMP_EPed.NOME_CLIFOR,?xTMP_EPed.NF_ENTRADA,?xTMP_EPed.SERIE_NF_ENTRADA,?o_005104.p_tool_status")

							sele xTMP_EPed
						ENDSCAN	

					ENDIF
					
					
					sele v_entradas_00
					replace filial_cobranca WITH v_entradas_00.filial
	*** LUCAS MIRANDA ****
				IF THISFORMSET.P_TOOL_status == 'I'				

					parametro_chave=THISFORMSET.pp_valida_chave_nfe_entrada
					chave_nfe=THISFORMSET.lx_form1.lx_pageframe1.page1.pageframe1.page_NFE.txt_chave_nfe.Value
					serie_nf_desc=thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.tv_Desc_Especie_Serie.Value
					nf_entrada_propria=thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.ck_nf_propria.Value
					
					IF parametro_chave = .T. AND f_vazio(chave_nfe) AND serie_nf_desc = 'NF-E' AND nf_entrada_propria = .F.
						MESSAGEBOX("VOCÊ NÃO INFORMOU A CHAVE !!!" + CHR(13) + "FAVOR INSERIR A CHAVE !",64)
						RETURN .F.
					ENDIF
							
				ENDIF						
						
					IF THISFORMSET.P_TOOL_status == 'E'
						
						MESSAGEBOX("Atenção, Todos os Seus Dados Serão Armazenados ",48,"Atenção_9!")		
						xmotivo_exclusao = inputbox('Descreva o motivo da Exclusão','Motivo Exclusão (Campo Obrigatório)','')
							 	
						text to	xinsert1 noshow textmerge	
							INSERT INTO ANM_LOG_EXCLUSAO_NF
							(NF_ENTRADA,SERIE_NF,FILIAL,NOME_CLIFOR,DATA_DIGITACAO,EMISSAO,RECEBIMENTO,VALOR,DATA_EXCLUSAO,
							MOTIVO_EXCLUSAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA)
						
							SELECT '<<V_ENTRADAS_00.NF_ENTRADA>>','<<V_ENTRADAS_00.SERIE_NF_ENTRADA>>','<<V_ENTRADAS_00.FILIAL>>',
							'<<V_ENTRADAS_00.NOME_CLIFOR>>','<<V_ENTRADAS_00.DATA_DIGITACAO>>','<<V_ENTRADAS_00.EMISSAO>>',
							'<<V_ENTRADAS_00.RECEBIMENTO>>','<<V_ENTRADAS_00.VALOR_TOTAL>>',(SELECT GETDATE()),'<<XMOTIVO_EXCLUSAO>>',
							'<<WUSUARIO>>','<<SYSTEM.NetUserName>>','<<SYSTEM.NetComputerName>>'
						endtext			
											
						if !f_insert(xinsert1) 
							messagebox("Não foi possível Excluir a Nota Fiscal ",48,"Atenção_9!")
							retu .f.
						ENDIF
						
			
						
					ENDIF	
			
					text to	xupdt noshow	
						insert into prop_entradas  
						(PROPRIEDADE,ITEM_PROPRIEDADE,VALOR_PROPRIEDADE,NF_ENTRADA,SERIE_NF_ENTRADA,NOME_CLIFOR)  
						select  
						'00014',1,b.valor_propriedade,a.nf_entrada, a.serie_nf_entrada,a.nome_clifor  
						from  
						(select top 1 a.pedido,a.nome_clifor,a.nf_entrada,a.serie_nf_entrada   
						from entradas_material a  
						where a.nome_clifor    = ?v_entradas_00.nome_clifor   
						and a.nf_entrada       = ?v_entradas_00.nf_entrada   
						and a.serie_nf_entrada = ?v_entradas_00.serie_nf_entrada) a   
						join prop_compras b  
						on a.pedido=b.pedido 
						left join prop_entradas c  
						on  a.nome_clifor      = c.nome_clifor 
						and a.nf_entrada       = c.nf_entrada  
						and a.serie_nf_entrada = c.serie_nf_entrada  
						where c.nome_clifor is null  
					endtext		
					
					if !f_update(xupdt) 
						messagebox("Não foi possível Inserir Propriedade")	
					endif		

					
				if	!f_vazio(xalias)	
					sele &xalias 
				endif	 
	
			
	

			case UPPER(xmetodo) == 'USR_SAVE_AFTER' 

				xalias=alias()
					
					***** Saida Automática dos materiais comprados para Pilotagem ****
					IF Thisformset.pp_anm_saida_auto_piloto AND Thisformset.P_TOOL_status <> 'E'

						SELECT Distinct PEDIDO,FILIAL,NF_ENTRADA,NOME_CLIFOR,SERIE_NF_ENTRADA FROM v_entradas_00_ret1_mat INTO CURSOR xTMP_EPed
						sele xTMP_EPed
						GO Top

						SCAN
							f_update("EXEC LX_ANM_GERA_SAIDA_PILOTO ?xTMP_EPed.PEDIDO,?xTMP_EPed.FILIAL,?xTMP_EPed.NOME_CLIFOR,?xTMP_EPed.NF_ENTRADA,?xTMP_EPed.SERIE_NF_ENTRADA,?o_005104.p_tool_status")

							sele xTMP_EPed
						ENDSCAN	
							
					ENDIF

					
					
					************INICIO CUSTO MEDIO MATERIAIS*********************
					If  v_entradas_00.tipo_operacao='C' && -- FINALIZO A OPERAÇÃO E ENTRADA NO ESTOQUE CENTRAL
					
					select	material,cor_material,filial,sum(qtde) as qtde, ; 
					sum(valor) as valor from v_entradas_00_ret1_mat	; 
					group by  material,cor_material,filial ; 
					into cursor	curEntMat
					

					text to	xselmov1 noshow	
						select a.*,sum(qtde_estoque) as qtde_estoque 
						from 
						(select emissao,documento,material,cor_material,tipo,qtde,saldo,
						(valor) as valor_ent,
						convert(numeric(14,5),((valor)/qtde)) as valor_unit 
					endtext	


					Text to	xupd noshow				 
					   UPDATE Materiais_Cores    
					   set  custo_reposicao = convert(numeric(14,5),?xcustomedio),    
					   custo_a_vista = convert(numeric(14,5),?xcustomedio)    
					   WHERE Material=?curEntMat.material   
					   AND Cor_Material=?curEntMat.cor_material  
					Endtext		
					
					
					Sele curEntMat	
					go top	

					scan	
						
						f_prog_bar('Atualizando Preço Medio de Entrada dos Materiais...',recno(),reccount()) 
						
			
						xselmov2 = " from FX_ANM_Monta_Cardex_01 ('" +allt(curEntMat.material)+"' , '"+ ; 
	 		            allt(curEntMat.cor_material)+"' , '%' , NULL, 0) " + ;
						"where tipo='ENTRADA DE N.F.') a " + ;
						"join estoque_materiais b  " + ;
						"on a.material=b.material and a.cor_material=b.cor_material " +;
						"group by emissao,documento,a.material,a.cor_material,tipo,qtde,saldo,valor_ent,valor_unit "  
						

						if !f_select(xselmov1+xselmov2,"curCardex")
							messagebox('Não foi póssível selecionar movimentação dos materiais !',32,'Atenção_3 !!!')
							retu .f.
						endif		
						sele curCardex	
							xsaldoant		= 0
							xvalorant		= 0
							xvalorestapos	= 0
							xcustomedio		= 0
							xcustoant		= 0 
							xseq_calc       = 0  
						scan	
							xsaldoant		= iif( (curCardex.saldo-curCardex.qtde)<0,0,(curCardex.saldo-curCardex.qtde) )
							xvalorant		= xsaldoant * iif( (xseq_calc=0 and xsaldoant>0), curCardex.valor_unit , xcustoant )
							xvalorestapos	= curCardex.valor_ent+xvalorant
							xcustomedio		= xvalorestapos/iif(curCardex.saldo<=curCardex.qtde,curCardex.qtde,curCardex.saldo) 
							xcustoant		= xcustomedio 
							xseq_calc       = xseq_calc + 1 
						endscan							
						
						sele curEntMat	

						if !f_update(xupd)	 
							messagebox('Não foi póssível atualizar os custo medio dos materiais !',32,'Atenção_4 !!!')
							retu .f.
						endif	
						
						sele curEntMat	
						
					endscan	
					f_prog_bar()	
 
					
				Endif	
				************FIM CUSTO MEDIO MATERIAIS*********************


			if	!f_vazio(xalias)	
				sele &xalias 
			endif	 

			
	
			otherwise
				return .t.				
		endcase
	endproc
	
	**** #XML ****
	Procedure Anm_Ctrl_Check

		xalias=alias()
		
			sele vOLD_v_entradas_00_ret1_mat
			LOCATE FOR material = v_entradas_00_ret1_mat.material AND cor_material = v_entradas_00_ret1_mat.cor_material

			IF vOLD_v_entradas_00_ret1_mat.anm_status_saida_item == .T.
			    
			    THISFORMSET.lX_FORM1.lx_PAGEFRAME1.page6.LX_GRID_FILHA1.col_Liberar_revisao.ck_Liberar_revisao.VALUE = 1
			
			ENDIF
			
		if !f_vazio(xalias)	
			sele &xalias
		endif	

	Endproc
	**** FIM - #XML ****
	
	Procedure Anm_Consulta_fin

		xalias=alias()
		
					*** Tratamento do status dos objetos ref. a entrada 2AA ***
					If !EMPTY(NVL(v_entradas_00.ANM_STATUS_ENTRADA,""))
						thisformset.lx_form1.lx_PAGEFRAME1.page6.bt_gera_pedido.visible    = .f. 
						thisformset.lx_form1.lx_PAGEFRAME1.page6.cmb_filial_pedido.enabled = .f. 
						
						f_select("SELECT FILIAL_DESTINO FROM ESTOQUE_SAI_MAT WHERE REQ_MATERIAL = replace(?v_entradas_00.ANM_STATUS_ENTRADA,'Pedido Gerado: ','')","xFilDest")

						thisformset.lx_form1.lx_PAGEFRAME1.page6.lb_Pedido_Gerado.visible = .t.
						thisformset.lx_form1.lx_PAGEFRAME1.page6.lb_Pedido_Gerado.caption = NVL(v_entradas_00.ANM_STATUS_ENTRADA,"")
						thisformset.lx_form1.lx_PAGEFRAME1.page6.cmb_filial_pedido.value  = xFilDest.FILIAL_DESTINO
						thisformset.lx_FORM1.lx_pageframe1.page6.lb_Pedido_Gerado.Left=712
					Else
						thisformset.lx_form1.lx_PAGEFRAME1.page6.bt_gera_pedido.visible   = .t. 
						thisformset.lx_form1.lx_PAGEFRAME1.page6.cmb_filial_pedido.enabled= .t. 
						
						thisformset.lx_form1.lx_PAGEFRAME1.page6.lb_Pedido_Gerado.visible = .f.
						thisformset.lx_form1.lx_PAGEFRAME1.page6.lb_Pedido_Gerado.caption = ""
						thisformset.lx_form1.lx_PAGEFRAME1.page6.cmb_filial_pedido.value  = ""
					Endif
					*** Tratamento do status dos objetos ref. a entrada 2AA ***
		
	
		if !f_vazio(xalias)	
			sele &xalias
		endif	

	Endproc

enddefine

************************************************** #XML ***
*-- Class:        pendente_finalizar_ent (c:\pastas\anm_class\pendente_finalizar_ent.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/15/14 01:18:07 PM
*
DEFINE CLASS bt_finaliza_revisao AS commandbutton


	Top = 63
	Left = 33
	Height = 23
	Width = 140
	FontBold = .T.
	Caption = "Pendente Finalizar"
	TabIndex = 40
	Name = "bt_finaliza_revisao"
	Visible = .t.
	Enabled =.t.
	
	PROCEDURE Click
	
				if thisformset.lx_FORM1.lx_pageframe1.page6.bt_finaliza_revisao.Caption = "Pendente Finalizar"
					
					xOld_p_pai_filtro_query = thisformset.p_pai_filtro_query
					
					SELECT v_entradas_00
					replace v_entradas_00.filial WITH Thisformset.pp_ANM_FILIAL_REVISAO_MP
					thisformset.p_pai_filtro_query = " ENTRADAS.NOME_CLIFOR+ENTRADAS.NF_ENTRADA+ENTRADAS.SERIE_NF_ENTRADA IN "+;
													 " (SELECT DISTINCT NOME_CLIFOR+NF_ENTRADA+SERIE_NF_ENTRADA FROM ESTOQUE_RET_MAT A "+;
													 " JOIN ESTOQUE_RET1_MAT B ON A.REQ_MATERIAL = B.REQ_MATERIAL AND A.FILIAL = B.FILIAL "+;
													 " WHERE ISNULL(ANM_STATUS_SAIDA_ITEM,0) = 0 AND "+;
													 " A.FILIAL = (SELECT DBO.FX_ANM_PARAMETRO_USER('ANM_FILIAL_REVISAO_MP') ) ) "
					o_toolbar.Botao_procura.Click()
				else					
					if messagebox("Deseja Finalizar a Revisão do Itens Marcados?",4+32+256,"Atenção!")=6	
						
						xFiltroFunc = ""
						xRomaneioRev = ""
						
						SELECT v_entradas_00_ret1_mat
						GO TOP
						SCAN
							IF v_entradas_00_ret1_mat.anm_status_saida_item == .T.
								sele vOLD_v_entradas_00_ret1_mat
								LOCATE FOR MATERIAL =v_entradas_00_ret1_mat.material AND COR_MATERIAL = v_entradas_00_ret1_mat.cor_material AND ;
								           REQ_MATERIAL = v_entradas_00_ret1_mat.req_material AND NOME_CLIFOR = v_entradas_00_ret1_mat.nome_clifor AND ;
								           ITEM = v_entradas_00_ret1_mat.item
								
								IF NVL(vOLD_v_entradas_00_ret1_mat.anm_status_saida_item,.F.) == .F. 
									xFiltroFunc = xFiltroFunc + vOLD_v_entradas_00_ret1_mat.item+","
									IF! ALLTRIM(vOLD_v_entradas_00_ret1_mat.req_material) $ xRomaneioRev 
										xRomaneioRev = xRomaneioRev + "|"+ALLTRIM(vOLD_v_entradas_00_ret1_mat.req_material)+"|,"
									ENDIF
									
									IF ALLTRIM(vOLD_v_entradas_00_ret1_mat.Filial) <> ALLTRIM(Thisformset.pp_ANM_FILIAL_REVISAO_MP)
										MESSAGEBOX('ATENÇÃO ... Finalização não Permitida.',64)
										RETURN .F.
									ENDIF	
								ENDIF
								
							SELECT v_entradas_00_ret1_mat
							ENDIF
						ENDSCAN
						
						IF EMPTY(xFiltroFunc)
							MESSAGEBOX('Os Materiais selecionados já foram Finalizados.',64)
						ELSE	
							xFiltroFunc = LEFT(xFiltroFunc,LEN(xFiltroFunc)-1)		
							xRomaneioRev = LEFT(xRomaneioRev,LEN(xRomaneioRev)-1)
							
	                                              sele v_entradas_00_ret1_mat
												  GO TOP
												  	
	                                              TEXT TO xExecProc TEXTMERGE NOSHOW

	                                                     EXECUTE LX_ANM_GERA_PEDIDO_OL_ENT_ITEM  '<<v_entradas_00_ret1_mat.nome_clifor>>','<<v_entradas_00_ret1_mat.nf_entrada>>',
	                                                                                             '<<v_entradas_00_ret1_mat.serie_nf_entrada>>','<<xRomaneioRev>>',
	                                                                                             '<<xFiltroFunc>>'     

	                                              ENDTEXT


									if !f_update(xExecProc)
										RETURN .f.
									endif
								
								MESSAGEBOX('Revisão Finalizada com sucesso!',64)
								
								sele v_entradas_00_ret1_mat
								GO top

								SCAN
									sele vold_v_entradas_00_ret1_mat 
									LOCATE FOR MATERIAL = v_entradas_00_ret1_mat.material AND COR_MATERIAL = v_entradas_00_ret1_mat.cor_material AND ;
									           REQ_MATERIAL = v_entradas_00_ret1_mat.req_material AND NOME_CLIFOR = v_entradas_00_ret1_mat.nome_clifor AND;
									           ITEM = v_entradas_00_ret1_mat.item
									
									REPLACE anm_status_saida_item WITH v_entradas_00_ret1_mat.anm_status_saida_item 

								sele v_entradas_00_ret1_mat

								ENDSCAN	
						 ENDIF
							
							sele v_entradas_00_ret1_mat
							GO top	
					 endif
				 endif
	
	ENDPROC
	

ENDDEFINE
*
*-- EndDefine: pendente_finalizar_ent
************************************************** FIM - #XML ***



**************************************************
*-- Class:        bt_pedidos_mat (c:\temp\rbx\bt_pedidos_mat.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   11/20/08 01:37:01 PM
*
DEFINE CLASS Botao_Pedido AS botao


	Top = 42
	Left = 417
	Height = 23
	Width = 291
	FontBold = .T.
	Caption = "\<Pedidos de compra"
	TabIndex = 7
	ForeColor = RGB(128,0,0)
	ZOrderSet = 14
	Name = "Botao_Pedido"
	Visible = .T.

	PROCEDURE Click
		Local nOldSele, cWhereNF, cWhere, cSQL as String

		nOldSele = Select()

		If ! InList(ThisFormSet.p_Tool_Status, "I", "A") OR v_Entradas_00.NOTA_COMPLEMENTAR

			Select(nOldSele)
			Return

		EndIf

		If InList(v_Entradas_00.TIPO_OPERACAO, "D", "N")

			F_Msg(["Não é possível utilizar essa opção para devoluções !", 0+48, "Atenção"])
			Select(nOldSele)
			Return

		EndIf

		If F_Vazio(v_Entradas_00.NOME_CLIFOR)

			F_Msg(["Informe o fornecedor para selecionar os pedidos !", 0+48, "Atenção"])
			Select(nOldSele)
			Return .F.

		EndIf

		With This.Parent.Parent

			.Page8.cmb_Fornecedores.ControlSource = ""
			.Page8.cmb_Fornecedores.RowSource     = ""
			.Page8.cmb_PEDIDOS.CONTROLSOURCE	  = ""
			.Page8.cmb_PEDIDOS.ROWSOURCE		  = ""

		EndWith


		If Used("xCur_Pedidos")

			Select xCur_Pedidos
			Use

		EndIf

		If Used("xCur_Pedidos_Fornec")

			Select xCur_Pedidos_Fornec
			Use

		EndIf


		If ThisFormSet.px_Bloq_EntPed_NOP
			cWhereNF = " AND ( COMPRAS.NATUREZA_ENTRADA IS NULL OR COMPRAS.NATUREZA_ENTRADA = ?v_Entradas_00.NATUREZA ) "
		Else
			cWhereNF = ""
		EndIf
		
			cWhere = "RTRIM(COMPRAS.TABELA_FILHA) = 'COMPRAS_MATERIAL' AND " + ;
			         "COMPRAS.TOT_QTDE_ENTREGAR > 0 AND " + ;
			         "COMPRAS.STATUS_APROVACAO = 'A' AND " + ;
					 "COMPRAS.FORNECEDOR = ?v_entradas_00.nome_clifor  " + ;
			         cWhereNF

*!*			cWhere = "RTRIM(COMPRAS.TABELA_FILHA) = 'COMPRAS_MATERIAL' AND " + ;
*!*			         "COMPRAS.TOT_QTDE_ENTREGAR > 0 AND " + ;
*!*			         "COMPRAS.STATUS_APROVACAO = 'A' AND " + ;
*!*			         "COMPRAS.FILIAL_A_FATURAR = ?v_entradas_00.filial AND " + ;
*!*					 "COMPRAS.FORNECEDOR = ?v_entradas_00.nome_clifor  " + ;
*!*			         cWhereNF
		         
		         
		         
		If wCtrl_Multi_Empresa
			cWhere = cWhere + " AND FILIAIS.EMPRESA = ?wEmpresa_Atual"
		EndIf

		cSQL = "SELECT DISTINCT COMPRAS.PEDIDO, COMPRAS.FORNECEDOR, COMPRAS.PEDIDO_FORNECEDOR, COMPRAS.FILIAL_COBRANCA, FILIAIS_COBRANCA.COD_FILIAL AS COD_FILIAL_COBRANCA " + ;
		       "FROM COMPRAS "

		If Type("ThisFormSet.pp_Filtrar_Limite_Pedido") == "L" AND ThisFormSet.pp_Filtrar_Limite_Pedido
			cSQL = cSQL + "INNER JOIN COMPRAS_MATERIAL ON COMPRAS.PEDIDO = COMPRAS_MATERIAL.PEDIDO AND COMPRAS_MATERIAL.LIMITE_ENTREGA >= ?v_Entradas_00.RECEBIMENTO "
		EndIf

		cSQL = cSQL + "INNER JOIN FILIAIS ON COMPRAS.FILIAL_A_ENTREGAR = FILIAIS.FILIAL " + ;
		              "LEFT JOIN FILIAIS AS FILIAIS_COBRANCA ON COMPRAS.FILIAL_COBRANCA = FILIAIS_COBRANCA.FILIAL " + ;
		              "WHERE " + cWhere + " " + ;
		              "ORDER BY COMPRAS.PEDIDO"

		If ! F_Select(cSQL, "xCur_Pedidos")

			Select(nOldSele)
			Return .F.

		EndIf

		If Reccount("xCur_Pedidos") == 0

			F_Msg(["Não há pedidos em aberto !", 0+48, "Atenção"])

			Select(nOldSele)
			Return .F.

		EndIf

		Select distinct fornecedor from xcur_pedidos into cursor xcur_pedidos_fornec

		Select xCur_Pedidos_Fornec
		Locate For FORNECEDOR == v_Entradas_00.NOME_CLIFOR

		If ! Found()
			F_Msg(["Não existem pedidos para o fornecedor da entrada, será utilizado para filtro um outro fornecedor.", 0+48, "Atenção"])
			Go Top
		EndIf

		With This.Parent.Parent

			.Page1.Enabled = .F.
			.Page2.Enabled = .F.
			.Page3.Enabled = .F.
			.Page4.Enabled = .F.
			.Page5.Enabled = .F.
			.Page6.Enabled = .F.
			.Page7.Enabled = .F.
			.Page8.Enabled = .T.
			.ActivePage    = 8

		EndWith
		
		sele v_Compras_01
		scan
			REPLACE filial_a_entregar WITH V_ENTRADAS_00.filial
		endscan
		
		Select(nOldSele)
		Return .T.
		

		
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_pedidos_mat
**************************************************




**************************************************
*-- Class:        cmb_pedidos (c:\temp\rbx\cmb_pedidos.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/20/08 04:18:01 PM
*
DEFINE CLASS cmb_pedidos AS lx_combobox


	BoundColumn = 1
	RowSource = ""
	ControlSource = "v_compras_01.pedido"
	Height = 21
	Left = 209
	Top = 31
	Width = 152
	p_tipo_dado = "EDITA"
	Name = "cmb_PEDIDOS"
	vISIBLE = .T.

	PROCEDURE l_desenhista_recalculo
		Local cOldSele, nPerc, nPerc_Qtde, cSQL, nQtde_Entrada, nQtde_Entregar

		Private cPedido

		cOldSele = Select()

		Select v_Compras_01
		F_StuffDBC('Additive', 'Pedido = ?xCur_Pedidos.Pedido')
		Go Top

		If ! Eof()

			Select v_Compras_01_Materiais
			Set Filter TO
			Requery()

			Delete All For ( Qtde_Entregar <= 0 )

			If Type("ThisFormSet.pp_Filtrar_Limite_Pedido") == "L" AND ThisFormSet.pp_Filtrar_Limite_Pedido
				Delete All For ( LIMITE_ENTREGA < v_Entradas_00.RECEBIMENTO )
			EndIf

			Go Top

		EndIf

		cPedido = This.Value

		F_Select('SELECT Compras.Comprimento_de_Rolos, Compras.Marca_Volumes FROM Compras WHERE Compras.Pedido = ?cPedido', 'curCompras')

		nPerc      = Iif( F_Vazio(curCompras.Comprimento_de_Rolos), 0, curCompras.Comprimento_de_Rolos)

		*fbn*	nPerc_Qtde = Iif( F_Vazio(curCompras.Marca_Volumes)       , 0, Iif( Alltrim(v_Entradas_00.Serie_NF_Entrada) <> Alltrim(wTipo_Producao_Serie), curCompras.Marca_Volumes, ( 100 - curCompras.Marca_Volumes ) ) )

		nPerc_Qtde = Iif( F_Vazio(curCompras.Marca_Volumes)       , 0, ;
		                  Iif( ! InList(v_Entradas_00.Serie_NF_Entrada, wTipo_Producao, wTipo_Producao_Serie), ;
		                       curCompras.Marca_Volumes, ;
		                       ( 100 - curCompras.Marca_Volumes ) ;
		                     ) ;
		                )

		cSQL       = 'SELECT SUM(c.Qtde) AS Qtde FROM Entradas a INNER JOIN Estoque_Ret_Mat b ON a.NF_Entrada = b.NF_Entrada AND ' + ;
		             'a.Nome_CliFor = b.Nome_CliFor AND a.Serie_NF_Entrada = b.Serie_NF_Entrada INNER JOIN Estoque_Ret1_Mat c ON ' + ;
		             'b.Req_Material = c.Req_Material AND b.Filial = c.Filial WHERE c.Material = ?v_Compras_01_Materiais.Material ' + ;
		             'AND c.Cor_Material = ?v_Compras_01_Materiais.Cor_Material AND c.Pedido = ?v_Compras_01_Materiais.Pedido ' + ;
		             'AND c.Entrega_Pedido = ?v_Compras_01_Materiais.Entrega AND a.Serie_NF_Entrada ' + ;
		             Iif( InList(v_Entradas_00.Serie_NF_Entrada, wTipo_Producao, wTipo_Producao_Serie), " IN ", " NOT IN " ) + ;
		             ' ( ?wTipo_Producao, ?wTipo_Producao_Serie )'

		*fbn*	             Iif( Alltrim(v_Entradas_00.Serie_NF_Entrada) == Alltrim(wTipo_Producao_Serie), '=', '<>' ) + ;

		Select v_Compras_01_Materiais
		Go Top

		Scan

			F_Select(cSQL, 'curEntrada')

			nQtde_Entrada = Iif( F_Vazio(curEntrada.Qtde), 0, CurEntrada.Qtde)

			** Ajusta a qtde *********************************************************
			Select v_Entradas_00_Ret1_Mat
			Go Top

			Locate For Pedido   == v_Compras_01_Materiais.Pedido AND ;
			           Material == v_Compras_01_Materiais.Material AND ;
			           Cor_Material == v_Compras_01_Materiais.Cor_Material AND ;
			           Entrega_Pedido == v_Compras_01_Materiais.Entrega

			If Found()

				Scan For Pedido   == v_Compras_01_Materiais.Pedido AND ;
				         Material == v_Compras_01_Materiais.Material AND ;
				         Cor_Material == v_Compras_01_Materiais.Cor_Material AND ;
				         Entrega_Pedido == v_Compras_01_Materiais.Entrega

					nQtde_Entrada = ( nQtde_Entrada + Qtde )

				EndScan

			EndIf
			**************************************************************************

			Select v_Compras_01_Materiais
			Replace comprimento_de_rolos    With nPerc , ;
					Custo_Cheio    With Custo, ;
			        Custo          With ( Custo - ( Custo * ( nPerc / 100 ) ) ), ;
			        Custo_Moeda    With ( Custo_Moeda - ( Custo_Moeda * ( nPerc / 100 ) ) ), ;
			        Valor_Entregar With ( Valor_Entregar - ( Valor_Entregar * ( nPerc / 100 ) ) )

			nQtde_Entregar = ( ( Qtde_Original - Qtde_Cancel_Pedido - nQtde_Entrada ) - ( ( Qtde_Original - Qtde_Cancel_Pedido  ) * ( nPerc_Qtde / 100 ) ) )
			nQtde_Entregar = Iif( nQtde_Entregar < 0, 0, nQtde_Entregar )

			Replace Qtde_Entregar With nQtde_Entregar

			Select v_Compras_01_Materiais
		 
		EndScan
				
		Delete All For ( Qtde_Entregar <= 0 )
		Go Top

		***tratamento filiais matrizes diferentes
		sele v_Compras_01
		scan
			REPLACE filial_a_entregar WITH V_ENTRADAS_00.filial
		endscan
*!*			sele v_compras_01	
*!*			xfilial_estoque=filial_a_entregar	
*!*			
*!*			repla filial_a_entregar with v_entradas_00.filial
*!*			sele v_entradas_00	
*!*			repla filial_estoque with xfilial_estoque 	
*!*			thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_filial_estoque.refresh() 		
		
		***tratamento filiais matrizes diferentes


		This.Parent.lx_Grid_Pedidos.Refresh()
		


		Select(cOldSele)
		Return
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmb_pedidos
**************************************************




**************************************************
*-- Class:        lb_status_entrada (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_anm_rateio_producao AS lx_label


	Caption = "Desc. Rateio"
	Height = 15
	Left = 205
	Top = 264
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_anm_rateio_producao"
	Visible = .t.
	Anchor = 0
	FontBold = .T.


	PROCEDURE DblClick	

		TEXT TO CurSelPgto TEXTMERGE NOSHOW
		
			SELECT 1 AS NF_PAGA 
			FROM ENTRADAS 
			INNER JOIN CTB_A_PAGAR_MOV 
			ON ( ENTRADAS.CTB_LANCAMENTO = CTB_A_PAGAR_MOV.LANCAMENTO_MOV 
			OR ENTRADAS.NUMERO_CONFERENCIA = CTB_A_PAGAR_MOV.LANCAMENTO_MOV ) 
			AND ENTRADAS.CTB_ITEM = CTB_A_PAGAR_MOV.ITEM_MOV 
			AND CTB_A_PAGAR_MOV.EMPRESA = 1
			JOIN CTB_LANCAMENTO_ITEM
			ON  CTB_A_PAGAR_MOV.LANCAMENTO = CTB_LANCAMENTO_ITEM.LANCAMENTO
			AND CTB_LANCAMENTO_ITEM.CODIGO_HISTORICO NOT IN ('IAD','BTP') 
			WHERE ENTRADAS.NF_ENTRADA = '<<v_entradas_00.nf_entrada>>' 
			AND ENTRADAS.SERIE_NF_ENTRADA = '<<v_entradas_00.serie_nf_entrada>>' 
			AND ENTRADAS.NOME_CLIFOR = '<<v_entradas_00.nome_clifor>>'
		
		ENDTEXT
		
		f_select(CurSelPgto,"xSelPgto",ALIAS())
		
		
		If thisformset.p_tool_status="P" and xSelPgto.NF_PAGA = 0  
			if messagebox("Deseja Inserir Desconto Financeiro?",4+32+256,"Atenção!")=6	
				o_005104.LX_FORM1.Lx_PageFrame1.Page6.Lx_grid_filha1.Col_tx_perda.Enabled = .T.
				*O_TOOLBAR.Botao_salva.Enabled= .T.
				thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.tx_anm_rateio_producao.Enabled = .T.
				thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.tx_anm_rateio_producao.Setfocus()
				
			endif	
		Else
			if xSelPgto.NF_PAGA = 1
				messagebox("Nota Fiscal já esta Paga. Impossível Inserir o desconto !!",0+48) 
			endif
		Endif

	ENDPROC  


ENDDEFINE
*
*-- EndDefine: lb_anm_rateio_producao 
**************************************************


**************************************************
*-- Class:        tx_anm_rateio_producao (c:\work\desenv\filtros_data\tx_valor_itens.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
DEFINE CLASS tx_anm_rateio_producao AS lx_textbox_base 


	ControlSource = "V_ENTRADAS_00.ANM_RATEIO_PRODUCAO"
	Height = 19
	Left = 197
	TabIndex = 4
	Top = 281
	Width = 117
	p_tipo_dado = "edita"
	Name = "tx_anm_rateio_producao"
	Visible = .T.
	Enabled = .T.	
	ForeColor = RGB(255,0,0)
	BorderColor = RGB(128,128,128)	
	SpecialEffect = 1 	
	BackStyle = 0 
	BorderStyle = 0 	
	INPUTMASK = "999 999 999.99"
	FontBold = .T.
	Readonly = .F.


	PROCEDURE Valid	
	
		IF THISFORMSET.P_TOOL_STATUS="P"
		
			if messagebox("Deseja Realmente Inserir Desconto Rateio para esta Nota ?",4+32+256,"Atenção!")=6
			
				xnf_entrada=v_entradas_00.nf_entrada
				xserie_nf_entrada=v_entradas_00.serie_nf_entrada
				xnome_clifor=v_entradas_00.nome_clifor
				xfilial=v_entradas_00.filial
				xfilial_estoque=v_entradas_00.filial_estoque	


				text to	xinsert1 noshow textmerge	
					UPDATE ENTRADAS SET ANM_RATEIO_PRODUCAO='<<v_entradas_00.ANM_RATEIO_PRODUCAO>>'
					WHERE NF_ENTRADA='<<XNF_ENTRADA>>' 
					and SERIE_NF_ENTRADA='<<XSERIE_NF_ENTRADA>>'  
					and NOME_CLIFOR='<<XNOME_CLIFOR>>'
				endtext			

				if !f_insert(xinsert1) 
					messagebox("Não foi possível Inserir Desconto Rateio na Entrada ",48,"Atenção_10!")
					retu .f.
				endif
				
				o_toolbar.Botao_refresh.Click()
							
			endif
		
			
		ENDIF	
		
	ENDPROC


	PROCEDURE DblClick	
	
		*If thisformset.p_tool_status="P"     
			if messagebox("Deseja Alterar o Status da Entrada?",4+32+256,"Atenção!")=6	
				thisformset.lx_form1.lx_pageframe1.page1.pageframe1.page2.tx_anm_rateio_producao.Enabled=.t. 
			endif	
		*Endif

	ENDPROC 



ENDDEFINE
*
*-- EndDefine: tx_anm_rateio_producao
**************************************************


**************************************************
*-- Class:        tx_valor_producao (c:\work\desenv\filtros_data\tx_valor_producao.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
DEFINE CLASS tx_valor_producao AS lx_textbox_base 


	ControlSource = "xvalor_producao"
	Height = 19
	Left = 88
	TabIndex = 4
	Top = 254
	Width = 102
	p_tipo_dado = "mostra"
	Name = "tx_valor_producao"
	Visible = .T.
	Enabled = .F.	
	ForeColor = RGB(255,0,0)
	BackStyle = 0 
	BorderStyle = 0 	
	BorderColor = RGB(128,128,128) 
	SpecialEffect = 1 
	INPUTMASK = "999 999 999.99"
	FontBold = .T.


ENDDEFINE
*
*-- EndDefine: tx_valor_producao
**************************************************



**************************************************
*-- Class:        tx_anm_frete_adicional (c:\work\desenv\filtros_data\tx_valor_itens.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
DEFINE CLASS tx_anm_frete_adicional AS lx_textbox_base 


	ControlSource = "V_ENTRADAS_00.ANM_FRETE_ADICIONAL"
	Height = 19
	Left = 8
	TabIndex = 4
	Top = 143
	Width = 117
	p_tipo_dado = "edita"
	Name = "tx_anm_frete_adicional"
	Visible = .T.
	Enabled = .T.	
	INPUTMASK = "999 999 999.99"
	FontBold = .T.
	Readonly = .F.



ENDDEFINE
*
*-- EndDefine: tx_anm_frete_adicional
**************************************************


**************************************************
*-- Class:        lb_anm_frete_adicional (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_anm_frete_adicional AS lx_label


	Caption = "Frete Add"
	Height = 15
	Left = 8
	Top = 127
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_anm_frete_adicional"
	Visible = .t.
	Anchor = 0
	FontBold = .T.


ENDDEFINE
*
*-- EndDefine: lb_anm_frete_adicional 
**************************************************






**************************************************
*-- Class:        btAlteraRateio
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS btAlteraRateio AS commandbutton

	Height = 13
	Left = 197
	Top = 296
	Width = 117
	Caption = "Altera Rateio"
	Name = "btAlteraRateio"
	Visible=.t.
	Enabled = .t.
	FontBold=.t.
	Fontsize=6
	tooltiptext="Altera Rateio"
	wordwrap = .T.

	PROCEDURE Click	
	
		*If thisformset.p_tool_status="P"     
			if messagebox("Deseja Alterar o Status da Entrada?",4+32+256,"Atenção!")=6	
				thisformset.lx_form1.lx_pageframe1.page1.pageframe1.page2.tx_anm_rateio_producao.Enabled=.t. 
			endif	
		*Endif

	ENDPROC 


ENDDEFINE
*
*-- EndDefine: btAlteraRateio
**************************************************



**************************************************
*-- Class:        lb_status_entrada (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_Pedido_Gerado AS lx_label


	Caption = ""
	Top = 8
	Left = 570
	Height = 24
	Width = 145
	FontBold=.T.
	AutoSize= .F.
	Name = "lb_Pedido_Gerado"
	Visible = .f.


ENDDEFINE
*
*-- EndDefine: lb_status_entrada 
**************************************************



**************************************************
*-- Class:        cmb_status_entrada (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_filial_pedido AS lx_combobox


	RowSource = ""
	ControlSource = ""
	Height = 22
	Left = 418
	TabIndex = 1
	Top = 3
	Width = 147
	ZOrderSet = 5
	Name = "cmb_filial_pedido"
	Visible = .t.
	Enabled = .t.
	Anchor = 0
	
	PROCEDURE Valid	
	
		IF !EMPTY(this.Value) AND THISFORMSET.P_TOOL_STATUS<>"L"
			thisformset.lx_form1.lx_PAGEFRAME1.page6.bt_gera_pedido.Enabled= .t.	
		ENDIF
	ENDPROC 

ENDDEFINE
*
*-- EndDefine: cmb_status_entrada
**************************************************


**************************************************
*-- Class:        bt_saida_avulsa (c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/08/10 01:37:14 PM
*
DEFINE CLASS bt_gera_pedido AS botao


	Top = 2
	Left = 567
	Height = 24
	Width = 140
	FontBold = .T.
	Caption = "Gera Pedido Armazem"
	TabIndex = 40
	Name = "bt_gera_pedido"
	Visible = .t.
	Enabled =.F.


	PROCEDURE Click
	

				if messagebox("Deseja Gerar Pedido Para Armazem?",4+32+256,"Atenção!")=6	
						
						thisformset.lx_FORM1.lx_pageframe1.page6.lb_Pedido_Gerado.Caption = ""
						xFilDest = thisformset.lx_form1.lx_PAGEFRAME1.page6.cmb_filial_pedido.value
					    if !f_update("EXECUTE LX_ANM_GERA_PEDIDO_OL ?v_entradas_00.nome_clifor,?v_entradas_00.nf_entrada,?v_entradas_00.serie_nf_entrada,?xFilDest")
							RETURN .f.
						endif

					
						f_select("SELECT REQ_MATERIAL FROM ESTOQUE_SAI_MAT WHERE CONVERT(VARCHAR(400),OBS)='SAIDA - NF:'+RTRIM(?v_entradas_00.nf_entrada)+', FORNECEDOR:'+RTRIM(?v_entradas_00.nome_clifor)+', SERIE_NF:'+RTRIM(?v_entradas_00.serie_nf_entrada)","xRetornaPedido" )
						f_update("update entradas set anm_status_entrada = 'Pedido Gerado: '+?xRetornaPedido.REQ_MATERIAL where nf_entrada = ?v_entradas_00.nf_entrada and nome_clifor = ?v_entradas_00.nome_clifor and serie_nf_entrada = ?v_entradas_00.serie_nf_entrada")
						
						
						f_select("SELECT FILIAL_DESTINO FROM ESTOQUE_SAI_MAT WHERE REQ_MATERIAL = ?xRetornaPedido.REQ_MATERIAL","xFilDest")					
						MESSAGEBOX("Pedido Gerado com Sucesso. Pedido a ser faturado: "+xRetornaPedido.REQ_MATERIAL,0+64)
						
						REPLACE V_ENTRADAS_00.ANM_STATUS_ENTRADA WITH "Pedido Gerado: "+xRetornaPedido.REQ_MATERIAL	
						thisformset.lx_FORM1.lx_pageframe1.page6.lb_Pedido_Gerado.Left=570
						thisformset.lx_FORM1.lx_pageframe1.page6.lb_Pedido_Gerado.Caption = V_ENTRADAS_00.ANM_STATUS_ENTRADA
						thisformset.lx_form1.lx_PAGEFRAME1.page6.lb_Pedido_Gerado.visible = .t.
						*thisformset.lx_form1.lx_PAGEFRAME1.page6.cmb_filial_pedido.value = xFilDest.FILIAL_DESTINO 
						thisformset.lx_form1.lx_PAGEFRAME1.page6.cmb_filial_pedido.enabled = .f.
						thisformset.lx_form1.lx_PAGEFRAME1.page6.bt_gera_pedido.visible = .f.		

									
				endif
	
	
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_saida_avulsa 
**************************************************






&&ismara - 27/09/2013 - criar o botão para imprimir etiquetas de MP
**************************************************
*-- Class:        imprime_etq_mp
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*
DEFINE CLASS imprime_etq_mp AS commandbutton


	Top = 0
	Left = 553
	Height = 22
	Width = 150
	Caption = "Etiqueta MP"
	Name = "imprime_etq_mp"
	visible=.t.
	enabled=.t.



	PROCEDURE Click


				SELECT v_entradas_00
				&&REPORT FORM wdir+'LINX\REPORT\USER\u005104ar etiqueta de materiais.frx' NOCONSOLE TO PRINTER 
				&& ismara - mandar para arquivo e depois pelo .bat enviar para a impressora
				REPORT FORM wdir+'LINX\REPORT\USER\u005104ar etiqueta de materiais.frx' NOCONSOLE TO FILE L:\etiqmp.txt ASCII
				
				SELECT v_entradas_00
				GO TOP
				
		WAIT WINDOW 'Etiquetas Impressas...' nowait 
	ENDPROC


ENDDEFINE
*
*-- EndDefine: imprime_etq_mp
**************************************************

* Tiago Carvalho - SS - Impressão de Etiquetas de codigo de barras.
DEFINE CLASS bt_etiqueta_peca AS commandbutton
	Height = 25
	Width = 85
	FontBold = .F.
	FontName = "Arial"
	FontSize = 8
    Caption = "Etiqueta"
	Name = "bt_etiqueta_peca"
	autosize = .T.
	visible = .T.
	enabled = .T.
	
	PROCEDURE Click
		IF !(thisformset.p_tool_status =="P")
			MESSAGEBOX("Etiqueta disponível somente em modo pesquisa!",0+64,"Obj-Etiqueta Somente Pesquisa")
			RETURN .t.
		else
			* Tiago Carvalho - SS - Impressão de Etiquetas de codigo de barras.
			lcSQl = "SELECT	A.DESC_MATERIAL, "+;
					"		A.DESC_COMPOSICAO, "+;
					"		A.UNID_ESTOQUE, "+;
					"		A.LARGURA, "+;
					"		B.DESC_COR_MATERIAL, "+;
					"		A.FABRICANTE,  "+;
					"		A.COLECAO  "+;
					"	FROM MATERIAIS A (NOLOCK)  "+;
					"	INNER JOIN MATERIAIS_CORES B (NOLOCK) "+;
					"		ON A.MATERIAL = B.MATERIAL     "+;
					"	WHERE A.MATERIAL = ?v_entradas_00_ret_peca.material "+;
					"		and B.cor_material = ?v_entradas_00_ret_peca.cor_material "

			f_select(lcSql,"CurTempMat")
			
			* 22/01/2014 - Síntese Soluções - Tiago Carvalho - Alterado para o padrão Sintese Etiquetas
			strPeca 			= ALLTRIM(v_entradas_00_ret_peca.PECA)
			strQtde 			= ALLTRIM(str(v_entradas_00_ret_peca.QTDE - v_entradas_00_ret_peca.perda, 7,3))
			strUnidEstoque 		= ALLTRIM(CurTempMat.unid_estoque)
			strLargura 			= ALLTRIM(str(v_entradas_00_ret_peca.LARGURA,6,2))
			strPartida			= ALLTRIM(v_entradas_00_ret_peca.PARTIDA)
			strLocalizacao 		= ALLTRIM(v_entradas_00_ret_peca.localizacao)
			strFabricante 		= ALLTRIM(CurTempMat.fabricante)
			strMaterial 		= ALLTRIM(v_entradas_00_ret_peca.material)
			strDescMaterial 	= ALLTRIM(CurTempMat.DESC_MATERIAL)
			strDescComposicao 	= ALLTRIM(CurTempMat.Desc_Composicao)
			strCor 				= ALLT(V_ENTRADAS_00_RET_PECA.COR_MATERIAL)
			strDescCor 			= ALLTRIM(CurTempMat.desc_cor_material)
			strNFEntrada		= ALLTRIM(V_ENTRADAS_00.NF_ENTRADA)
			strFornecedor		= ALLTRIM(V_ENTRADAS_00.NOME_CLIFOR)
			strColecao			= ALLTRIM(CurTempMat.COLECAO)
			strPecaTemp			= ""
			strSaida			= ""	

			USE IN CurTempMat

			nAntArea = select()

			wait wind 'IMPRIMINDO ETIQUETAS...' nowait

			strProc = SET("Procedure")

			Set procedure To \Linx\Report\User\Proc_SS_Etiquetas.prg Additive

			IF !DIRECTORY('C:\SINTESE\ETIQUETA')
				MD('C:\SINTESE\ETIQUETA')
			ENDIF

			IF FILE ('C:\SINTESE\ETIQUETA\PECAMP.ETQ')
				DELETE FILE 'C:\SINTESE\ETIQUETA\PECAMP.ETQ'
			ENDIF

			intArq = fCreate('C:\SINTESE\ETIQUETA\PECAMP.ETQ', 0)
			if (intArq >= 0)
				fwrite(intArq, Proc_Etiqueta_Peca(strPeca, strQtde, strUnidEstoque, strLargura, strPartida, strLocalizacao, strFabricante, strMaterial, strDescMaterial, strDescComposicao, strCor, strDescCor,strNFEntrada,strFornecedor,strColecao,strPecaTemp,strSaida))
				fClose(intArq)
				!COPY C:\SINTESE\ETIQUETA\PECAMP.ETQ LPT1
			Endif

			SELECT (nAntArea)

			SET PROCEDURE TO &strProc

			wait wind 'IMPRESSÃO CONCLUIDA.' nowait
		endif
	ENDPROC
enddefine


**************************************************
*-- Class:        btn_etiqueta (c:\linx desenv\classes lucas\btn_etiqueta.vcx)
*-- ParentClass:  botao (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/06/14 05:29:10 PM
*
DEFINE CLASS btn_etiqueta AS botao


	Top = 11
	Left = 562
	Height = 22
	Width = 114
	FontBold = .T.
	Caption = "Imprimir Etiqueta"
	ForeColor = RGB(0,0,0)
	Name = "btn_etiqueta"
	visible = .T.


	PROCEDURE Click
		SELE V_ENTRADAS_00_RET_PECA
		GO TOP
		 
		SCAN

			thisformset.lx_FORM1.lx_pageframe1.page7.Lx_grid_filha1.COL_ETIQUETA_PECA.Bt_etiqueta_peca.Click()

			SELE V_ENTRADAS_00_RET_PECA

		ENDSCAN
	ENDPROC


ENDDEFINE
*
*-- EndDefine: btn_etiqueta
**************************************************

**************************************************
*-- Class:        lx_entrada_revisao (c:\linx desenv\classes lucas\lx_entrada_revisao.vcx)
*-- ParentClass:  lx_checkbox (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   02/20/15 04:41:06 PM
*
DEFINE CLASS lx_entrada_revisao AS lx_checkbox


	Top = 129
	Left = 448
	Height = 15
	Width = 199
	Alignment = 0
	Caption = "Entrada Para Revisão MP Rbx Fábrica"
	Name = "lx_entrada_revisao"
	Visible = .t.

ENDDEFINE
*
*-- EndDefine: lx_entrada_revisao
**************************************************
