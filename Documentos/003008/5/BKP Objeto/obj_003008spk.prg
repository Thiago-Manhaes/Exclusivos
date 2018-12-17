define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
		
		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
		DO CASE
			CASE UPPER(XMETODO) == 'USR_INIT'
				WAIT WINDOW 'OBJ-SS 1.1' NOWAIT
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

				** Lucas Miranda - 17/03/2015 - Adicionado uma nova coluna ANM_DESENHO_ESTAMPA, FARM_COLECAO
							sele v_materiais_00_cores
								xalias=ALIAS()

								oCur = getcursoradapter(xalias)
								oCur.addbufferfield("materiais_cores.anm_desenho_estampa", "C(10)",.T., "Desenho/Estampa", "materiais_cores.anm_desenho_estampa")
								oCur.addbufferfield("MATERIAIS_CORES.FARM_COLECAO", "C(6)",.T., "COLECAO", "MATERIAIS_CORES.FARM_COLECAO")	
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
							
						*** #1 - LUCAS MIRANDA - 22/03/2016 - LIBERAR CAMPO COD.BASE VARIANTE E HAB PECA PARTIDA
							with thisformset.lx_form1.lx_pageframe1.Page1
								.addobject("btn_anm_peca","btn_anm_peca")
							endwith	
								
						*** #1 - LUCAS MIRANDA - 22/03/2016
						
							if	!f_vazio(xalias)	
								sele &xalias 
							endif	
										
				
			CASE UPPER(XMETODO) == 'USR_INCLUDE_AFTER'
				
				xalias=alias()
				
				*If Type("ThisFormSet.pp_tipo_material") == "C" AND THISFORMSET.P_TOOL_STATUS =='I'
*!*						lcTipo = ThisFormSet.pp_tipo_material
*!*						f_select ("SELECT TIPO, CTRL_PARTIDAS = ISNULL(CTRL_PARTIDAS,0),CTRL_PECAS = ISNULL(CTRL_PECAS,0),CTRL_PECAS_PARCIAL = ISNULL(CTRL_PECAS_PARCIAL,0) FROM MATERIAIS_TIPO where tipo = ?lcTipo","CurTipo")
*!*						IF RECCOUNT("CurTipo")>0
*!*							replace V_MATERIAIS_00.CTRL_PARTIDAS 		WITH CurTipo.CTRL_PARTIDAS 		IN V_MATERIAIS_00
*!*							replace V_MATERIAIS_00.CTRL_PECAS 			WITH CurTipo.CTRL_PECAS 		IN V_MATERIAIS_00
*!*							replace V_MATERIAIS_00.CTRL_PECAS_PARCIAL 	WITH CurTipo.CTRL_PECAS_PARCIAL IN V_MATERIAIS_00
*!*							
*!*							thisformset.lx_FORM1.lx_pageframe1.page1.Ck_CTRL_PARTIDAS.Refresh ()
*!*							thisformset.lx_FORM1.lx_pageframe1.page1.Ck_CTRL_PECAS.Refresh ()
*!*							thisformset.lx_FORM1.lx_pageframe1.page1.ck_CTRL_PECAS_PARCIAL.Refresh ()
*!*						ENDIF
			
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
	
					
				IF (upper(xnome_obj)== 'TV_TIPO_MATERIAL' OR upper(xnome_obj)== 'CMB_GRUPO') AND THISFORMSET.P_TOOL_STATUS <> 'L'	
					SELE V_MATERIAIS_00					
				  	IF V_MATERIAIS_00.GRUPO = 'ETIQUETAS' AND  !'AVIAMENTO' $ ALLTRIM(V_MATERIAIS_00.TIPO)
						THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL.value = '113103'
						THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_COMPRA.value = '3.2.1.10.01'
						THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_DEV_COMPRA.value = '3.2.1.10.02'
					ELSE
						IF 'PANOS' $ V_MATERIAIS_00.TIPO
							THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL.value = '113101'
							THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_COMPRA.value = '351103'
							THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_DEV_COMPRA.value = '351104'	
						ELSE
							IF 'AVIAMENTO' $ V_MATERIAIS_00.TIPO OR 'JÓIAS' $ V_MATERIAIS_00.TIPO
								THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL.value = '113103'
								THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_COMPRA.value = '351112'
								THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_DEV_COMPRA.value = '351113'
							ELSE
								IF 'CONSUMIVEIS' $ V_MATERIAIS_00.TIPO
									THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL.value = '113401'
									THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_COMPRA.value = '113401'
									THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_DEV_COMPRA.value = '351113'
								ELSE
									THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL.value = '113103'
									THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_COMPRA.value = '351103'
									THISFORMSET.lx_FORM1.lx_pageframe1.page8.lx_pageframe1.page1.tv_CONTA_CONTABIL_DEV_COMPRA.value = '351104'			
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
				
				***** Lucas Miranda, ANM_DESENHO_ESTAMPA e FARM_COLECAO *****
				if type("thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.COL_ANM_DESENHO_ESTAMPA") <> "U" AND TYPE("thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.column1") <> "U"
				
					if thisformset.p_tool_status $ 'IA' 
						thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.COL_ANM_DESENHO_ESTAMPA.Enabled = .T.
						thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.column1.Enabled = .T.
					else
						thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.COL_ANM_DESENHO_ESTAMPA.Enabled = .F.
						thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.column1.Enabled = .F.
					endif
				endif
				***** Fim - Lucas Miranda *****	
				
				
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
				if !f_vazio(xalias)
					sele &xalias
				endif

			CASE UPPER(XMETODO) == 'USR_SAVE_BEFORE' 
				xalias=alias()
				
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
				If Thisformset.p_tool_status $ "I,A"
					sele v_materiais_00
					if v_materiais_00.compra_minima = 0
						MESSAGEBOX("Bloqueado Compra Mínima com valor zero !!!",0+16,"Compra Mínima")
						Return .F.
					endif
				Endif
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