define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
		
		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
		DO CASE
			CASE UPPER(XMETODO) == 'USR_INIT'
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 

				** Tiago Carvalho - Sintese Soluções - 23/04/2014 - Botão para Impressão de Etiqueta termica para material e Cor
				with THISFORMSET.LX_FORM1.LX_PAGEFRAME1.PAGE1.LX_GRID_FILHA1
					lcColumnCount = .columncount 
					lcColumnCount = lcColumnCount + 1 
				    .addcolumn(lcColumnCount )
					.columns[lcColumnCount].name = 'col_etiqueta'
					.col_etiqueta.width = 70
					.col_etiqueta.columnorder = 1
					.col_etiqueta.header1.caption = 'Etiqueta'
					.col_etiqueta.header1.alignment = 2
					.col_etiqueta.header1.FONTSIZE = 8
					.col_etiqueta.BackColor = 15399423
					.col_etiqueta.addobject('bt_etiqueta','bt_etiqueta')
					.col_etiqueta.currentcontrol = 'bt_etiqueta'
					.col_etiqueta.removeobject('text1')
					.col_etiqueta.currentcontrol = 'bt_etiqueta'
					.col_etiqueta.sparse = .F.
					.col_etiqueta.refresh()
				ENDWITH
									
				** Variável para guardar o valor original do parametro *** Variável é retornada no métodio USR_ALTER_BEFORE para voltar ao original **
				Public Old_pp_altera_custo_mp
				Old_pp_altera_custo_mp = thisformset.pp_altera_custo_mp 
				** FIM - Variável para guardar o valor original do parametro ** 
				
				** Lucas Miranda - 15/03/2017 - Validação NCM
					sele v_materiais_00
					xalias_pai=alias()
					
					oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("MATERIAIS.GS_VALIDA_NCM", "L",.T., "Validação NCM", "MATERIAIS.GS_VALIDA_NCM")
					oCur.addbufferfield("MATERIAIS.GS_PORCENTAGEM_CONSUMO_FT", "N(9,3)",.T., "Porc. Consumo", "MATERIAIS.GS_PORCENTAGEM_CONSUMO_FT")
					oCur.addbufferfield("MATERIAIS.GS_TAMANHO_TECIDOTECA", "C(25)",.T., "Tam. Tecidoteca", "MATERIAIS.GS_TAMANHO_TECIDOTECA")
					oCur.addbufferfield("MATERIAIS.GS_PERSONALIZACAO_TECIDOTECA", "C(25)",.T., "Per. Tecidoteca", "MATERIAIS.GS_PERSONALIZACAO_TECIDOTECA")
					oCur.addbufferfield("MATERIAIS.GS_AGRUPAMENTO_COR_TECIDOTECA", "C(25)",.T., "Agr. cor Tecidoteca", "MATERIAIS.GS_AGRUPAMENTO_COR_TECIDOTECA")			
					oCur.confirmstructurechanges() 
					
				** Fim Validação NCM
				f_select("select '' as status_aprovacao union all select status_aprovacao  from GS_ESTAMPAS_STATUS ","xstatus_stampa")	
				** Lucas Miranda - 17/03/2015 - Adicionado uma nova coluna ANM_DESENHO_ESTAMPA, FARM_COLECAO
							sele v_materiais_00_cores
								xalias=ALIAS()

								oCur = getcursoradapter(xalias)
								oCur.addbufferfield("materiais_cores.anm_desenho_estampa", "C(10)",.T., "Desenho/Estampa", "materiais_cores.anm_desenho_estampa")
								oCur.addbufferfield("MATERIAIS_CORES.FARM_COLECAO", "C(6)",.T., "COLECAO", "MATERIAIS_CORES.FARM_COLECAO")	
								oCur.addbufferfield("MATERIAIS_CORES.ANM_RECORRENTES", "L",.F., "RECORRENTES", "MATERIAIS_CORES.ANM_RECORRENTES")	
								oCur.addbufferfield("MATERIAIS_CORES.GS_STATUS_ESTAMPA", "C(40)",.T., "STATUS ESTAMPA", "MATERIAIS_CORES.GS_STATUS_ESTAMPA")
								oCur.confirmstructurechanges() 
							
							
							with THISFORMSET.LX_FORM1.LX_PAGEFRAME1.PAGE1.LX_GRID_FILHA1 
												xcColumnCount = .columncount
												xcColumnCount = xcColumnCount + 1 
									.addcolumn(xcColumnCount)
									.columns[xcColumnCount].name = 'col_anm_desenho_estampa'
									.col_anm_desenho_estampa.width = 100
									.col_anm_desenho_estampa.columnorder = 9
									.col_anm_desenho_estampa.header1.caption = 'Desenho/Estampa'
									.col_anm_desenho_estampa.header1.alignment = 2
									.col_anm_desenho_estampa.header1.FONTSIZE = 8
									.col_anm_desenho_estampa.refresh()
									.col_anm_desenho_estampa.ControlSource='v_materiais_00_cores.anm_desenho_estampa'
									

									.col_tx_REFER_FABRICANTE.width=110
									.ColumnCount=thisform.lx_PAGEFRAME1.page1.LX_GRID_FILHA1.ColumnCount+1
									.column1.header1.FontName ='tahoma'
									.column1.header1.FontSize =8
									.column1.header1.Alignment = 2
									.column1.header1.caption = 'Coleção'
									.column1.width = 80
									.column1.columnorder = 7
									.column1.ControlSource='V_MATERIAIS_00_CORES.FARM_COLECAO'
									.column1.text1.FontName ='tahoma'
									.column1.text1.FontSize =8		
									.column1.text1.format ="!"						
							endwith
	
							*** Tipo Recorrentes - Lucas Miranda - 22/11/2016
							with THISFORMSET.LX_FORM1.LX_PAGEFRAME1.PAGE1.LX_GRID_FILHA1 
									lcColumnCount = .columncount 
									lcColumnCount = lcColumnCount + 1 
								    .addcolumn(lcColumnCount )
									.columns[lcColumnCount].name ='cl_Recorrentes'
									WITH .cl_Recorrentes
											.BackColor = 15399423
											.Header1.FONTSIZE =8
											.Header1.FontName ='tahoma'
											.Header1.Alignment = 2
											.Header1.Name='h_Recorrentes'
											.h_Recorrentes.Caption='Recorrentes'
											.AddObject('ck_recorrentes','CheckBox')
											.Sparse= .F.
											.CurrentControl = 'ck_recorrentes'
											.ck_recorrentes.Caption=""
											.ColumnOrder = 14
											.ck_recorrentes.BackStyle = 0
											.ck_recorrentes.Visible = .T.
											.ck_recorrentes.Enabled = .F.
											.RemoveObject("text1") 
											.ControlSource="v_materiais_00_cores.anm_recorrentes"
									ENDWITH	
						   ENDWITH
					 
					  with THISFORMSET.LX_FORM1.LX_PAGEFRAME1.PAGE1.LX_GRID_FILHA1 
						lcColumnCount = .ColumnCount
						lcColumnCount = lcColumnCount + 1
						.AddColumn(lcColumnCount )
						.Columns[lcColumnCount].Name = 'col_status_estampa'
							.col_status_estampa.Width = 150
							*.col_periodo_cor.BackColor = 15399423
							.col_status_estampa.ColumnOrder = 9
							.col_status_estampa.header1.Caption = 'Status Aprovação'
							.col_status_estampa.header1.Alignment = 2
							.col_status_estampa.header1.FontSize = 8
							.col_status_estampa.header1.FontName ='tahoma'
							.col_status_estampa.RemoveObject('text1')
							.col_status_estampa.AddObject('cmb_status_estampa','cmb_status_estampa')
							.col_status_estampa.Sparse = .F.
							.col_status_estampa.Refresh()
							.col_status_estampa.cmb_status_estampa.RowSource="xstatus_stampa.status_aprovacao"
							.col_status_estampa.ControlSource="v_materiais_00_cores.gs_status_estampa"
						 ENDWITH

						*** #1 - LUCAS MIRANDA - 22/03/2016 - LIBERAR CAMPO COD.BASE VARIANTE E HAB PECA PARTIDA
							with thisformset.lx_form1.lx_pageframe1.Page1
								.addobject("btn_anm_peca","btn_anm_peca")
							endwith	
								
						*** #1 - LUCAS MIRANDA - 22/03/2016
						
						** Lucas Miranda - 15/03/2017 - Validação NCM **
						with thisformset.lx_form1.lx_pageframe1.Page8
							.addobject("btn_gsncm","btn_gsncm")
						endwith
						
						with thisformset.lx_form1.lx_pageframe1.Page8.lx_PAGEFRAME1.page1	
							.addobject("lx_gscheck","lx_gscheck")
							.lx_gscheck.ControlSource="v_materiais_00.gs_valida_ncm"
						endwith	
						** Fim Validação NCM **
						
						** Porc. Consumo **
						with thisformset.lx_form1.lx_pageframe1.page1
							.addobject("lx_gstxt_base_consumo","lx_gstxt_base_consumo")
							.addobject("gs_label_porc_consumo","gs_label_porc_consumo")						
						 endwith
						** Fim Porc. Consumo
						
						**Gustavo Stutzel - 21/05/2018 - Aba de complemento **
						f_select("select TAMANHO from GS_TAMANHO_TECIDOTECA","curTamTecido",ALIAS())
						f_select("select AGRUPAMENTO_COR from GS_AGRUPAMENTO_COR_TECIDOTECA","curAgrupTecido",ALIAS())
						f_select("select PERSONALIZACAO from GS_PERSONALIZACAO_TECIDOTECA","curPersoTecido",ALIAS())
						
						thisformset.lx_form1.lx_pageframe1.PageCount = thisformset.lx_form1.lx_pageframe1.PageCount+1
						WITH thisformset.lx_form1.lx_pageframe1.page11
									.Caption = 'Info. Adicional'					
									.FontName ='tahoma'
									.FONTSIZE = 8
									.addobject('gs_label_tamanho','gs_label_tamanho')
									.addobject('gs_label_personalizacao','gs_label_personalizacao')
									.addobject('gs_label_agrupamento_cor','gs_label_agrupamento_cor')
									.addobject('cmb_tamanho','cmb_tamanho')
									.cmb_tamanho.RowSource="curTamTecido.TAMANHO"
									.cmb_tamanho.Enabled = .T.
									.addobject('cmb_personalizacao','cmb_personalizacao')
									.cmb_personalizacao.RowSource="curPersoTecido.PERSONALIZACAO"
									.cmb_personalizacao.Enabled=.t.
									.addobject('cmb_agrupamento_cor','cmb_agrupamento_cor')
									.cmb_agrupamento_cor.RowSource="curAgrupTecido.AGRUPAMENTO_COR"
									.cmb_agrupamento_cor.Enabled = .T.
						ENDWITH
						
						Thisformset.L_limpa()
						
							if	!f_vazio(xalias)	
								sele &xalias 
							endif	 
										
				
			CASE UPPER(XMETODO) == 'USR_INCLUDE_AFTER'
				
				xalias=alias()
				
			
			If Type("ThisFormSet.pp_tipo_material") == "C" and THISFORMSET.P_TOOL_STATUS =='I'	 
			
				lcFilial = ThisFormSet.pp_anm_filial_armazem
 				f_select("select ESTOQUE_CTRL_PECA from filiais where filial = ?lcFilial","xFiltrl")
				SELE xFiltrl

					IF RECCOUNT("xFiltrl")>0
						replace V_MATERIAIS_00.CTRL_PARTIDAS 		WITH xFiltrl.ESTOQUE_CTRL_PECA		IN V_MATERIAIS_00
						replace V_MATERIAIS_00.CTRL_PECAS 			WITH xFiltrl.ESTOQUE_CTRL_PECA		IN V_MATERIAIS_00
						replace V_MATERIAIS_00.CTRL_PECAS_PARCIAL 	WITH xFiltrl.ESTOQUE_CTRL_PECA		IN V_MATERIAIS_00
						
						ThisFormSet.lx_FORM1.lx_pageframe1.page1.Ck_CTRL_PARTIDAS.Refresh ()
						ThisFormSet.lx_FORM1.lx_pageframe1.page1.Ck_CTRL_PECAS.Refresh ()
						ThisFormSet.lx_FORM1.lx_pageframe1.page1.ck_CTRL_PECAS_PARCIAL.Refresh ()				
					ENDIF				

			ENDIF
				
				if !f_vazio(xalias)
					sele &xalias
				endif			
			
			CASE UPPER(XMETODO) == 'USR_ALTER_BEFORE'  
				
				xalias=alias()
				
					** Retornar Variável Original **
					thisformset.pp_altera_custo_mp = Old_pp_altera_custo_mp
					** FIM - Retornar Variável Original **
				
				if !f_vazio(xalias)
					sele &xalias
				endif
			
			
			CASE UPPER(XMETODO) == 'USR_WHEN'  
				
				xalias=alias()	
					
					** Julio - 07-03-2014 - Bloqueia alterar preço de materiais com entrada de nota fiscal **
					If upper(xnome_obj) = 'TX_CUSTO_REPOSICAO'
						
						Text To SelConfEnt TextMerge Noshow
						
						 SELECT COUNT(*) as QTDE_ENT_NF 
							FROM ESTOQUE_RET1_MAT AS A (NOLOCK)
								    JOIN ESTOQUE_RET_MAT AS B (NOLOCK) 
										ON  A.REQ_MATERIAL = B.REQ_MATERIAL 
										AND A.FILIAL = B.FILIAL
									 JOIN MATERIAIS_CORES AS M (NOLOCK) 
										ON  M.MATERIAL = A.MATERIAL 
										AND A.COR_MATERIAL = M.COR_MATERIAL
								     JOIN ENTRADAS AS C (NOLOCK) 
										ON  C.NOME_CLIFOR = B.NOME_CLIFOR 
										AND C.NF_ENTRADA = B.NF_ENTRADA 
										AND C.SERIE_NF_ENTRADA = B.SERIE_NF_ENTRADA	     
									JOIN (SELECT SUM(QTDE_ESTOQUE) AS QTDE_ESTOQUE,MATERIAL,COR_MATERIAL 
											FROM ESTOQUE_MATERIAIS 
											GROUP BY MATERIAL,COR_MATERIAL 
											HAVING SUM(QTDE_ESTOQUE) > 0 ) D
										ON  M.MATERIAL = D.MATERIAL 
										AND A.COR_MATERIAL = D.COR_MATERIAL	
											JOIN COMPRAS E
											ON A.PEDIDO = E.PEDIDO	
							WHERE A.MATERIAL = '<<V_MATERIAIS_00_CORES.MATERIAL>>' AND A.COR_MATERIAL = '<<V_MATERIAIS_00_CORES.COR_MATERIAL>>'
							  AND TIPO_COMPRA NOT IN  (SELECT * FROM dbo.FXANM_ConsultaVarString(
														(SELECT dbo.FX_ANM_PARAMETRO_USER('ANM_TIPO_COMPRA_MOST'))+','+
														(SELECT dbo.FX_ANM_PARAMETRO_USER('ANM_TIPO_COMPRA_PILOT_AUT')) ) )    

						Endtext
						
						Sele V_MATERIAIS_00_CORES
						f_select(SelConfEnt,"xConfNfEnt") 
						
						If xConfNfEnt.QTDE_ENT_NF > 0 And V_MATERIAIS_00_CORES.CUSTO_REPOSICAO > 0 
						       
						       MESSAGEBOX("Você não tem permissão de alterar esta informação !!!",16)
						       RETURN .f.
						Endif

					Endif
					** FIM - Julio - 07-03-2014 - Bloqueia alterar preço de materiais com entrada de nota fiscal **
					
					** solicitação feita pela Luciana Oliveira - 17/08/2015 - Lucas miranda
					If upper(xnome_obj) = 'CMB_TRIBUT_ORIGEM'
						IF THISFORMSET.P_TOOL_STATUS =='I' OR THISFORMSET.P_TOOL_STATUS =='A'
							If v_materiais_00.tribut_origem = '1'
								F_SELECT("SELECT ID_EXCECAO_GRUPO,DESC_EXCECAO_GRUPO FROM CTB_EXCECAO_GRUPO WHERE ID_EXCECAO_GRUPO = ?o_003008.pp_anm_grup_exc_imposto_padr","xDescExc")
									if !F_VAZIO(xDescExc.ID_EXCECAO_GRUPO)
										REPLACE v_materiais_00.id_excecao_grupo WITH xDescExc.ID_EXCECAO_GRUPO
										replace v_materiais_00.desc_excecao_grupo WITH xDescExc.DESC_EXCECAO_GRUPO 
									endif
								
								THISFORMSET.lx_form1.lx_PAGEFRAME1.page8.lx_PAGEFRAME1.page1.refresh()
							Endif
						Endif	
					Endif					
				if !f_vazio(xalias)
					sele &xalias
				endif
				
				
				
			CASE UPPER(XMETODO) == 'USR_VALID'  
				xalias=alias()
				** Tiago Carvalho - SS - Marca o o controle de peças com base no cadastro de tipos.
				IF (UPPER(XNOME_OBJ) == 'TV_TIPO_MATERIAL' OR upper(xnome_obj)== 'CMB_SUBGRUPO' ) AND THISFORMSET.P_TOOL_STATUS =='I'
					f_select ("SELECT TIPO, CTRL_PARTIDAS = ISNULL(CTRL_PARTIDAS,0),CTRL_PECAS = ISNULL(CTRL_PECAS,0),CTRL_PECAS_PARCIAL = ISNULL(CTRL_PECAS_PARCIAL,0) FROM MATERIAIS_TIPO where tipo = ?V_MATERIAIS_00.TIPO","CurTipo")
					
					IF RECCOUNT("CurTipo")>0
						replace V_MATERIAIS_00.CTRL_PARTIDAS 		WITH CurTipo.CTRL_PARTIDAS 		IN V_MATERIAIS_00
						replace V_MATERIAIS_00.CTRL_PECAS 			WITH CurTipo.CTRL_PECAS 		IN V_MATERIAIS_00
						replace V_MATERIAIS_00.CTRL_PECAS_PARCIAL 	WITH CurTipo.CTRL_PECAS_PARCIAL IN V_MATERIAIS_00
						
						thisformset.lx_FORM1.lx_pageframe1.page1.Ck_CTRL_PARTIDAS.Refresh ()
						thisformset.lx_FORM1.lx_pageframe1.page1.Ck_CTRL_PECAS.Refresh ()
						thisformset.lx_FORM1.lx_pageframe1.page1.ck_CTRL_PECAS_PARCIAL.Refresh ()
					ENDIF
				ENDIF	
				 
				** Lucas Miranda - Grupo Soma - 03/05/2018 - Marca o controle de peças com base no cadastro de tipos
				IF (UPPER(XNOME_OBJ) == 'CK_CTRL_PARTIDAS' OR upper(xnome_obj)== 'CK_CTRL_PECAS' OR upper(xnome_obj)== 'CK_CTRL_PECAS_PARCIAL' ) AND THISFORMSET.P_TOOL_STATUS =='I'
					f_select ("SELECT TIPO, CTRL_PARTIDAS = ISNULL(CTRL_PARTIDAS,0),CTRL_PECAS = ISNULL(CTRL_PECAS,0),CTRL_PECAS_PARCIAL = ISNULL(CTRL_PECAS_PARCIAL,0) FROM MATERIAIS_TIPO where tipo = ?V_MATERIAIS_00.TIPO","CurTipoValid")
					Sele CurTipoValid
					IF RECCOUNT("CurTipoValid")>0
						IF V_MATERIAIS_00.ctrl_partidas != CurTipoValid.ctrl_partidas OR V_MATERIAIS_00.CTRL_PECAS != CurTipoValid.ctrl_pecas OR V_MATERIAIS_00.CTRL_PECAS_PARCIAL != CurTipoValid.ctrl_pecas_parcial	
							replace V_MATERIAIS_00.CTRL_PARTIDAS 		WITH CurTipoValid.CTRL_PARTIDAS 	 IN V_MATERIAIS_00 
							replace V_MATERIAIS_00.CTRL_PECAS 			WITH CurTipoValid.CTRL_PECAS 		 IN V_MATERIAIS_00
							replace V_MATERIAIS_00.CTRL_PECAS_PARCIAL 	WITH CurTipoValid.CTRL_PECAS_PARCIAL IN V_MATERIAIS_00
											
							thisformset.lx_FORM1.lx_pageframe1.page1.Ck_CTRL_PARTIDAS.Refresh ()
							thisformset.lx_FORM1.lx_pageframe1.page1.Ck_CTRL_PECAS.Refresh ()
							thisformset.lx_FORM1.lx_pageframe1.page1.ck_CTRL_PECAS_PARCIAL.Refresh ()
						ENDIF	
					ENDIF 
				ENDIF
					
				IF (upper(xnome_obj)== 'TV_TIPO_MATERIAL' OR upper(xnome_obj)== 'CMB_GRUPO') AND THISFORMSET.P_TOOL_STATUS <> 'L'	
					SELE V_MATERIAIS_00					
				  	IF V_MATERIAIS_00.GRUPO = 'ETIQUETAS' AND  !'AVIAMENTO' $ ALLTRIM(V_MATERIAIS_00.TIPO)
						THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL.value = '113103'
						THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_COMPRA.value = '3.2.1.10.01'
						THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_DEV_COMPRA.value = '3.2.1.10.02'
						
						IF THISFORMSET.P_TOOL_STATUS =='I'
							THISFORMSET.lx_form1.lx_pageframe1.page8.lx_pageframe1.page1.comboItemSped.Value='01'
						ENDIF	
					ELSE
						IF 'PANOS' $ V_MATERIAIS_00.TIPO
							THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL.value = '113101'
							THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_COMPRA.value = '351103'
							THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_DEV_COMPRA.value = '351104'
							
							IF THISFORMSET.P_TOOL_STATUS =='I'
								THISFORMSET.lx_form1.lx_pageframe1.page8.lx_pageframe1.page1.comboItemSped.Value='01'
							ENDIF
						ELSE
							IF 'AVIAMENTO' $ V_MATERIAIS_00.TIPO OR 'JÓIAS' $ V_MATERIAIS_00.TIPO
								THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL.value = '113103'
								THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_COMPRA.value = '351112'
								THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_DEV_COMPRA.value = '351113'
								
								IF THISFORMSET.P_TOOL_STATUS =='I'
									THISFORMSET.lx_form1.lx_pageframe1.page8.lx_pageframe1.page1.comboItemSped.Value='01'
								ENDIF
							ELSE
								IF 'CONSUMIVEIS' $ V_MATERIAIS_00.TIPO
									THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL.value = '113401'
									THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_COMPRA.value = '113401'
									THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_DEV_COMPRA.value = '351113'
									
									IF THISFORMSET.P_TOOL_STATUS =='I'
										THISFORMSET.lx_form1.lx_pageframe1.page8.lx_pageframe1.page1.comboItemSped.Value='01'
									ENDIF
								ELSE
									THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL.value = '113103'
									THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_COMPRA.value = '351103'
									THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_DEV_COMPRA.value = '351104'	
									
									IF THISFORMSET.P_TOOL_STATUS =='I'
										THISFORMSET.lx_form1.lx_pageframe1.page8.lx_pageframe1.page1.comboItemSped.Value='01'
									ENDIF		
								ENDIF		
							ENDIF	 
						ENDIF
					ENDIF	
				 ENDIF	
				
				if !f_vazio(xalias)
					sele &xalias
				ENDIF
				 
			CASE UPPER(XMETODO) == 'USR_REFRESH' 
				xalias=alias()
				
				* Validação NCM *
				Thisformset.lx_form1.lx_PAGEFRAME1.Page8.lx_PAGEFRAME1.page1.lx_textbox_base2.Width=380
				* Fim Validação NCM
				***** Lucas Miranda, ANM_DESENHO_ESTAMPA e FARM_COLECAO *****
				if type("thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.COL_ANM_DESENHO_ESTAMPA") <> "U" AND TYPE("thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.column1") <> "U"
				
					if thisformset.p_tool_status $ 'IA' 
						thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.COL_ANM_DESENHO_ESTAMPA.Enabled = .T.
						thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.column1.Enabled = .T.
						thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.col_status_estampa.Enabled = .T.
					else
						thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.COL_ANM_DESENHO_ESTAMPA.Enabled = .F.
						thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.column1.Enabled = .F.
						thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.col_status_estampa.Enabled = .F.
					endif
				endif
				***** Fim - Lucas Miranda *****	
				*** Tipo Recorrentes - Lucas Miranda - 22/11/2016
				IF TYPE("thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.cL_RECORRENTES") <> "U"
					if thisformset.p_tool_status $ 'IA' 
						thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.cL_RECORRENTES.Enabled = .T.
					else
						thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.cL_RECORRENTES.Enabled = .F.
					endif
				endif
				*** Fim - Tipo Recorrentes - Lucas Miranda - 22/11/2016
				
				*** #1 - LUCAS MIRANDA - 22/03/2016 - LIBERAR CAMPO COD.BASE VARIANTE E HAB PECA PARTIDA
				
					IF THISFORMSET.P_TOOL_STATUS =='A'
						thisformset.lx_form1.lx_pageframe1.page1.Btn_anm_peca.Visible= thisformset.PP_anm_per_alt_ctrlesp
							If V_Materiais_00.varia_material_tamanho = .T.
								thisformset.lx_form1.lx_pageframe1.Page1.Lx_textbox_base1.Enabled=.t.
							Else	
								thisformset.lx_form1.lx_pageframe1.Page1.Lx_textbox_base1.Enabled=.F.
							Endif
					Else
						if type("thisformset.lx_form1.lx_pageframe1.page1.Btn_anm_peca") <> "U"	
							thisformset.lx_form1.lx_pageframe1.page1.Btn_anm_peca.Visible=.F.		
						Endif
					Endif	

				*** FIM - #1 - LUCAS MIRANDA ***
				
				 ** Gustavo Stutzel -- Libera campos da aba de informações adicionais**
				 if type("thisformset.lx_foRM1.lx_pageframe1.page11.cmb_tamanho") <> "U"
					
					 if thisformset.p_tool_status $ 'IAL' 
					 	thisformset.lx_foRM1.lx_pageframe1.page11.refresh()
						thisformset.lx_foRM1.lx_pageframe1.page11.cmb_tamanho.Enabled=.t.
						thisformset.lx_foRM1.lx_pageframe1.page11.cmb_agrupamento_cor.Enabled=.t.
						thisformset.lx_foRM1.lx_pageframe1.page11.cmb_personalizacao.Enabled=.t.
						*thisformset.lx_form1.lx_pageframe1.page11.lx_obs_pers.Enabled = .t.
					 ELSE
					    IF thisformset.p_tool_status $ 'P'
					 		thisformset.lx_foRM1.lx_pageframe1.page11.cmb_tamanho.Enabled=.f.
							thisformset.lx_foRM1.lx_pageframe1.page11.cmb_agrupamento_cor.Enabled=.f.
							thisformset.lx_foRM1.lx_pageframe1.page11.cmb_personalizacao.Enabled=.f.
							*thisformset.lx_form1.lx_pageframe1.page11.lx_obs_pers.Enabled = .f.
						endif
					 Endif
				 endif
				 **Fim -- Gustavo Stutzel**
				
				** Lucas Miranda - 15/03/2017 - Validação NCM **
				If TYPE("thisformset.lx_form1.lx_pageframe1.Page8.btn_gsncm") <> "U"
					if thisformset.p_tool_status == 'L' 
						thisformset.lx_form1.lx_pageframe1.Page8.btn_gsncm.enabled=Thisformset.pp_anm_validacao_ncm
					ELSE
						thisformset.lx_form1.lx_pageframe1.Page8.btn_gsncm.enabled=.f.
					endif
				Endif
				If TYPE("thisformset.lx_form1.lx_pageframe1.Page8.lx_PAGEFRAME1.page1.lx_gscheck") <> "U"
					if thisformset.p_tool_status == 'L' 
						thisformset.lx_form1.lx_pageframe1.Page8.lx_PAGEFRAME1.page1.lx_gscheck.enabled=.T.
					else	
					 	thisformset.lx_form1.lx_pageframe1.Page8.lx_PAGEFRAME1.page1.lx_gscheck.enabled=Thisformset.pp_anm_validacao_ncm
					endif
				Endif
				** Fim Validação NCM **
			 	 
			 	**** Porc. Consumo ***
			 	IF TYPE("thisformset.lx_form1.lx_pageframe1.page1.gs_label_porc_consumo") <> "U"
					if thisformset.p_tool_status $ 'IA' 
						thisformset.lx_form1.lx_pageframe1.page1.lx_gstxt_base_consumo.Enabled = thisformset.pp_gs_perm_alt_cons_material
					else
						If thisformset.p_tool_status $ 'L'
							thisformset.lx_form1.lx_pageframe1.page1.lx_gstxt_base_consumo.Enabled = .T.
						Else
							IF thisformset.p_tool_status $ 'P'
								thisformset.lx_form1.lx_pageframe1.page1.lx_gstxt_base_consumo.Enabled = .F.	
							Endif	
						Endif	
					endif
				ENDIF

			 	**** Fim Porc. Consumo
				if !f_vazio(xalias)
					sele &xalias
				endif
 
			
			CASE UPPER(XMETODO) == 'USR_SAVE_BEFORE' 
				xalias=alias()
				
				*** Bloqueio Semi-Acabado - Lucas Miranda - 08/02/2018
				f_select("select * from materiais_tipo (nolock) where tipo = ?v_materiais_00.tipo","CTipoMat",ALIAS())
								
				IF !(THISFORMSET.P_TOOL_STATUS =='E')
*!*						if v_materiais_00.semi_acabado > 0 AND CTipoMat.indica_tecido = .t.
*!*							Thisformset.lx_form1.lx_pageframe1.page7.lx_pageframe.page1.lx_tool_filhas.Botao_top.Click					
*!*							Sele v_materiais_00_cores
*!*							go top
*!*							Scan 
*!*								Sele v_materiais_00_ficha_tecnica
*!*								LOCATE FOR material = v_materiais_00_cores.material AND cor_material = v_materiais_00_cores.cor_material
*!*								If !FOUND("v_materiais_00_ficha_tecnica") AND v_materiais_00_cores.inativo = .F.

*!*									MESSAGEBOX("Falta informar Semi-Acabado, favor verificar !!!",0+16)
*!*									Return .F.
*!*								Endif
*!*									
*!*								Thisformset.lx_form1.lx_pageframe1.page7.lx_pageframe.page1.lx_tool_filhas.botao_proximo.Click
*!*							Sele v_materiais_00_cores
*!*							ENDSCAN
*!*							Thisformset.lx_form1.lx_pageframe1.page7.lx_pageframe.page1.lx_tool_filhas.Botao_top.Click
*!*						Endif		
					
					If	v_materiais_00.semi_acabado = 0 
						Thisformset.lx_form1.lx_pageframe1.page7.lx_pageframe.page1.lx_tool_filhas.Botao_top.Click
						Sele v_materiais_00_cores
						go top
						Scan 
							Sele v_materiais_00_ficha_tecnica
							LOCATE FOR material = v_materiais_00_cores.material AND cor_material = v_materiais_00_cores.cor_material
							If FOUND() AND v_materiais_00_cores.inativo = .F. AND !F_Vazio(v_materiais_00_ficha_tecnica.material)
								MESSAGEBOX("Tem semi-acabado informado, favor verificar !!!",0+16)
								Return .F.
							Endif
								
							Thisformset.lx_form1.lx_pageframe1.page7.lx_pageframe.page1.lx_tool_filhas.botao_proximo.Click
						Sele v_materiais_00_cores
						ENDSCAN
						Thisformset.lx_form1.lx_pageframe1.page7.lx_pageframe.page1.lx_tool_filhas.Botao_top.Click
					endif
				ENDIF
				*** Fim - Bloqueio Semi-Acabado
				
				** Sintese Soluções - Tiago Carvalho - 17/12/2013 - Obriga a informar a largura para materiais que controlam peças/partidas.
				IF !(THISFORMSET.P_TOOL_STATUS =='E')
					IF (V_MATERIAIS_00.CTRL_PARTIDAS OR V_MATERIAIS_00.CTRL_PECAS) AND F_VAZIO(V_MATERIAIS_00.LARGURA)
						MESSAGEBOX("A Largura é obrigatória para materiais que controlam peças/partidas, informe a largura e salve novamente!",0+16,"Largura Obrigatória")
						sele &xalias
						RETURN .f.
					ENDIF
				ENDIF
				
				** Sintese Soluções - Tiago Carvalho - 16/12/2013 - Avisa que o material está ou não sendo marcado com controle de peças/partidas na inclusão.
				IF THISFORMSET.P_TOOL_STATUS =='I'
					IF V_MATERIAIS_00.CTRL_PARTIDAS OR V_MATERIAIS_00.CTRL_PECAS
						IF (MESSAGEBOX("O material está marcado para controlar peças/partidas, esse processo não pode ser alterado após a inclusão do material, deseja continuar?",4+32+256,"Obj-Controle de Peças/Partidas")) <> 6
							sele &xalias
							RETURN .f.
						ENDIF
					ELSE
						IF (MESSAGEBOX("O material não marcado para controlar peças/partidas, esse processo não pode ser alterado após a inclusão do material, deseja continuar?",4+32+256,"Obj-Controle de Peças/Partidas")) <> 6
							sele &xalias
							RETURN .f.
						ENDIF
					ENDIF
				endif				
				
				IF THISFORMSET.P_TOOL_STATUS =='A'
					
					SELECT V_MATERIAIS_00
					** Sintese Soluções - Tiago Carvalho - 16/12/2013 - Alterado para só atualizar a classificação fiscal se estiver diferente na nota fiscal.
					TEXT TO xUpdateNcm NOSHOW TEXTMERGE 
						UPDATE B
							SET B.CLASSIF_FISCAL = '<<LTRIM(RTRIM(V_MATERIAIS_00.CLASSIF_FISCAL))>>'
						FROM FATURAMENTO A
						INNER JOIN FATURAMENTO_ITEM B
							ON A.NF_SAIDA = B.NF_SAIDA AND A.SERIE_NF = B.SERIE_NF AND A.FILIAL = B.FILIAL
						WHERE B.CODIGO_ITEM = '<<LTRIM(RTRIM(V_MATERIAIS_00.MATERIAL))>>'
							AND A.STATUS_NFE NOT IN ('5','49','59','0')
							AND B.CLASSIF_FISCAL <> '<<LTRIM(RTRIM(V_MATERIAIS_00.CLASSIF_FISCAL))>>'
					ENDTEXT 
					f_update(xUpdateNcm)
				ENDIF
				
				** Sintese Soluções - Tiago Carvalho - 16/12/2013 - Alterado para acontecer em inclusão e alteração, não fazer em exclusão.
				IF THISFORMSET.P_TOOL_STATUS =='A' OR THISFORMSET.P_TOOL_STATUS =='I'	
												
					** Sintese Soluções - Tiago Carvalho -SS1 03/10/2013 - Atualiza a propriedade de conta contabili de despesa para materiais com base no cadastro de grupo e subgrupo
					** SS1 inicio**
					IF USED("CurPropMateriais")
						
						strSQL =	" SELECT MAX(PROPRIEDADE) AS PROPRIEDADE ,COUNT(*) AS QUANTIDADE_DE_PROPRIEDADES "+;
									" 	FROM PROPRIEDADE "+;
									"	WHERE TITULO_PROPRIEDADE ='CONTA CONTABIL DESPESA' "

						f_select(strSQL ,"CurNumPropriedade")
							
						IF RECCOUNT("CurNumPropriedade") > 0
							IF CurNumPropriedade.QUANTIDADE_DE_PROPRIEDADES > 1 
								MESSAGEBOX("Foram encontradas mais de uma propriedade para cadastro de conta contabil de despesa, verifique!",0+16,"Propriedade Duplicada")
								sele &xalias
								RETURN .f.
							ENDIF
							
							strSQl = 	"	SELECT TOP 1 A.CONTA_CONTABIL "+;
										"		FROM (	SELECT CONTA_CONTABIL,ORDEM=1 FROM SS_MATERIAIS_SUBGRUPO_CONTA_CONTABIL(NOLOCK) WHERE GRUPO =?v_Materiais_00.grupo AND SUBGRUPO =?v_Materiais_00.SUBGRUPO "+;
										"				UNION ALL  "+;
										"				SELECT CONTA_CONTABIL,ORDEM=2 FROM SS_MATERIAIS_SUBGRUPO_CONTA_CONTABIL(NOLOCK) WHERE GRUPO =?v_Materiais_00.grupo AND LTRIM(RTRIM(SUBGRUPO))='' "+;
										"		) A	ORDER BY ORDEM  "
							
							f_select (strSQl,"CurTmpContaContabil")  
								
							IF reccount("CurTmpContaContabil") > 0
								
								SELECT CurTmpContaContabil
								SELECT CurNumPropriedade
								SELECT curPropMateriais
									
								LOCATE FOR curpropmateriais.propriedade == CurNumPropriedade.PROPRIEDADE 
								IF !FOUND()
									strSQL=	"	SELECT	propriedade,material=?v_Materiais_00.material,item_propriedade=1,valor_propriedade=?CurTmpContaContabil.CONTA_CONTABIL,data_para_transferencia = getdate(),propriedade1 = '',faixa_final, "+;
											"			faixa_inicial,mascara_valor,desc_propriedade,propriedade_requerida,tipo_propriedade,tipo_validacao,data_para_transferencia1='  /  /  ', "+;
											"			data_ativacao,data_desativacao,filtro_de_propriedades,titulo_propriedade,tabela,validacao_tabela_campo,valor_padrao,consulta_ativa, "+;
											"			cod_grupo,responsavel,colunas_auxiliares,filtro_auxiliar,tabelas_auxiliares,lx_status_registro,	acao =''  "+;
											"		FROM PROPRIEDADE WHERE TITULO_PROPRIEDADE ='CONTA CONTABIL DESPESA' "
									
									f_select(strSQL,"CurTmpPropMateriais")
									
									IF RECCOUNT("CurTmpPropMateriais") > 0
										SELECT 	curPropMateriais
										APPEND BLANK 
										replace curPropMateriais.propriedade				with  CurTmpPropMateriais.propriedade				,;
												curPropMateriais.material					with  CurTmpPropMateriais.material					,;		
												curPropMateriais.item_propriedade			with  CurTmpPropMateriais.item_propriedade			,;
												curPropMateriais.valor_propriedade			with  CurTmpPropMateriais.valor_propriedade			,;
												curPropMateriais.data_para_transferencia	with  CurTmpPropMateriais.data_para_transferencia	,;	
												curPropMateriais.propriedade1				with  CurTmpPropMateriais.propriedade1				,;
												curPropMateriais.faixa_final				with  CurTmpPropMateriais.faixa_final				,;	
												curPropMateriais.faixa_inicial				with  CurTmpPropMateriais.faixa_inicial				,;
												curPropMateriais.mascara_valor				with  CurTmpPropMateriais.mascara_valor				,;
												curPropMateriais.desc_propriedade			with  CurTmpPropMateriais.desc_propriedade			,;
												curPropMateriais.propriedade_requerida		with  CurTmpPropMateriais.propriedade_requerida		,;
												curPropMateriais.tipo_propriedade			with  CurTmpPropMateriais.tipo_propriedade			,;
												curPropMateriais.tipo_validacao				with  CurTmpPropMateriais.tipo_validacao			,;	
												curPropMateriais.data_para_transferencia1	with  CTOD('  /  /  ')								,;
												curPropMateriais.data_ativacao				with  CurTmpPropMateriais.data_ativacao				,;
												curPropMateriais.data_desativacao			with  CTOD('  /  /  ')								,;
												curPropMateriais.filtro_de_propriedades		with  CurTmpPropMateriais.filtro_de_propriedades	,;	
												curPropMateriais.titulo_propriedade			with  CurTmpPropMateriais.titulo_propriedade		,;	
												curPropMateriais.tabela						with  CurTmpPropMateriais.tabela					,;	
												curPropMateriais.validacao_tabela_campo		with  CurTmpPropMateriais.validacao_tabela_campo	,;	
												curPropMateriais.valor_padrao				with  CurTmpPropMateriais.valor_padrao				,;
												curPropMateriais.consulta_ativa				with  CurTmpPropMateriais.consulta_ativa			,;	
												curPropMateriais.cod_grupo					with  CurTmpPropMateriais.cod_grupo					,;
												curPropMateriais.responsavel				with  CurTmpPropMateriais.responsavel				,;	
												curPropMateriais.colunas_auxiliares			with  CurTmpPropMateriais.colunas_auxiliares		,;	
												curPropMateriais.filtro_auxiliar			with  CurTmpPropMateriais.filtro_auxiliar			,;	
												curPropMateriais.tabelas_auxiliares			with  CurTmpPropMateriais.tabelas_auxiliares		,;	
												curPropMateriais.lx_status_registro			with  CurTmpPropMateriais.lx_status_registro		,;	
												curPropMateriais.acao						with  CurTmpPropMateriais.acao IN curPropMateriais
									endif
									IF USED("CurTmpPropMateriais")
										USE IN CurTmpPropMateriais
									ENDIF
																
								else	
									IF RECCOUNT("CurTmpContaContabil") > 0
										IF f_vazio("curpropmateriais.valor_propriedade")
											replace curpropmateriais.valor_propriedade WITH CurTmpContaContabil.conta_contabil IN CurTmpContaContabil
										ELSE 
											IF ALLTRIM(CurTmpContaContabil.conta_contabil) <> ALLTRIM(curpropmateriais.valor_propriedade)
												lcContaPropriedade = ALLTRIM(curpropmateriais.valor_propriedade)
												lcContaTabelaGrupo = ALLTRIM(CurTmpContaContabil.conta_contabil)
												lcMensagem = "A conta contábil do cadastro da propriedade está diferente da conta cadastrada na tabela de contas por Grupo/Subgrupo"+CHR(10)+CHR(10)+;
															 "Conta Contábil Propriedade: "+lcContaPropriedade+CHR(10)+;
															 "Conta Contábil Cadastro de Grupo/Subgrupo: "+lcContaTabelaGrupo+CHR(10)+CHR(10)+;
															 "Deseja Atualizar com a conta cadastrada por grupo/subgrupo?"
													
												IF (MESSAGEBOX(lcMensagem,4+32+256,"Propriedade Desatualizada!"))== 6
													replace curpropmateriais.valor_propriedade WITH CurTmpContaContabil.conta_contabil IN CurTmpContaContabil
												ENDIF
											endif
										endif
									endif
									
									IF OLDVAL("valor_propriedade", "curpropmateriais") <> curpropmateriais.valor_propriedade
										
										strSQl = 	"	SELECT	COUNT(*) AS QTDE_CONTABILIZADA "+;
													"		FROM ESTOQUE_SAI1_MAT A (NOLOCK) "+;
													"		INNER JOIN ESTOQUE_SAI_MAT B(NOLOCK) "+;
													"			ON A.REQ_MATERIAL = B.REQ_MATERIAL "+;
													"		WHERE B.CTB_LANCAMENTO IS NOT NULL "+;
													"			AND A.MATERIAL =?v_Materiais_00.Material "
								
										f_select (strSQl , "curTmpMaterialContabilizado")
										IF curTmpMaterialContabilizado.QTDE_CONTABILIZADA > 0
											MESSAGEBOX("Existem materiais já contabilizados, eles não serão contabilizados novamente!",0+64,"Atenção!")
										endif		
										
										IF USED("curTmpMaterialContabilizado")
											USE IN curTmpMaterialContabilizado
										ENDIF	
										
									ENDIF
								ENDIF
							ENDIF
						ENDIF 
					ENDIF

					IF USED("CurTmpContaContabil")
						USE IN CurTmpContaContabil
					ENDIF

					IF USED("CurNumPropriedade")
						USE IN CurNumPropriedade
					endif
					** SS1 fim**	
				ENDIF
				
				*#4 - LUCAS MIRANDA - 29/09/2016 - BLOQUEAR COMPRA MINIMA ZERADO
				*** CUSTOMIZAÇÃO RETIRADA A PEDIDO DO GUILHERME -- JULIO 01/12/2017
*!*					If Thisformset.p_tool_status $ "I,A"
*!*						sele v_materiais_00
*!*						if v_materiais_00.compra_minima = 0
*!*							MESSAGEBOX("Bloqueado Compra Mínima com valor zero !!!",0+16,"Compra Mínima")
*!*							Return .F.
*!*						endif
*!*					Endif
				*#4 - LUCAS MIRANDA - 29/09/2016 - BLOQUEAR COMPRA MINIMA ZERADO
				
				if !f_vazio(xalias)
					sele &xalias
				endif	
				
		otherwise
			return .t.				
		endcase
	endproc
ENDDEFINE

** Tiago Carvalho - Sintese Solucoes - 23/04/2014 - Etiqueta para ajudar no endereçamento dos materiais.
DEFINE CLASS bt_etiqueta AS commandbutton
	Height = 25
	Width = 85
	FontBold = .F.
	FontName = "Arial"
	FontSize = 8
    Caption = "Etiqueta"
	Name = "bt_etiqueta"
	autosize = .T.
	visible = .T.
	enabled = .T.
		
	PROCEDURE Click
		IF !DIRECTORY("C:\SINTESE\ETIQUETA")
			MKDIR "C:\SINTESE\ETIQUETA"
		ENDIF
		
		lcQtde = INPUTBOX("Informe o Número de Etiquetas!","Informe o Número de Etiquetas!","1")
		lcQtdeEstoque = INPUTBOX("Informe a Qtde da Embalagem exemplo 22.22 ou 1.00!","Informe a Qtde da Embalagem exemplo 22.22 ou 1.00!","1.00")

		lcQtde =ALLTRIM(lcQtde )		
		lcQtdeEstoque =ALLTRIM(lcQtdeEstoque)
		
		lSomenteInteiro = .T.
		
		lcUnidade = ALLTRIM(V_MATERIAIS_00.UNID_ESTOQUE)
		
		IF INLIST (lcUnidade,"UN","PAR") AND MOD(VAL(STRTRAN(lcQtdeEstoque ,'.',',')),1) <> 0
			MESSAGEBOX("Qtde Invalida!"+CHR(10)+CHR(13)+"Para par e Unidade Digite somente Numeros Inteiros!"+CHR(10)+CHR(13)+"Exemplo: 10000"+CHR(10)+CHR(13)+"Exemplo acima para DEZ MIL UNIDADES ou PAR",0+64,"Operação Cancelada!")
			RETURN .F.
		ENDIF
						
		FOR iPosicao = 1 TO LEN(lcQtdeEstoque)
			IF !INLIST(SUBSTR(lcQtdeEstoque,iPosicao,1),'0','1','2','3','4','5','6','7','8','9','.')
				lSomenteInteiro = .F.
			ENDIF
		ENDFOR
		
		IF !lSomenteInteiro 
			MESSAGEBOX("Qtde Invalida!"+CHR(10)+CHR(13)+"Digite Somente Números e o Separador de Decimal!"+CHR(10)+CHR(13)+"Exemplo: 10000.00"+CHR(10)+CHR(13)+"Exemplo acima para DEZ MIL",0+64,"Operação Cancelada!")
			RETURN .F.
		ENDIF
		
		lQtdeSomenteInteiro = .T.
		FOR iPosicao = 1 TO LEN(lcQtde)
			IF !INLIST(SUBSTR(lcQtde,iPosicao,1),'1','2','3','4','5','6','7','8','9')
				lQtdeSomenteInteiro = .F.
			ENDIF
		ENDFOR
		
		IF !lQtdeSomenteInteiro 
			MESSAGEBOX("Numero de Etiquetas Inválido!"+CHR(10)+CHR(13)+"Digite Somente Números inteiros!"+CHR(10)+CHR(13)+"Exemplo: 10"+CHR(10)+CHR(13)+"Exemplo acima para Imprimir DEZ etiquetas",0+64,"Operação Cancelada!")
			RETURN .F.
		ENDIF			
			
		lcQtdeEstoque = STRTRAN(lcQtdeEstoque,',','.')
		IF f_vazio(lcQtde)or f_vazio(lcQtdeEstoque )
			MESSAGEBOX("Qtde Invalida",0+64,"Operação Cancelada!")
			RETURN .F.
		ELSE
			lcQtde= RIGHT("0000"+ALLTRIM(lcQtde),4)
		
			strProc = SET("Procedure")
			Set procedure To \Linx\Report\User\Proc_SS_Etiquetas.prg Additive
					
			lcNomeArq = "C:\SINTESE\ETIQUETA\EtiquetaMp"+wusuario+".ETQ"
			intArq = fCreate(lcNomeArq, 0)
			if (intArq >= 0)
				
				lcMaterial = ALLTRIM(V_MATERIAIS_00.MATERIAL)
				lcDescMaterial = ALLTRIM(V_MATERIAIS_00.DESC_MATERIAL)
				lcUnidade = ALLTRIM(V_MATERIAIS_00.UNID_ESTOQUE)
				lcCor = ALLTRIM(V_MATERIAIS_00_CORES.COR_MATERIAL)
				lcDescCor = ALLTRIM(V_MATERIAIS_00_CORES.DESC_COR_MATERIAL)
				
				fwrite(intArq, Proc_Etiqueta_Mp(lcMaterial, lcDescMaterial , lcCor , lcDescCor,lcUnidade,lcQtdeEstoque, lcQtde ))
				fClose(intArq)
				!COPY &lcNomeArq LPT1
			ENDIF

			WAIT WINDOW 'ETIQUETA IMPRESSA...' NOWAIT
		
			SET PROCEDURE TO &strProc
		ENDIF
		
		RETURN .T. 
	EndProc
ENDDEFINE
**************************************************
*-- Class:        btn_anm_peca (c:\users\lucas.miranda\desktop\projetos\linx desenv\classes lucas\btn_anm_peca.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   03/23/16 11:02:07 AM
*
DEFINE CLASS btn_anm_peca AS commandbutton


	Top = 146
	Left = 421
	Height = 18
	Width = 96
	Caption = "Peça / Partida"
	Name = "btn_anm_peca"

	PROCEDURE Click
					
		lcTipo = V_MATERIAIS_00.tipo
		f_select ("SELECT TIPO, CTRL_PARTIDAS = ISNULL(CTRL_PARTIDAS,0),CTRL_PECAS = ISNULL(CTRL_PECAS,0),CTRL_PECAS_PARCIAL = ISNULL(CTRL_PECAS_PARCIAL,0) FROM MATERIAIS_TIPO where tipo = ?lcTipo","CurTipo")
		IF RECCOUNT("CurTipo")>0
			If CurTipo.Ctrl_Partidas = .T. AND v_materiais_00.ctrl_partidas = .f.
				replace V_MATERIAIS_00.ctrl_partidas with .t.
				replace V_MATERIAIS_00.ctrl_pecas with .t.
				replace V_MATERIAIS_00.ctrl_pecas_parcial with .t.
				
				thisformset.lx_FORM1.lx_pageframe1.page1.Ck_CTRL_PARTIDAS.Refresh ()
				thisformset.lx_FORM1.lx_pageframe1.page1.Ck_CTRL_PECAS.Refresh ()
				thisformset.lx_FORM1.lx_pageframe1.page1.ck_CTRL_PECAS_PARCIAL.Refresh ()	
			Else
				If CurTipo.Ctrl_Partidas = .F. AND v_materiais_00.ctrl_partidas = .F.
				 MESSAGEBOX("Tipo do Material não está habilitado para Peça/Partida !!!",0+64,"Peça/Partida")
				Endif 
				 
				If CurTipo.Ctrl_Partidas = .F. AND v_materiais_00.ctrl_partidas = .T.
				  If MESSAGEBOX("Tipo do Material não está habilitado para Peça/Partida, Deseja Desmarcar ?",4+32,"Peça/Partida") = 6
						 replace V_MATERIAIS_00.ctrl_partidas with .f.
						 replace V_MATERIAIS_00.ctrl_pecas with .f.
						 replace V_MATERIAIS_00.ctrl_pecas_parcial with .f.
						
						 thisformset.lx_FORM1.lx_pageframe1.page1.Ck_CTRL_PARTIDAS.Refresh ()
						 thisformset.lx_FORM1.lx_pageframe1.page1.Ck_CTRL_PECAS.Refresh ()
						 thisformset.lx_FORM1.lx_pageframe1.page1.ck_CTRL_PECAS_PARCIAL.Refresh ()	
				   Endif	
				 Endif
			Endif
		Endif
	ENDPROC


ENDDEFINE
*
*-- EndDefine: btn_anm_peca
**************************************************
**** Tipo Recorrentes - Lucas Miranda - 22/11/2016
*-- Class:        cmb_status_entrada (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_recorrentes AS lx_combobox


	RowSource = ""
	ControlSource = ""
	Height = 22
	Left = 625
	TabIndex = 1
	Top = 45
	Width = 147
	ZOrderSet = 5
	Name = "cmb_recorrentes"
	Visible = .t.
	Enabled = .t.
	Anchor = 0

*	PROCEDURE Valid	
	
*	ENDPROC 

ENDDEFINE

DEFINE CLASS ck_recorrentes AS lx_checkbox


	Top = 10
	Left = 18
	Height = 15
	Width = 88
	AutoSize = .T.
	Alignment = 0
	Caption = "Recorrentes"
	ControlSource = ""
	Name = "ck_recorrentes"


ENDDEFINE
*
*-- EndDefine: ck_liberar_grade_web

**************************************************
*-- Class:        lx_gscheck (c:\linx desenv\classes lucas\lx_gscheck.vcx)
*-- ParentClass:  lx_checkbox (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   03/15/17 11:10:00 AM
*
DEFINE CLASS lx_gscheck AS lx_checkbox


	Top = 19
	Left = 689
	Alignment = 0
	Caption = ""
	ControlSource = ""
	Name = "lx_gscheck"
	Visible = .t.

ENDDEFINE
*
*-- EndDefine: lx_gscheck
**************************************************

**************************************************
*-- Class:        btn_gsncm (c:\linx desenv\classes lucas\btn_gsncm.vcx)
*-- ParentClass:  botao (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   03/15/17 11:09:11 AM
*
DEFINE CLASS btn_gsncm AS commandbutton


	Top = 3
	Left = 635
	Height = 20
	Width = 64
	Caption = "Atua. NCM"
	Name = "btn_gsncm"
	Visible = .t.
	PROCEDURE Click
		strcaminho = getfile("xls?","Importar Arquivo","Importar",0,"Importar Arquivo")

					if empty(NVL(strcaminho,''))
						messagebox("Operação Cancelada!",0+64,"Arquivo Inválido!")
						return .f.
					endif

					F_wait("Importando as informações, Aguarde...")

					if used("CUR_IMPORT")
						use in CUR_IMPORT
					endif

					CREATE CURSOR CUR_IMPORT(MATERIAL C(11), CLASSIF_FISCAL C(10), VALIDA_NCM C(1))

 
					try
						objxls 			= createobject("excel.application")
						objworkbook 	= objxls.workbooks.open(strcaminho)
						objsheet 		= objworkbook.sheets(1)
						iRowsSheet 		= objsheet.Rows.Count
						iPermitido 	    = 65000
						iImatrizIni		= 2 
						iImatrizFim		= iPermitido 
						iPercorrido     = 1 

						IF (MOD(iRowsSheet , iPermitido ) > 0 )
							iPercorrer = (ROUND(iRowsSheet/iPermitido,0))+1
						ELSE 
							iPercorrer = (iRowsSheet/iPermitido)
						ENDIF

						IF upper(alltrim(objsheet.cells(1,1).text)) <> "MATERIAL" OR upper(alltrim(objsheet.cells(1,2).text))<> "CLASSIF_FISCAL" OR upper(alltrim(objsheet.cells(1,3).text))<> "VALIDA_NCM"
							MESSAGEBOX("O Layout do Arquivo é Inválido, O Cabeçalho deve Conter as Seguintes Informações:"+CHR(10)+"MATERIAL Célula A"+CHR(10)+"CLASSIF_FISCAL Célula B"+CHR(10)+"VALIDA_NCM Célula C",0+16,"Obj - Layout Inválido")
							return .f.
							*GO to oexception
						ENDIF

						IF f_vazio(alltrim(objsheet.cells(iPermitido,1).text)) 
							objsheetRange   = objsheet.range(objsheet.cells(iImatrizIni,1),objsheet.cells(iImatrizFim,3)).value
							SELECT CUR_IMPORT
							APPEND FROM array objsheetRange   
						ELSE 
							DO WHILE iPercorrer >= iPercorrido      

								objsheetRange   = objsheet.range(objsheet.cells(iImatrizIni,1),objsheet.cells(iImatrizFim,3)).value

								SELECT CUR_IMPORT
								APPEND FROM array objsheetRange

								iPercorrido = iPercorrido + 1
								iImatrizIni = IIF(iImatrizIni==2,1 + iPermitido,iImatrizIni + iPermitido)
								iImatrizFim = IIF((iImatrizFim + iPermitido) < iRowsSheet, iImatrizFim + iPermitido, iRowsSheet )
							ENDDO

						ENDIF


						objworkbook.close()
						release objsheet
						release objworkbook
						release objxls 


					catch to oexception

						objworkbook.close()
						release objsheet
						release objworkbook
						release objxls 
					ENDTRY


					if type("oexception") = "O"
						f_wait()
						return.f.
					ENDIF
				
				f_wait()
				
				CurCartaoNaoImportado = ""
				xCartaoNaoImportado = 0
				xGetDate = DTOS(DATE())
				xCountReg = 0
				xTRit = 0
				xMsgErro = ''
				
				SELECT cur_import
				DELETE FROM cur_import WHERE f_vazio(material)
				
								
				F_wait("Validando informações, Aguarde...")
				
				select distinct LTRIM(RTRIM(MATERIAL)) as MATERIAL from cur_import into CURSOR xCod_VerMaterial
				Sele xCod_VerMaterial			
						 
				
				f_select("select LTRIM(RTRIM(MATERIAL)) as MATERIAL from MATERIAIS (nolock)","xTabMaterial")
				Select * FROM xCod_VerMaterial a ;
				left join xTabMaterial b ;
				on a.MATERIAL = b.MATERIAL where b.MATERIAL is null ;
				into cursor xNExisteMaterial
				
				Sele xNExisteMaterial
				If RECCOUNT()>0
					*xMsgErro = xMsgErro + "Existe(m) material(ais) no arquivo não cadastrado na Tabela Materiais"
					Sele xNExisteMaterial
					COPY TO c:\temp\ERRO_COD_MATERIAL XLS
					MESSAGEBOX("Existe material no arquivo não cadastrado na Tabela Materiais"+CHR(13)+"Erro exportado para: c:\temp\ERRO_COD_MATERIAL"+CHR(13)+"Favor Verificar !!!",0+16,"Importação")
					release xNExisteMaterial
					F_wait()
					Return .F.
				Endif	
				
				select distinct LTRIM(RTRIM(CLASSIF_FISCAL)) as CLASSIF_FISCAL from cur_import into CURSOR xCod_VerClassif READWRITE
				Sele xCod_VerClassif	
				DELETE FROM xCod_VerClassif WHERE f_vazio(CLASSIF_FISCAL)
				
				f_select("select LTRIM(RTRIM(CLASSIF_FISCAL)) as CLASSIF_FISCAL from CLASSIF_FISCAL (nolock)","xTabClassif")
				Select * FROM xCod_VerClassif a ;
				left join xTabClassif b ;
				on a.CLASSIF_FISCAL = b.CLASSIF_FISCAL where b.CLASSIF_FISCAL is null AND !f_vazio(a.classif_fiscal) ;
				into cursor xNExisteClassif
			
				
				Sele xNExisteClassif
				If RECCOUNT()>0
					*xMsgErro = xMsgErro + "Existe(m) material(ais) no arquivo não cadastrado na Tabela Materiais"
					Sele xNExisteClassif
					COPY TO c:\temp\ERRO_Classificacao_fiscal XLS
					MESSAGEBOX("Existe material no arquivo não cadastrado na Tabela Classificação Fiscal"+CHR(13)+"Erro exportado para: c:\temp\ERRO_Classificacao_fiscal"+CHR(13)+"Favor Verificar !!!",0+16,"Importação")
					release xNExisteClassif
					F_wait()
					Return .F.
				Endif					
				
				F_wait()
				
				F_wait("Validando as Classificações Fiscais, Aguarde...")

				
					SELECT cur_import
					Count to xTReg
					GO top
					SCAN
					 
						xTRit = xTRit + 1
						F_PROG_BAR("Aguarde, Atualizando Cadastro ..."+ALLTRIM(STR(xTRit))+" de "+ALLTRIM(STR(xTReg))+;
					            CHR(13)+ALLTRIM(STR((xTRit/xTReg)*100))+"% Concluido",xTRit,xTReg)	
					If F_VAZIO(cur_import.classif_fiscal)	
						TEXT TO xUpdate TEXTMERGE NOSHOW
							update materiais set gs_valida_ncm = '<<IIF(UPPER(cur_import.valida_ncm)='S',1,0)>>'
							where material = '<<cur_import.material>>'
						ENDTEXT
					Endif
					
					IF !F_VAZIO(cur_import.classif_fiscal)	
						TEXT TO xUpdate TEXTMERGE NOSHOW
							update materiais set gs_valida_ncm = '<<IIF(UPPER(cur_import.valida_ncm)='S',1,0)>>', classif_fiscal = '<<cur_import.classif_fiscal>>'
							where material = '<<cur_import.material>>'
						ENDTEXT
					Endif	
						
						f_execute(xUpdate)
					
						SELECT cur_import
					endscan
				F_PROG_BAR()	
				f_wait()
				MESSAGEBOX("Importado/Atualizado com Sucesso !!!",0+64,"Importação")
						
	ENDPROC
	
ENDDEFINE
*
*-- EndDefine: btn_gsncm
**************************************************
**************************************************
*-- Class:        cmb_status_entrada (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_status_estampa AS lx_combobox


	RowSource = ""
	ControlSource = ""
	Height = 22
	Left = 625
	TabIndex = 1
	Top = 45
	Width = 147
	ZOrderSet = 5
	Name = "cmb_status_estampa"
	Visible = .t.
	Enabled = .t.
	Anchor = 0

*	PROCEDURE Valid	
	
*	ENDPROC 

ENDDEFINE



**************************************************
*-- Class:        lx_gs_label_porc_consumo (c:\linx desenv\classes lucas\lx_gs_label_porc_consumo.vcx)
*-- ParentClass:  lx_label (c:\linx_homolog_spk16\exclusivos\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   05/16/17 10:37:10 AM
*
DEFINE CLASS gs_label_porc_consumo AS lx_label


	Caption = "Porc. Consumo"
	Left = 356
	Top = 123
	Name = "gs_label_porc_consumo"
	Visible = .T. 

ENDDEFINE
*
*-- EndDefine: lx_gs_label_porc_consumo
**************************************************
*-- Class Library:  c:\linx desenv\classes lucas\lx_gstxt_base_consumo.vcx
**************************************************


**************************************************
*-- Class:        lx_gstxt_base_consumo (c:\linx desenv\classes lucas\lx_gstxt_base_consumo.vcx)
*-- ParentClass:  lx_textbox_base (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   05/16/17 10:38:05 AM
*
DEFINE CLASS lx_gstxt_base_consumo AS lx_textbox_base


	Height = 21
	Left = 432
	Top = 119
	Width = 50
	Name = "lx_gstxt_base_consumo"
	ControlSource = "v_materiais_00.GS_PORCENTAGEM_CONSUMO_FT"
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: lx_gstxt_base_consumo
**************************************************
**************************************************
*-- Class:        gstxt_tamanho 
*-- ParentClass:  lx_textbox_base (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   05/16/17 10:38:05 AM
*
DEFINE CLASS gstxt_tamanho AS lx_textbox_base

	Height = 21
	Left = 432
	Top = 119
	Width = 50
	Name = "gstxt_tamanho"
	ControlSource = "v_materiais_00.GS_PORCENTAGEM_CONSUMO_FT"
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: lx_gstxt_base_consumo
**************************************************
**************************************************
*-- Class:        lx_gs_label_tamanho)
*-- ParentClass:  lx_label
*-- BaseClass:    label
*-- Time Stamp:   17/05/18 09:38:10 AM
*
DEFINE CLASS gs_label_tamanho AS lx_label


	Caption = "Tamanho"
	Left = 10
	Top = 20
	Name = "gs_label_tamanho"
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: lx_gs_label_tamanho
**************************************************
**************************************************
*-- Class:        lx_gs_label_agrupamento_cor)
*-- ParentClass:  lx_label
*-- BaseClass:    label
*-- Time Stamp:   17/05/18 09:38:10 AM
*
DEFINE CLASS gs_label_agrupamento_cor AS lx_label


	Caption = "Agrup. Cor"
	Left = 10
	Top = 50
	Name = "gs_label_agrupamento_cor"
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: lx_gs_label_agrupamento_cor
**************************************************
**************************************************
*-- Class:        lx_gs_label_personalizacao)
*-- ParentClass:  lx_label
*-- BaseClass:    label
*-- Time Stamp:   17/05/18 09:38:10 AM
*
DEFINE CLASS gs_label_personalizacao AS lx_label


	Caption = "Personalização"
	Left = 10
	Top = 79
	Name = "gs_label_personalizacao"
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: lx_gs_label_personalizacao
**************************************************
**************************************************
*-- Class:        lx_gs_label_OBS
*-- ParentClass:  lx_label
*-- BaseClass:    label
*-- Time Stamp:   17/05/18 09:38:10 AM
*
DEFINE CLASS gs_label_obs AS lx_label


	Caption = "OBS Pers.: "
	Left = 280
	Top = 50
	Name = "gs_label_obs"
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: lx_gs_label_OBS
**************************************************
**************************************************
*-- Class:        cmb_tamanho
*-- ParentClass:  lx_combobox 
*-- BaseClass:    combobox
*-- Time Stamp:   16/05/18 10:32:34 AM
*
DEFINE CLASS cmb_tamanho AS lx_combobox

	ControlSource = "v_materiais_00.gs_tamanho_tecidoteca"
	Height = 22
	Left = 100
	TabIndex = 1
	Top = 16
	Width = 147
	ZOrderSet = 5
	Name = "cmb_tamanho"
	Visible = .t.
	Enabled = .t.
	Anchor = 0

*	PROCEDURE Valid	
	
*	ENDPROC 

ENDDEFINE
**************************************************
**************************************************
*-- Class:        cmb_agrupamento_cor
*-- ParentClass:  lx_combobox 
*-- BaseClass:    combobox
*-- Time Stamp:   16/05/18 10:32:34 AM
*
DEFINE CLASS cmb_agrupamento_cor AS lx_combobox

	ControlSource = "v_materiais_00.gs_agrupamento_cor_tecidoteca"
	Height = 22
	Left = 100
	TabIndex = 1
	Top = 45
	Width = 147
	ZOrderSet = 5
	Name = "cmb_agrupamento_cor"
	Visible = .t.
	Enabled = .t.
	Anchor = 0

*	PROCEDURE Valid	
	
*	ENDPROC 

ENDDEFINE
**************************************************
**************************************************
*-- Class:        cmb_personalizacao
*-- ParentClass:  lx_combobox 
*-- BaseClass:    combobox
*-- Time Stamp:   16/05/18 10:32:34 AM
*
DEFINE CLASS cmb_personalizacao AS lx_combobox

	ControlSource = "v_materiais_00.gs_personalizacao_tecidoteca"
	Height = 22
	Left = 100
	TabIndex = 1
	Top = 75
	Width = 147
	ZOrderSet = 5
	Name = "cmb_personalizacao"
	Visible = .t.
	Enabled = .t.
	Anchor = 0
	
ENDDEFINE	
**************************************************
