*!**************************************************************************
*!* PROGRAMA EXTERNO PARA LEITURA EXTRATO MULTIBANDEIRA CIELO		     *!*
*!* VERSAO 000.1 - 24/03/2011						                     *!*
*!* Organização do arquivo: Sequencial - Tamanho do registro: 250 bytes  *!*
*!* M5 - Diana C. Figueiredo - Criado em: 04/09/2011        	         *!*
*!************************************************************************!*
PROCEDURE LX_CAPTACAO_VENDAS_CIELO
      LPARAMETERS PFORMSET, HANDLE_FILE, PTAMREG, PTAMARQ

xLer = .T.
DO WHILE !FEOF(HANDLE_FILE)
	F_WAIT('Captando Resumos do Arquivo: '+PFORMSET.px_arquivo_adm+'!',PTAMARQ)
SET STEP ON 
	xLinha   = FGETS(HANDLE_FILE,PTAMREG)
	xTipoReg = SUBSTR(xLinha,001,01)

	IF xTipoReg = '1'							&& Cabeçalho

	 	IF SUBSTR(xLinha,123,2) $ '01,02,03,00' &&AND Substr(xLinha,161,1) = ' '	
	 		&& Captar 01 Pago
	 		&& Não está lendo Antecipacao xSubstr(xLinha,161,1) = 'A' por enquanto
			xLer = .T.
		ELSE
			xLer = .F.
			LOOP
		ENDIF

		xStatus =	IIF(SUBSTR(xLinha,161,1) = 'A', 'Antecipacao',;
					IIF(SUBSTR(xLinha,123,2) = '01', 'Pagamento',;
					IIF(SUBSTR(xLinha,123,2) = '00', 'Previsao',;
					IIF(SUBSTR(xLinha,123,2) = '02' or SUBSTR(xLinha,123,2) = '03', 'Transito',''))))
		
		IF SUBSTR(xLinha,123,2) $ '01'
			xVencimento	 = CTOD(SUBSTR(xLinha,049,02)+'/'+SUBSTR(xLinha,047,02)+'/'+SUBSTR(xLinha,045,02))		&& Data de Crédito (Pagamento)
		ELSE
			xVencimento	 = CTOD(SUBSTR(xLinha,055,02)+'/'+SUBSTR(xLinha,053,02)+'/'+SUBSTR(xLinha,051,02))		&& Data prevista para Crédito
		ENDIF
		
		IF SUBSTR(xLinha,123,2) != '01'      												&& Como é só previsão não tem o registro detalhe tipo=2 para D a parcela esta no detalhe
			xParcela	 = IIF( SUBSTR(xLinha,019,02) = '  ', 'AV', SUBSTR(xLinha,019,02) + '/')
			xParcela	 = IIF( xParcela = '00/', '01/', xParcela )								&& Se Previsão de Pagamento
			xMaxParcelas = IIF( SUBSTR(xLinha,019,02) = '  ', '', SUBSTR(xLinha,022,02))
			XGUIA_ENVIO  = SUBSTR(xLinha,012,07)
			xQtdeAceLote = VAL(SUBSTR(xLinha,136,06))
			xQtdeRejLote = VAL(SUBSTR(xLinha,143,06))
		ENDIF
		
		xVTaxaLote	 = VAL(SUBSTR(xLinha,072,13))/100										&& Taxa Administrativa em valor, sempre traz a taxa total que deve ser rateada para os itens
		xVBrutoLote  = VAL(SUBSTR(xLinha,058,13))/100										&& Valor Bruto do lote
		xVLiqLote    = VAL(SUBSTR(xLinha,099,13))/100										&& Valor Liquido do lote
		xVRejLote    = VAL(SUBSTR(xLinha,086,13))/100										&& Valor Rejeitado do lote
		
		xEmissao	 = CTOD(SUBSTR(xLinha,043,02)+'/'+SUBSTR(xLinha,041,02)+'/'+SUBSTR(xLinha,039,02))
		
		xIndicaDeb	 = IIF(SUBSTR(xLinha,142,1) = 'E',.T.,.F.)								&& Indicador de Débito
		
		xCodBandeira = SUBSTR(xLinha,197,03)
		DO CASE 
		CASE xCodBandeira = '001'  && VISA
			xWhere = "ADMINISTRADORA LIKE 'VISA%' AND TIPO_CARTAO = "+IIF(xIndicaDeb =.T.,"1","0")
		CASE xCodBandeira = '002'  && MASTER
			xWhere = "ADMINISTRADORA IN ('MASTERCARD','CREDICARD','REDESHOP') AND TIPO_CARTAO = "+IIF(xIndicaDeb = .T.,"1","0")
		CASE xCodBandeira = '009'  && DINERS
			xWhere = "ADMINISTRADORA LIKE 'DIN%ER%' AND TIPO_CARTAO = "+IIF(xIndicaDeb = .T.,"1","0")
		CASE xCodBandeira = '007'  && ELO
			xWhere = "ADMINISTRADORA LIKE 'ELO%' AND TIPO_CARTAO = "+IIF(xIndicaDeb = .T.,"1","0")
		OTHERWISE 
			xWhere = "ADMINISTRADORA NOT IN ('MASTERCARD','CREDICARD','REDESHOP') AND ADMINISTRADORA NOT LIKE 'VISA%' AND ADMINISTRADORA NOT LIKE 'DIN%ER%' AND ADMINISTRADORA NOT LIKE 'ELO%' AND TIPO_CARTAO = "+IIF(xIndicaDeb = .T.,"1","0")
		ENDCASE
		
		f_select("SELECT taxa_administracao,codigo_administradora,administradora,tipo_cartao "+;
					"FROM administradoras_cartao WHERE "+xWhere+" AND rede_controladora = '"+PFORMSET.rede+"'","cur_adms")
		IF RECCOUNT("cur_adms") > 0
			SELECT cur_adms 
			GO TOP
			xAdm = ""
			SCAN
				xAdm = xAdm+cur_adms.codigo_administradora+";"
			ENDSCAN 
		ELSE
			xAdm = ""
		ENDIF
				
		IF SUBSTR(xLinha,150,01) $ 'C;T'  && Se é previsão de pagamento não tem detalhes apenas os campos do cabecalho de lote tipo 1 então já preenche o cursor da tela direto
			SELECT 	v_temp_lote
			xlocateagrupa = PFORMSET.PX_CONDICAO_AGREGACAO_EXTRATOS
			LOCATE FOR &xlocateagrupa.
			IF EOF() 
				APPEND BLANK
				REPLACE CP	 		WITH 0,;
					MAQUINETA 		WITH xMaquineta,;
					FILIAL          WITH PFORMSET.lx_localiza_filial(xMaquineta),;
					GUIA_ENVIO 		WITH XGUIA_ENVIO,;
					PARCELA 		WITH xParcela + xMaxParcelas,;
					STATUS 			WITH xStatus ,;
					VENCIMENTO 		WITH xVencimento,;
					VALOR_BRUTO 	WITH xVBrutoLote,;
					VALOR_TAXA 		WITH xVTaxaLote,;
					VALOR_REJEITADO WITH xVRejLote,;
					VALOR_LIQUIDO 	WITH xVLiqLote,;
					QTDE_ACEITOS 	WITH xQtdeAceLote ,;
					QTDE_REJEITADOS WITH xQtdeRejLote,;
					EMISSAO			WITH xEmissao 
			ELSE 
				REPLACE CP		WITH 0,;
				VALOR_BRUTO 	WITH VALOR_BRUTO+xVBrutoLote,;
				VALOR_TAXA 		WITH VALOR_TAXA+xVTaxaLote,;
				VALOR_REJEITADO WITH VALOR_REJEITADO+xVRejLote,;
				VALOR_LIQUIDO 	WITH VALOR_LIQUIDO+xVLiqLote,;
				QTDE_ACEITOS 	WITH QTDE_ACEITOS+xQtdeAceLote ,;
				QTDE_REJEITADOS WITH QTDE_REJEITADOS+xQtdeRejLote 
			ENDIF
		ENDIF
				
		LOOP
	ENDIF

	IF xLer = .F.  && Se a leitura do cabecalho não é para ser feita pula os itens (se houver até o proximo cabecalho)
		LOOP
	ENDIF
	
	IF xTipoReg = '2' 									&& Movimentos de venda - a vista e parcelados
		
		xMaquineta   = PADL(SUBSTR(xLinha,002,10),11,'0')
		xEmissao	 = CTOD(SUBSTR(xLinha,044,02)+'/'+SUBSTR(xLinha,042,02)+'/'+SUBSTR(xLinha,038,04))
		xCartao		 = SUBSTR(xLinha,019,19)
		XNUMERO_APROVACAO_CARTAO = PADL(ALLTRIM(SUBSTR(xLinha,140,06)),9,"0")

		XGUIA_ENVIO = SUBSTR(xLinha,012,07)
		
		xValorBruto	 = VAL(SUBSTR(xLinha,047,13))/100
		xValorRejeitado = 0
		xObservacao = xAdm
		xQtdeAceitos = 1
		xQtdeRejeitados = 0
		
		&& Utiliza o valor total da Taxa do cabeçalho para calcular a porcentagem e ratear nos itens.
		xValorTaxa	 = ROUND(xValorBruto * (xVTaxaLote / xVBrutoLote),02)
		xValorLiquido= xValorBruto - xValorTaxa
		
		xParcela	 = IIF( SUBSTR(xLinha,060,02) = '00', 'AV', SUBSTR(xLinha,060,02) + '/' +SUBSTR(xLinha,062,02))
		
		SELECT 	v_temp_lote
		xlocateagrupa = PFORMSET.PX_CONDICAO_AGREGACAO_EXTRATOS
		LOCATE FOR &xlocateagrupa.
		IF EOF() 
			APPEND BLANK
			REPLACE CP	 		WITH 0,;
				MAQUINETA 		WITH xMaquineta,;
				FILIAL          WITH PFORMSET.lx_localiza_filial(xMaquineta),;
				GUIA_ENVIO 		WITH XGUIA_ENVIO,;
				PARCELA 		WITH xParcela ,;
				STATUS 			WITH xStatus ,;
				EMISSAO 		WITH xEmissao,;
				VENCIMENTO 		WITH xVencimento,;
				VALOR_BRUTO 	WITH xValorBruto,;
				VALOR_TAXA 		WITH xValorTaxa,;
				VALOR_REJEITADO WITH xValorRejeitado,;
				VALOR_LIQUIDO 	WITH xValorLiquido,;
				QTDE_ACEITOS 	WITH xQtdeAceitos,;
				QTDE_REJEITADOS WITH xQtdeRejeitados,;
				CARTAO			WITH xCartao,;
				NUMERO_APROVACAO_CARTAO With XNUMERO_APROVACAO_CARTAO,;
				OBSERVACAO      WITH xObservacao
		ELSE 
			REPLACE CP		WITH 0,;
			VALOR_BRUTO 	WITH VALOR_BRUTO+xValorBruto,;
			VALOR_TAXA 		WITH VALOR_TAXA+xValorTaxa,;
			VALOR_REJEITADO WITH VALOR_REJEITADO+xValorRejeitado,;
			VALOR_LIQUIDO 	WITH VALOR_LIQUIDO+xValorLiquido,;
			QTDE_ACEITOS 	WITH QTDE_ACEITOS+xQtdeAceitos,;
			QTDE_REJEITADOS WITH QTDE_REJEITADOS+xQtdeRejeitados
		ENDIF

		xSomaBruto	= xSomaBruto  + VALOR_BRUTO
		xSomaTaxa	= xSomaTaxa   + VALOR_TAXA
		xSomaRejeit	= xSomaRejeit + VALOR_REJEITADO
		xSomaLiquid	= xSomaLiquid + VALOR_LIQUIDO
		xQtdeResumo = xQtdeResumo + 1
		
	ENDIF

ENDDO
F_WAIT()
  
ENDPROC      