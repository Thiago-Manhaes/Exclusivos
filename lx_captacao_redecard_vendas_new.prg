PROCEDURE	LX_CAPTACAO_REDECARD_VENDAS_NEW

			LPARAMETERS PFORMSET, ;
						HANDLE_FILE, ;
						PTAMREG, PTAMARQ

			DIMENSION aStatus(63,2)
			aStatus(01,1)	= '000' 
			aStatus(01,2)	= 'CV / NSU OK               '
			aStatus(02,1)	= '001' 
			aStatus(02,2)	= 'VENDA JA PROCESSADA       '
			aStatus(03,1)	= '002' 
			aStatus(03,2)	= 'MOEDA INV·LIDA            '
			aStatus(04,1)	= '003' 
			aStatus(04,2)	= 'TT PREST DIF VR VD        '
			aStatus(05,1)	= '004' 
			aStatus(05,2)	= 'CV / NSU SEM VR PREST     '
			aStatus(06,1)	= '005' 
			aStatus(06,2)	= 'CP ACIMA LIM REDESHO      '
			aStatus(07,1)	= '007' 
			aStatus(07,2)	= 'CV / NSU IRREGULAR        '
			aStatus(08,1)	= '008' 
			aStatus(08,2)	= 'ESTAB BORDERO INVALI      '
			aStatus(09,1)	= '010' 
			aStatus(09,2)	= 'CARTAO EM BP              '
			aStatus(10,1)	= '011' 
			aStatus(10,2)	= 'CV / NSU SEM ASSINATURA   '
			aStatus(11,1)	= '012' 
			aStatus(11,2)	= 'CV / NSU ILEGIVEL         '
			aStatus(12,1)	= '013' 
			aStatus(12,2)	= 'CV / NSU SEM AUTORIZACAO  '
			aStatus(13,1)	= '014' 
			aStatus(13,2)	= 'CARTAO N CRED/DINERS      '
			aStatus(14,1)	= '015' 
			aStatus(14,2)	= 'FALTA 2A VIA PROCESS      '
			aStatus(15,1)	= '016' 
			aStatus(15,2)	= 'ESTAB S/ IATA N AUTO      '
			aStatus(16,1)	= '017' 
			aStatus(16,2)	= 'CV / NSU IRREGULAR        '
			aStatus(17,1)	= '018' 
			aStatus(17,2)	= 'CARTAO EM BP              '
			aStatus(18,1)	= '019' 
			aStatus(18,2)	= 'TX EMBARQUE VLR EXCD      '
			aStatus(19,1)	= '020' 
			aStatus(19,2)	= 'CARTAO VENCIDO            '
			aStatus(20,1)	= '021' 
			aStatus(20,2)	= 'CV / NSU PARA CARTAO JURID'
			aStatus(21,1)	= '022' 
			aStatus(21,2)	= 'ACIMA LIMITE C/AUTOR      '
			aStatus(22,1)	= '023' 
			aStatus(22,2)	= 'DATA CV / NSU POSTERIOR RV'
			aStatus(23,1)	= '025' 
			aStatus(23,2)	= 'CARTAO N CRED/DINERS      '
			aStatus(24,1)	= '027' 
			aStatus(24,2)	= 'CV / NSU PARA CARTAO INTER'
			aStatus(25,1)	= '028' 
			aStatus(25,2)	= 'CARTAO EM BP              '
			aStatus(26,1)	= '029' 
			aStatus(26,2)	= 'PROMOCAO MASTERCARD       '
			aStatus(27,1)	= '030' 
			aStatus(27,2)	= 'TR INV P/TIPO CARTAO      '
			aStatus(28,1)	= '031' 
			aStatus(28,2)	= 'PLAN PAGTO BIG TICKE      '
			aStatus(29,1)	= '032' 
			aStatus(29,2)	= 'COD AUT N ENCONTRADO      '
			aStatus(30,1)	= '034' 
			aStatus(30,2)	= 'DATA CV / NSU POSTERIOR RV'
			aStatus(31,1)	= '035' 
			aStatus(31,2)	= 'CV / NSU COM VR INCORRETO '
			aStatus(32,1)	= '036' 
			aStatus(32,2)	= 'CV / NSU SEM AUTORIZACAO  '
			aStatus(33,1)	= '037' 
			aStatus(33,2)	= 'APRES. TARDIA CV / NSU    '
			aStatus(34,1)	= '041' 
			aStatus(34,2)	= 'PARC.INVAL.VIAC.AERE      '
			aStatus(35,1)	= '042' 
			aStatus(35,2)	= 'NAC.INVAL.- DUTY FRE      '
			aStatus(36,1)	= '043' 
			aStatus(36,2)	= 'MQ INVA/NAO TR VISTA      '
			aStatus(37,1)	= '044' 
			aStatus(37,2)	= 'CV / NSU S/JRS EM RV ROTAT'
			aStatus(38,1)	= '045' 
			aStatus(38,2)	= 'CV / NSU ROT EM RV S/JUROS'
			aStatus(39,1)	= '047' 
			aStatus(39,2)	= 'CARTAO N PODE PARCEL      '
			aStatus(40,1)	= '048' 
			aStatus(40,2)	= 'ESTAB.NAO AUTORIZADO      '
			aStatus(41,1)	= '049' 
			aStatus(41,2)	= 'DESCUMPRIM DE PROCED      '
			aStatus(42,1)	= '102' 
			aStatus(42,2)	= 'COD AUT N ENCONTRADO      '
			aStatus(43,1)	= '106' 
			aStatus(43,2)	= 'VR CV / NSU MAIOR QUE AUT '
			aStatus(44,1)	= '108' 
			aStatus(44,2)	= 'AUT CART√O DIFERENTE      '
			aStatus(45,1)	= '109' 
			aStatus(45,2)	= 'ESTAB BORDERO INVALI      '
			aStatus(46,1)	= '110' 
			aStatus(46,2)	= 'TIPO TRANS DF DA AUT      '
			aStatus(47,1)	= '111' 
			aStatus(47,2)	= 'CV / NSU SEM ASSINATURA   '
			aStatus(48,1)	= '112' 
			aStatus(48,2)	= 'CV / NSU ILEGIVEL         '
			aStatus(49,1)	= '114' 
			aStatus(49,2)	= 'CART√O N CRED/DINERS      '
			aStatus(50,1)	= '115' 
			aStatus(50,2)	= 'FALTA 2A VIA PROCESS      '
			aStatus(51,1)	= '117' 
			aStatus(51,2)	= 'CV / NSU IRREGULAR        '
			aStatus(52,1)	= '125' 
			aStatus(52,2)	= 'CART√O N CRED/DINERS      '
			aStatus(53,1)	= '137' 
			aStatus(53,2)	= 'APRES. TARDIA CV / NSU    '
			aStatus(54,1)	= '141' 
			aStatus(54,2)	= 'PARC. INVAL. VIAC. AERE   '
			aStatus(55,1)	= '142' 
			aStatus(55,2)	= 'NAC. INVAL. - DUTY FRE    '
			aStatus(56,1)	= '143' 
			aStatus(56,2)	= 'MQ INVA/N√O TR VISTA      '
			aStatus(57,1)	= '144' 
			aStatus(57,2)	= 'CV / NSU S/ JRS EM RV ROTA'
			aStatus(58,1)	= '145' 
			aStatus(58,2)	= 'CV / NSU ROT EM RV S/ JURO'
			aStatus(59,1)	= '147' 
			aStatus(59,2)	= 'CARTAO N PODE PARCEL      '
			aStatus(60,1)	= '148' 
			aStatus(60,2)	= 'ESTAB. N√O AUTORIZADO     '
			aStatus(61,1)	= '149' 
			aStatus(61,2)	= 'DESCUMPRIM DE PROCED      '
			aStatus(62,1)	= '194' 
			aStatus(62,2)	= 'CV / NSU SEM AUTORIZA«√O  '
			aStatus(63,1)	= '198' 
			aStatus(63,2)	= 'COD AUT REUTILIZADO       '
			lcArquivo		= FILETOSTR(PFORMSET.px_arquivo_adm)
			lcCrLf			= CHR(10)     		

			for	lcOcorrencia = 1 to OCCURS(lcCrLf,lcArquivo)

				F_WAIT('Captando Resumos do Arquivo: '+PFORMSET.px_arquivo_adm+'!',PTAMARQ)

				xLinha 		= STREXTRACT(lcArquivo,lcCrLf,lcCrLf,lcOcorrencia)	
				xTipoReg 	= SUBSTR(xLinha,001,03)

				do	case

					case	inlist(xTipoReg,'010','012')

							do	case

								case	inlist(xTipoReg,'010')	&& RV Parcelado sem juros

										xmaquineta      = substr(xlinha,004,09)
										If !f_vazio(PFORMSET.px_tipo_estabelecimento)
											If !Seek(PADL(ALLTRIM(xmaquineta),11,"0")+" "+ALLTRIM(PFORMSET.px_tipo_estabelecimento), "cur_relacao_estabelecimentos", "idxTipo")
												Loop 
											EndIf 
										EndIf 
										xguia_envio     = substr(xlinha,013,09)
										xemissao        = ctod(substr(xlinha,041,02)+'/'+substr(xlinha,043,02)+'/'+substr(xlinha,045,04))	&& -ruy
										xvctorejeitado  = ctod(substr(xlinha,129,02)+'/'+substr(xlinha,131,02)+'/'+substr(xlinha,133,04))	&& -ruy
										xvalorrejeitado = val(substr(xlinha,084,15))/100


								case	inlist(xTipoReg,'012')	&& CV / NSU Parcelado sem juros

										If !f_vazio(PFORMSET.px_tipo_estabelecimento)
											If !Seek(PADL(ALLTRIM(xmaquineta),11,"0")+" "+ALLTRIM(PFORMSET.px_tipo_estabelecimento), "cur_relacao_estabelecimentos", "idxTipo")
												Loop 
											EndIf 
										EndIf 
										
										lcParcelaAcm 	= 0
										lcLiquidoAcm	= 0
                                        xvalor_bruto	= val(substr(xlinha,038,15))/100
										xvalor_liquido	= val(substr(xlinha,206,15))/100                              
										xCartao			= substr(xLinha,068,16)
										xStatusCv		= SUBSTR(xLinha,084,03)
										xMaxParcelas	= IIF(VAL(SUBSTR(xLinha,087,02))=0,'01',SUBSTR(xLinha,087,02))
										xAprovacao		= PADL(ALLTRIM(STR(val(substr(xlinha,89,12)),12)),9,'0') && substr(xLinha,129,06)	
										xvalor_taxa		= (val(substr(xlinha,114,15))/100)/VAL(xMaxParcelas) &&(xvalor_bruto-xvalor_liquido)/xvalor_bruto
										xTipoCaptura  	= IIF(SUBSTR(xLinha,205,01)='1','MANUAL',;
														  IIF(SUBSTR(xLinha,205,01)='2','POS',;
														  IIF(SUBSTR(xLinha,205,01)='3','PDV',;
														  IIF(SUBSTR(xLinha,205,01)='4','TO',;
														  IIF(SUBSTR(xLinha,205,01)='5','INTERNET',;
														  IIF(SUBSTR(xLinha,205,01)='9','OUTROS',''))))))

										for	lcParcela = 1 to val(xMaxParcelas)

                                            xparcela 				= padl(alltrim(str(lcParcela,2)),2,'0')+'/'+xmaxparcelas
											xvalor_parcela_bruto	= iif(lcParcela<val(xMaxParcelas),xvalor_bruto/val(xMaxParcelas),xvalor_bruto-lcParcelaAcm)										
                                            xvalor_parcela_liquido	= iif(lcParcela<val(xMaxParcelas),xvalor_liquido/val(xMaxParcelas),xvalor_liquido-lcLiquidoAcm)
											xvencimento				= gomonth(xemissao,lcparcela)
											lcParcelaAcm			= lcParcelaAcm 	+ xvalor_parcela_bruto
											lcLiquidoAcm			= lcLiquidoAcm 	+ xvalor_parcela_liquido
											xsomabruto				= xsomabruto  	+ xvalor_parcela_bruto
											xsomataxa				= xsomataxa   	+ xvalor_taxa
											xsomarejeit				= xsomarejeit 	+ xvalorrejeitado
											xsomaliquid				= xsomaliquid 	+ xvalor_parcela_liquido
											xqtderesumo 			= xqtderesumo 	+ 1

											append blank in v_temp_lote		
	
											replace cp						with 0,;
													maquineta 				with xmaquineta,;
													filial          		with pformset.lx_localiza_filial(xmaquineta),;
													guia_envio 				with xguia_envio,;
													parcela 				with xparcela,;
													status 					with xStatusCv+' - parcelas: parcelado sem juros',;
													emissao 				with xemissao,;
													vencimento 				with xvencimento,;
													valor_bruto 			with xvalor_parcela_bruto,;
													valor_taxa 				with xvalor_taxa,;
													valor_rejeitado 		with xvalorrejeitado,;
													valor_liquido 			with xvalor_parcela_liquido,;
													qtde_aceitos 			with iif(val(xStatusCv)=0,qtde_aceitos+1,qtde_aceitos)   ,;
													qtde_rejeitados 		with iif(val(xStatusCv)>0,qtde_rejeitados+1,qtde_rejeitados),;
													cartao					with xcartao,;
													tipo_captura    		with xTipoCaptura,;
													numero_aprovacao_cartao with xAprovacao,;
	                              					observacao				with xStatusCv+' - '+aStatus(CEILING(ASCAN(aStatus,xStatusCv)/2),2) in v_temp_lote 

										endfor	

							endcase

					case	inlist(xTipoReg,'006','008')

							do	case

								case	inlist(xTipoReg,'006')		&& RV Credito rotativo

										xmaquineta      = substr(xlinha,004,09)
										If !f_vazio(PFORMSET.px_tipo_estabelecimento)
											If !Seek(PADL(ALLTRIM(xmaquineta),11,"0")+" "+ALLTRIM(PFORMSET.px_tipo_estabelecimento), "cur_relacao_estabelecimentos", "idxTipo")
												Loop 
											EndIf 
										EndIf 
										xguia_envio     = substr(xlinha,013,09)
										xemissao        = ctod(substr(xlinha,041,02)+'/'+substr(xlinha,043,02)+'/'+substr(xlinha,045,04))
										xvctorejeitado  = ctod(substr(xlinha,041,02)+'/'+substr(xlinha,043,02)+'/'+substr(xlinha,045,04))
										xvalorrejeitado = val(substr(xlinha,084,15))/100

								case	inlist(xTipoReg,'008')		&& CV / NSU Credito rotativo

										If !f_vazio(PFORMSET.px_tipo_estabelecimento)
											If !Seek(PADL(ALLTRIM(xmaquineta),11,"0")+" "+ALLTRIM(PFORMSET.px_tipo_estabelecimento), "cur_relacao_estabelecimentos", "idxTipo")
												Loop 
											EndIf 
										EndIf 
                                        xparcela 				= 'AV' &&'01/001'
										xvalor_parcela_bruto	= val(substr(xlinha,038,15))/100
                                        xvalor_parcela_liquido	= val(substr(xlinha,204,15))/100
										xvencimento				= ctod(substr(xlinha,022,02)+'/'+substr(xlinha,024,02)+'/'+substr(xlinha,026,04))
										xvencimento				= gomonth(xvencimento,1)
										xCartao					= substr(xLinha,068,16)
										xStatusCv				= SUBSTR(xLinha,084,03)
										xAprovacao				= PADL(ALLTRIM(STR(val(substr(xlinha,87,12)),12)),9,'0') && substr(xLinha,129,06)	
										xvalor_taxa				= val(substr(xlinha,112,15))/100 &&(xvalor_parcela_bruto-xvalor_parcela_liquido)/xvalor_parcela_bruto
										xTipoCaptura  			= IIF(SUBSTR(xLinha,203,01)='1','MANUAL',;
																  IIF(SUBSTR(xLinha,203,01)='2','POS',;
																  IIF(SUBSTR(xLinha,203,01)='3','PDV',;
																  IIF(SUBSTR(xLinha,203,01)='4','TO',;
																  IIF(SUBSTR(xLinha,203,01)='5','INTERNET',;
																  IIF(SUBSTR(xLinha,203,01)='9','OUTROS',''))))))

										xsomabruto				= xsomabruto  	+ xvalor_parcela_bruto
										xsomataxa				= xsomataxa   	+ xvalor_taxa
										xsomarejeit				= xsomarejeit 	+ xvalorrejeitado
										xsomaliquid				= xsomaliquid 	+ xvalor_parcela_liquido
										xqtderesumo 			= xqtderesumo 	+ 1

										append blank in v_temp_lote		

										replace cp						with 0,;
												maquineta 				with xmaquineta,;
												filial          		with pformset.lx_localiza_filial(xmaquineta),;
												guia_envio 				with xguia_envio,;
												parcela 				with xparcela,;
												status 					with xStatusCv+' - parcelas: parcelado sem juros',;
												emissao 				with xemissao,;
												vencimento 				with xvencimento,;
												valor_bruto 			with xvalor_parcela_bruto,;
												valor_taxa 				with xvalor_taxa,;
												valor_rejeitado 		with xvalorrejeitado,;
												valor_liquido 			with xvalor_parcela_liquido,;
												qtde_aceitos 			with iif(val(xStatusCv)=0,qtde_aceitos+1,qtde_aceitos)   ,;
												qtde_rejeitados 		with iif(val(xStatusCv)>0,qtde_rejeitados+1,qtde_rejeitados),;
												cartao					with xcartao,;
												tipo_captura    		with xTipoCaptura,;
												numero_aprovacao_cartao with xAprovacao,;
                              					observacao				with xStatusCv+' - '+aStatus(CEILING(ASCAN(aStatus,xStatusCv)/2),2) in v_temp_lote 

							endcase

				endcase

			endfor						    	

			F_WAIT()
   				
   			sele v_temp_lote
   			BROWSE normal	
ENDPROC      