
define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj

		do case
			case UPPER(xmetodo) == 'USR_INIT'
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
				
				* 27/06/2014 - Leandro Rocha (SS): Adicionado check box "chkEstoqueLocalizacao", será usado para indicar se a quantidade de estoque mostrada será com base no saldo de estoque os das localizações marcadas como "PERMITE_DISTRIBUICAO".
				thisformset.LX_FORM1.AddObject('chkEstoqueLocalizacao', 'lx_checkBox')
				thisformset.LX_FORM1.chkEstoqueLocalizacao.Value = 0
				thisformset.LX_FORM1.chkEstoqueLocalizacao.Visible = .t.
				thisformset.LX_FORM1.chkEstoqueLocalizacao.Anchor = 0
				thisformset.LX_FORM1.chkEstoqueLocalizacao.Caption = 'Estoque Recebimento (Localização)'
				thisformset.LX_FORM1.chkEstoqueLocalizacao.top = thisformset.LX_FORM1.ck_esconde_grades.top
				thisformset.LX_FORM1.chkEstoqueLocalizacao.left = thisformset.LX_FORM1.ck_desconsiderar_disponivel_pedido_op.Left
			
			
				* 03/06/2014 - Leandro Rocha (SS): Adicionado campo "Data Lib. CQ" "Lib. CQ por". Esse campo será usado para indicar quando o Controle de Qualidade aprovou a distribuição e por quem foi feita a liberação.
				* 19/05/2014 - Leandro Rocha (SS): Adicionado campo "Data Distribuição (Data envio)". Esse campo será usado para indicar quando a logística estará liberada para efetuar a distribuição romaneio.
				objCursor = getcursoradapter('v_romaneios_produto_04')
				objCursor.addbufferfield("ROMANEIOS.DATA_ENVIO", "D", .T., "DATA_ENVIO", "ROMANEIOS.DATA_ENVIO")
				objCursor.addbufferfield("ROMANEIOS.DATA_LIBERACAO_CQ", "T", .T., "DATA_LIBERACAO_CQ", "ROMANEIOS.DATA_LIBERACAO_CQ")
				objCursor.addbufferfield("ROMANEIOS.ID_USUARIO_LIBERACAO_CQ", "I", .T., "ID_USUARIO_LIBERACAO_CQ", "ROMANEIOS.ID_USUARIO_LIBERACAO_CQ")
				objCursor.addbufferfield("ROMANEIOS.RESPONSAVEL", "C(40)", .F., "RESPONSAVEL", "ROMANEIOS.RESPONSAVEL")
				objCursor.confirmstructurechanges()

				RELEASE objCursor

				thisformset.LX_FORM1.AddObject('txtDataEnvio', 'lx_textbox_base_SS')
				thisformset.LX_FORM1.txtDATAENVIO.ControlSource = 'v_romaneios_produto_04.DATA_ENVIO'
				thisformset.LX_FORM1.txtDataEnvio.Visible = .t.
				thisformset.LX_FORM1.txtDataEnvio.anchor = 0
				thisformset.LX_FORM1.txtDataEnvio.top = thisformset.LX_FORM1.tx_tot_disponivel.Top + 3
				thisformset.LX_FORM1.txtDataEnvio.Left = thisformset.LX_FORM1.tx_tot_disponivel.left - 150
				thisformset.LX_FORM1.txtDataEnvio.format = '!'
				thisformset.LX_FORM1.txtDataEnvio.value = {}

				thisformset.LX_FORM1.AddObject('lblDataEnvio', 'lx_label')
				thisformset.LX_FORM1.lblDataEnvio.Visible = .t.
				thisformset.LX_FORM1.lblDataEnvio.anchor = 0
				thisformset.LX_FORM1.lblDataEnvio.Caption = 'Data Distribuição'
				thisformset.LX_FORM1.lblDataEnvio.AutoSize = .f.
				thisformset.LX_FORM1.lblDataEnvio.Width = 100
				thisformset.LX_FORM1.lblDataEnvio.top = thisformset.LX_FORM1.txtDataEnvio.top + 3
				thisformset.LX_FORM1.lblDataEnvio.left = thisformset.LX_FORM1.txtDataEnvio.Left - 100
				thisformset.LX_FORM1.lblDataEnvio.top = thisformset.LX_FORM1.txtDataEnvio.top + 3
				thisformset.LX_FORM1.lblDataEnvio.Alignment = 0
				thisformset.LX_FORM1.lblDataEnvio.FontBold = .T.
				
				thisformset.lx_FORM1.label_agrupamento.Visible = .f.
				thisformset.lx_FORM1.tx_id_agrupamento.Visible = .f.
				thisformset.lx_FORM1.tx_desc_agrupamento.Visible = .f.

				thisformset.lx_FORM1.AddObject('txtDataLibCq','lx_textbox_base')
				thisformset.lx_FORM1.txtDataLibCq.Visible = .t.
				thisformset.lx_FORM1.txtDataLibCq.Left = thisformset.lx_FORM1.tv_cod_planejamento.Left
				thisformset.lx_FORM1.txtDataLibCq.top = thisformset.lx_FORM1.tv_cod_planejamento.top + 20
				thisformset.lx_FORM1.txtDataLibCq.Width = 130
				thisformset.lx_FORM1.txtDataLibCq.anchor = 0
				thisformset.LX_FORM1.txtDataLibCq.ControlSource = 'v_romaneios_produto_04.DATA_LIBERACAO_CQ'
				thisformset.LX_FORM1.txtDataLibCq.P_TIPO_DADO = 'MOSTRA'
				thisformset.LX_FORM1.txtDataLibCq.Enabled = .F.
				
				thisformset.lx_FORM1.AddObject('txtUsuarioLibCq','lx_textbox_base')
				thisformset.lx_FORM1.txtUsuarioLibCq.Visible = .t.
				thisformset.lx_FORM1.txtUsuarioLibCq.Left = thisformset.lx_FORM1.tv_cod_planejamento.Left
				thisformset.lx_FORM1.txtUsuarioLibCq.top = thisformset.lx_FORM1.txtDataLibCq.top + 22
				thisformset.lx_FORM1.txtUsuarioLibCq.Width = 243
				thisformset.lx_FORM1.txtUsuarioLibCq.anchor = 0
				thisformset.LX_FORM1.txtUsuarioLibCq.ControlSource = 'v_romaneios_produto_04.RESPONSAVEL'
				thisformset.LX_FORM1.txtUsuarioLibCq.Enabled = .F.

				thisformset.lx_FORM1.AddObject('lblDataLibCq','lx_label')
				thisformset.lx_FORM1.lblDataLibCq.Visible = .t.
				thisformset.lx_FORM1.lblDataLibCq.Caption = 'Data Lib. CQ'
				thisformset.lx_FORM1.lblDataLibCq.Top = thisformset.lx_FORM1.txtDataLibCq.top + 3
				thisformset.lx_FORM1.lblDataLibCq.Left = thisformset.lx_FORM1.txtDataLibCq.left - 67
				thisformset.lx_FORM1.lblDataLibCq.anchor = 0
				
				thisformset.lx_FORM1.AddObject('lblUsuarioLibCq','lx_label')
				thisformset.lx_FORM1.lblUsuarioLibCq.Visible = .t.
				thisformset.lx_FORM1.lblUsuarioLibCq.Caption = 'Lib. CQ Por'
				thisformset.lx_FORM1.lblUsuarioLibCq.Top = thisformset.lx_FORM1.txtUsuarioLibCq.top + 3
				thisformset.lx_FORM1.lblUsuarioLibCq.Left = thisformset.lx_FORM1.txtUsuarioLibCq.left - 59				
				thisformset.lx_FORM1.lblUsuarioLibCq.anchor = 0
				
				* 11/11/2014 - Leandro Rocha: Alterado para o padrão da prioridade do rateio ser (% depois Prioridade) e para ser a order ser descendente
				thisformset.lx_FORM1.lx_PAGEFRAME1.page2.Lx_percentual.Value = 1
				thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_prioridade.Value = 2
				thisformset.lx_FORM1.lx_PAGEFRAME1.page2.Ck_ascdesc.Value = .t.
				thisformset.lx_FORM1.lx_PAGEFRAME1.page2.Ck_ascdesc.l_desenhista_recalculo()

			case UPPER(xmetodo) == 'USR_SEARCH_AFTER'
				* 03/06/2014 - Leandro Rocha (SS): Atualiza o nome do responsável pela liberação do controle de qualidade
				SELECT v_romaneios_produto_04 
				SCAN 
					IF f_select('SELECT NOME_COMPLETO FROM SS_USUARIOS_COLETOR WHERE ID_USUARIO = ?v_romaneios_produto_04.ID_USUARIO_LIBERACAO_CQ', 'curUsuarioCq')
						replace v_romaneios_produto_04.RESPONSAVEL WITH ALLTRIM(NVL(curUsuarioCq.NOME_COMPLETO, '')) IN v_romaneios_produto_04
						USE IN curUsuarioCq
					ENDIF 
				ENDSCAN 
				GO TOP IN v_romaneios_produto_04
				
			case UPPER(xmetodo) == 'USR_SAVE_BEFORE'
				IF EMPTY(NVL(v_romaneios_produto_04.DATA_ENVIO, ''))
					IF MESSAGEBOX( 'A Data de distribuição não foi definida. O produto não será distribuido pela Logística.' + CHR(10) +;
								'Deseja continuar sem definir a data de distribuição?', 32 + 4, 'ATENÇÃO') <> 6
						RETURN .F.
					ENDIF
				ELSE 
					MESSAGEBOX('Data de distribuição definida para:' + DTOC(v_romaneios_produto_04.DATA_ENVIO) + '.', 64, 'ATENÇÃO')
				ENDIF

			case UPPER(xmetodo) == 'USR_ALTER_AFTER'
				* 29/05/2014 - Leandro Rocha (SS): Sugere data de liberação da distribuição o próximo dia possível
				IF EMPTY(NVL(v_romaneios_produto_04.DATA_ENVIO, ''))
					IF !F_select('SELECT GETDATE() AS DATA_HORA_ATUAL', 'curDatahora')
						MESSAGEBOX('Erro ao consultar hora do servidor, tente novamente.', 16, 'ATENÇÃO')
						RETURN .F.
					ELSE
						dtDataHoraAtual = curDatahora.DATA_HORA_ATUAL
						strHoraParametro = ALLTRIM(thisformset.pp_hora_corte_data_distrib)
						USE IN curDatahora
					ENDIF 

					* Se a hora atual for maior que a hora de corte definida no parâmetro sugere o dia seguinte, caso contrário sugere o dia atual.
					IF (dtDataHoraAtual - DATETIME(YEAR(dtDataHoraAtual), MONTH(dtDataHoraAtual), DAY(dtDataHoraAtual), VAL(SUBSTR(strHoraParametro, 1, 2)), VAL(SUBSTR(strHoraParametro, 4, 2)))) > 0 
						dtDataSugestao = TTOD(dtDataHoraAtual) + 1
					ELSE
						dtDataSugestao = TTOD(dtDataHoraAtual)
					ENDIF
					
					* Se for sábado ou domingo joga para segunda 
					dtDataSugestao = dtDataSugestao + IIF(DOW(dtDataSugestao) = 1, 1, IIF(DOW(dtDataSugestao) = 7, 2, 0))
					
					replace v_romaneios_produto_04.DATA_ENVIO WITH dtDataSugestao IN v_romaneios_produto_04
					thisformset.refresh()
				ENDIF

			case UPPER(xmetodo) == 'USR_TRIGGER_AFTER' 
				* Atualiza a data de envio no banco de dados, foi feito dessa forma porque esse cursor não é atualizado pela tela.
				iF !f_UPDATE('update romaneios set data_envio = ?v_romaneios_produto_04.DATA_ENVIO where romaneio = ?v_romaneios_produto_04.ROMANEIO AND FILIAL = ?v_romaneios_produto_04.FILIAL')
					MESSAGEBOX('Erro ao atualizar data de envio no romaneio. Tente novamente.', 16, 'ATENÇÃO')
					RETURN .F.
				ENDIF
				=DODEFAULT()
							 
			case (UPPER(xmetodo) == 'USR_REFRESH' AND upper(xnome_obj) = 'ROMANEIOS_010') OR ;
				 (UPPER(xmetodo) == 'USR_WHEN' AND upper(xnome_obj) = 'CMD_ATUALIZA_DISPONIVEL') OR ;
 				 (UPPER(xmetodo) == 'USR_WHEN' AND upper(xnome_obj) = 'CHKESTOQUELOCALIZACAO') OR ;
 				 (UPPER(xmetodo) == 'USR_WHEN' AND upper(xnome_obj) = 'CK_ESTOQUE_DISPONIVEL') OR ;
				 (UPPER(xmetodo) == 'USR_SEARCH_AFTER') OR ;
				 (UPPER(xmetodo) == 'USR_WHEN' AND upper(xnome_obj) = 'BOTAO1')

				strAlias = alias()
				strRecno = RECNO()
				
*!*					* Marca automaticamento o check de estoque disponível com base na localização apenas quando a distribuição for feita com base na OP/Pedido 
*!*				 	IF UPPER(xmetodo) == 'USR_SEARCH_AFTER' AND UPPER(TYPE('thisformset.LX_FORM1.chkEstoqueLocalizacao')) == 'O'
*!*				 		IF !EMPTY(NVL(V_ROMANEIOS_PRODUTO_04.ORDEM_PRODUCAO, ''))
*!*					 		thisformset.LX_FORM1.chkEstoqueLocalizacao.Value = 1
*!*					 	ELSE 
*!*				 		 	thisformset.LX_FORM1.chkEstoqueLocalizacao.Value = 0
*!*						 ENDIF
*!*					ENDIF
				
				strFilial = V_ROMANEIOS_PRODUTO_04_RESERVAS.FILIAL
				strProduto = V_ROMANEIOS_PRODUTO_04_RESERVAS.PRODUTO
					
				* 26/07/2013 - Leandro Rocha (SS): Alterado para mostrar o estoque disponível com base na localização ou no estoque				
				IF UPPER(TYPE('thisformset.LX_FORM1.chkEstoqueLocalizacao')) == 'O' AND thisformset.LX_FORM1.chkEstoqueLocalizacao.Value = 1
					TEXT TO strSql TEXTMERGE NOSHOW
						SELECT  FILIAL, PRODUTO, COR_PRODUTO, ESTOQUE,
								ES1, ES2, ES3, ES4, ES5, ES6, ES7, ES8, ES9, ES10, ES11, ES12, ES13, ES14, ES15, ES16, ES17, ES18, ES19, ES20, ES21, ES22, ES23, ES24, 
								ES25, ES26, ES27, ES28, ES29, ES30, ES31, ES32, ES33, ES34, ES35, ES36, ES37, ES38, ES39, ES40, ES41, ES42, ES43, ES44, ES45, ES46, ES47, ES48
							FROM W_SS_ESTOQUE_LOCALIZACAO_DISTRIBUICAO (nolock)
							WHERE PRODUTO = '<<strProduto>>' 
								AND FILIAL = '<<strFilial>>'
					ENDTEXT
				ELSE 
					TEXT TO strSql TEXTMERGE NOSHOW
						SELECT	FILIAL, PRODUTO, COR_PRODUTO, 
								(ES1 + ES2 + ES3 + ES4 + ES5 + ES6 + ES7 + ES8 + ES9 + ES10 + ES11 + ES12 + ES13 + ES14 + ES15 + ES16) AS ESTOQUE,
								ES1, ES2, ES3, ES4, ES5, ES6, ES7, ES8, ES9, ES10, ES11, ES12, ES13, ES14, ES15, ES16
							FROM (SELECT	CASE 	WHEN A.FILIAL = 'RECEBIMENTO PA SC' THEN 'ESTOQUE CENTRAL' 	
													WHEN A.FILIAL = 'FARM RECEBIMENTO PA' THEN 'FARM FILIAL PA' 	
													WHEN A.FILIAL = 'FABULA RECEBIMENTO PA' THEN 'FABULA FILIAL PA' 	
												ELSE A.FILIAL END AS FILIAL, 
											A.PRODUTO, 
											A.COR_PRODUTO, 
											CASE WHEN SUM(ISNULL(ES1,0)) - SUM(ISNULL(E1,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES1,0)) - SUM(ISNULL(E1,0)) END AS ES1,
											CASE WHEN SUM(ISNULL(ES2,0)) - SUM(ISNULL(E2,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES2,0)) - SUM(ISNULL(E2,0)) END AS ES2,
											CASE WHEN SUM(ISNULL(ES3,0)) - SUM(ISNULL(E3,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES3,0)) - SUM(ISNULL(E3,0)) END AS ES3,
											CASE WHEN SUM(ISNULL(ES4,0)) - SUM(ISNULL(E4,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES4,0)) - SUM(ISNULL(E4,0)) END AS ES4,
											CASE WHEN SUM(ISNULL(ES5,0)) - SUM(ISNULL(E5,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES5,0)) - SUM(ISNULL(E5,0)) END AS ES5,
											CASE WHEN SUM(ISNULL(ES6,0)) - SUM(ISNULL(E6,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES6,0)) - SUM(ISNULL(E6,0)) END AS ES6,
											CASE WHEN SUM(ISNULL(ES7,0)) - SUM(ISNULL(E7,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES7,0)) - SUM(ISNULL(E7,0)) END AS ES7,
											CASE WHEN SUM(ISNULL(ES8,0)) - SUM(ISNULL(E8,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES8,0)) - SUM(ISNULL(E8,0)) END AS ES8,
											CASE WHEN SUM(ISNULL(ES9,0)) - SUM(ISNULL(E9,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES9,0)) - SUM(ISNULL(E9,0)) END AS ES9,
											CASE WHEN SUM(ISNULL(ES10,0)) - SUM(ISNULL(E10,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES10,0)) - SUM(ISNULL(E10,0)) END AS ES10,
											CASE WHEN SUM(ISNULL(ES11,0)) - SUM(ISNULL(E11,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES11,0)) - SUM(ISNULL(E11,0)) END AS ES11,
											CASE WHEN SUM(ISNULL(ES12,0)) - SUM(ISNULL(E12,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES12,0)) - SUM(ISNULL(E12,0)) END AS ES12,
											CASE WHEN SUM(ISNULL(ES13,0)) - SUM(ISNULL(E13,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES13,0)) - SUM(ISNULL(E13,0)) END AS ES13,
											CASE WHEN SUM(ISNULL(ES14,0)) - SUM(ISNULL(E14,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES14,0)) - SUM(ISNULL(E14,0)) END AS ES14,
											CASE WHEN SUM(ISNULL(ES15,0)) - SUM(ISNULL(E15,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES15,0)) - SUM(ISNULL(E15,0)) END AS ES15,
											CASE WHEN SUM(ISNULL(ES16,0)) - SUM(ISNULL(E16,0)) < 0 THEN 0 ELSE SUM(ISNULL(ES16,0)) - SUM(ISNULL(E16,0)) END AS ES16
										FROM WANM_ESTOQUE_PRODUTOS A (NOLOCK)
										LEFT JOIN(SELECT FILIAL, PRODUTO, COR_PRODUTO, SUM(QTDE_EMBALADA) AS QTDE_EMBALADA,
														 SUM(E1) AS E1,SUM(E2) AS E2,SUM(E3) AS E3,SUM(E4) AS E4,SUM(E5) AS E5,SUM(E6) AS E6,SUM(E7) AS E7,SUM(E8) AS E8,SUM(E9) AS E9,SUM(E10) AS E10,
														SUM(E11) AS E11,SUM(E12) AS E12,SUM(E13) AS E13,SUM(E14) AS E14,SUM(E15) AS E15,SUM(E16) AS E16 
													FROM VENDAS_PROD_EMBALADO (NOLOCK)
													WHERE MATA_SALDO = 0 
													GROUP BY FILIAL, PRODUTO, COR_PRODUTO) B
											ON A.FILIAL = B.FILIAL AND A.PRODUTO = B.PRODUTO AND A.COR_PRODUTO = B.COR_PRODUTO
										WHERE A.PRODUTO = '<<strProduto>>' 
					ENDTEXT		
					
					IF UPPER(ALLTRIM(strFilial)) == 'ESTOQUE CENTRAL'
						strSql = strSql + " AND (a.FILIAL = 'ESTOQUE CENTRAL' OR A.FILIAL = 'RECEBIMENTO PA SC') "
					ELSE 
						IF UPPER(ALLTRIM(strFilial)) == 'FARM FILIAL PA'
							strSql = strSql + " AND (a.FILIAL = 'FARM FILIAL PA' OR A.FILIAL = 'FARM RECEBIMENTO PA') "
						ELSE
							IF UPPER(ALLTRIM(strFilial)) == 'FABULA FILIAL PA'
								strSql = strSql + " AND (a.FILIAL = 'FABULA FILIAL PA' OR A.FILIAL = 'FABULA RECEBIMENTO PA') "
							ELSE
								strSql = strSql + " AND a.FILIAL = '" + strFilial + "' "
							ENDIF 
						ENDIF 
					ENDIF 
					
					strSql = strSql + 	"	GROUP BY CASE WHEN A.FILIAL = 'RECEBIMENTO PA SC' THEN 'ESTOQUE CENTRAL' " +;
										"	WHEN A.FILIAL = 'FARM RECEBIMENTO PA' THEN 'FARM FILIAL PA' " +;
										"	WHEN A.FILIAL = 'FABULA RECEBIMENTO PA' THEN 'FABULA FILIAL PA' " +;
										"	ELSE A.FILIAL END, A.PRODUTO, A.COR_PRODUTO) A " 
				ENDIF
				
				f_select(strSql, 'CurGradeDisponivel', ALIAS())

				UPDATE A ;
					SET A.DISPONIVEL = NVL(B.ESTOQUE, 0), SALDO = DISPONIVEL - RESERVAR, A.D1 = NVL(B.ES1, 0), A.D2 = NVL(B.ES2, 0), A.D3 = NVL(B.ES3, 0), A.D4 = NVL(B.ES4, 0), ;
						A.D5 = NVL(B.ES5, 0), A.D6 = NVL(B.ES6, 0), A.D7 = NVL(B.ES7, 0), A.D8 = NVL(B.ES8, 0), A.D9 = NVL(B.ES9, 0), A.D10 = NVL(B.ES10, 0), ;
						A.D11 = NVL(B.ES11, 0), A.D12 = NVL(B.ES12, 0), A.D13 = NVL(B.ES13, 0), A.D14 = NVL(B.ES14, 0), A.D15 = NVL(B.ES15, 0), A.D16 = NVL(B.ES16, 0), ;
						S1 = D1-R1, S2 = D2-R2, S3 = D3-R3, S4 = D4-R4, S5 = D5-R5, S6 = D6-R6, S7 = D7-R7, S8 = D8-R8, S9 = D9-R9, S10 = D10-R10, ;
						S11 = D11-R11, S12 = D12-R12, S13 = D13-R13, S14 = D14-R14, S15 = D15-R15, S16 = D16-R16 ;
					FROM V_ROMANEIOS_PRODUTO_04_DISPONIVEL A ;
					LEFT JOIN CurGradeDisponivel B ;
						ON A.PRODUTO == B.PRODUTO AND A.COR_PRODUTO == B.COR_PRODUTO	
						
				CALCULATE SUM(DISPONIVEL) TO intQtdeDisponivel IN V_ROMANEIOS_PRODUTO_04_DISPONIVEL 
				CALCULATE SUM(SALDO) TO intQtdeSaldo IN V_ROMANEIOS_PRODUTO_04_DISPONIVEL
				
				Thisformset.lx_FORM1.tx_tot_disponivel.value = NVL(intQtdeDisponivel, 0)
				Thisformset.lx_FORM1.tx_tot_saldo.value = NVL(intQtdeSaldo, 0)

				USE IN CurGradeDisponivel
			
				* Atualiza quantidade vendida na loja
				TEXT TO strSql TEXTMERGE NOSHOW
					SELECT 	FILIAL, PRODUTO, COR_PRODUTO, 
							SUM(V1) AS C1, SUM(V2) AS C2, SUM(V3) AS C3, SUM(V4) AS C4, SUM(V5) AS C5, 
							SUM(V6) AS C6, SUM(V7) AS C7, SUM(V8) AS C8, SUM(V9) AS C9, SUM(V10) AS C10,
							SUM(V1+V2+V3+V4+V5+V6+V7+V8+V9+V10) AS TOT_C 
						FROM(SELECT C.FILIAL,A.PRODUTO,A.COR_PRODUTO,
									CASE WHEN A.TAMANHO= 1 THEN A.QTDE_VENDIDA ELSE 0 END AS V1,
									CASE WHEN A.TAMANHO= 2 THEN A.QTDE_VENDIDA ELSE 0 END AS V2,
									CASE WHEN A.TAMANHO= 3 THEN A.QTDE_VENDIDA ELSE 0 END AS V3, 
									CASE WHEN A.TAMANHO= 4 THEN A.QTDE_VENDIDA ELSE 0 END AS V4,
									CASE WHEN A.TAMANHO= 5 THEN A.QTDE_VENDIDA ELSE 0 END AS V5,
									CASE WHEN A.TAMANHO= 6 THEN A.QTDE_VENDIDA ELSE 0 END AS V6,
									CASE WHEN A.TAMANHO= 7 THEN A.QTDE_VENDIDA ELSE 0 END AS V7,
									CASE WHEN A.TAMANHO= 8 THEN A.QTDE_VENDIDA ELSE 0 END AS V8,
									CASE WHEN A.TAMANHO= 9 THEN A.QTDE_VENDIDA ELSE 0 END AS V9,
									CASE WHEN A.TAMANHO= 10 THEN A.QTDE_VENDIDA ELSE 0 END AS V10
								FROM  (SELECT CODIGO_FILIAL, PRODUTO, COR_PRODUTO, TAMANHO, ISNULL(SUM(QTDE),0) AS QTDE_VENDIDA
											FROM LOJA_VENDA_PRODUTO
											GROUP BY CODIGO_FILIAL,PRODUTO,COR_PRODUTO,TAMANHO) A
								LEFT JOIN (SELECT CODIGO_FILIAL, PRODUTO, COR_PRODUTO, TAMANHO, SUM(QTDE) AS QTDE_TROCA
												FROM LOJA_VENDA_TROCA
												GROUP BY CODIGO_FILIAL,PRODUTO,COR_PRODUTO,TAMANHO) B
									ON A.CODIGO_FILIAL = B.CODIGO_FILIAL AND A.PRODUTO = B.PRODUTO AND A.COR_PRODUTO = B.COR_PRODUTO AND A.TAMANHO = B.TAMANHO
								JOIN LOJAS_VAREJO C
									ON A.CODIGO_FILIAL = C.CODIGO_FILIAL
								where a.produto = '<<strProduto>>') A
						GROUP BY FILIAL, PRODUTO, COR_PRODUTO
						ORDER BY FILIAL
				ENDTEXT

				f_select(strSql, 'CurGradeVenda', ALIAS())

				UPDATE A ;
					SET A.C1 = B.C1, A.C2 = B.C2, A.C3 = B.C3, A.C4 = B.C4, A.C5 = B.C5, ;
						A.C6 = B.C6, A.C7 = B.C7, A.C8 = B.C8, A.C9 = B.C9, A.C10 = B.C10, ;
						A.TOT_C = B.TOT_C ;
				FROM V_ROMANEIOS_PRODUTO_04_RESERVAS A ;
				JOIN CurGradeVenda B ;
					ON A.CLIENTE_ATACADO == B.FILIAL AND A.PRODUTO == B.PRODUTO AND A.COR_PRODUTO == B.COR_PRODUTO	

				USE IN CurGradeVenda
						
				IF !f_vazio(strAlias)
					SELECT(strAlias)
					GO (strRecno)
				endif		
	
			OTHERWISE
				RETURN .t.				
		endcase
	endproc
ENDDEFINE

DEFINE CLASS lx_textbox_base_SS AS lx_textbox_base
	Visible = .T.
	Enabled = .T.
	Width = 80

	PROCEDURE Refresh
		this.Enabled = IIF(inlist(thisformset.p_tool_status, 'A', 'L'), .T., .F.)
		=DODEFAULT()
	ENDPROC

	PROCEDURE Valid
		IF !F_select('SELECT GETDATE() AS DATA_HORA_ATUAL', 'curDatahora')
			MESSAGEBOX('Erro ao consultar hora do servidor, tente novamente.', 16, 'ATENÇÃO')
			RETURN .F.
		ELSE
			dtDataHoraAtual = curDatahora.DATA_HORA_ATUAL
			strHoraParametro = ALLTRIM(thisformset.pp_hora_corte_data_distrib)
			USE IN curDatahora
		ENDIF 
		* Verifica se a data de distribuição  é menor que a data atual ou a data igual atual e hora maior que a do parâmetro 
		IF thisformset.p_tool_status == 'A' AND !EMPTY(NVL(this.Value, '')) AND this.Value = DATE(YEAR(dtDataHoraAtual), MONTH(dtDataHoraAtual), DAY(dtDataHoraAtual)) AND ;
			(dtDataHoraAtual - DATETIME(YEAR(dtDataHoraAtual), MONTH(dtDataHoraAtual), DAY(dtDataHoraAtual), VAL(SUBSTR(strHoraParametro, 1, 2)), VAL(SUBSTR(strHoraParametro, 4, 2)))) > 0
			MESSAGEBOX('A data de distribuição não pode a data atual porque a hora atual é superior a: ' + strHoraParametro + '.' + CHR(10) + 'Informe uma data superior a data atual.', 16, 'ATENÇÃO')
			RETURN .F.
		ENDIF  
		
		IF thisformset.p_tool_status == 'A' AND !EMPTY(NVL(this.Value, '')) AND this.Value < DATE(YEAR(dtDataHoraAtual), MONTH(dtDataHoraAtual), DAY(dtDataHoraAtual))
			MESSAGEBOX('A data de distribuição não pode ser inferior ao dia: ' + DTOC(dtDataHoraAtual) + '.', 16, 'ATENÇÃO')
			RETURN .F.
		ENDIF 
		
		* Verifica se a data de distribuição é sábado ou domingo. Não pode ser final de semana.
		IF thisformset.p_tool_status == 'A' AND !EMPTY(NVL(this.Value, '')) AND INLIST(DOW(this.Value), 7, 1)
			MESSAGEBOX('A data de distribuição não pode ser Sábado ou Domingo.', 16, 'ATENÇÃO')
			RETURN .F.
		ENDIF 

		=DODEFAULT()
	ENDPROC
ENDDEFINE

