define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
			do case
				CASE UPPER(xmetodo) == 'USR_INIT'
					
					Thisformset.p_auditoria = ''
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Vers�o: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
									

				CASE UPPER(XMETODO) == 'USR_SAVE_BEFORE'
					xalias = alias()

					
					* 18/02/2015 - Leandro Rocha (SS): Coloca a filial de rateio igual a filial de faturamento, e usu�rio como respons�vel. Assim que � feito no faturamento manual
					IF thisformset.P_TOOL_STATUS == "I"
						IF !f_select([SELECT filial, cod_filial FROM filiais (nolock) WHERE filial = ?v_faturamento_05.filial], [curFilialRateio])
							MESSAGEBOX('Erro ao consulta c�digo da filial para usar como rateio de filial, tente novamente!', 16+0, 'ATEN��O')
							RETURN .F.
						ENDIF						

						REPLACE v_faturamento_05.rateio_filial WITH curFilialRateio.cod_filial ,;
								v_faturamento_05.conferido WITH .T. ,;
								v_faturamento_05.conferido_por WITH wUsuario ;
					 		IN v_faturamento_05
						
						USE IN curFilialRateio
					ENDIF					
					
					* 18/02/2015 - Leandro Rocha (SS): N�o permite faturamento com duas filiais de origem de estoque diferente na mesma NF. Esse bloqueio havia no objeto padr�o da Animale.
					SELECT DISTINCT COD_FILIAL_ESTOQUE FROM V_FATURAMENTO_05_PROD INTO CURSOR "curTempArmazens"
				
					IF RECCOUNT('curTempArmazens') > 1
						MESSAGEBOX("N�o � permitido NF com mais de uma Filial de Armazem na mesma NF.", 16, "ATEN��O")
						USE IN curTempArmazens
						RETURN .F.	
					ENDIF 
					
					USE IN curTempArmazens
					
					* 17/06/2014 - TIAGO CARVALHO - SINTESE SOLU��ES - SS01 -INICIO -  BLOQUEIA O FATURAMENTO ONDE O TOTAL FATURADO POR CAIXA � DIFERENTE DO TOTAL DA CAIXA ORIGINAL DA CAIXA, OU SEJA, N�O DEIXA FATURAR CAIXA PARCIALMENTE. E ATUALIZA O NUMERO DO LACRE
					IF (thisformset.P_TOOL_STATUS == "I" OR thisformset.P_TOOL_STATUS == "A" ) AND F_VAZIO(v_faturamento_05.MOTIVO_CANCELAMENTO_NFE)
						
						SELECT 	CAIXA, ;
								SUM(F1+F2+F3+F4+F5+F6+F7+F8+F9+F10+F11+F12+F13+F14+F15+F16+F17+F18+F19+F20+F21+F22+F23+F24+F25+F26+F27+F28+F29+F30+F31+F32+F33+F34+F35+F36+F37+F38+F39+F40+F41+F42+F43+F44+F45+F46+F47+F48) AS TOTAL_CAIXA_FATURAMENTO ;
							FROM v_faturamento_05_prod WITH (BUFFERING = .T.)  ;
							GROUP BY CAIXA ;
							INTO CURSOR curDivergencia
						
						lcObsLacre = ''
						
						SELECT curDivergencia
						GO TOP 
						SCAN FOR !F_VAZIO(ALLTRIM(curDivergencia.caixa))
							
							lcCaixa = ALLTRIM(curDivergencia.caixa)
							
							TEXT TO lcSql TEXTMERGE NOSHOW 
								SELECT	A.CAIXA, 
									NUMERO_LACRE = ISNULL(B.NUMERO_LACRE,'') , 
									TOTAL_CAIXA_ORIGINAL = SUM(E1+E2+E3+E4+E5+E6+E7+E8+E9+E10+E11+E12+E13+E14+E15+E16+E17+E18+E19+E20+E21+E22+E23+E24+E25+E26+E27+E28+E29+E30+E31+E32+E33+E34+E35+E36+E37+E38+E39+E40+E41+E42+E43+E44+E45+E46+E47+E48) 
									FROM VENDAS_PROD_EMBALADO A(NOLOCK)
									INNER JOIN FATURAMENTO_CAIXAS B(NOLOCK)
										ON A.CAIXA = B.CAIXA 
									WHERE A.CAIXA =?lcCaixa
								GROUP BY A.CAIXA,NUMERO_LACRE
								UNION ALL
								SELECT	A.CAIXA, 
										NUMERO_LACRE = '' , 
										TOTAL_CAIXA_ORIGINAL = SUM(F1+F2+F3+F4+F5+F6+F7+F8+F9+F10+F11+F12+F13+F14+F15+F16+F17+F18+F19+F20+F21+F22+F23+F24+F25+F26+F27+F28+F29+F30+F31+F32+F33+F34+F35+F36+F37+F38+F39+F40+F41+F42+F43+F44+F45+F46+F47+F48) 
										FROM FATURAMENTO_PROD A(NOLOCK)
										INNER JOIN FATURAMENTO_CAIXAS B(NOLOCK)
											ON A.CAIXA = B.CAIXA 
										WHERE A.CAIXA =?lcCaixa
									GROUP BY A.CAIXA
							ENDTEXT
										
							IF !f_select(lcSql, "CurCaixaOriginal")
								MESSAGEBOX('Erro ao consultar total original da caixa, tente novamente', 0+48, 'OBJ-SS- ERRO FATURAMENTO')
								RETURN .F.
							ENDIF
							
							IF RECCOUNT([CurCaixaOriginal]) < 1
								MESSAGEBOX('Caixa n�o encontrada na origem tente novamente. Caixa:' + ALLTRIM(curDivergencia.Caixa),  0+48, 'OBJ-SS- ERRO FATURAMENTO')
								RETURN .F.				
							ENDIF
							
							IF !F_VAZIO(ALLTRIM(CurCaixaOriginal.NUMERO_LACRE))
								lcObsLacre = lcObsLacre + "CX/LACRE:" + ALLTRIM(CurCaixaOriginal.CAIXA) + "/" + ALLTRIM(CurCaixaOriginal.NUMERO_LACRE) + " "
							ENDIF
								
							lcTotalCaixaOriginal = NVL(CurCaixaOriginal.TOTAL_CAIXA_ORIGINAL, 0)
							
							SELECT CurCaixaOriginal
							USE
								
							SELECT curDivergencia
								
							IF NVL(curDivergencia.TOTAL_CAIXA_FATURAMENTO, 0) <> lcTotalCaixaOriginal
								MESSAGEBOX( 'A caixa:' + ALLTRIM(curDivergencia.caixa) + ' tem quantidade divergente da origem.' + CHR(10) + ;
											'Qtde Faturada: ' + ALLTRIM(str(curDivergencia.TOTAL_CAIXA_FATURAMENTO)) + ' Qtde Original:' + ALLTRIM(STR(lcTotalCaixaOriginal)) + CHR(10) + ;
											'Processo cancelado, Verifique a Caixa e Tente Novamente', 0+16, 'OBJ-SS- ERRO FATURAMENTO')
								SELECT curDivergencia
								USE
								RETURN .f.
							ENDIF
						ENDSCAN
						
						IF !("LACRE" $ UPPER(ALLTRIM(v_faturamento_05.OBS)) OR F_VAZIO(lcObsLacre))
						
							lcObsLacre = "Cod Destino:" + ALLTRIM(v_faturamento_05.cod_clifor) + " - " + lcObsLacre
							*** incluido a coluna filial para aparecer no campo obs - lucas miranda - 15/09/2016
							IF F_VAZIO(ALLTRIM(v_faturamento_05.OBS))
								REPLACE v_faturamento_05.OBS WITH lcObsLacre IN v_faturamento_05							
							ELSE
								REPLACE v_faturamento_05.OBS WITH ALLTRIM(v_faturamento_05.OBS) + ' ' + lcObsLacre IN v_faturamento_05
							ENDIF
						ENDIF
						
						SELECT curDivergencia
						USE
					ENDIF				
					* 17/06/2014 - TIAGO CARVALHO - SINTESE SOLU��ES SS01 - FIM -
					
				*** incluido a coluna filial para aparecer no campo obs - lucas miranda - 15/09/2016
					IF F_VAZIO(ALLTRIM(v_faturamento_05.OBS))
						REPLACE v_faturamento_05.OBS WITH ALLTRIM(v_faturamento_05.filial) IN v_faturamento_05							
					ELSE
						REPLACE v_faturamento_05.OBS WITH ALLTRIM(v_faturamento_05.filial) + '  ' + ALLTRIM(v_faturamento_05.OBS) IN v_faturamento_05
					ENDIF
				***
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
				
				otherwise
				return .t.				
			endcase
	endproc
ENDDEFINE



