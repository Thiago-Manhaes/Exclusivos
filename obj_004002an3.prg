* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                                        *
* OBJETIVO.:                                                                                                        *
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
		 
		*** Projeto Entrega Direta - Solicitante: Guilherme Kaercher - Desenvolvedor: Lucas Miranda *** GS_ProjEntregaDireta #1
		
		do CASE 
		
			CASE UPPER(xmetodo)=='USR_INIT' 
			
			
				**Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_programa_00  
				sele v_compras_01   
				xalias_pai=alias()

  				oCur = getcursoradapter(xalias_pai)
				oCur.addbufferfield("COLECAO", "C(25)",.T., "COLECAO", "COMPRAS.COLECAO")
				oCur.addbufferfield("MES_ENTRADA_LOJA","C(25)",.T., "MES_ENTRADA_LOJA", "COMPRAS.MES_ENTRADA_LOJA")		
				*** FABIANO - LUCAS MIRANDA - 01/04/2016
				oCur.addbufferfield("COMPRAS.ANM_STATUS_ALMOX", "C(25)",.T., "ANM_STATUS_ALMOX", "COMPRAS.ANM_STATUS_ALMOX")
				oCur.addbufferfield("COMPRAS.ANM_DATA_INICIO_SEPARACAO", "D",.T., "ANM_DATA_INICIO_SEPARACAO", "COMPRAS.ANM_DATA_INICIO_SEPARACAO")		
				*** FIM - FABIANO - LUCAS MIRANDA - 01/04/2016		
				*** Inclusão do campo Condição de Pagamento Original - Lucas Miranda - 20/09/2017
				oCur.addbufferfield("COMPRAS.GS_CONDICAO_PGTO_ORI", "C(3)",.T., "Condição Pgto Original", "COMPRAS.GS_CONDICAO_PGTO_ORI")
				*** Fim - Inclusão do campo Condição de Pagamento Original - Lucas Miranda - 20/09/2017
				
				*** GS_ProjEntregaDireta #1
				oCur.addbufferfield("COMPRAS.GS_ENTREGA_DIRETA", "L",.T., "Entrega Direta", "COMPRAS.GS_ENTREGA_DIRETA")
				oCur.addbufferfield("COMPRAS.GS_ESTOQUE_TERCEIRO", "L",.T., "Estoque Terceiro", "COMPRAS.GS_ESTOQUE_TERCEIRO")
				oCur.addbufferfield("COMPRAS.GS_LOTE", "N(10)",.T., "Lote", "COMPRAS.GS_LOTE")
				oCur.confirmstructurechanges() 	
				*** GS_ProjEntregaDireta #1
				
				** Custo
				Sele v_compras_01_materiais
				xalias_pai=alias()
				oCur = getcursoradapter(xalias_pai)
				oCur.addbufferfield("0 AS MATERIAL_CUSTO_RC", "L",.T., "Material/Cor Reprovado Custo", "0 AS MATERIAL_CUSTO_RC")
				oCur.confirmstructurechanges() 	
				**
				
				**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 
				
				public xOldStatusAlmox,xstatus_entrada,xordem_servico,curSepara,xSaveAfter,xVerEstEstamparia
				
				xVerEstEstamparia = 0
				xSaveAfter = ''
				
				f_select("select convert(varchar(25),valor_propriedade) as anm_status_almox from propriedade_valida where propriedade='00057'","xstatus_entrada")
				
				f_select("select distinct filial from filiais where CTRL_PRODUCAO_MATERIAL = 1","xstatus_filial_mat")
								 
				store '' to	xordem_servico

				with thisformset.lx_form1.lx_pageframe1.page8	
					.addobject("lb_status_entrada","lb_status_entrada")
					.addobject("cmb_status_entrada","cmb_status_entrada")					
					.addobject("tx_data_ini_separacao","tx_data_ini_separacao")					
					.addobject("lb_data_ini_separacao","lb_data_ini_separacao")	
				endwith

				
				with thisformset.lx_form1.lx_pageframe1
					.page8.cmb_status_entrada.RowSource="xstatus_entrada"
					.page8.cmb_status_entrada.ControlSource="v_compras_01.ANM_STATUS_ALMOX" 
					.page8.tx_data_ini_separacao.ControlSource="v_compras_01.ANM_DATA_INICIO_SEPARACAO" 
				endwith	
				*** FIM - FABIANO - LUCAS MIRANDA - 01/04/2016	
				TEXT TO xMes NOSHOW textmerge
					
					SELECT VALOR_PROPRIEDADE,
					CASE WHEN C.VALOR_ATUAL LIKE '%'+RTRIM(LTRIM(A.VALOR_PROPRIEDADE))+'%'
						 THEN D.VALOR_ATUAL ELSE B.VALOR_ATUAL END AS PERCENTUAL_ACEITAVEL
					FROM PROPRIEDADE_VALIDA A
						LEFT JOIN PARAMETROS B ON B.PARAMETRO = 'TOLERANCIA_PORCENTAGEM_MA'
						LEFT JOIN PARAMETROS C ON C.PARAMETRO = 'ANM_MES_ENT_TIPO_PERC'
						LEFT JOIN PARAMETROS D ON D.PARAMETRO = 'ANM_MES_ENT_PERC_ACEIT'
						
					WHERE PROPRIEDADE = '00202' ORDER BY DATA_ATIVACAO
					
					--SELECT VALOR_PROPRIEDADE FROM PROPRIEDADE_VALIDA
					--WHERE PROPRIEDADE = '00202' ORDER BY DATA_ATIVACAO

					--DECLARE @VALOR_ATUAL	VARCHAR(200)	= (SELECT MES FROM WANM_MES_ENTRADA_LOJAS_COMPRAS)
					--SELECT * FROM FXANM_ConsultaVarString(@VALOR_ATUAL)

				ENDTEXT
				f_select(xMes, 'curMes')
				SELE curMes		
					
			
				
			  f_select ('select DESC_COLECAO  from colecoes','curColecao',ALIAS())
			  SELECT curColecao 
			  APPEND BLANK  
				
              WITH thisformset.lx_form1.lx_PAGEFRAME1.page1
					.addObject("bt_exporta_materiais","bt_exporta_materiais")
					.addObject("cmbColecao","cmbColecao")
					.addObject("lblColecao","lblColecao")		
					.addObject("cmbMesEntrada","cmbMesEntrada")
					.addObject("lblMesEntrada","lblMesEntrada")
					*** GS_ProjEntregaDireta #1
					.addObject("gs_check_entrega_direta","gs_check_entrega_direta")
					.addObject("gs_check_estoque_terceiro","gs_check_estoque_terceiro")
					.gs_check_entrega_direta.enabled = Thisformset.pp_gs_liga_entr_dire_e_cons
					.gs_check_estoque_terceiro.enabled = Thisformset.pp_gs_liga_entr_dire_e_cons
					.addObject("tx_gs_lote","tx_gs_lote")
					.addObject("lb_gs_lote","lb_gs_lote")
					*** Fim - GS_ProjEntregaDireta #1
					.addobject("btn_cond_pgto_ori","btn_cond_pgto_ori")
					.addobject("cnt_gs_cond_pgto_ori","cnt_gs_cond_pgto_ori")
					.cnt_gs_cond_pgto_ori.BackColor= RGB(255,255,255)
					.cnt_gs_cond_pgto_ori.addObject("lx_lbl_gs_cond_ori","lx_lbl_gs_cond_ori")
					.cnt_gs_cond_pgto_ori.addObject("lx_txt_gs_cond_pgto_ori","lx_txt_gs_cond_pgto_ori")
					.cnt_gs_cond_pgto_ori.addObject("lx_tv_gs_cond_pgto_ori","lx_tv_gs_cond_pgto_ori")
              ENDWITH
			 
			 *Reprova Custo
		 	  WITH ThisFormSet.lX_FORM1.lx_PAGEFRAME1.page2.lX_GRID_FILHA1
					lcColumnCount = .ColumnCount
					lcColumnCount = lcColumnCount + 1
					.AddColumn(lcColumnCount )
					.Columns[lcColumnCount].Name = 'col_material_rc'
						.col_material_rc.Width = 100
						*.col_periodo_cor.BackColor = 15399423
						.col_material_rc.ColumnOrder = 1
						.col_material_rc.header1.Caption = 'Material/Cor R.C.'
						.col_material_rc.header1.Alignment = 2
						.col_material_rc.header1.FontName='Tahoma'
						.col_material_rc.header1.FontSize=8
						.col_material_rc.RemoveObject('text1')
						.col_material_rc.Enabled = .T.
						.col_material_rc.Sparse = .F.
						.col_material_rc.AddObject('ck_gs_material_rc','ck_gs_material_rc')
						.col_material_rc.ControlSource = "V_Compras_01_materiais.material_custo_rc"
						.col_material_rc.Refresh()
			  ENDWITH
				
				thisformset.lx_form1.lx_pageframe1.page8.Lx_porc_dif_maior.visible = .f.
				thisformset.lx_form1.lx_pageframe1.page8.Lx_label2.visible = .f.
				
				
				*Lucas Miranda - 24/02/2017
				*A aba devolução trava ao clicar como nunca é usado foi desabilitado.
				thisformset.lx_form1.lx_pageframe1.page12.Enabled =.F.
			 
			 
			 ** Botão Consumo Estoque Terceiro
			 ** Lucas Miranda - 04/09/2017
			 	With thisformset.lx_form1.lx_pageframe1.page8
					.AddObject("btn_gs_consumo_terceiro","btn_gs_consumo_terceiro")
				Endwith
			 ** Fim Botão Consumo Estoque Terceiro
			 
			  THISFORMSET.L_LIMPA()		
			  
			CASE UPPER(xmetodo)=='USR_VALID' 
				
				xalias=alias()
				*--Lucas Miranda - Bloqueio Forma de pagamento do fornecedor - 07/11/2017
						           				
					If upper(xnome_obj) = 'CMB_STATUS_COMPRA' AND Thisformset.p_tool_status $ 'IA' 
						f_select("SELECT * FROM PROP_FORNECEDORES WHERE PROPRIEDADE = '00474' and fornecedor=?v_compras_01.fornecedor","CurPropValCusto")
						sele CurPropValCusto
		           		If !F_Vazio(CurPropValCusto.valor_propriedade) AND CurPropValCusto.valor_propriedade = 'SIM'
		           			if used("CurPropValCusto") 
								use in CurPropValCusto
							endif
							
							F_Select("Select * From Compras Where tabela_filha='COMPRAS_MATERIAL' and Pedido=?V_Compras_01.pedido and Status_Compra='RC'","CurStatusRC")
							If !F_Vazio(CurStatusRC.pedido) AND (CurStatusRC.Status_Compra <> V_Compras_01.status_compra) 
								If thisformset.pp_gs_permite_alt_status_rc = .F.  AND !(ALLTRIM(v_compras_01.tipo_compra) $ Thisformset.pp_gs_valida_tipo_compra_rc) 
									Sele V_Compras_01
									Replace V_Compras_01.status_compra    with CurStatusRC.status_compra
									Replace V_Compras_01.status_aprovacao with CurStatusRC.status_aprovacao 
	 								thisformset.lx_form1.lx_pageframe1.page1.lx_aprovado.Value=IIF(V_Compras_01.status_aprovacao='E','EM ESTUDO',IIF(V_Compras_01.status_aprovacao='A','APROVADO',IIF(V_Compras_01.status_aprovacao='R','REPROVADO',IIF(V_Compras_01.status_aprovacao='P','PENDENTE DE APROVAÇÃO',''))))
									*thisformset.lx_form1.lx_pageframe1.page1.cmb_status_compra.L_Desenhista_recalculo()
									MESSAGEBOX("Você não tem permissão para alterar o"+CHR(13)+ "Status se estiver como Reprovado - Custo",0+16)
								Endif
								
								if used("CurStatusRC") 
									use in CurStatusRC
								endif
							Endif	 
						Endif
					Endif	
					
					If upper(xnome_obj) = 'TV_COR_MATERIAL'
						If thisformset.pp_custo_fornecedor = .t.
							if used("xMatCorFornc") 
								use in xMatCorFornc
							endif
							
							if used("xMatCorTab") 
								use in xMatCorTab
							endif
							
							if used("CurCustoNeg") 
								use in CurCustoNeg
							endif
							
							TEXT TO xCustoNeg NOSHOW TEXTMERGE
								select isnull(b.fornecedor,e.fornecedor) as fornecedor, a.material, a.cor_material, isnull(e.custo_neg,isnull(b.custo_reposicao,a.custo_a_vista)) as custo_a_vista 
								from materiais_cores a
								left join (SELECT * FROM materiais_fornecedor WHERE FORNECEDOR = '<<V_COMPRAS_01.FORNECEDOR>>')b
								on a.material = b.material 
								and a.cor_material = b.cor_material
								LEFT JOIN ( SELECT FORNECEDOR, MATERIAL, COR_MATERIAL, ISNULL(CUSTO_NEGOCIADO,0) AS CUSTO_NEG 
												FROM GS_CUSTO_NEGOCIADO_MATERIAL (NOLOCK) 
													WHERE STATUS_CUSTO = 'APROVADO' AND ISNULL(CUSTO_NEGOCIADO,0) > 0
													AND FORNECEDOR = '<<V_COMPRAS_01.FORNECEDOR>>') E
								ON A.MATERIAL = E.MATERIAL
								AND A.COR_MATERIAL = E.COR_MATERIAL
								where a.MATERIAL = '<<V_Compras_01_Materiais.material>>'
								and a.COR_MATERIAL = '<<V_Compras_01_Materiais.cor_material>>'
							ENDTEXT						
							f_select(xCustoNeg,"CurCustoNeg")
							Sele V_Compras_01_materiais
							Replace V_Compras_01_materiais.custo with CurCustoNeg.custo_a_vista 
							
*!*								F_select("Select * From Materiais_fornecedor where material=?V_Compras_01_materiais.material and cor_material=?V_Compras_01_materiais.cor_material and Fornecedor=?v_compras_01.fornecedor","xMatCorFornc") 	
*!*								If F_Vazio(xMatCorFornc.Material)
*!*									F_select("Select * From Materiais_Cores where material=?V_Compras_01_materiais.material and cor_material=?V_Compras_01_materiais.cor_material","xMatCorTab") 	
*!*									Sele V_Compras_01_materiais
*!*									Replace V_Compras_01_materiais.custo with xMatCorTab.custo_reposicao 
*!*								Endif
							
						Endif
					Endif
				*Fim Reprova Custo
					If upper(xnome_obj) = 'TV_FORNECEDOR'
						**** Condição Pgto Original - Lucas Miranda - 20/09/2017
						
						If Thisformset.p_tool_status = 'I' OR Thisformset.p_tool_status = 'A'
						 	If !(ALLTRIM(v_compras_01.tipo_compra) $ Thisformset.pp_gs_valida_tipo_compra_rc) and !f_vazio(v_compras_01.tipo_compra)
								f_select("select * from prop_fornecedores (nolock) where propriedade='00510' and fornecedor=?v_compras_01.fornecedor","CurPropFornInter",ALIAS())
								f_select("select * from prop_fornecedores (nolock) where propriedade='00509' and fornecedor=?v_compras_01.fornecedor","CurPropValidCond",ALIAS())
								IF !f_vazio(CurPropFornInter.propriedade) and !f_vazio(CurPropValidCond.propriedade)
									If ALLTRIM(CurPropFornInter.valor_propriedade) == 'NAO' AND ALLTRIM(CurPropValidCond.valor_propriedade) == 'SIM'
										Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.visible=.t.
										
										Text TO xSelCondPgto TextMerge Noshow
								
											select B.CONDICAO_PGTO,B.DESC_COND_PGTO,B.TIPO_CONDICAO 
											from FORNECEDORES (nolock) A 
												JOIN COND_ENT_PGTOS (nolock) B
												ON A.CONDICAO_PGTO = B.CONDICAO_PGTO 
											where FORNECEDOR = '<<V_COMPRAS_01.FORNECEDOR>>'
										Endtext	
										f_select(xSelCondPgto,"xCondFornec")
											
										With Thisformset.lx_FORM1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori
											.lx_tv_gs_cond_pgto_ori.Value 	= xCondFornec.CONDICAO_PGTO
											.lx_txt_gs_cond_pgto_ori.Value	= xCondFornec.DESC_COND_PGTO
										EndWith	
									Else	
										Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.visible=.F.

											*if !f_vazio(Thisformset.lx_FORM1.lx_pageframe1.page1.tv_condicao_pgto.Value)
												
												Text TO xSelCondPgto TextMerge Noshow
													
													select B.CONDICAO_PGTO,B.DESC_COND_PGTO,B.TIPO_CONDICAO 
													from FORNECEDORES (nolock) A 
														JOIN COND_ENT_PGTOS (nolock) B
														ON A.CONDICAO_PGTO = B.CONDICAO_PGTO 
													where FORNECEDOR = '<<V_COMPRAS_01.FORNECEDOR>>'
												Endtext	
												f_select(xSelCondPgto,"xCondFornec")
													
												With Thisformset.lx_FORM1.lx_pageframe1.page1
													.tv_condicao_pgto.Value 		= xCondFornec.CONDICAO_PGTO
													.tx_desc_condicao_pgto.Value	= xCondFornec.DESC_COND_PGTO
													.tx_tipo_condicao.Value			= xCondFornec.TIPO_CONDICAO 
													.cnt_gs_cond_pgto_ori.lx_tv_gs_cond_pgto_ori.Value 	= xCondFornec.CONDICAO_PGTO
													.cnt_gs_cond_pgto_ori.lx_txt_gs_cond_pgto_ori.Value	= xCondFornec.DESC_COND_PGTO
												EndWith	
												
												Thisformset.lx_FORM1.lx_pageframe1.page1.tv_condicao_pgto.l_desenhista_recalculo()
												Thisformset.lx_FORM1.Tv_FORNECEDOR.l_desenhista_recalculo() 
											*endif
						
									Endif
								ENDIF
								
								If USED("CurPropFornInter")
									USE IN CurPropFornInter
								ENDIF
								
								If USED("CurPropValidCond")
									USE IN CurPropValidCond
								Endif
							Else
								if !f_vazio(Thisformset.lx_FORM1.lx_pageframe1.page1.tv_condicao_pgto.Value)
							
									Text TO xSelCondPgto TextMerge Noshow
										
										select B.CONDICAO_PGTO,B.DESC_COND_PGTO,B.TIPO_CONDICAO 
										from FORNECEDORES A 
											JOIN COND_ENT_PGTOS B
											ON A.CONDICAO_PGTO = B.CONDICAO_PGTO 
										where FORNECEDOR = '<<V_COMPRAS_01.FORNECEDOR>>'
									Endtext	
									f_select(xSelCondPgto,"xCondFornec")
										
									With Thisformset.lx_FORM1.lx_pageframe1.page1
										.tv_condicao_pgto.Value 		= xCondFornec.CONDICAO_PGTO
										.tx_desc_condicao_pgto.Value	= xCondFornec.DESC_COND_PGTO
										.tx_tipo_condicao.Value			= xCondFornec.TIPO_CONDICAO 
									EndWith	
									
									Thisformset.lx_FORM1.lx_pageframe1.page1.tv_condicao_pgto.l_desenhista_recalculo()
									Thisformset.lx_FORM1.Tv_FORNECEDOR.l_desenhista_recalculo() 
								endif
							Endif
						Else
							If Thisformset.p_tool_status $ 'L'
								Thisformset.lx_form1.lx_pageframe1.page1.tv_condicao_pgto.Enabled = .T.
								*Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.visible=.F.
							Endif	
						Endif	
					Endif	
						 
	 				If upper(xnome_obj) = 'LX_TV_GS_COND_PGTO_ORI' 
	 					If Thisformset.p_tool_status $ 'IAL'
		 					if !f_vazio(V_COMPRAS_01.GS_CONDICAO_PGTO_ORI)
									
								Text TO xSelCondPgtoOr TextMerge Noshow
									select CONDICAO_PGTO, DESC_COND_PGTO
									from COND_ENT_PGTOS (nolock)
									where CONDICAO_PGTO = '<<V_COMPRAS_01.GS_CONDICAO_PGTO_ORI>>'
								Endtext	
								f_select(xSelCondPgtoOr,"xCondPgtoOr")
									
								With Thisformset.lx_FORM1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori
									.lx_txt_gs_cond_pgto_ori.Value = xCondPgtoOr.DESC_COND_PGTO
									.lx_txt_gs_cond_pgto_ori.ToolTipText=xCondPgtoOr.DESC_COND_PGTO
								EndWith	
							endif
	 					Endif
	 				Endif
					
					If upper(xnome_obj) = 'TV_CONDICAO_PGTO'
						If Thisformset.p_tool_status = 'I' OR Thisformset.p_tool_status = 'A'
							If !(ALLTRIM(v_compras_01.tipo_compra) $ Thisformset.pp_gs_valida_tipo_compra_rc) and !f_vazio(v_compras_01.tipo_compra)
									f_select("select * from prop_fornecedores (nolock) where propriedade='00510' and fornecedor=?v_compras_01.fornecedor","CurPropFornInter",ALIAS())
									f_select("select * from prop_fornecedores (nolock) where propriedade='00509' and fornecedor=?v_compras_01.fornecedor","CurPropValidCond",ALIAS())
									IF !f_vazio(CurPropFornInter.propriedade) and !f_vazio(CurPropValidCond.propriedade)
										If !(ALLTRIM(CurPropFornInter.valor_propriedade) == 'NAO' AND ALLTRIM(CurPropValidCond.valor_propriedade) == 'SIM')											
												Text TO xSelCondPgto TextMerge Noshow
													select CONDICAO_PGTO, DESC_COND_PGTO,TIPO_CONDICAO 
													from COND_ENT_PGTOS (nolock)
													where CONDICAO_PGTO = '<<V_COMPRAS_01.CONDICAO_PGTO>>'
												Endtext	
												f_select(xSelCondPgto,"xCondFornec")
													
												With Thisformset.lx_FORM1.lx_pageframe1.page1
													.tv_condicao_pgto.Value 		= xCondFornec.CONDICAO_PGTO
													.tx_desc_condicao_pgto.Value	= xCondFornec.DESC_COND_PGTO
													.tx_tipo_condicao.Value			= xCondFornec.TIPO_CONDICAO 
													.cnt_gs_cond_pgto_ori.lx_tv_gs_cond_pgto_ori.Value 	= xCondFornec.CONDICAO_PGTO
													.cnt_gs_cond_pgto_ori.lx_txt_gs_cond_pgto_ori.Value	= xCondFornec.DESC_COND_PGTO
												EndWith	
												
												Thisformset.lx_FORM1.lx_pageframe1.page1.tv_condicao_pgto.l_desenhista_recalculo()
												Thisformset.lx_FORM1.Tv_FORNECEDOR.l_desenhista_recalculo() 
										Endif
									Endif
							Else
								Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.visible=.F.
									Text TO xSelCondPgto TextMerge Noshow
										select CONDICAO_PGTO, DESC_COND_PGTO,TIPO_CONDICAO 
										from COND_ENT_PGTOS (nolock)
										where CONDICAO_PGTO = '<<V_COMPRAS_01.CONDICAO_PGTO>>'
									Endtext	
									f_select(xSelCondPgto,"xCondFornec")
										 
									With Thisformset.lx_FORM1.lx_pageframe1.page1
										.tv_condicao_pgto.Value 		= xCondFornec.CONDICAO_PGTO
										.tx_desc_condicao_pgto.Value	= xCondFornec.DESC_COND_PGTO
										.tx_tipo_condicao.Value			= xCondFornec.TIPO_CONDICAO 
										.cnt_gs_cond_pgto_ori.lx_tv_gs_cond_pgto_ori.Value 	= xCondFornec.CONDICAO_PGTO
										.cnt_gs_cond_pgto_ori.lx_txt_gs_cond_pgto_ori.Value	= xCondFornec.DESC_COND_PGTO
									EndWith	
									
									Thisformset.lx_FORM1.lx_pageframe1.page1.tv_condicao_pgto.l_desenhista_recalculo()
									Thisformset.lx_FORM1.Tv_FORNECEDOR.l_desenhista_recalculo() 
									 
									If thisformset.pp_ANM_PGTO_FORNECEDOR_OS = .t.
							
										Sele V_Compras_01
										

										TEXT TO xParc NOSHOW TEXTMERGE
									 		select condicao_pgto, desc_cond_pgto, numero_parcelas, parcela_1 
									 		from COND_ENT_PGTOS
		 								 		where desc_cond_pgto='<<V_Compras_01.DESC_COND_PGTO>>'
										ENDTEXT
								
										f_select(xParc, 'cur_Parc')
										
										TEXT TO xPgto NOSHOW TEXTMERGE
											select F.FORNECEDOR, F.CONDICAO_PGTO, CEP.DESC_COND_PGTO, CEP.PARCELA_1
		 										from CADASTRO_CLI_FOR CCF
		 										JOIN FORNECEDORES F
		 										ON CCF.CLIFOR=F.CLIFOR
		 										JOIN COND_ENT_PGTOS CEP
		 										ON F.CONDICAO_PGTO=CEP.CONDICAO_PGTO
		 										where F.FORNECEDOR='<<V_Compras_01.FORNECEDOR>>'
										ENDTEXT
										
										f_select(xPgto, 'cur_Pgto')
										
											IF cur_Parc.parcela_1<cur_Pgto.parcela_1 
											
													IF thisformset.pp_ANM_ALTERA_COND_PGTO_OS = .f. 
													
															IF thisformset.p_tool_status = 'I'
										   												   					
										   						MESSAGEBOX("O Usuário Não Tem Permissão Para Reduzir o Prazo de Pagamento Do Fornecedor!!", 0+48)
										   					
										   							REPLACE V_COMPRAS_01.CONDICAO_PGTO WITH CUR_PGTO.CONDICAO_PGTO		
										   							REPLACE V_COMPRAS_01.DESC_COND_PGTO WITH CUR_PGTO.DESC_COND_PGTO
										   				
										   					ENDIF
										   			
										   					IF thisformset.p_tool_status = 'A'
										   				
										   						TEXT TO XSEL NOSHOW TEXTMERGE
										   				
										   							SELECT COMPRAS.CONDICAO_PGTO, COND_ENT_PGTOS.DESC_COND_PGTO
										   							FROM COMPRAS
										   							JOIN COND_ENT_PGTOS
										   							ON COMPRAS.CONDICAO_PGTO=COND_ENT_PGTOS.CONDICAO_PGTO
										   							WHERE COMPRAS.PEDIDO='<<V_COMPRAS_01.PEDIDO>>'

										   						ENDTEXT
										   				
										   						F_SELECT(XSEL, 'CUR_SEL')
										   				
										   						SELECT CUR_SEL
										   						MESSAGEBOX("O Usuário Não Tem Permissão Para Reduzir o Prazo de Pagamento Do Fornecedor!!", 0+48)
										   				
										   							REPLACE V_COMPRAS_01.CONDICAO_PGTO WITH CUR_SEL.CONDICAO_PGTO		
										   							REPLACE V_COMPRAS_01.DESC_COND_PGTO WITH CUR_SEL.DESC_COND_PGTO
										   							
										   					ENDIF
									   					
									   				 ENDIF
								   				
								   			ENDIF
				
									ENDIF
									
							Endif
						Endif
					Endif
					
					
					If upper(xnome_obj) = 'TV_TIPO_COMPRA'
						If Thisformset.p_tool_status = 'I' OR Thisformset.p_tool_status = 'A'
							If !(ALLTRIM(v_compras_01.tipo_compra) $ Thisformset.pp_gs_valida_tipo_compra_rc) and !f_vazio(v_compras_01.tipo_compra)
									f_select("select * from prop_fornecedores (nolock) where propriedade='00510' and fornecedor=?v_compras_01.fornecedor","CurPropFornInter",ALIAS())
									f_select("select * from prop_fornecedores (nolock) where propriedade='00509' and fornecedor=?v_compras_01.fornecedor","CurPropValidCond",ALIAS())
									IF !f_vazio(CurPropFornInter.propriedade) and !f_vazio(CurPropValidCond.propriedade)
										If ALLTRIM(CurPropFornInter.valor_propriedade) == 'NAO' AND ALLTRIM(CurPropValidCond.valor_propriedade) == 'SIM'
												
												Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.visible=.T.
												
												Text TO xSelCondPgto TextMerge Noshow
													select CONDICAO_PGTO, DESC_COND_PGTO,TIPO_CONDICAO 
													from COND_ENT_PGTOS (nolock)
													where CONDICAO_PGTO = '<<V_COMPRAS_01.GS_CONDICAO_PGTO_ORI>>'
												Endtext	
												f_select(xSelCondPgto,"xCondFornec")
													
												With Thisformset.lx_FORM1.lx_pageframe1.page1
													.tv_condicao_pgto.Value 		= xCondFornec.CONDICAO_PGTO
													.tx_desc_condicao_pgto.Value	= xCondFornec.DESC_COND_PGTO
													.tx_tipo_condicao.Value			= xCondFornec.TIPO_CONDICAO 
													.cnt_gs_cond_pgto_ori.lx_tv_gs_cond_pgto_ori.Value 	= xCondFornec.CONDICAO_PGTO
													.cnt_gs_cond_pgto_ori.lx_txt_gs_cond_pgto_ori.Value	= xCondFornec.DESC_COND_PGTO
												EndWith	
												
												Thisformset.lx_FORM1.lx_pageframe1.page1.tv_condicao_pgto.l_desenhista_recalculo()
												Thisformset.lx_FORM1.Tv_FORNECEDOR.l_desenhista_recalculo() 
										Endif
									Endif
							Else
								Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.visible=.F.
									Text TO xSelCondPgto TextMerge Noshow
										select CONDICAO_PGTO, DESC_COND_PGTO,TIPO_CONDICAO 
										from COND_ENT_PGTOS (nolock)
										where CONDICAO_PGTO = '<<V_COMPRAS_01.CONDICAO_PGTO>>'
									Endtext	
									f_select(xSelCondPgto,"xCondFornec")
										
									With Thisformset.lx_FORM1.lx_pageframe1.page1
										.tv_condicao_pgto.Value 		= xCondFornec.CONDICAO_PGTO
										.tx_desc_condicao_pgto.Value	= xCondFornec.DESC_COND_PGTO
										.tx_tipo_condicao.Value			= xCondFornec.TIPO_CONDICAO 
										.cnt_gs_cond_pgto_ori.lx_tv_gs_cond_pgto_ori.Value 	= xCondFornec.CONDICAO_PGTO
										.cnt_gs_cond_pgto_ori.lx_txt_gs_cond_pgto_ori.Value	= xCondFornec.DESC_COND_PGTO
									EndWith	
									
									Thisformset.lx_FORM1.lx_pageframe1.page1.tv_condicao_pgto.l_desenhista_recalculo()
									Thisformset.lx_FORM1.Tv_FORNECEDOR.l_desenhista_recalculo() 
							Endif
						Endif	
					Endif
					
					*** Fim - Condição Pagamento Original - Lucas Miranda - 20/09/2017
						
*!*							if !f_vazio(Thisformset.lx_FORM1.lx_pageframe1.page1.tv_condicao_pgto.Value)
*!*								
*!*								Text TO xSelCondPgto TextMerge Noshow
*!*									
*!*									select B.CONDICAO_PGTO,B.DESC_COND_PGTO,B.TIPO_CONDICAO 
*!*									from FORNECEDORES A 
*!*										JOIN COND_ENT_PGTOS B
*!*										ON A.CONDICAO_PGTO = B.CONDICAO_PGTO 
*!*									where FORNECEDOR = '<<V_COMPRAS_01.FORNECEDOR>>'
*!*								Endtext	
*!*								f_select(xSelCondPgto,"xCondFornec")
*!*									
*!*								With Thisformset.lx_FORM1.lx_pageframe1.page1
*!*									.tv_condicao_pgto.Value 		= xCondFornec.CONDICAO_PGTO
*!*									.tx_desc_condicao_pgto.Value	= xCondFornec.DESC_COND_PGTO
*!*									.tx_tipo_condicao.Value			= xCondFornec.TIPO_CONDICAO 
*!*								EndWith	
*!*								
*!*								Thisformset.lx_FORM1.lx_pageframe1.page1.tv_condicao_pgto.l_desenhista_recalculo()
*!*								Thisformset.lx_FORM1.Tv_FORNECEDOR.l_desenhista_recalculo() 
*!*							endif
		
					
					 
					If upper(xnome_obj) = 'CMBMESENTRADA' AND Thisformset.p_tool_status $ 'IA'
						
						SELECT V_COMPRAS_01
						REPLACE MES_ENTRADA_LOJA WITH thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbMesEntrada.value
						
						SELECT CURMES
						LOCATE FOR ALLTRIM(VALOR_PROPRIEDADE) = ALLTRIM(V_COMPRAS_01.MES_ENTRADA_LOJA)
						
						Thisformset.lx_FORM1.lx_pageframe1.page1.sp_ENTREGA_ACEITAVEL.Value = VAL(CURMES.PERCENTUAL_ACEITAVEL)
						
						*** Projeto Mes Entrada Loja - Lucas Miranda - 28/03/2017
						
						xMesColecao=IIF(v_compras_01.mes_entrada_loja='JANEIRO','1',IIF(v_compras_01.mes_entrada_loja='FEVEREIRO','2',IIF(v_compras_01.mes_entrada_loja='MARÇO','3',IIF(v_compras_01.mes_entrada_loja='ABRIL','4',IIF(v_compras_01.mes_entrada_loja='MAIO','5',IIF(v_compras_01.mes_entrada_loja='JUNHO','6',IIF(v_compras_01.mes_entrada_loja='JULHO','7',IIF(v_compras_01.mes_entrada_loja='AGOSTO','8',IIF(v_compras_01.mes_entrada_loja='SETEMBRO','9',IIF(v_compras_01.mes_entrada_loja='OUTUBRO','10',IIF(v_compras_01.mes_entrada_loja='NOVEMBRO','11',IIF(v_compras_01.mes_entrada_loja='DEZEMBRO','12',v_compras_01.mes_entrada_loja))))))))))))
						If !f_vazio(v_compras_01.mes_entrada_loja) 
						Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.RowSource=''
							If val(xMesColecao) >= 1 and val(xMesColecao) <= 6				
								TEXT TO xcurColecao NOSHOW textmerge
									select desc_colecao
									from colecoes where temporada IN (7,4,6) and inativo = 0
								Endtext
								F_select(xCurColecao,"curColecao")
								SELECT curColecao
								APPEND BLANK  
								Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.Enabled = .T.
								Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.RowSource='curColecao'
								release xMesColecao
								Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.SetFocus()
								
									If Thisformset.p_tool_status ="I"
										TEXT TO xCol TEXTMERGE NOSHOW
											SELECT COLECAO, DESC_COLECAO FROM COLECOES WHERE COLECAO = ?o_004002.pp_colecao_padrao
										ENDTEXT 

										f_select(xCol,"Cur_Colpadrao")
										sele Cur_Colpadrao
										REPLACE V_COMPRAS_01.COLECAO WITH Cur_Colpadrao.DESC_COLECAO
										thisformset.lx_form1.lx_pageframe1.page1.CmbColecao.Value = Cur_Colpadrao.DESC_COLECAO
									Else
										If Thisformset.p_tool_status ="A"
											Sele V_COMPRAS_01
											REPLACE V_COMPRAS_01.COLECAO WITH ''
											thisformset.lx_form1.lx_pageframe1.page1.CmbColecao.Value = ''
										Endif	
									Endif	
							Else
								If val(xMesColecao) >= 7 and val(xMesColecao) <= 12
									TEXT TO xcurColecao NOSHOW textmerge
										select desc_colecao
										from colecoes where temporada IN (7,2,5) and inativo = 0
									Endtext
									F_select(xCurColecao,"curColecao")
									SELECT curColecao
									APPEND BLANK  
									Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.Enabled = .T.
									Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.RowSource='curColecao'
									release xMesColecao
									Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.SetFocus()
									If Thisformset.p_tool_status ="I"
										TEXT TO xCol TEXTMERGE NOSHOW
											SELECT COLECAO, DESC_COLECAO FROM COLECOES WHERE COLECAO = ?o_004002.pp_colecao_padrao
										ENDTEXT 

										f_select(xCol,"Cur_Colpadrao")
										sele Cur_Colpadrao
										REPLACE V_COMPRAS_01.COLECAO WITH Cur_Colpadrao.DESC_COLECAO
										thisformset.lx_form1.lx_pageframe1.page1.CmbColecao.Value = Cur_Colpadrao.DESC_COLECAO
									Else
										If Thisformset.p_tool_status ="A"
											Sele V_COMPRAS_01
											REPLACE V_COMPRAS_01.COLECAO WITH ''
											thisformset.lx_form1.lx_pageframe1.page1.CmbColecao.Value = ''
										Endif	
									Endif	
								Else
									TEXT TO xcurColecao NOSHOW textmerge
										select desc_colecao
										from colecoes 
										where inativo = 0
										--where year(data_inicio_meta) >= year(getdate()) 
									Endtext
									F_select(xCurColecao,"curColecao")
									SELECT curColecao
									APPEND BLANK  
									Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.Enabled = .T.
									Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.RowSource='curColecao'
									release xMesColecao
									Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.SetFocus()
									If Thisformset.p_tool_status ="I"
										TEXT TO xCol TEXTMERGE NOSHOW
											SELECT COLECAO, DESC_COLECAO FROM COLECOES WHERE COLECAO = ?o_004002.pp_colecao_padrao
										ENDTEXT 

										f_select(xCol,"Cur_Colpadrao")
										sele Cur_Colpadrao
										REPLACE V_COMPRAS_01.COLECAO WITH Cur_Colpadrao.DESC_COLECAO
										thisformset.lx_form1.lx_pageframe1.page1.CmbColecao.Value = Cur_Colpadrao.DESC_COLECAO										
									Else
										If Thisformset.p_tool_status ="A"
											Sele V_COMPRAS_01
											REPLACE V_COMPRAS_01.COLECAO WITH ''
											thisformset.lx_form1.lx_pageframe1.page1.CmbColecao.Value = ''
										Endif	
									Endif							
								Endif
							Endif
						Endif
					Endif
 				
				if !f_vazio(xalias)	
					sele &xalias
				endif
				
			CASE UPPER(xmetodo)=='USR_ALTER_BEFORE'  		
					
					SELECT V_COMPRAS_01
					REPLACE V_COMPRAS_01.APROVADOR_POR WITH wusuario + ' '+ DTOC(DATE())				
            
            CASE UPPER(xmetodo)=='USR_SAVE_BEFORE' 
	           	
	           	xalias=alias()
	           	
	           		** Reprovar Pedido Custo Caso esteja maior que no cadastro
	           		if used("CurReprovaCusto") 
						use in CurReprovaCusto
					endif
					
					if used("curMateriaisCores") 
						use in curMateriaisCores
					endif
	           		
	           		if used("CurPropValCusto") 
						use in CurPropValCusto
					endif
	           		
	           		if used("CurMatCusto") 
						use in CurMatCusto
					endif
	           		
	           		if used("xStatusAprovacao") 
	           			use in xStatusAprovacao
					endif
	           		
	           		If Thisformset.p_tool_status ="I"
						f_select("SELECT * FROM PROP_FORNECEDORES WHERE PROPRIEDADE = '00474' and fornecedor=?v_compras_01.fornecedor","CurPropValCusto")
						sele CurPropValCusto
		           			If !F_Vazio(CurPropValCusto.valor_propriedade) AND CurPropValCusto.valor_propriedade = 'SIM'
		           				If Thisformset.pp_gs_permite_alt_status_rc = .F. AND !(ALLTRIM(v_compras_01.tipo_compra) $ Thisformset.pp_gs_valida_tipo_compra_rc)
				           			Sele v_compras_01_materiais
									Go Top
									Scan
										If v_compras_01_materiais.qtde_entregar > 0 
											*F_Select("Select * From Materiais_Cores where material=?v_compras_01_materiais.material and cor_material=?v_compras_01_materiais.cor_material","CurReprovaCusto")
												Text TO xReprovaCusto TextMerge Noshow
													select isnull(b.fornecedor,e.fornecedor) as fornecedor, a.material, a.cor_material, isnull(e.custo_neg,isnull(b.custo_reposicao,a.custo_a_vista)) as custo_a_vista 
													from materiais_cores a
													left join (SELECT * FROM materiais_fornecedor WHERE FORNECEDOR = '<<V_COMPRAS_01.FORNECEDOR>>')b
													on a.material = b.material 
													and a.cor_material = b.cor_material
													LEFT JOIN ( SELECT FORNECEDOR, MATERIAL, COR_MATERIAL, ISNULL(CUSTO_NEGOCIADO,0) AS CUSTO_NEG 
																 FROM GS_CUSTO_NEGOCIADO_MATERIAL (NOLOCK) 
																  WHERE STATUS_CUSTO = 'APROVADO' 
																  	AND ISNULL(CUSTO_NEGOCIADO,0) > 0
																	AND FORNECEDOR = '<<V_COMPRAS_01.FORNECEDOR>>') E
													ON A.MATERIAL = E.MATERIAL
													AND A.COR_MATERIAL = E.COR_MATERIAL
													where a.MATERIAL = '<<V_Compras_01_Materiais.material>>'
													and a.COR_MATERIAL = '<<V_Compras_01_Materiais.cor_material>>'
												Endtext	
												
												f_select(xReprovaCusto,"CurReprovaCusto")
											Sele CurReprovaCusto
											
											f_select("select * from materiais_cores where material = ?V_Compras_01_Materiais.material and cor_material=?V_Compras_01_Materiais.cor_material","curMateriaisCores")
											Sele curMateriaisCores
											
												IF v_compras_01_materiais.custo > IIF(F_Vazio(CurReprovaCusto.custo_a_vista),curMateriaisCores.custo_a_vista,CurReprovaCusto.custo_a_vista) AND ;
													v_compras_01_materiais.custo-IIF(F_Vazio(CurReprovaCusto.custo_a_vista),curMateriaisCores.custo_a_vista,CurReprovaCusto.custo_a_vista) > Thisformset.pp_gs_repro_centavos_custo
													
													Sele V_Compras_01
													Replace V_Compras_01.status_compra WITH 'RC'
													
													F_select("select * from compras_status where status_compra=?V_Compras_01.status_compra","xStatusAprovacao")
													Replace V_Compras_01.status_aprovacao with xStatusAprovacao.status_aprovacao 
					 								thisformset.lx_form1.lx_pageframe1.page1.lx_aprovado.Value=IIF(V_Compras_01.status_aprovacao='E','EM ESTUDO',IIF(V_Compras_01.status_aprovacao='A','APROVADO',IIF(V_Compras_01.status_aprovacao='R','REPROVADO',IIF(V_Compras_01.status_aprovacao='P','PENDENTE DE APROVAÇÃO',''))))
													Thisformset.lx_form1.lx_pageframe1.page1.cmb_status_compra.Refresh()	
													
													Sele V_Compras_01_materiais
													Thisformset.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_mATERIAL_RC.ck_gs_material_rc.Value=1
					 								Replace V_Compras_01_materiais.material_custo_rc WITH .T.
												Else
													Sele V_Compras_01_materiais
													Thisformset.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_mATERIAL_RC.ck_gs_material_rc.Value=0
				 									Replace V_Compras_01_materiais.material_custo_rc WITH .F.													
												Endif	
											Sele v_compras_01_materiais
										Endif
									Endscan
			           			Endif
			           		Endif
	           		Endif
	           		
	           		If Thisformset.p_tool_status ="A"
	           			f_select("SELECT * FROM PROP_FORNECEDORES WHERE PROPRIEDADE = '00474' and fornecedor=?v_compras_01.fornecedor","CurPropValCusto")
						sele CurPropValCusto
		           			If !F_Vazio(CurPropValCusto.valor_propriedade) AND CurPropValCusto.valor_propriedade = 'SIM'
		           				If Thisformset.pp_gs_permite_alt_status_rc = .F. AND !(ALLTRIM(v_compras_01.tipo_compra) $ Thisformset.pp_gs_valida_tipo_compra_rc)
		           					Sele v_compras_01_materiais
									Go Top
									Scan
		           						F_Select("Select * from compras_material where pedido=?v_compras_01.pedido and material=?v_compras_01_materiais.material and cor_material=?v_compras_01_materiais.cor_material and entrega=?v_compras_01_materiais.entrega","CurMatCusto")
		           						Sele CurMatCusto 
		           						If F_Vazio(CurMatCusto.material)
		           							If v_compras_01_materiais.qtde_entregar > 0 
												*F_Select("Select * From Materiais_Cores where material=?v_compras_01_materiais.material and cor_material=?v_compras_01_materiais.cor_material","CurReprovaCusto")
													Text TO xReprovaCusto TextMerge Noshow
														select isnull(b.fornecedor,e.fornecedor) as fornecedor, a.material, a.cor_material, isnull(e.custo_neg,isnull(b.custo_reposicao,a.custo_a_vista)) as custo_a_vista 
														from materiais_cores a
														left join (SELECT * FROM materiais_fornecedor WHERE FORNECEDOR = '<<V_COMPRAS_01.FORNECEDOR>>')b
														on a.material = b.material 
														and a.cor_material = b.cor_material
														LEFT JOIN ( SELECT FORNECEDOR, MATERIAL, COR_MATERIAL, ISNULL(CUSTO_NEGOCIADO,0) AS CUSTO_NEG 
																	 FROM GS_CUSTO_NEGOCIADO_MATERIAL (NOLOCK) 
																	  WHERE STATUS_CUSTO = 'APROVADO' 
																	  	AND ISNULL(CUSTO_NEGOCIADO,0) > 0
																		AND FORNECEDOR = '<<V_COMPRAS_01.FORNECEDOR>>') E
														ON A.MATERIAL = E.MATERIAL
														AND A.COR_MATERIAL = E.COR_MATERIAL
														where a.MATERIAL = '<<V_Compras_01_Materiais.material>>'
														and a.COR_MATERIAL = '<<V_Compras_01_Materiais.cor_material>>'
													Endtext	
													
													f_select(xReprovaCusto,"CurReprovaCusto")
												Sele CurReprovaCusto
												
												f_select("select * from materiais_cores where material = ?V_Compras_01_Materiais.material and cor_material=?V_Compras_01_Materiais.cor_material","curMateriaisCores")
												Sele curMateriaisCores
												
													IF v_compras_01_materiais.custo > IIF(F_Vazio(CurReprovaCusto.custo_a_vista),curMateriaisCores.custo_a_vista,CurReprovaCusto.custo_a_vista) AND ;
														v_compras_01_materiais.custo-IIF(F_Vazio(CurReprovaCusto.custo_a_vista),curMateriaisCores.custo_a_vista,CurReprovaCusto.custo_a_vista) > Thisformset.pp_gs_repro_centavos_custo
													
														Sele V_Compras_01
														Replace V_Compras_01.status_compra WITH 'RC'
														
														F_select("select * from compras_status where status_compra=?V_Compras_01.status_compra","xStatusAprovacao")
														Replace V_Compras_01.status_aprovacao with xStatusAprovacao.status_aprovacao 
						 								thisformset.lx_form1.lx_pageframe1.page1.lx_aprovado.Value=IIF(V_Compras_01.status_aprovacao='E','EM ESTUDO',IIF(V_Compras_01.status_aprovacao='A','APROVADO',IIF(V_Compras_01.status_aprovacao='R','REPROVADO',IIF(V_Compras_01.status_aprovacao='P','PENDENTE DE APROVAÇÃO',''))))
						 								Thisformset.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_mATERIAL_RC.ck_gs_material_rc.Value=1
					 									Replace V_Compras_01_materiais.material_custo_rc WITH .T.
														Thisformset.lx_form1.lx_pageframe1.page1.cmb_status_compra.Refresh()
													Else
														Sele V_Compras_01_materiais
														Thisformset.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_mATERIAL_RC.ck_gs_material_rc.Value=0
					 									Replace V_Compras_01_materiais.material_custo_rc WITH .F.
													Endif	
												Sele v_compras_01_materiais
											Endif
		           						Endif
		           						Sele v_compras_01_materiais
		           					EndScan
		           				Endif
							Endif
	           		Endif
	           		
	           		** Fim Reprovar Custo
	           		
	           		*** GS_ProjEntregaDireta #1
	           		If Thisformset.pp_gs_liga_entr_dire_e_cons = .T.
		           		If thisformset.p_tool_status="I"
		           			Sele V_Compras_01_Materiais
							Go Top	
								Text TO xEntregaDireta TextMerge Noshow
									select * 
									from W_GS_FORNECEDOR_ENTREGA_DIRETA
									where MATERIAL = '<<V_Compras_01_Materiais.material>>'
									and COR_MATERIAL = '<<V_Compras_01_Materiais.cor_material>>'
									and FORNECEDOR = '<<V_COMPRAS_01.FORNECEDOR>>'
								Endtext	
								
								f_select(xEntregaDireta,"CurEntregaDireta")
								If !F_Vazio(CurEntregaDireta.material)
									If MESSAGEBOX("Esse pedido de Compra é Entrega Direta ?",4+32) = 6
										Sele V_Compras_01
										Replace V_Compras_01.gs_entrega_direta WITH .T.
										USE IN CurEntregaDireta
										Thisformset.lx_form1.lx_pageframe1.page1.gs_check_entrega_direta.Refresh()
									Else	
										Sele V_Compras_01
										Replace V_Compras_01.gs_entrega_direta WITH .F.
										USE IN CurEntregaDireta
										Thisformset.lx_form1.lx_pageframe1.page1.gs_check_entrega_direta.Refresh()
									Endif
								Endif
						Endif	
					Endif
	           		*** Fim - GS_ProjEntregaDireta #1
	           		
		           	**AJUSTE PARA GRAVAR NO BANCO 
		           	SELECT V_COMPRAS_01
		           	REPLACE COLECAO WITH thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.value				 
					REPLACE MES_ENTRADA_LOJA WITH thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbMesEntrada.value
					
					if !F_VAZIO(o_004002.lx_form1.lx_pageframe1.page1.Cnt_gs_cond_pgto_ori.Lx_tv_gs_cond_pgto_ori.Value)
						Sele v_compras_01
						replace v_compras_01.gs_condicao_pgto_ori with thisformset.lx_form1.lx_pageframe1.page1.Cnt_gs_cond_pgto_ori.Lx_tv_gs_cond_pgto_ori.Value
					endif
					
					SELE V_COMPRAS_01	
						IF F_VAZIO(V_COMPRAS_01.mes_entrada_loja)
							MESSAGEBOX("Favor Colocar Mês Entrada Loja !!!",0+48)
							RETURN .f.
						ENDIF					  			   		
				 	*** Projeto Mes Entrada Loja - Lucas Miranda	
				 		IF F_VAZIO(V_COMPRAS_01.colecao)
							MESSAGEBOX("Favor Colocar Coleção !!!",0+48)
							RETURN .f.
						ENDIF	
				 	
				 	xMesColecao=IIF(v_compras_01.mes_entrada_loja='JANEIRO','1',IIF(v_compras_01.mes_entrada_loja='FEVEREIRO','2',IIF(v_compras_01.mes_entrada_loja='MARÇO','3',IIF(v_compras_01.mes_entrada_loja='ABRIL','4',IIF(v_compras_01.mes_entrada_loja='MAIO','5',IIF(v_compras_01.mes_entrada_loja='JUNHO','6',IIF(v_compras_01.mes_entrada_loja='JULHO','7',IIF(v_compras_01.mes_entrada_loja='AGOSTO','8',IIF(v_compras_01.mes_entrada_loja='SETEMBRO','9',IIF(v_compras_01.mes_entrada_loja='OUTUBRO','10',IIF(v_compras_01.mes_entrada_loja='NOVEMBRO','11',IIF(v_compras_01.mes_entrada_loja='DEZEMBRO','12',v_compras_01.mes_entrada_loja))))))))))))
					If !f_vazio(v_compras_01.mes_entrada_loja) and !f_vazio(v_compras_01.colecao)
						If val(xMesColecao) >= 1 and val(xMesColecao) <= 6
							TEXT TO xcurColecao NOSHOW textmerge
								select desc_colecao
								from colecoes where temporada IN (7,4,6) and inativo = 0 and desc_colecao='<<v_compras_01.colecao>>'
							Endtext
								F_select(xCurColecao,"curVerColecao")
								Sele curVerColecao
								If F_Vazio(curVerColecao.desc_colecao)
									MESSAGEBOX("Favor Verificar a Coleção correspondente ao Mês !",0+16,"Coleção")
									Return .F.
								Endif
						Else
							If val(xMesColecao) >= 7 and val(xMesColecao) <= 12	
								TEXT TO xcurColecao NOSHOW textmerge
									select desc_colecao
									from colecoes where temporada IN (7,2,5) and inativo = 0 and desc_colecao='<<v_compras_01.colecao>>'
									Endtext
									F_select(xCurColecao,"curVerColecao")
									Sele curVerColecao
									If F_Vazio(curVerColecao.desc_colecao)
										MESSAGEBOX("Favor Verificar a Coleção correspondente ao Mês !",0+16,"Coleção")
										Return .F.
									Endif
							Else
								TEXT TO xcurColecao NOSHOW textmerge
									select desc_colecao
									from colecoes 
									where inativo = 0 and desc_colecao='<<v_compras_01.colecao>>'
								Endtext
									F_select(xCurColecao,"curVerColecao")
									Sele curVerColecao
									If F_Vazio(curVerColecao.desc_colecao)
										MESSAGEBOX("Favor Verificar a Coleção correspondente ao Mês !",0+16,"Coleção")
										Return .F.
									Endif
							Endif
						Endif
					Endif
					*** Fim - Projeto Mes Entrada Loja - Lucas Miranda
				 	***** COLOCAR CUSTO NOS MATERIAIS QUANDO MATERIAL NAO CONTEM CUSTO **********
				   	SELE V_COMPRAS_01_MATERIAIS
				   	GO TOP
				    
				   	SCAN
				   		
				   		SELE V_COMPRAS_01_MATERIAIS
				   		f_update("UPDATE MATERIAIS_CORES SET CUSTO_A_VISTA =?V_COMPRAS_01_MATERIAIS.CUSTO WHERE CUSTO_A_VISTA = 0 AND MATERIAL = ?V_COMPRAS_01_MATERIAIS.MATERIAL AND COR_MATERIAL =?V_COMPRAS_01_MATERIAIS.COR_MATERIAL")

				   	ENDSCAN		
					***** FIM ***** JULIO **** 19-03-2013 ******************************************
					*** #1 - Lucas Miranda - Implantação Envio Para Consumo			
					If Thisformset.pp_gs_liga_entr_dire_e_cons = .T.	
						If thisformset.p_tool_status="I"	
							If 'TERCEIRO' $ v_compras_01.tipo_compra AND (!'ENVIAD' $ V_COMPRAS_01.anm_status_almox or f_vazio(v_compras_01.anm_status_almox))
								Sele v_compras_01_reservas
								Locate For v_compras_01_reservas.reserva > 0
								If RECCOUNT()>0
									F_Select("Select * from filiais where rede_lojas='98' and filial=?v_compras_01.fornecedor","xFornEstamparia")
									
									If f_vazio(xFornEstamparia.filial)
										MESSAGEBOX("Não é possível ser estoque de terceiro !!!"+CHR(13)+"Filial não cadastrada como estoque terceiro !!!",0+16)
										USE IN xFornEstamparia
										Return .F.
									Endif

									sele v_compras_01_reservas
									Locate For v_compras_01_reservas.reserva > 0
									Go Top
										f_select("Select * from W_GS_FORNECEDOR_ENTREGA_DIRETA where material=?v_compras_01_reservas.material and cor_material=?v_compras_01_reservas.cor_material","xMatEntregaDireta")
										Sele xMatEntregaDireta
															
										If RECCOUNT()>0 and !F_Vazio(xFornEstamparia.filial)
											IF MESSAGEBOX("Consome estoque terceiro ?",4+32)=6
												Sele V_Compras_01
												Replace V_Compras_01.GS_ESTOQUE_TERCEIRO WITH .T.
											Else		
												Sele V_Compras_01
												Replace V_Compras_01.GS_ESTOQUE_TERCEIRO WITH .F.
											Endif		
										Else
											Sele V_Compras_01
											Replace V_Compras_01.GS_ESTOQUE_TERCEIRO WITH .F.
										Endif
								ENDIF
							ENDIF
						Endif
					Endif
					
					If Thisformset.pp_gs_liga_entr_dire_e_cons = .T.
						If Thisformset.p_tool_status $ 'A'	
							If v_compras_01.gs_estoque_terceiro = .t.
								If !'TERC' $ v_compras_01.tipo_compra 
									MESSAGEBOX("Tipo de compra não permite Estoque Terceiro !!!",0+16)
									Return .F.
								Else	
									F_Select("Select * From Filiais where rede_lojas = '98' and filial=?v_compras_01.fornecedor","VerFilialTerceiro")
									Sele VerFilialTerceiro
									If F_vazio(VerFilialTerceiro.filial)
										MESSAGEBOX("Filial não cadastrado como Estoque Terceiro !!!",0+16)
										Return .F.
									Endif
								Endif
								
								If 'ENVIAD' $ V_COMPRAS_01.anm_status_almox
									MESSAGEBOX("Não é possível marcar como Estoque Terceiro,"+CHR(13)+"pedido Enviado para almoxarifado !!!",0+16)
									Return .F.
								Endif
							Endif
						Endif
					Endif
					*lucas verificar saldo materiais	
					
				   Sele V_compras_01_reservas
				   xReg = RECCOUNT()
				   Go Top
				   
				   xMsg  = ''
				   XQMat = 0
				   xCont = 0
				   
				   
				   Scan 		 	
				 		*** GS_ProjEntregaDireta #1 - Incluído V_Compras_01.gs_entrega_direta
			 		
				 		IF V_compras_01_reservas.Reserva > 0 and thisformset.pp_anm_valida_estoque AND (!'ENVIAD' $ V_COMPRAS_01.anm_status_almox or f_vazio(v_compras_01.anm_status_almox)) ;
				 			AND V_Compras_01.GS_ESTOQUE_TERCEIRO = .F. 
				 		
					 		xCont = xCont + 1
					 		f_prog_bar("Consultando Estoque Disp. - Materia  l: ";
					 		           +ALLTRIM(V_compras_01_reservas.Material)+" | Cor: "+ALLTRIM(V_compras_01_reservas.Cor_Material)+CHR(13)+;
					 		            "Aguarde ... "+ALLTRIM(STR(ROUND((xCont/xReg)*100,0)))+"% Concluido",xCont,xReg)
					 		           
					 		Text To xSelEDisp TextMerge NoShow
					 		
					 			SELECT * FROM FX_ANM_ESTOQUE_MAT_DISP('<<V_compras_01.Pedido>>','','<<V_compras_01.Filial_a_entregar>>','<<V_compras_01_reservas.Material>>','<<V_compras_01_reservas.Cor_Material>>') 
					 			WHERE QTDE_ESTOQUE_DISP 	< <<V_compras_01_reservas.Reserva>>
					   		
					   		EndText
					   		
					   		f_select(xSelEDisp,"Tmp_CurEstDisp")
					   		
					   		If RecCount()>0
					   			
					   			XQMat = XQMat + 1
					   			xMsg = xMsg + CHR(13) + ALLTRIM(STR(XQMat))+ "- Material: "+ALLTRIM(Tmp_CurEstDisp.Material)+" | Cor: "+ALLTRIM(Tmp_CurEstDisp.Cor_Material)+" | Disponível: "+ALLTRIM(STR(Tmp_CurEstDisp.Qtde_Estoque_Disp,15,3))
					   		
					   		Else
					   			xSaveAfter = 'S'
					   			text to	xDataSeparacao noshow textmerge	
							
									SELECT  case 
										when convert(int,left(convert(varchar(13),getdate(),108),2)) > 15  
										then dbo.lx_dias_uteis('000994',convert(datetime,convert(varchar(13),getdate(),112)),2)
										else dbo.lx_dias_uteis('000994',convert(datetime,convert(varchar(13),getdate(),112)),1)
									end as DataSeparacao
								endtext
					
								f_select(xDataSeparacao,"CurDataSeparacao")
								
								sele V_compras_01
								replace anm_status_almox with '1-ENVIADO PARA ALMOX'
								replace ANM_DATA_INICIO_SEPARACAO with CurDataSeparacao.DataSeparacao
					   			
					   		Endif
				   		 ENDIF
			   		
				   	Sele V_compras_01_reservas
				   	EndScan
					f_prog_bar()
					
					If XQMat = 1
						MESSAGEBOX("Quantidade Reservada Maior que Quantidade Disponível do Material:" + CHR(13) + xMsg,64)
							f_select("select ANM_STATUS_ALMOX,ANM_DATA_INICIO_SEPARACAO from COMPRAS where PEDIDO=?v_compras_01.pedido ","curStatusAlmox",alias())
							Sele V_compras_01
							replace anm_status_almox with curStatusAlmox.Anm_Status_Almox
							replace ANM_DATA_INICIO_SEPARACAO with curStatusAlmox.ANM_DATA_INICIO_SEPARACAO 
							release curStatusAlmox
						RETURN .f.
					Else	
						If XQMat > 1
							MESSAGEBOX("Quantidade Reservada Maior que Quantidade Disponível dos Materiais:" + CHR(13) + xMsg,64)
							f_select("select ANM_STATUS_ALMOX,ANM_DATA_INICIO_SEPARACAO from COMPRAS where PEDIDO=?v_compras_01.pedido ","curStatusAlmox",alias())
							Sele V_compras_01
							replace anm_status_almox with curStatusAlmox.Anm_Status_Almox
							replace ANM_DATA_INICIO_SEPARACAO with curStatusAlmox.ANM_DATA_INICIO_SEPARACAO
							release curStatusAlmox
							RETURN .f.
						Endif
					Endif
					
					Sele V_compras_01_reservas
				    Go Top
					
					
			
						
				If Thisformset.pp_anm_valid_tipo_compra_ben = .T.
					if 'BENEF' $ v_compras_01.tipo_compra OR 'REACABAMENTO' $ v_compras_01.tipo_compra 
						Sele V_Compras_01_Reservas
						If Reccount() = 0
							MESSAGEBOX("Favor colocar reserva Semi-Acabado",0+64)
							Return .F.
						Endif
					endif
					if !'BENEF' $ v_compras_01.tipo_compra and !'REACABAMENTO' $ v_compras_01.tipo_compra  
						Sele V_Compras_01_Reservas
						If Reccount() > 0
							MESSAGEBOX("Favor colocar tipo para Beneficiamento/Reacabamento, pois tem Semi-Acabado",0+64)
							Return .F.
						Endif
					endif
				Endif
					
				*** #1 - Lucas Miranda - Implantação Envio Para Consumo	
				if !f_vazio(xalias)	
					sele &xalias
				endif
			
			
				
			CASE UPPER(xmetodo)=='USR_SEARCH_BEFORE'
				SELECT V_COMPRAS_01
	          	REPLACE COLECAO WITH thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.value
	          	REPLACE MES_ENTRADA_LOJA WITH thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbMesEntrada.value
			    
			    
			CASE UPPER(xmetodo)=='USR_SEARCH_AFTER'                
				thisformset.lx_form1.lx_PAGEFRAME1.page1.bt_exporta_materiais.visible = .T.		
				
			CASE UPPER(xmetodo)=='USR_CLEAN_AFTER'
				
				if type("thisformset.lx_form1.lx_PAGEFRAME1.page1.bt_exporta_materiais")<>"U"
					thisformset.lx_form1.lx_PAGEFRAME1.page1.bt_exporta_materiais.visible = .F.
				endif		
				
				** Condição Pagamento Original - Lucas Miranda - 20/09/2017
				if type("thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori")<>"U"
					With Thisformset.lx_FORM1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori
						.lx_txt_gs_cond_pgto_ori.Value = ''
						.lx_txt_gs_cond_pgto_ori.ToolTipText='lx_txt_gs_cond_pgto_ori'
					EndWith		
				endif
				**Fim - Condição Pagamento Original - Lucas Miranda - 20/09/2017
			CASE UPPER(xmetodo)=='USR_REFRESH'                
				 
				xalias=alias()
				
					TRY
						thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.value=v_compras_01.colecao 
						thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbMesEntrada.value=v_compras_01.mes_entrada_loja
						
						If thisformset.p_tool_status="I"
							sele v_compras_01
							f_select("select * from W_CTB_RATEIO_FILIAIS where filial = ?v_compras_01.filial_a_entregar and (DESC_RATEIO_FILIAL not like 'ratei%ger%pel%' and rateio_filial not like 'f%')","xRateio")
							SELE xRateio

							if f_vazio(xRateio.cod_filial)
								MESSAGEBOX("Rateio Filial Não Encontrado, Favor Inserir Manualmente !",0+16)
							else 
								sele v_compras_01
								replace v_compras_01.rateio_filial with xRateio.rateio_filial
								replace v_compras_01.desc_rateio_filial with xRateio.desc_rateio_filial
							endif	
							thisformset.lx_FORM1.lx_pageframe1.page1.tv_raTEIO_FILIAL.refresh()
							thisformset.lx_FORM1.lx_pageframe1.page1.tx_deSC_RATEIO_FILIAL.refresh()
						Endif 
						 
					CATCH 
					
					endtry 
				**** #1 - Lucas Miranda - Implantação Envio Para Consumo	
					if type("thisformset.lx_form1.lx_pageframe1.page8.lb_status_entrada")<>"U"
							
							if thisformset.p_tool_status = "I" 
								thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.T.
							else	
								If thisformset.p_tool_status = "L" 
									thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.T.
									Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.RowSource=''
									f_select ('select DESC_COLECAO  from colecoes','curColecao',ALIAS())
									SELECT curColecao 
									APPEND BLANK  
									Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.RowSource='curColecao'
									Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.Value=''
								Else
									thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.F.	
								Endif	
							endif		
														
							if thisformset.p_tool_status $'IA'
								thisformset.lx_form1.lx_pageframe1.page8.lb_status_entrada.visible = .F.
								thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.visible = .F.	
														
							else
								thisformset.lx_form1.lx_pageframe1.page8.lb_status_entrada.visible = .T.
								thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.visible = .T.
								
							endif	

								
							if thisformset.p_tool_status = 'P'
									thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.enabled=.F.
									thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbMesEntrada.enabled=.F.	
								
									thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.RowSource=''
									f_select ('select DESC_COLECAO  from colecoes (nolock)','curColecao',ALIAS())
									SELECT curColecao 
									APPEND BLANK  
									thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.RowSource='curColecao'
									F_SELECT("Select colecao from compras (nolock) where pedido=?v_compras_01.pedido","Ex_Colecao")
									If !F_Vazio(Ex_Colecao.colecao)
										Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.Value=Ex_Colecao.colecao
										Sele v_compras_01
										REPLACE COLECAO WITH o_004002.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.value	
									Endif
							else
								thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.enabled=.T.	
								thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbMesEntrada.enabled=.T.
							endif
										
						endif	
						
								
						if type("thisformset.lx_form1.lx_pageframe1.page8.tx_data_ini_separacao")<>"U"
							
							if	thisformset.p_tool_status='L'
								thisformset.lx_form1.lx_pageframe1.page8.tx_data_ini_separacao.enabled=.t.
							else	
								thisformset.lx_form1.lx_pageframe1.page8.tx_data_ini_separacao.enabled=.f.						
							endif

						endif
						
							Thisformset.lx_form1.lx_pageframe1.Page8.Botao1.Enabled = .T.
							Thisformset.lx_form1.lx_pageframe1.Page8.Botao4.Enabled = .T.
						*** #1 - Lucas Miranda - Implantação Envio Para Consumo	
						
						*** GS_ProjEntregaDireta #1
						if type("thisformset.lx_form1.lx_pageframe1.page1.gs_check_entrega_direta")<>"U"
							If Thisformset.pp_gs_liga_entr_dire_e_cons = .T.
								If thisformset.p_tool_status $ 'IP'
									thisformset.lx_form1.lx_pageframe1.page1.gs_check_entrega_direta.Enabled = .F.
								Else	
										If thisformset.p_tool_status $ 'A'
											Sele V_Compras_01_Materiais
											Go Top	
												Text TO xEntregaDireta TextMerge Noshow
													select * 
													from W_GS_FORNECEDOR_ENTREGA_DIRETA
													where MATERIAL = '<<V_Compras_01_Materiais.material>>'
													and COR_MATERIAL = '<<V_Compras_01_Materiais.cor_material>>'
													and FORNECEDOR = '<<V_COMPRAS_01.FORNECEDOR>>'
												Endtext	
												
												f_select(xEntregaDireta,"CurEntregaDireta")
												If !F_Vazio(CurEntregaDireta.material)
													USE IN CurEntregaDireta
													thisformset.lx_form1.lx_pageframe1.page1.gs_check_entrega_direta.Enabled = .T.
												Else	
													USE IN CurEntregaDireta
													thisformset.lx_form1.lx_pageframe1.page1.gs_check_entrega_direta.Enabled = .F.
												ENDIF
									 	Else
											thisformset.lx_form1.lx_pageframe1.page1.gs_check_entrega_direta.Enabled = .T.
										Endif													
								Endif
							Endif
						endif
						
						if type("thisformset.lx_form1.lx_pageframe1.page1.gs_check_estoque_terceiro")<>"U"
							If Thisformset.pp_gs_liga_entr_dire_e_cons = .T.
								If thisformset.p_tool_status $ 'IP'
									thisformset.lx_form1.lx_pageframe1.page1.gs_check_estoque_terceiro.Enabled = .F.
								Else	
										If thisformset.p_tool_status $ 'A'
											Sele V_Compras_01_Materiais
											Go Top	
												Text TO xEntregaDireta TextMerge Noshow
													select * 
													from W_GS_FORNECEDOR_ENTREGA_DIRETA
													where MATERIAL = '<<V_Compras_01_Materiais.material>>'
													and COR_MATERIAL = '<<V_Compras_01_Materiais.cor_material>>'
													and FORNECEDOR = '<<V_COMPRAS_01.FORNECEDOR>>'
												Endtext	
												
												f_select(xEntregaDireta,"CurEntregaDireta")
												If !F_Vazio(CurEntregaDireta.material)
													USE IN CurEntregaDireta
													thisformset.lx_form1.lx_pageframe1.page1.gs_check_estoque_terceiro.Enabled = .F.
												Else	
													USE IN CurEntregaDireta
													thisformset.lx_form1.lx_pageframe1.page1.gs_check_estoque_terceiro.Enabled = .T.
												ENDIF
									 	Else
											thisformset.lx_form1.lx_pageframe1.page1.gs_check_estoque_terceiro.Enabled = .T.
										Endif													
								Endif
							Endif
						endif
						***Fim - GS_ProjEntregaDireta #1
						
						
						** Consumo Estoque Terceiro
						** Lucas Miranda - 04/09/2017
						if type("thisformset.lx_form1.lx_pageframe1.page8.btn_gs_consumo_terceiro")<>"U"
							If Thisformset.p_tool_status = "P"
															
								TEXT TO xHabilitaBotao NOSHOW TEXTMERGE
									SELECT  COMPRAS.*
									
									FROM COMPRAS COMPRAS
									join (select ORDEM_PRODUCAO, MATERIAL, COR_MATERIAL, SUM(reserva) as reserva 
										  from PRODUCAO_RESERVA 
										  group by ORDEM_PRODUCAO, MATERIAL, COR_MATERIAL) PRODUCAO_RESERVA
									ON COMPRAS.PEDIDO = PRODUCAO_RESERVA.ORDEM_PRODUCAO
									AND COMPRAS.TABELA_FILHA = 'COMPRAS_MATERIAL'
									
									JOIN FILIAIS FILIAIS
									ON COMPRAS.FORNECEDOR = FILIAIS.FILIAL
									AND FILIAIS.REDE_LOJAS = '98'
									
									WHERE PRODUCAO_RESERVA.reserva > 0
									AND COMPRAS.GS_ESTOQUE_TERCEIRO = 1
									AND COMPRAS.STATUS_APROVACAO <> ('R')
									AND COMPRAS.PEDIDO = ?V_COMPRAS_01.PEDIDO
								ENDTEXT
																		
								f_select(xHabilitaBotao,"CurHabilitaBotao")	

								If Reccount("CurHabilitaBotao")>0
									thisformset.lx_form1.lx_pageframe1.page8.btn_gs_consumo_terceiro.visible = .t.
								ELSE
									thisformset.lx_form1.lx_pageframe1.page8.btn_gs_consumo_terceiro.visible = .f.
								Endif
							Else	
								thisformset.lx_form1.lx_pageframe1.page8.btn_gs_consumo_terceiro.visible=.f.
							Endif
						Endif
						** Fim - Consumo Estoque Terceiro
						
						** Lote - Solicitado pelo Julio Cesar 
						if type("thisformset.lx_form1.lx_pageframe1.page1.tx_gs_lote")<>"U"
							If Thisformset.p_tool_status = "I"
								thisformset.lx_form1.lx_pageframe1.page1.tx_gs_lote.value=null
							Endif	
							
							thisformset.lx_form1.lx_pageframe1.page1.tx_gs_lote.Enabled = thisformset.p_tool_status = "L"
						endif	
						** Fim Lote
						
						** Reprova Custo
						If TYPE('ThisFormSet.lX_FORM1.lx_PAGEFRAME1.page2.lX_GRID_FILHA1.col_material_rc.ck_gs_material_rc')<>'U'
							If THISFORMSET.P_tool_status $ 'I'
								ThisFormSet.lX_FORM1.lx_PAGEFRAME1.page2.lX_GRID_FILHA1.col_material_rc.ck_gs_material_rc.Enabled=.T.
							Else	
								If THISFORMSET.p_tool_status $ 'AP' AND V_Compras_01.status_compra = 'RC'
									ThisFormSet.lX_FORM1.lx_PAGEFRAME1.page2.lX_GRID_FILHA1.col_material_rc.ck_gs_material_rc.Enabled=.T.
									f_select("SELECT * FROM PROP_FORNECEDORES WHERE PROPRIEDADE = '00474' and fornecedor=?v_compras_01.fornecedor","CurPropValCusto")
									sele CurPropValCusto
					           			If !F_Vazio(CurPropValCusto.valor_propriedade) AND CurPropValCusto.valor_propriedade = 'SIM'
					           			 
												If !(ALLTRIM(v_compras_01.tipo_compra) $ THISFORMSET.pp_gs_valida_tipo_compra_rc)

													Sele v_compras_01_materiais
													Go Top
													Scan												
															If v_compras_01_materiais.qtde_entregar > 0 
																*F_Select("Select * From Materiais_Cores where material=?v_compras_01_materiais.material and cor_material=?v_compras_01_materiais.cor_material","CurReprovaCusto")
																	Text TO xReprovaCusto TextMerge Noshow
																		select b.fornecedor, a.material, a.cor_material, isnull(b.custo_reposicao,a.custo_a_vista) as custo_a_vista 
																		from materiais_cores a
																		left join materiais_fornecedor b
																		on a.material = b.material 
																		and a.cor_material = b.cor_material
																		where a.MATERIAL = '<<V_Compras_01_Materiais.material>>'
																		and a.COR_MATERIAL = '<<V_Compras_01_Materiais.cor_material>>'
																		and FORNECEDOR = '<<V_COMPRAS_01.FORNECEDOR>>'
																	Endtext	
																	
																	f_select(xReprovaCusto,"CurReprovaCusto")
																Sele CurReprovaCusto
																
																f_select("select * from materiais_cores where material = ?V_Compras_01_Materiais.material and cor_material=?V_Compras_01_Materiais.cor_material","curMateriaisCores")
																Sele curMateriaisCores
																
																		IF v_compras_01_materiais.custo > IIF(F_Vazio(CurReprovaCusto.custo_a_vista),curMateriaisCores.custo_a_vista,CurReprovaCusto.custo_a_vista)
																			Sele V_Compras_01_materiais
																			Replace V_Compras_01_materiais.material_custo_rc WITH .T.
																			THISFORMSET.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_mATERIAL_RC.ck_gs_material_rc.Value=1
																		Else
																			Sele V_Compras_01_materiais
																			Replace V_Compras_01_materiais.material_custo_rc WITH .F.
																			THISFORMSET.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_mATERIAL_RC.ck_gs_material_rc.Value=0	
																		Endif	
															Endif
														Sele v_compras_01_materiais
													Endscan
													
													if used("CurReprovaCusto") 
														use in CurReprovaCusto
													endif
													
													if used("curMateriaisCores") 
														use in curMateriaisCores
													endif
													
													if used("CurPropValCusto") 
														use in CurPropValCusto
													endif
													
													if used("CurMatCusto") 
														use in CurMatCusto
													endif
											Endif
						           		Endif
									Endif
								Endif
							Endif
													
						** Fim Reprova Custo
						
						** Condição Pagamento Original - Lucas Miranda - 20/09/2017

						if type("thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori")<>"U"	

							If Thisformset.p_tool_status $ 'A' 
								IF !(ALLTRIM(v_compras_01.tipo_compra) $ Thisformset.pp_gs_valida_tipo_compra_rc) AND o_004002.pp_gs_bloq_cond_pgto_ped = .t.
									*Thisformset.lx_form1.lx_pageframe1.page1.tv_condicao_pgto.ReadOnly=.T.
									Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.Lx_tv_gs_cond_pgto_ori.ReadOnly=.T.
								Else	
									Thisformset.lx_form1.lx_pageframe1.page1.tv_condicao_pgto.ReadOnly=.F.
									Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.Lx_tv_gs_cond_pgto_ori.ReadOnly=.F.
								Endif
							Endif					
							
							If Thisformset.p_tool_status = 'A' AND !(ALLTRIM(v_compras_01.tipo_compra) $ Thisformset.pp_gs_valida_tipo_compra_rc)
								f_select("select * from prop_fornecedores (nolock) where propriedade='00510' and fornecedor=?v_compras_01.fornecedor","CurPropFornInter",ALIAS())
								f_select("select * from prop_fornecedores (nolock) where propriedade='00509' and fornecedor=?v_compras_01.fornecedor","CurPropValidCond",ALIAS())
								IF !f_vazio(CurPropFornInter.propriedade) and !f_vazio(CurPropValidCond.propriedade)
									If ALLTRIM(CurPropFornInter.valor_propriedade) == 'NAO' AND ALLTRIM(CurPropValidCond.valor_propriedade) == 'SIM'
										Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.Visible = .T.
									Else	
										Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.Visible = .F.
									Endif
								ENDIF
							Else
								Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.Visible = .F.
							Endif
							
							If Thisformset.p_tool_status = 'L'
								Thisformset.lx_form1.lx_pageframe1.page1.Btn_cond_pgto_ori.Visible=.T.
								Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.Visible=.F.
							Endif
							
							If Thisformset.p_tool_status = 'P'
								Thisformset.lx_form1.lx_pageframe1.page1.tv_condicao_pgto.Enabled = .F.
								Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.lx_tv_gs_cond_pgto_ori.Enabled = .F.
								Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.lx_txt_gs_cond_pgto_ori.Enabled = .F.
								
								Text TO xSelCondPgtoOr TextMerge Noshow
									select CONDICAO_PGTO, DESC_COND_PGTO
									from COND_ENT_PGTOS (nolock)
									where CONDICAO_PGTO = '<<V_COMPRAS_01.GS_CONDICAO_PGTO_ORI>>'
								Endtext	
								f_select(xSelCondPgtoOr,"xCondPgtoOr")
									
								With Thisformset.lx_FORM1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori
									.lx_txt_gs_cond_pgto_ori.Value = IIF(f_vazio(xCondPgtoOr.DESC_COND_PGTO),'',xCondPgtoOr.DESC_COND_PGTO)
									.lx_txt_gs_cond_pgto_ori.ToolTipText=IIF(f_vazio(xCondPgtoOr.DESC_COND_PGTO),'',xCondPgtoOr.DESC_COND_PGTO)
								EndWith	
								
								
								Text TO xSelCondPgtoC TextMerge Noshow								
									select CONDICAO_PGTO, DESC_COND_PGTO, TIPO_CONDICAO
									from COND_ENT_PGTOS (nolock)
									where CONDICAO_PGTO = '<<V_COMPRAS_01.CONDICAO_PGTO>>'
								Endtext	
								f_select(xSelCondPgtoC,"xCondFornecC")
									
								With Thisformset.lx_FORM1.lx_pageframe1.page1
									.tv_condicao_pgto.Value 		= xCondFornecC.CONDICAO_PGTO
									.tx_desc_condicao_pgto.Value	= xCondFornecC.DESC_COND_PGTO
									.tx_tipo_condicao.Value			= xCondFornecC.TIPO_CONDICAO 
								EndWith	
								
								Thisformset.lx_FORM1.lx_pageframe1.page1.tv_condicao_pgto.l_desenhista_recalculo()
								Thisformset.lx_FORM1.Tv_FORNECEDOR.l_desenhista_recalculo()
								
								If !(ALLTRIM(v_compras_01.tipo_compra) $ o_004002.pp_gs_valida_tipo_compra_rc) and !f_vazio(v_compras_01.tipo_compra)
									f_select("select * from prop_fornecedores (nolock) where propriedade='00510' and fornecedor=?v_compras_01.fornecedor","CurPropFornInter",ALIAS())
									f_select("select * from prop_fornecedores (nolock) where propriedade='00509' and fornecedor=?v_compras_01.fornecedor","CurPropValidCond",ALIAS())
									IF !f_vazio(CurPropFornInter.propriedade) and !f_vazio(CurPropValidCond.propriedade)
										If ALLTRIM(CurPropFornInter.valor_propriedade) == 'NAO' AND ALLTRIM(CurPropValidCond.valor_propriedade) == 'SIM'
											Thisformset.lx_form1.lx_pageframe1.page1.Btn_cond_pgto_ori.Visible=.T.
										Else
											Thisformset.lx_form1.lx_pageframe1.page1.Btn_cond_pgto_ori.Visible=.F.
										Endif
									Endif
								Else
									Thisformset.lx_form1.lx_pageframe1.page1.Btn_cond_pgto_ori.Visible=.F.
								Endif
							Endif
						Endif
						**Fim - Condição Pagamento Original - Lucas Miranda - 20/09/2017
						 
						
						If thisformset.p_tool_status $ 'IA'
							xVerEstEstamparia = 0
						Endif	

				if !f_vazio(xalias)	
					sele &xalias
				endif	
				
				 
			CASE UPPER(xmetodo)=='USR_INCLUDE_AFTER'
			
			*thisformset.lx_form1.lx_pageframe1.page2.lx_grid_filha1.col_mATERIAL_RC.ck_gs_material_rc.Value=0
			
			SELECT V_COMPRAS_01
			REPLACE V_COMPRAS_01.APROVADOR_POR WITH wusuario + ' '+ DTOC(DATE())
			
			TEXT TO xCol TEXTMERGE NOSHOW
				SELECT COLECAO, DESC_COLECAO FROM COLECOES WHERE COLECAO = ?o_004002.pp_colecao_padrao
			ENDTEXT 

			f_select(xCol,"Cur_Colpadrao")
			sele Cur_Colpadrao
			REPLACE V_COMPRAS_01.COLECAO WITH Cur_Colpadrao.DESC_COLECAO
			thisformset.lx_form1.lx_pageframe1.page1.CmbColecao.Value = Cur_Colpadrao.DESC_COLECAO
			
			*** #2 - Lucas Miranda - BLOQUEIO DATA ENTREGA DEPOIS DE 5 DIAS DA EMISSÃO 
			Thisformset.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.coL_TX_ENTREGA.Enabled = .T.
			Thisformset.lx_form1.lx_pageframe1.page1.tx_enTREGA_UNICA.Enabled = .T.
			Thisformset.lx_form1.lx_pageframe1.page1.ck_CTRL_MULT_ENTREGAS.Enabled = .T.
			*** #2 - Lucas Miranda - BLOQUEIO DATA ENTREGA DEPOIS DE 5 DIAS DA EMISSÃO 
			*thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.value='' 
			
			*** #3 - Julio Cesar - Inclusão do parâmetro para trazer uma natureza por padrão 
			xNaturezaPadrao = Thisformset.pp_ANM_NAT_COMPRA_PADRAO
			Thisformset.lx_FORM1.lx_pageframe1.page1.LX_Textbox_valida1.Value = xNaturezaPadrao   
			
			f_select("SELECT CTB_TIPO_OPERACAO FROM NATUREZAS_ENTRADAS WHERE NATUREZA= ?xNaturezaPadrao","CurTipoOpe",ALIAS())
			Thisformset.lx_FORM1.lx_pageframe1.page1.tx_ctb_Tipo_Operacao.Value = CurTipoOpe.CTB_TIPO_OPERACAO 
			USE IN CurTipoOpe
			RELEASE xNaturezaPadrao 
			
			xCentroCustoPadrao = Thisformset.pp_anm_centro_custo_padrao
			Thisformset.lx_FORM1.lx_pageframe1.page1.tv_raTEIO_CENTRO_CUSTO.value= xCentroCustoPadrao
			RELEASE xCentroCustoPadrao 
			*** #3 - Julio Cesar - Inclusão do parâmetro para trazer uma natureza por padrão 
			
			** Condição Pagamento Original - Lucas Miranda - 20/09/2017
			if type("thisformset.lx_form1.lx_pageframe1.page1.lx_tv_gs_cond_pgto_ori")<>"U"
				Thisformset.lx_form1.lx_PAGEFRAME1.page1.tv_CONDICAO_PGTO.Enabled=.f.
				Thisformset.lx_form1.lx_PAGEFRAME1.page1.lx_tv_gs_cond_pgto_ori.Enabled=.f.
				
				With Thisformset.lx_FORM1.lx_pageframe1.page1
					.lx_txt_gs_cond_pgto_ori.Value = ''
					.lx_txt_gs_cond_pgto_ori.ToolTipText='lx_txt_gs_cond_pgto_ori'
				EndWith		
			endif
			**Fim - Condição Pagamento Original - Lucas Miranda - 20/09/2017
			
			CASE UPPER(xmetodo)=='USR_ALTER_AFTER' 	

			*** #1 - Lucas Miranda - Implantação Envio Para Consumo
				thisformset.lx_form1.lx_pageframe1.Page8.LX_GRID_FILHA1.Col_tx_RESERVA_ORIGINAL.Enabled = .T.
				Thisformset.lx_form1.lx_pageframe1.Page8.LX_GRID_FILHA1.Col_tx_matar_saldo_reserva.Enabled=.T.
				Thisformset.lx_form1.lx_pageframe1.Page8.Botao1.Enabled = .T.
				Thisformset.lx_form1.lx_pageframe1.Page8.Botao4.Enabled = .T.
			*** #2 - Lucas Miranda - BLOQUEIO DATA ENTREGA DEPOIS DE 5 DIAS DA EMISSÃO 
				xdata_atual = DATE()
				xdata_emissao = v_compras_01.emissao
				xData = xdata_atual - xdata_emissao
				IF xData > 5 and Thisformset.pp_anm_libera_entrega_mp = .f.
					Thisformset.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.coL_TX_ENTREGA.Enabled = .f.
					Thisformset.lx_form1.lx_pageframe1.page1.tx_enTREGA_UNICA.Enabled = .f.
					Thisformset.lx_form1.lx_pageframe1.page1.ck_CTRL_MULT_ENTREGAS.Enabled = .f.
					RELEASE xdata_atual
					RELEASE xdata_emissao 
					RELEASE xData 								
				Else
					Thisformset.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.coL_TX_ENTREGA.Enabled = .T.
					Thisformset.lx_form1.lx_pageframe1.page1.tx_enTREGA_UNICA.Enabled = .T.
					Thisformset.lx_form1.lx_pageframe1.page1.ck_CTRL_MULT_ENTREGAS.Enabled = .T.
				Endif					
			
			** Condição Pagamento Original - Lucas Miranda - 21/09/2017
			CASE UPPER(xmetodo)=='USR_SAVE_AFTER'
			
				xalias=alias()
					
					f_update("EXEC DBO.LX_GS_COND_PGTO_AUTO_PED_MP ?v_compras_01.pedido")
					
					If !(ALLTRIM(v_compras_01.tipo_compra) $ Thisformset.pp_gs_valida_tipo_compra_rc) and !f_vazio(v_compras_01.tipo_compra)
					f_select("select * from prop_fornecedores (nolock) where propriedade='00510' and fornecedor=?v_compras_01.fornecedor","CurPropFornInter",ALIAS())
					f_select("select * from prop_fornecedores (nolock) where propriedade='00509' and fornecedor=?v_compras_01.fornecedor","CurPropValidCond",ALIAS())
						IF !f_vazio(CurPropFornInter.propriedade) and !f_vazio(CurPropValidCond.propriedade)
								If ALLTRIM(CurPropFornInter.valor_propriedade) == 'NAO' AND ALLTRIM(CurPropValidCond.valor_propriedade) == 'SIM'
									Text TO xSelCondPgtoC TextMerge Noshow								
										select A.CONDICAO_PGTO, A.DESC_COND_PGTO, A.TIPO_CONDICAO
										from COND_ENT_PGTOS (nolock) A
										JOIN COMPRAS (NOLOCK)B
										ON A.CONDICAO_PGTO = B.CONDICAO_PGTO 
										where PEDIDO = '<<V_COMPRAS_01.PEDIDO>>'
									Endtext	
									f_select(xSelCondPgtoC,"xCondFornecC")
										
									With Thisformset.lx_FORM1.lx_pageframe1.page1
										.tv_condicao_pgto.Value 		= xCondFornecC.CONDICAO_PGTO
										.tx_desc_condicao_pgto.Value	= xCondFornecC.DESC_COND_PGTO
										.tx_tipo_condicao.Value			= xCondFornecC.TIPO_CONDICAO 
									EndWith	
								Endif				
						Endif
					Endif
				if !f_vazio(xalias)	
					sele &xalias
				endif	
			*** #2 - Lucas Miranda - BLOQUEIO DATA ENTREGA DEPOIS DE 5 DIAS DA EMISSÃO 	
			CASE UPPER(xmetodo)=='USR_ITEN_INCLUDE_BEFORE' OR UPPER(xmetodo)=='USR_ITEN_DELETE_BEFORE'
				
				xalias=alias()
					If upper(xnome_obj) = 'COMPRAS_001'
						IF thisformset.p_tool_status = 'A' AND thisformset.lx_form1.lx_pageframe1.ActivePage = 9 
							if v_compras_01.anm_status_almox = '1-ENVIADO PARA ALMOX'
								MESSAGEBOX("Proibido Incluir ou Excluir Material com Pedido Enviado Para Almoxarifado !",16)
								Return .F.
							endif 		
						
						ENDIF
					Endif		
				if !f_vazio(xalias)	
					sele &xalias
				endif					
			
			CASE UPPER(xmetodo)=='USR_WHEN'
				
				xalias=alias()
					If upper(xnome_obj) = 'TX_RESERVA_ORIGINAL' or upper(xnome_obj) = 'BOTAO1' or upper(xnome_obj) = 'BOTAO4'
						IF thisformset.p_tool_status = 'A' AND thisformset.lx_form1.lx_pageframe1.ActivePage = 9 
							if v_compras_01.anm_status_almox = '1-ENVIADO PARA ALMOX'
								Thisformset.lx_form1.lx_pageframe1.Page8.LX_GRID_FILHA1.Col_tx_RESERVA_ORIGINAL.Enabled = .F.
								Thisformset.lx_form1.lx_pageframe1.Page8.LX_GRID_FILHA1.Col_tx_matar_saldo_reserva.Enabled=.f.
								Thisformset.lx_form1.lx_pageframe1.Page8.Botao1.Enabled = .F.
								Thisformset.lx_form1.lx_pageframe1.Page8.Botao4.Enabled = .F.
							endif 		
						
						ENDIF
					Endif		
				
				*** Projeto Mes Entrada Loja - Lucas Miranda - 28/03/2017
					If upper(xnome_obj) = 'CMBCOLECAO' AND Thisformset.p_tool_status $ 'IA'
						xMesColecao=IIF(v_compras_01.mes_entrada_loja='JANEIRO','1',IIF(v_compras_01.mes_entrada_loja='FEVEREIRO','2',IIF(v_compras_01.mes_entrada_loja='MARÇO','3',IIF(v_compras_01.mes_entrada_loja='ABRIL','4',IIF(v_compras_01.mes_entrada_loja='MAIO','5',IIF(v_compras_01.mes_entrada_loja='JUNHO','6',IIF(v_compras_01.mes_entrada_loja='JULHO','7',IIF(v_compras_01.mes_entrada_loja='AGOSTO','8',IIF(v_compras_01.mes_entrada_loja='SETEMBRO','9',IIF(v_compras_01.mes_entrada_loja='OUTUBRO','10',IIF(v_compras_01.mes_entrada_loja='NOVEMBRO','11',IIF(v_compras_01.mes_entrada_loja='DEZEMBRO','12',v_compras_01.mes_entrada_loja))))))))))))
						If !f_vazio(v_compras_01.mes_entrada_loja) 
						Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.RowSource=''
							If val(xMesColecao) >= 1 and val(xMesColecao) <= 6				
								TEXT TO xcurColecao NOSHOW textmerge
									select desc_colecao
									from colecoes where temporada IN (7,4,6) and inativo = 0
								Endtext
								F_select(xCurColecao,"curColecao")
								SELECT curColecao
								APPEND BLANK  
								Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.Enabled = .T.
								Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.RowSource='curColecao'
								release xMesColecao

							Else
								If val(xMesColecao) >= 7 and val(xMesColecao) <= 12
									TEXT TO xcurColecao NOSHOW textmerge
										select desc_colecao
										from colecoes where temporada IN (7,2,5) and inativo = 0
									Endtext
									F_select(xCurColecao,"curColecao")
									SELECT curColecao
									APPEND BLANK  
									Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.Enabled = .T.
									Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.RowSource='curColecao'
									release xMesColecao
								Else
									TEXT TO xcurColecao NOSHOW textmerge
										select desc_colecao
										from colecoes 
										where inativo = 0
										--where year(data_inicio_meta) >= year(getdate()) 
									Endtext
									F_select(xCurColecao,"curColecao")
									SELECT curColecao
									APPEND BLANK  
									Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.Enabled = .T.
									Thisformset.lx_form1.lx_pageframe1.page1.cmbColecao.RowSource='curColecao'
									release xMesColecao
					 			Endif
							Endif
						Endif
					Endif				
				
				if !f_vazio(xalias)	
					sele &xalias
				endif					
			
			CASE UPPER(xmetodo)=='USR_SAVE_AFTER'
				
				xalias=alias()
					If thisformset.p_tool_status $ 'IA' AND xSaveAfter = 'S' AND 'ENVIAD' $ V_COMPRAS_01.anm_status_almox
							text to	xinsert1 noshow textmerge	

								INSERT INTO ANM_STATUS_COMPRAS_MP_MOV
								(PEDIDO,ANM_STATUS_ALMOX,
								DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP,CHAVE_ID)
								SELECT 
								'<<V_Compras_01.pedido>>',
								'<<V_Compras_01.ANM_STATUS_ALMOX>>','<<DTOS(WDATA)>>',
								'<<WUSUARIO>>','<<SYSTEM.NetUserName>>','<<SYSTEM.NetComputerName>>',(SELECT GETDATE()),
								(select max(id_registro) from ANM_STATUS_COMPRAS_MP_MOV where pedido = '<<V_Compras_01.pedido>>' and left(ANM_STATUS_ALMOX,1)=1 and ANM_STATUS_ALMOX = '1-ENVIADO PARA ALMOX' )

							endtext

							xSaveAfter = ''
							
							if !f_insert(xinsert1) 
								messagebox("Não foi Gravar o Log do Status do Pedido de Compra",48,"Atenção_8!")
							ENDIF	
					
					Endif		
				
			*** #1 - Lucas Miranda - Implantação Envio Para Consumo	
				if !f_vazio(xalias)	
					sele &xalias
				endif	
			
			otherwise
				return .t.				
		endcase
	ENDPROC 
ENDDEFINE


**************************************************
*-- Class:        bt_saida_avulsa (c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/08/10 01:37:14 PM
*
DEFINE CLASS bt_exporta_materiais AS botao


	Top = 352
	Left = 35
	Height = 20
	Width = 230
	FontBold = .T.
	Caption = "Exporta Materiais dos Pedidos (Excel)"
	TabIndex = 40
	Name = "bt_exporta_materiais"
	Visible = .F.


	PROCEDURE Click	
		
	*SET STEP ON	
			
			SELECT B.PEDIDO,B.MATERIAL AS EMISSAO,B.MATERIAL,B.DESC_MATERIAL,B.COR_MATERIAL,B.DESC_COR_MATERIAL,;
			A.FORNECEDOR,B.QTDE_ENTREGUE,B.VALOR_ENTREGUE,B.QTDE_ENTREGAR,B.VALOR_ENTREGAR,;
			A.FORNECEDOR AS STATUS_APROVACAO,A.APROVADOR_POR,A.TIPO_COMPRA;
			FROM V_COMPRAS_01 A JOIN V_COMPRAS_01_MATERIAIS B; 
			ON A.PEDIDO = B.PEDIDO WHERE 1=2 INTO CURSOR EXPORTA_MATERIAIS_EXCEL READWRITE
			
			SELE EXPORTA_MATERIAIS_EXCEL 
			GO TOP 

 	SELE V_COMPRAS_01
 	GO TOP
 	
 	SCAN
		
		SELE V_COMPRAS_01
		f_prog_bar('Exportando Pedido nº '+V_COMPRAS_01.PEDIDO)
		
		TEXT TO XSEL TEXTMERGE NOSHOW
		
			SELECT B.PEDIDO,CONVERT(CHAR,(A.EMISSAO),103) AS EMISSAO,B.MATERIAL,C.DESC_MATERIAL,B.COR_MATERIAL,D.DESC_COR_MATERIAL,
			A.FORNECEDOR,B.QTDE_ENTREGUE,CONVERT(NUMERIC(18,2),B.VALOR_ENTREGUE) AS VALOR_ENTREGUE,B.QTDE_ENTREGAR,
			CONVERT(NUMERIC(18,2),B.VALOR_ENTREGAR) AS VALOR_ENTREGAR,E.DESC_STATUS_COMPRA,A.APROVADOR_POR,A.TIPO_COMPRA
			FROM COMPRAS A JOIN COMPRAS_MATERIAL B
			ON A.PEDIDO = B.PEDIDO
			JOIN MATERIAIS C
			ON B.MATERIAL = C.MATERIAL
			JOIN MATERIAIS_CORES D
			ON  B.MATERIAL = D.MATERIAL
			AND B.COR_MATERIAL = D.COR_MATERIAL
			JOIN COMPRAS_STATUS E
			ON A.STATUS_APROVACAO = E.STATUS_COMPRA
			WHERE A.PEDIDO = '<<V_COMPRAS_01.PEDIDO>>'
		
		ENDTEXT
		
		F_SELECT(XSEL,"TMP_EXPORTACAO",ALIAS())
		
	SELE TMP_EXPORTACAO
	GO TOP
	
		SCAN		
			
			SELE EXPORTA_MATERIAIS_EXCEL
			
			APPEND BLANK
			REPLACE     TIPO_COMPRA 	  WITH ALLTRIM(TMP_EXPORTACAO.TIPO_COMPRA)
			REPLACE     PEDIDO	 		  WITH ALLTRIM(TMP_EXPORTACAO.PEDIDO)
			REPLACE     EMISSAO	 		  WITH ALLTRIM(TMP_EXPORTACAO.EMISSAO)
			REPLACE		MATERIAL	      WITH ALLTRIM(TMP_EXPORTACAO.MATERIAL)
			REPLACE	    DESC_MATERIAL	  WITH ALLTRIM(TMP_EXPORTACAO.DESC_MATERIAL)
			REPLACE		COR_MATERIAL	  WITH ALLTRIM(TMP_EXPORTACAO.COR_MATERIAL)
			REPLACE		DESC_COR_MATERIAL WITH ALLTRIM(TMP_EXPORTACAO.DESC_COR_MATERIAL)
			REPLACE		QTDE_ENTREGUE     WITH 		   TMP_EXPORTACAO.QTDE_ENTREGUE
			REPLACE		VALOR_ENTREGUE    WITH         TMP_EXPORTACAO.VALOR_ENTREGUE
			REPLACE		QTDE_ENTREGAR     WITH         TMP_EXPORTACAO.QTDE_ENTREGAR
			REPLACE		VALOR_ENTREGAR    WITH         TMP_EXPORTACAO.VALOR_ENTREGAR
			REPLACE		FORNECEDOR        WITH ALLTRIM(TMP_EXPORTACAO.FORNECEDOR)
			REPLACE		STATUS_APROVACAO  WITH ALLTRIM(TMP_EXPORTACAO.DESC_STATUS_COMPRA)
			REPLACE		APROVADOR_POR     WITH ALLTRIM(TMP_EXPORTACAO.APROVADOR_POR)
		
		SELE TMP_EXPORTACAO
		
		ENDSCAN	
	
	RELEASE TMP_EXPORTACAO
	
	SELE V_COMPRAS_01
	

	
	ENDSCAN
				
		SELE V_COMPRAS_01
 		GO TOP	

	SELE EXPORTA_MATERIAIS_EXCEL
	GO TOP

		COPY TO C:\TEMP\Exportacao_Pedido_Materiais.XLS XLS
		MESSAGEBOX("Exportado com sucesso para C:\TEMP\Exportacao_Pedido_Materiais.XLS",0+64)
	
	RELEASE EXPORTA_MATERIAIS_EXCEL
 	f_wait()
 				
	ENDPROC

ENDDEFINE
*
*-- EndDefine: bt_saida_avulsa 
**************************************


**************************************************
*-- Class:        cmb_separa_almox (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmbColecao AS lx_combobox

Name = "cmbColecao"
visible=.t.
top=162
left=365
width=145
controlsource=v_compras_01.colecao 
rowsource='curColecao'
enabled=.t.				
rowsourcetype=2
value='' 



ENDDEFINE
*
*-- EndDefine: cmbColecao
**************************************************

**************************************************
*-- Class:        lblColecao(p:\tmpsid\entradas_rbx\lblColecao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lblColecao AS lx_label
				
	visible=.t.
	top=165
	left=320
	width=77
	caption='Coleção'					
	height=15
	Name = "lblColecao"


ENDDEFINE
*
*-- EndDefine: lblColecao
**************************************************

**************************************************
*-- Class:        cmb_separa_almox (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmbMesEntrada AS lx_combobox

Name = "cmbMesEntrada"
visible=.t.
top=162
left=605
width=121
controlsource=v_compras_01.mes_entrada_loja 
rowsource='curMes'
enabled=.t.				
rowsourcetype=2
value='' 



ENDDEFINE
*
*-- EndDefine: cmbColecao
**************************************************

**************************************************
*-- Class:        lblMesEntrada(p:\tmpsid\entradas_rbx\lblColecao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lblMesEntrada AS lx_label
				
	visible=.t.
	top=165
	left=515
	width=77
	caption='Mês Entrada Loja'					
	height=15
	Name = "lblMesEntrada"


ENDDEFINE
*
*-- EndDefine: lblMesEntrada
**************************************************
**************************************************
*-- Class:        lb_status_entrada (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_status_entrada AS lx_label


	Caption = "Status Entrada"
	Height = 15
	Left = 334
	Top = 6
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	FontBold = .T.
	p_muda_size = .F.
	Name = "lb_status_entrada"
	Visible = .t. 
	Anchor = 0
	Alignment=0

	PROCEDURE DblClick	
		
		*If thisformset.p_tool_status="P" and (v_producao_os_01.anm_status_almox <>"2-RECEBIDO ALMOX" or f_vazio(v_producao_os_01.anm_status_almox))  
	If thisformset.p_tool_status ="P"
		sele v_compras_01 
		xOldStatusAlmox = v_compras_01.anm_status_almox
		if f_vazio(v_compras_01.filial_a_entregar)
			MESSAGEBOX("Favor colocar a filial para enviar para consumo !!!",0+64)
			RETURN .f.
		Endif		

		sele v_compras_01
		
		If v_compras_01.anm_status_almox="1-ENVIADO PARA ALMOX" 
			
			text to xselUser noshow textmerge	
				SELECT * FROM PROPRIEDADE_VALIDA 
				WHERE PROPRIEDADE='00058' 
				AND LTRIM(RTRIM(VALOR_PROPRIEDADE))= '<<WUSUARIO>>'
			endtext	
		
			f_select(xselUser,"curUserFimOs",alias())
			
			if f_vazio(curUserFimOs.valor_propriedade)
				messagebox("Você Não tem Permissão para Alterar o Status do Pedido enquanto não for Finalizado",48,"Atenção!!!")
				thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.F.
				retu .f.
				o_toolbar.Botao_refresh.Click()
			else
				if messagebox("Deseja Alterar o Status do Pedido?",4+32+256,"Atenção!")=6	
					thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.T.	
				endif
			endif				
		Else
				if messagebox("Deseja Alterar o Status do Pedido?",4+32+256,"Atenção!")=6	
					thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.T.
				endif		
		Endif
	Endif

	ENDPROC 

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
DEFINE CLASS cmb_status_entrada AS lx_combobox


	RowSource = ""
	ControlSource = ""
	Height = 22
	Left = 430
	TabIndex = 1
	Top = 3
	Width = 135
	ZOrderSet = 5
	Name = "cmb_status_entrada"
	Visible = .t.
	Enabled = .t.
	Anchor = 0

	PROCEDURE Valid	
	
	
	IF THISFORMSET.P_TOOL_STATUS="P"
	
		If V_Compras_01.anm_status_almox <> "1-ENVIADO PARA ALMOX" 
			
			if messagebox("Deseja Finalizar este Pedido de Compra?",4+32+256,"Atenção!")=6	

				xordem_servico=V_Compras_01.pedido
				*ORDEM_SERVICO,ANM_STATUS_ALMOX,DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP
				text to	xinsert1 noshow textmerge	

					UPDATE COMPRAS SET ANM_STATUS_ALMOX='<<v_compras_01.anm_status_almox>>'	, ANM_DATA_INICIO_SEPARACAO=null
					WHERE pedido='<<xordem_servico>>' 
				
					INSERT INTO ANM_STATUS_COMPRAS_MP_MOV
					(PEDIDO,ANM_STATUS_ALMOX,
					DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP,CHAVE_ID)
					SELECT 
					'<<xordem_servico>>',
					'<<V_Compras_01.ANM_STATUS_ALMOX>>','<<DTOS(WDATA)>>',
					'<<WUSUARIO>>','<<SYSTEM.NetUserName>>','<<SYSTEM.NetComputerName>>',(SELECT GETDATE()),
					(select max(id_registro) from ANM_STATUS_COMPRAS_MP_MOV where pedido = '<<xordem_servico>>' and left(ANM_STATUS_ALMOX,1)=1 and ANM_STATUS_ALMOX = '1-ENVIADO PARA ALMOX' )

				endtext


				if !f_insert(xinsert1) 
					messagebox("Não foi possível Alterar o Status do Pedido de Compra",48,"Atenção_8!")
					replace v_compras_01.anm_status_almox with xOldStatusAlmox
					thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.F.
					retu .f.
				ELSE
					
					f_select("select ANM_DATA_INICIO_SEPARACAO from COMPRAS where PEDIDO=?xordem_servico ","curDataIciAlmox",alias())
				
					thisformset.lx_form1.lx_pageframe1.page8.tx_data_ini_separacao.value=curDataIciAlmox.ANM_DATA_INICIO_SEPARACAO 
					o_toolbar.Botao_refresh.Click()
				ENDIF	
				
				o_toolbar.Botao_refresh.Click()

			endif
						
		
		Else
		
			
			if messagebox("Deseja Alterar o Status deste Ped. para "+allt(V_Compras_01.anm_status_almox)+" ?",4+32+256,"Atenção!")=6
				
				xordem_servico=V_Compras_01.PEDIDO
				
				TEXT TO xSelReserva TEXTMERGE NOSHOW
				
					SELECT COUNT(*) as QTDE FROM PRODUCAO_RESERVA (NOLOCK) A
					--JOIN (SELECT DISTINCT ORDEM_PRODUCAO FROM WANM_PRODUCAO_TAREFAS_OS (NOLOCK)
					--		      WHERE ORDEM_SERVICO = '<<xordem_servico>>' ) B
					--		ON A.ORDEM_PRODUCAO= B.ORDEM_PRODUCAO  
					WHERE A.RESERVA > 0 
					AND A.ORDEM_PRODUCAO ='<<xordem_servico>>'
				ENDTEXT
				
				f_select(xSelReserva,"xVerifReserva")
				
				IF xVerifReserva.QTDE = 0
					MESSAGEBOX("ATENÇÃO!"+CHR(13)+"Impossível Enviar Ped., Não existe material a ser consumido.",64)
					f_select("select ANM_STATUS_ALMOX from COMPRAS where PEDIDO=?xordem_servico ","curStatsAlmox",alias())
					thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.value=curStatsAlmox.ANM_STATUS_ALMOX 
					
					thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.F.
					RETURN .F.
					o_toolbar.Botao_refresh.Click()
				ENDIF
				
				*lucas verificar saldo materiais	
				  If V_Compras_01.anm_status_almox = "1-ENVIADO PARA ALMOX" 	
				   Sele V_compras_01_reservas
				   xReg = RECCOUNT()
				   Go Top
				   
				   xMsg  = ''
				   XQMat = 0
				   xCont = 0
				   
				   Scan 		 	
				 		
				 		IF V_compras_01_reservas.Reserva > 0 and thisformset.pp_anm_valida_estoque 
					 		xCont = xCont + 1
					 		f_prog_bar("Consultando Estoque Disp. - Material: ";
					 		           +ALLTRIM(V_compras_01_reservas.Material)+" | Cor: "+ALLTRIM(V_compras_01_reservas.Cor_Material)+CHR(13)+;
					 		            "Aguarde ... "+ALLTRIM(STR(ROUND((xCont/xReg)*100,0)))+"% Concluido",xCont,xReg)
					 		           
					 		Text To xSelEDisp TextMerge NoShow
					 		
					 			SELECT * FROM FX_ANM_ESTOQUE_MAT_DISP('<<V_compras_01.Pedido>>','','<<V_compras_01.Filial_a_Entregar>>','<<V_compras_01_reservas.Material>>','<<V_compras_01_reservas.Cor_Material>>') 
					 			WHERE QTDE_ESTOQUE_DISP 	< <<V_compras_01_reservas.Reserva>>
					   		
					   		EndText
					   		
					   		f_select(xSelEDisp,"Tmp_CurEstDisp")
					   		
					   		If RecCount()>0
					   			
					   			XQMat = XQMat + 1
					   			xMsg = xMsg + CHR(13) + ALLTRIM(STR(XQMat))+ "- Material: "+ALLTRIM(Tmp_CurEstDisp.Material)+" | Cor: "+ALLTRIM(Tmp_CurEstDisp.Cor_Material)+" | Disponível: "+ALLTRIM(STR(Tmp_CurEstDisp.Qtde_Estoque_Disp,15,3))
					   		
					   		Endif	
				   		ENDIF
				   	
				   	Sele V_compras_01_reservas
				   	EndScan
					f_prog_bar()
					
					If XQMat = 1
						f_select("select ANM_STATUS_ALMOX from COMPRAS where PEDIDO=?xordem_servico ","curStatsAlmox",alias())
    					thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.value=curStatsAlmox.ANM_STATUS_ALMOX 
						MESSAGEBOX("Quantidade Reservada Maior que Quantidade Disponível do Material:" + CHR(13) + xMsg,64)
						
						thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.F.
						RETURN .f.
					Else	
						If XQMat > 1
							f_select("select ANM_STATUS_ALMOX from COMPRAS where PEDIDO=?xordem_servico ","curStatsAlmox",alias())
							thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.value=curStatsAlmox.ANM_STATUS_ALMOX 
							MESSAGEBOX("Quantidade Reservada Maior que Quantidade Disponível dos Materiais:" + CHR(13) + xMsg,64)
							
							thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.F.
							RETURN .f.
						Endif
					Endif
				
					
					Sele V_compras_01_reservas
				    Go Top					
				Endif
				*lucas verificar saldo materiais
				
				*ORDEM_SERVICO,ANM_STATUS_ALMOX,DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP
				text to	xinsert1 noshow textmerge	

						UPDATE COMPRAS SET ANM_STATUS_ALMOX='<<V_Compras_01.anm_status_almox>>'
						WHERE PEDIDO='<<xordem_servico>>' and tabela_filha = 'COMPRAS_MATERIAL'

						UPDATE COMPRAS SET ANM_DATA_INICIO_SEPARACAO=
							case 
						           when convert(int,left(convert(varchar(13),getdate(),108),2)) > <<INT(Thisformset.pp_HORA_DATA_SEPARACAO_ALMOX)>> OR
											(SELECT COUNT(*) WHERE
											DBO.LX_DATA_REAL('000994',convert(datetime,convert(varchar(13),getdate(),112)))=	
											                          convert(datetime,convert(varchar(13),getdate(),112)) ) = 0  
						           then dbo.lx_dias_uteis('000994',convert(datetime,convert(varchar(13),getdate(),112)),2)
						           else dbo.lx_dias_uteis('000994',convert(datetime,convert(varchar(13),getdate(),112)),1)
						    end
										
						WHERE PEDIDO='<<xordem_servico>>' and tabela_filha = 'COMPRAS_MATERIAL'

					INSERT INTO ANM_STATUS_COMPRAS_MP_MOV
					(PEDIDO,ANM_STATUS_ALMOX,
					DATA_ALTERACAO,DATA_SEPARA,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP)
					SELECT 
					'<<xordem_servico>>',
					'<<V_Compras_01.ANM_STATUS_ALMOX>>','<<DTOS(WDATA)>>',
					(select anm_data_inicio_separacao from COMPRAS where PEDIDO = '<<xordem_servico>>'),
					'<<WUSUARIO>>','<<SYSTEM.NetUserName>>','<<SYSTEM.NetComputerName>>',(SELECT GETDATE())

				endtext	
				
				
				if !f_insert(xinsert1) 
					messagebox("Não foi possível Alterar o Status do Pedido de Compra",48,"Atenção_8!")
					replace v_compras_01.anm_status_almox with xOldStatusAlmox
					thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.F.
					retu .f.
				endif
				

				o_toolbar.Botao_refresh.Click()
				
				f_select("select ANM_DATA_INICIO_SEPARACAO from COMPRAS where PEDIDO=?xordem_servico ","curDataIciAlmox",alias())
				
				thisformset.lx_form1.lx_pageframe1.page8.tx_data_ini_separacao.value=curDataIciAlmox.ANM_DATA_INICIO_SEPARACAO 
							
			endif	
	
		Endif	
	
	ENDIF 
	
	ENDPROC 
	
	



ENDDEFINE
*
*-- EndDefine: cmb_status_entrada
**************************************************
**************************************************
*-- Class:        tx_data_ini_separacao (c:\temp\tx_data_ini_separacao.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS tx_data_ini_separacao AS lx_textbox_base


	ControlSource = ""
	Height = 19
	Left = 430
	TabIndex = 11
	Top = 27
	Width = 80
	ZOrderSet = 8
	Name = "tx_data_ini_separacao"
	Enabled=.T.
	Visible=.T.

ENDDEFINE
*
*-- EndDefine: tx_data_ini_separacao
**************************************************
**************************************************
*-- Class:        lb_data_ini_separacao (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_data_ini_separacao AS lx_label


	Caption = "Data Separação"
	Height = 15
	Left = 334
	Top = 28
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_data_ini_separacao"
	Visible = .t.
	Anchor = 0
	Alignment=0
	FontBold = .T.
	
ENDDEFINE
*
*-- EndDefine: lb_data_ini_separacao 
**************************************************
**************************************************
*-- Class:        gs_check_entrega_direta (c:\linx desenv\classes lucas\gs_check_entrega_direta.vcx)
*-- ParentClass:  checkbox
*-- BaseClass:    checkbox
*-- Time Stamp:   04/25/17 04:32:09 PM
*
DEFINE CLASS gs_check_entrega_direta AS checkbox


	Top = 225
	Left = 620
	Height = 17
	Width = 100
	Alignment = 0
	Caption = "Entrega Direta"
	Name = "gs_check_entrega_direta"
	ControlSource="v_compras_01.gs_entrega_direta"
	FontName='TAHOMA'
	FontSize=8
	Visible = .t.

ENDDEFINE
*
*-- EndDefine: gs_check_entrega_direta
**************************************************

**************************************************
*-- Class:        gs_check_entrega_direta (c:\linx desenv\classes lucas\gs_check_entrega_direta.vcx)
*-- ParentClass:  checkbox
*-- BaseClass:    checkbox
*-- Time Stamp:   04/25/17 04:32:09 PM
*
DEFINE CLASS gs_check_estoque_terceiro AS checkbox


	Top = 225
	Left = 500
	Height = 17
	Width = 120
	Alignment = 0
	Caption = "Estoque Terceiro"
	Name = "gs_check_estoque_terceiro"
	ControlSource="v_compras_01.gs_estoque_terceiro"
	FontName='TAHOMA'
	FontSize=8
	Visible = .t.

ENDDEFINE
*
*-- EndDefine: gs_check_entrega_direta
**************************************************
**************************************************
*-- Class:        tx_data_ini_separacao (c:\temp\tx_data_ini_separacao.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS tx_gs_lote AS lx_textbox_base


	ControlSource = "v_compras_01.gs_lote"
	Height = 19
	Left = 450
	TabIndex = 11
	Top = 225
	Width = 40
	ZOrderSet = 8
	Name = "tx_gs_lote"
	Enabled=.T.
	Visible=.T.

ENDDEFINE
*
*-- EndDefine: tx_data_ini_separacao
**************************************************
**************************************************
*-- Class:        lb_data_ini_separacao (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_gs_lote AS lx_label


	Caption = "Lote"
	Height = 15
	Left = 425
	Top = 227
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_gs_lote"
	Visible = .t.
	Anchor = 0
	Alignment=0
	
ENDDEFINE
*
*-- EndDefine: lb_data_ini_separacao 
**************************************************
*!*	**************************************************
*-- Class:        ck_liberar_grade_web (c:\users\lucas.miranda\desktop\ck_liberar_grade_web.vcx)
*-- ParentClass:  lx_checkbox (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   04/08/16 02:20:05 PM
**** #1 - LUCAS.MIRANDA - 08/04/2016 - INCLUINDO A COLUNA LIBERAR WEB NA ABA CORES 
DEFINE CLASS ck_gs_material_rc AS lx_checkbox


	Top = 10
	Left = 18
	Height = 15
	Width = 88
	AutoSize = .T.
	Alignment = 0
	Caption = ""
	ControlSource = ""
	Name = "ck_gs_material_rc"
	FontName='TAHOMA'
	FontSize=8

ENDDEFINE
*
*-- EndDefine: ck_liberar_grade_web

**************************************************
*-- Class:        btn_consumo_estoque_terceiro(c:\linx desenv\classes lucas\btn_consumo_estoque_terceiro.vcx)
*-- ParentClass:  botao (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/06/14 05:29:10 PM
*
Define Class btn_gs_consumo_terceiro As botao


	Top = 46
	Left = 429
	Height = 23
	Width = 110
	FontBold = .T. 
	FontName = 'TAHOMA'
	Caption = "Consumo Terceiro"
	ForeColor = Rgb(0,0,0)
	Name = "btn_gs_consumo_terceiro"
	Visible = .T.


	Procedure Click
	
		If Thisformset.pp_gs_perm_bt_cons_terceiro = .F.
			MESSAGEBOX("Você não tem permissão para gerar consumo de Terceiros !!!",0+16)
			Return .F.
		Endif	
		
		if used("CurConsumoTerceiroLote")
			use in CurConsumoTerceiroLote
		endif
		
		if used("CurVerifConsumo")
			use in CurVerifConsumo
		endif
		
		F_WAIT("Aguarde, Consumindo Estoque Terceiro !!!")
		TEXT TO xConsumoTerceiroLote NOSHOW TEXTMERGE
			DECLARE 	@FILIAL	VARCHAR(19), @PEDIDO_PROC CHAR(8),	@MATERIAL_PROC CHAR(11),	@COR_MATERIAL_PROC CHAR(10),	@QTDE_CONSUMIR_PROC DECIMAL(10,3)
			DECLARE curAgrup CURSOR FOR 
				SELECT  COMPRAS.FORNECEDOR, COMPRAS.PEDIDO, PRODUCAO_RESERVA.MATERIAL, PRODUCAO_RESERVA.COR_MATERIAL, PRODUCAO_RESERVA.RESERVA AS QTDE_A_CONSUMIR  

				FROM COMPRAS (nolock) COMPRAS
				join (select ORDEM_PRODUCAO, MATERIAL, COR_MATERIAL, SUM(reserva) as reserva 
						from PRODUCAO_RESERVA (nolock)
						group by ORDEM_PRODUCAO, MATERIAL, COR_MATERIAL) PRODUCAO_RESERVA
				ON COMPRAS.PEDIDO = PRODUCAO_RESERVA.ORDEM_PRODUCAO
				AND COMPRAS.TABELA_FILHA = 'COMPRAS_MATERIAL'
			
				WHERE PRODUCAO_RESERVA.reserva > 0
				AND COMPRAS.GS_ESTOQUE_TERCEIRO = 1
				AND COMPRAS.STATUS_APROVACAO <> ('R')
				AND COMPRAS.PEDIDO =?V_COMPRAS_01.PEDIDO
			OPEN curAgrup    
			FETCH NEXT FROM curAgrup INTO @FILIAL, @PEDIDO_PROC, @MATERIAL_PROC, @COR_MATERIAL_PROC, @QTDE_CONSUMIR_PROC
			WHILE @@FETCH_STATUS = 0  
			BEGIN    
				EXEC LX_ANM_GERA_CONSUMO_TERCEIRO @FILIAL, @PEDIDO_PROC, @MATERIAL_PROC, @COR_MATERIAL_PROC, @QTDE_CONSUMIR_PROC												  						
														  
				FETCH NEXT FROM curAgrup INTO @FILIAL, @PEDIDO_PROC, @MATERIAL_PROC, @COR_MATERIAL_PROC, @QTDE_CONSUMIR_PROC
			END    
			CLOSE curAgrup    
			DEALLOCATE curAgrup   
		ENDTEXT
												
		f_select(xConsumoTerceiroLote,"CurConsumoTerceiroLote")
		F_WAIT()
			
		TEXT TO xVerifConsumo NOSHOW TEXTMERGE
			SELECT ORDEM_PRODUCAO, MATERIAL, COR_MATERIAL, SUM(RESERVA) AS RESERVA 
			FROM PRODUCAO_RESERVA 
			WHERE ORDEM_PRODUCAO=?V_COMPRAS_01.PEDIDO
			GROUP BY ORDEM_PRODUCAO, MATERIAL, COR_MATERIAL
		ENDTEXT
												
		f_select(xVerifConsumo,"CurVerifConsumo")
		
		If CurVerifConsumo.reserva > 0
			MESSAGEBOX("Ainda existe(m) material(is) sem consumo !!!",0+48)
		Else
			MESSAGEBOX("Material(is) consumido(s) !!!",0+64)
			o_toolbar.botao_refresh.Click()
		Endif
		
				
Enddefine
*
*-- EndDefine: btn_gs_consumo_terceiro
**************************************************

**************************************************
*-- Class:        btn_cond_pgto_ori (c:\linx desenv\classes lucas\btn_cond_pgto_ori.vcx)
*-- ParentClass:  botao (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/21/17 11:07:12 AM
*
DEFINE CLASS btn_cond_pgto_ori AS botao


	Top = 3
	Left = 15
	Height = 17
	Width = 21
	Caption = "..."
	Name = "btn_cond_pgto_ori"
	ToolTipText = "Visualizar Pgto Original"
	Visible = .F.
	
	Procedure Click
		
		If Thisformset.p_tool_status $ 'LP'
			Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.Visible=!Thisformset.lx_form1.lx_pageframe1.page1.cnt_gs_cond_pgto_ori.Visible
		Endif	
	
	
ENDDEFINE
*
*-- EndDefine: btn_cond_pgto_ori
**************************************************

**************************************************
*-- Class:        cnt_gs_cond_pgto_ori (c:\linx desenv\classes lucas\cnt_gs_cond_pgto_ori.vcx)
*-- ParentClass:  lx_container (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    container
*-- Time Stamp:   09/21/17 09:30:02 AM
*
DEFINE CLASS cnt_gs_cond_pgto_ori AS lx_container


	Top = 0
	Left = 38
	Width = 235
	Height = 25
	Name = "cnt_gs_cond_pgto_ori"
	BorderWidth = 0
	Visible = .F.
	
ENDDEFINE
*
*-- EndDefine: cnt_gs_cond_pgto_ori
**************************************************

**************************************************
*-- Class:        gs_cond_pgto_ori (c:\linx desenv\classes lucas\lx_gs_cond_pgto_ori.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- Time Stamp:   09/20/17 11:56:07 AM
*
DEFINE CLASS lx_lbl_gs_cond_ori AS lx_label
				
	FontSize = 8
	Caption = "Pgto Orig."
	Height = 15
	Left = 20
	Top = 6
	Width = 71
	TabIndex = 39
	ZOrderSet = 25
	Name = "lx_lbl_gs_cond_ori"
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: gs_cond_pgto_ori
**************************************************
**************************************************
*-- Class:        gs_cond_pgto_ori (c:\linx desenv\classes lucas\lx_gs_cond_pgto_ori.vcx)
*-- ParentClass:  container
*-- BaseClass:    container
*-- Time Stamp:   09/20/17 11:56:07 AM

DEFINE CLASS lx_txt_gs_cond_pgto_ori AS lx_textbox_base


	ControlSource = ""
	Height = 19
	Left = 116
	Top = 4
	Width = 115
	Name = "lx_txt_gs_cond_pgto_ori"
	Visible=.T.


ENDDEFINE

*
*-- EndDefine: gs_cond_pgto_ori
**************************************************

**************************************************
*-- Class:        lx_tv_gs_cond_pgto_ori_l (c:\linx desenv\classes lucas\lx_tv_gs_cond_pgto_ori_l.vcx)
*-- ParentClass:  lx_textbox_valida (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   09/20/17 06:31:08 PM
*
DEFINE CLASS lx_tv_gs_cond_pgto_ori AS lx_textbox_valida


	ControlSource = "V_COMPRAS_01.GS_CONDICAO_PGTO_ORI"
	Height = 19
	Left = 73
	Top = 4
	Width = 42
	p_valida_coluna = "CONDICAO_PGTO"
	p_valida_coluna_tabela = "COND_ENT_PGTOS"
	p_valida_where = "AND CONDICAO_ESPECIAL = 0"
	Name = "Lx_tv_gs_cond_pgto_ori"
	Visible=.T.

ENDDEFINE
*
*-- EndDefine: lx_tv_gs_cond_pgto_ori_l
**************************************************