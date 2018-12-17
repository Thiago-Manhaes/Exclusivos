Define Class Obj_Entrada_XML As Custom
	*!* Criar Função e chamar no Obj de entrada *!*

	** Função abaixo criada para executar em todos os metodos da tela **
	Function l_Obj_entrada_xml String

	Lparam xTransacao, xmetodo, xobjeto ,xnome_obj,xToolStatus
	*!* Aqui escrever o código a ser executado pela função *!*	
		
 
	If (Upper(xmetodo) == 'USR_INCLUDE_AFTER' Or Upper(xmetodo) == 'USR_ALTER_BEFORE') &&AND xToolStatus $ 'I,A'

		*!* Desabilita entrada propria caso usuário não tenha permissão no parâmetro *!*
		xParam = xTransacao+".pp_GS_NOTA_PROPRIA"
		IF TYPE("&xParam")<>'U'
			IF !&xParam
				With &xTransacao
					.lx_form1.lx_pageframe1.page1.pageframe1.page1.ck_nf_propria.Enabled= .f.
				Endwith
			ENDIF
		ENDIF	
		
		xParamEspSerie = xTransacao+".pp_anm_especie_serie_padrao"
		If  &xParamEspSerie <> '0'

			If xToolStatus = 'I'
				With &xTransacao
					.lx_form1.lx_pageframe1.page1.pageframe1.page1.tv_Desc_Especie_Serie.Value = 'NF-E'
				Endwith

				Sele V_ENTRADAS_00
				xEspecie_Serie = 5
				xModelo_Fiscal = '55'

				Replace ESPECIE_SERIE 		 With xEspecie_Serie
				Replace NUMERO_MODELO_FISCAL With xModelo_Fiscal
			Endif

			With &xTransacao
				.lx_form1.lx_pageframe1.page1.pageframe1.page1.tv_Desc_Especie_Serie.Valid()
				.lx_form1.lx_pageframe1.page1.pageframe1.page1.tv_Desc_Especie_Serie.Enabled = .F.
			Endwith

		Endif

		With &xTransacao
			.lx_form1.lx_pageframe1.page1.pageframe1.page1.pageframe1.page1.tv_transportadora_a_pagar.p_valida_colunas_select= ;
				'TRANSPORTADORAS.TRANSPORTADORA,TRANSPORTADORAS.CGC,TRANSPORTADORAS.INSCRICAO'
		Endwith

	Endif

	If Upper(xmetodo) == 'USR_VALID'
		
		If Upper(xnome_obj)=='TV_DESC_ESPECIE_SERIE' Or Upper(xnome_obj)=='TV_OPERACAO' Or Upper(xnome_obj)=='NF_ENTRADA_PROPRIA'

			xVorF = !V_ENTRADAS_00.NUMERO_MODELO_FISCAL='55' Or V_ENTRADAS_00.NF_ENTRADA_PROPRIA
			xParamReturn = xTransacao+".pp_ANM_AVISA_OU_BLOQ_XML_NFE"
			*** travar, liberar campos ***
			****************************
			With &xTransacao

				With .lx_form1.lx_pageframe1
					** aba: 1-cabeçalho
					With .page1.pageframe1.page1
						.tx_emissao.Enabled= xVorF
						.pageframe1.page1.CmdFretePagar.Enabled = xVorF
					Endwith

					** aba: 2-cabeçalho
					With .page1.pageframe1.page2
						.tx_frete.Enabled= xVorF
						.tx_seguro.Enabled= xVorF
						.tx_porc_desconto.Enabled= .T. 
						.tx_porc_encargo.Enabled= .T.
						.tx_desconto.Enabled= .T.
						.tx_encargo.Enabled= .T.
					Endwith

					** aba: nfe
					With .page1.pageframe1.page_nfe
						.txt_chave_nfe.Enabled = &xParamReturn
						.txt_protocolo_autorizacao.Enabled = xVorF
						.txt_data_autorizacao_nfe.Enabled = xVorF
						.cmb_tipo_emissao_nfe.Enabled = xVorF
					Endwith
				Endwith

			Endwith
			*** Fim, Travar, Liberar campos ****

		Endif


		If Upper(xnome_obj)=='CMD_IMPORTA_CHAVE_NFE'

			*** importando itens do xml ***
			*******************************
			Select cur_nfe_xml
			wtotal = (Strextract(conteudo_nfe,'<ICMSTot>','</ICMSTot>',1))
			wide   = (Strextract(conteudo_nfe,'<ide>','</ide>',1))
			xEmit = (Strextract(conteudo_nfe,'<emit>','</emit>',1))

			Select V_ENTRADAS_00
			Replace FRETE    With Val(Strextract(wtotal,'<vFrete>','</vFrete>',1))
			Replace SEGURO   With Val(Strextract(wtotal,'<vSeg>','</vSeg>',1))
			Replace DESCONTO With Val(Strextract(wtotal,'<vDesc>','</vDesc>',1))
			Replace ENCARGO  With Val(Strextract(wtotal,'<vOutro>','</vOutro>',1))
			*** fim importa itens do xml ***

			** Bloqueia alterar especie serie após importar XML **
			Sele V_ENTRADAS_00
			With &xTransacao
				.lx_form1.lx_pageframe1.page1.pageframe1.page1.tv_Desc_Especie_Serie.Enabled = f_vazio(CHAVE_NFE)
			Endwith


		Endif

	Endif

	Endfunc


	** Função abaixo criada para executar no momento do Refresh da tela **
	Function l_anm_valida_xml String

	Lparam xTransacao, xmetodo, xobjeto ,xnome_obj,xToolStatus
	*!* Aqui escrever o código a ser executado pela função *!*

		
	*!* Libera caso a entrada seja uma entrada própria *!*
	If V_ENTRADAS_00.NF_ENTRADA_PROPRIA or xToolStatus = 'E' or V_ENTRADAS_00.NUMERO_MODELO_FISCAL<>'55'
		Return .T.
		Select(nOldSele)
	Endif


	*!* Começa aqui classe de validação *!*
	Local cArquivo, nOldSele, cNumero_Modelo_Fiscal, xReturn, cMsg, nQtde_Total, nQtde_Item, wveicTransp, wTransp, wtotal, dAutorizacao, cProtocolo

	nOldSele = Select()

	*-- VERIFICANDO SE EXISTE OS PARÂMETROS --*
	If !F_select("Select VALOR_ATUAL as MODELO from PARAMETROS where PARAMETRO = 'INTERFACE_NFE'","CURINTERFACE")
		Messagebox.Show( "Impossivel selecionar - PARAMETROS: INTERFACE_NFE",48,"Atenção")
		Select(nOldSele)
		Return .F.
	Endif

	If !F_select("Select VALOR_ATUAL as PARAM from PARAMETROS where PARAMETRO = 'ANM_TOLERANCIA_XML_NFE'","CURPARAM")
		Messagebox.Show( "Impossivel selecionar - PARAMETROS: ANM_TOLERANCIA_XML_NFE",48,"Atenção")
		Select(nOldSele)
		Return .F.
	Endif

	If !F_select("Select VALOR_ATUAL as PARAM from PARAMETROS where PARAMETRO = 'ANM_TOLERANCIA_IMP_XML_NF'","CURPARAM")
		Messagebox.Show( "Impossivel selecionar - PARAMETROS: ANM_TOLERANCIA_IMP_XML_NF",48,"Atenção")
		Select(nOldSele)
		Return .F.
	Endif

	If !F_select("Select VALOR_ATUAL as PARAM from PARAMETROS where PARAMETRO = 'ANM_INDIC_VALID_ICMS_XML'","CURPARAM")
		Messagebox.Show( "Impossivel selecionar - PARAMETROS: ANM_INDIC_VALID_ICMS_XML",48,"Atenção")
		Select(nOldSele)
		Return .F.
	Endif

	If Reccount("CURINTERFACE") = 0 Or CURINTERFACE.MODELO <> '2' Or wLayout_Xml_Nfe <> 'SEFAZ'
		Select(nOldSele)
		Return .T.
	Endif
	*-- VERIFICANDO SE EXISTE OS PARÂMETROS --*

	*-- Cria Cursor XML --*
	Select V_ENTRADAS_00

	cSQL = " SELECT RIGHT(LEFT(RTRIM(SUBSTRING(CHAVE_NFE,26,9)),9),9)+ '-'+SUBSTRING(CHAVE_NFE,23,3) AS NFE, " + ;
		" NFE_XML.CHAVE_NFE, NFE_XML.PROTOCOLO, NFE_XML.DATA_AUTORIZACAO_NFE, NFE_XML.STATUS, " + ;
		" NFE_XML.POSSUI_PRODUTOS,  NFE_XML.DATA_CARGA, NFE_XML.NUMERO_MODELO_FISCAL, " + ;
		" NFE_XML.ID_XML_NFE, NFE_XML.CNPJ_EMITENTE_NFE, NFE_XML.CNPJ_DESTINATARIO_NFE, " + ;
		" NFE_XML.USUARIO_ULT_MOVTO, NFE_XML.DATA_ULT_MOVTO, NFE_XML.CNPJ_TRANSPORTADORA_NFE, " + ;
		" NFE_XML.OBS, NFE_XML.CONTEUDO_NFE, NFE_XML.ID_EDI_ARQUIVO_LOG " + ;
		" FROM NFE_XML " + ;
		" WHERE NFE_XML.CHAVE_NFE = ?v_entradas_00.CHAVE_NFE"

	If ! F_select(cSQL, "CurXML_NFE")
		Select(nOldSele)
		Return .T.
	Endif

	*---- carrega as do Cursor
	Select CurXML_NFE

	If f_vazio(CurXML_NFE.conteudo_nfe) Or Reccount() = 0
		Messagebox("XML não encontrado ...",64)
		Return .F.
	Endif

	*---- carrega as variáveis
	cArquivo=CurXML_NFE.conteudo_nfe
	cNumero_Modelo_Fiscal=CurXML_NFE.NUMERO_MODELO_FISCAL
	dAutorizacao=CurXML_NFE.DATA_AUTORIZACAO_NFE
	cProtocolo=CurXML_NFE.PROTOCOLO
	xReturn  = .T.
	xParamReturn = xTransacao+".pp_ANM_AVISA_OU_BLOQ_XML_NFE"

	Use In CurXML_NFE

	If Alltrim(cNumero_Modelo_Fiscal) = '55'

		Wait Window "Validando a Nota Fiscal..." Nowait

		*-- VALIDAÇÕES DO XML --*
		cMsg = ''

		*--INI:GRUPO NFE--*
		Select V_ENTRADAS_00

		** PROTOCOLO AUTORIZACAO - TRAVA SALVAR
		If PROTOCOLO_AUTORIZACAO_NFE <> cProtocolo
			xReturn = &xParamReturn
			cMsg = cMsg + 'PROTOCOLO AUTORIZACAO NFE%13%'
		Endif

		** DATA_AUTORIZACAO_NFE - TRAVA SALVAR
		If DATA_AUTORIZACAO_NFE <> dAutorizacao
			xReturn = &xParamReturn
			cMsg = cMsg + 'DATA AUTORIZACAO NFE%13%'
		Endif

		** TIPO EMISSAO NFE - TRAVA SALVAR
		If TIPO_EMISSAO_NFE <> Val((Strextract(cArquivo,'<tpEmis>','</tpEmis>',1)))
			xReturn = &xParamReturn
			cMsg = cMsg + 'TIPO EMISSAO NFE%13%'
		Endif
		*--FIM:GRUPO NFE--*


		*--INI:GRUPO EMITENTE--*

		** RG\IE DO EMITENTE - TRAVA SALVAR
		xEmit = Strextract(cArquivo,'<emit>','</emit>',1)
		If Val(V_ENTRADAS_00.RG_IE) <> Val(Strextract(xEmit,'<IE>','</IE>',1))
			xReturn = &xParamReturn
			cMsg = cMsg + 'RG\IE DO EMITENTE%13%'
		Endif
		*--FIM:GRUPO EMITENTE--*

		*--INI:GRUPO DESTINATARIO--*

		** CEP DO DESTINATÁRIO - TRAVA SALVAR
		xDest = Strextract(cArquivo,'<dest>','</dest>',1)
		F_select("Select CEP,UF,RG_IE from CADASTRO_CLI_FOR where NOME_CLIFOR =  ?v_entradas_00.FILIAL","Cur_Dados_Filial")

		If Alltrim(Cur_Dados_Filial.cep) <> Alltrim(Strextract(xDest,'<CEP>','</CEP>',1))
			xReturn = &xParamReturn
			cMsg = cMsg + 'CEP DO DESTINATÁRIO%13%'
		Endif

		** UF DO DESTINATÁRIO - TRAVA SALVAR
		If Alltrim(Cur_Dados_Filial.UF) <> Alltrim(Strextract(xDest,'<UF>','</UF>',1))
			xReturn = &xParamReturn
			cMsg = cMsg + 'UF DO DESTINATÁRIO%13%'
		Endif

		** RG\IE DO DESTINATÁRIO - TRAVA SALVAR
		If Val(Cur_Dados_Filial.RG_IE) <> Val(Strextract(xDest,'<IE>','</IE>',1))
			xReturn = &xParamReturn
			cMsg = cMsg + 'RG\IE DO DESTINATÁRIO%13%'
		Endif

		Use In Cur_Dados_Filial
		*--FIM:GRUPO DESTINATARIO--*

		*--INI: GRUPO VALORES--*
		Sele V_ENTRADAS_00
		wtotal = (Strextract(cArquivo,'<ICMSTot>','</ICMSTot>',1))

		** VALOR TOTAL -- TRAVA SALVAR COM TOLERANCIA
		xValTolerancia = xTransacao+".pp_ANM_TOLERANCIA_XML_NFE"
		If VALOR_TOTAL < Val((Strextract(wtotal,'<vNF>','</vNF>',1))) - &xValTolerancia Or ;
				VALOR_TOTAL > Val((Strextract(wtotal,'<vNF>','</vNF>',1))) + &xValTolerancia
			xReturn = &xParamReturn
			cMsg = cMsg + 'VALOR TOTAL%13%'
		Endif

		** VALOR_SUB_ITENS  -- TRAVA SALVAR COM TOLERANCIA
		If VALOR_SUB_ITENS < Val((Strextract(wtotal,'<vProd>','</vProd>',1))) - &xValTolerancia Or ;
				VALOR_SUB_ITENS > Val((Strextract(wtotal,'<vProd>','</vProd>',1))) + &xValTolerancia
			xReturn = &xParamReturn
			cMsg = cMsg + 'VALOR SUB ITENS%13%'
		Endif

		** VALOR FRETE - TRAVA SALVAR
		If FRETE <> Val(Strextract(wtotal,'<vFrete>','</vFrete>',1))
			xReturn = &xParamReturn
			cMsg = cMsg + 'FRETE%13%'
		Endif

		** VALOR SEGURO - TRAVA SALVAR
		If SEGURO <> Val(Strextract(wtotal,'<vSeg>','</vSeg>',1))
			xReturn = &xParamReturn
			cMsg = cMsg + 'SEGURO%13%'
		Endif

		** VALOR DESCONTO - TRAVA SALVAR
		If DESCONTO <> Val(Strextract(wtotal,'<vDesc>','</vDesc>',1))
			xReturn = &xParamReturn
			cMsg = cMsg + 'DESCONTO%13%'
		Endif

		** VALOR ENCARGO - TRAVA SALVAR
		If ENCARGO <> Val(Strextract(wtotal,'<vOutro>','</vOutro>',1))
			xReturn = &xParamReturn
			cMsg = cMsg + 'ENCARGO%13%'
		Endif
		*--FIM: GRUPO VALORES--*

		*--INI:GRUPO FRETE\TRANSPORTADORA--*

		wTransp = (Strextract(cArquivo,'<transp>','</transp>',1))
		cCGC=(Strextract(wTransp,'<CNPJ>','</CNPJ>',1))
		xModFrete = (Strextract(wTransp,'<modFrete>','</modFrete>',1))

		** FRETE A PAGAR - TRAVA SALVAR
		nTipo_frete = Iif(Val((Strextract(cArquivo,'<modFrete>','</modFrete>',1)))=0,1,Iif(Val((Strextract(cArquivo,'<modFrete>','</modFrete>',1)))=1,0,Val((Strextract(cArquivo,'<modFrete>','</modFrete>',1)))))
		If FRETE_A_PAGAR <> nTipo_frete
			xReturn = &xParamReturn
			cMsg = cMsg + 'FRETE A PAGAR%13%'
		Endif

		If !F_select("Select TOP 1 TRANSPORTADORA,CGC,INSCRICAO from TRANSPORTADORAS where TRANSPORTADORA = ?v_entradas_00.TRANSPORTADORA_A_PAGAR","curTransp")
			=f_msg(["Problema no Select em TRANSPORTADORAS!", 0 + 16, "Erro !!!"])
			Return .F.
		Endif

		** TRANSPORTADORAS - TRAVA SALVAR TIPOS 1 E 0

		** CNPJ TRANSPORTADORA - NAO TRAVA SALVAR
		If curTransp.CGC <> Strextract(wTransp,'<CNPJ>','</CNPJ>',1) And Val(xModFrete) < 2
			*xReturn = &xParamReturn
			cMsg = cMsg + 'CNPJ DA TRANSPORTADORA%13%'
		Endif

		** IE TRANSPORTADORA - NAO TRAVA SALVAR
		If Val(curTransp.INSCRICAO) <> Val(Strextract(wTransp,'<IE>','</IE>',1)) And Val(xModFrete) < 2
			*xReturn = &xParamReturn
			cMsg = cMsg + 'IE DA TRANSPORTADORA%13%'
		Endif



		** PLACA VEICULO - NAO TRAVA SALVAR
		Select V_ENTRADAS_00
		wveicTransp = (Strextract(cArquivo,'<veicTransp>','</veicTransp>',1))
		If VEICULO_PLACA <> (Strextract(wveicTransp,'<placa>','</placa>',1))
			*xReturn = &xParamReturn
			cMsg = cMsg + 'PLACA VEICULO%13%'
		Endif

		** UF PLACA VEICULO - NAO TRAVA SALVAR
		If UF_PLACA_VEICULO <> (Strextract(wveicTransp,'<UF>','</UF>',1))
			*xReturn = &xParamReturn
			cMsg = cMsg + 'UF PLACA VEICULO%13%'
		Endif

		*-- INI:GRUPO DE VOLUMES --*

		** TIPO VOLUME - NAO TRAVA SALVAR
		If TIPO_VOLUME <> (Strextract(cArquivo,'<esp>','</esp>',1))
			*xReturn = &xParamReturn
			cMsg = cMsg + 'TIPO VOLUME%13%'
		Endif

		** PESO LIQUIDO - NAO TRAVA SALVAR
		If Round(PESO,2) <> Round(Val((Strextract(cArquivo,'<pesoL>','</pesoL>',1))),2)
			*xReturn = &xParamReturn
			cMsg = cMsg + 'PESO LIQUIDO%13%'
		Endif

		** PESO BRUTO - NAO TRAVA SALVAR
		If Round(PESO_BRUTO,2) <> Round(Val((Strextract(cArquivo,'<pesoB>','</pesoB>',1))),2)
			*xReturn = &xParamReturn
			cMsg = cMsg + 'PESO BRUTO%13%'
		Endif

		** QTDE VOLUME - NAO TRAVA SALVAR
		If EMBALAGENS <> Val((Strextract(cArquivo,'<qVol>','</qVol>',1)))
			*xReturn = &xParamReturn
			cMsg = cMsg + 'EMBALAGENS%13%'
		Endif

		** NUMERACAO VOLUMES - NAO TRAVA SALVAR
		If NUMERACAO_VOLUMES <> (Strextract(cArquivo,'<nVol>','</nVol>',1))
			*xReturn = &xParamReturn
			cMsg = cMsg + 'NUMERACAO VOLUMES%13%'
		Endif

		** MARCA VOLUMES - NAO TRAVA SALVAR
		If MARCA_VOLUMES <> (Strextract(cArquivo,'<marca>','</marca>',1))
			*xReturn = &xParamReturn
			cMsg = cMsg + 'MARCA VOLUMES%13%'
		Endif
		*-- FIM:GRUPO DE VOLUMES --*


		Wait Window 'Validando Impostos da Nota Fiscal...' Nowait

		*--INI:IMPOSTOS- CABEÇALHO 2--*

		xImpTolerancia = xTransacao+".pp_ANM_TOLERANCIA_IMP_XML_NF"
		xIndFiscalTerc = xTransacao+".pp_ANM_INDIC_VALID_ICMS_XML"
		
		** Verificando os CFOP que não terão validação de imposto com o XML **
		TEXT TO xSelCFOPconsumo TEXTMERGE NOSHOW

			SELECT DISTINCT CFOP FROM 
			(SELECT DISTINCT INDICADOR_CFOP,CODIGO_FISCAL_OPERACAO CFOP FROM CTB_LX_CARACTERISTICA_CFOP(NOLOCK) 
			UNION ALL
			SELECT DISTINCT INDICADOR_CFOP,CODIGO_FISCAL_INTERESTADUAL FROM CTB_LX_CARACTERISTICA_CFOP(NOLOCK)  
			UNION ALL
			SELECT DISTINCT INDICADOR_CFOP,CODIGO_FISCAL_EXTERIOR FROM CTB_LX_CARACTERISTICA_CFOP(NOLOCK) ) CFOP
				JOIN (SELECT * FROM FXANM_ConsultaVarString(
							(SELECT DBO.FX_ANM_PARAMETRO_USER('ANM_INDICA_CFOP_NAO_VALID') AS INDICADOR_CFOP) ) ) PMT
				ON CFOP.INDICADOR_CFOP = PMT.valores			
			WHERE  CFOP IS NOT NULL

		ENDTEXT
		f_select(xSelCFOPconsumo,"CurCFOPconsumo")
		
		xValidaImposto = .T. && Se veradeiro, Valida imposto
		Select v_entradas_00_imposto_cfop_total
		Go Top
		Scan

			Select CurCFOPconsumo
			Locate For CFOP = v_entradas_00_imposto_cfop_total.codigo_fiscal_operacao
			If Found()

				xNaoValidaImposto = .F. && Se Falso, não valida imposto
			Endif

			Select v_entradas_00_imposto_cfop_total
		Endscan
		Go Top
		
		** Apagando variáveis criadas **
		If Used("CurCFOPconsumo")
			Use In  CurCFOPconsumo
			Release xSelCFOPconsumo
		Endif
		** Fim - Verificando os CFOP que não terão validação de imposto com o XML **
		
		Select v_entradas_00_imposto_total
		Scan
			Do Case

				** ICMS - TRAVA SALVAR COM TOLERANCIA
			Case ID_IMPOSTO = 1 And xTransacao != 'o_005109' And ! Str(V_ENTRADAS_00.INDICADOR_FISCAL_TERCEIRO) $ &xIndFiscalTerc And xValidaImposto
				If v_entradas_00_imposto_total.BASE_IMPOSTO_ESPELHO < Val((Strextract(wtotal,'<vBC>','</vBC>',1))) - &xImpTolerancia Or ;
						v_entradas_00_imposto_total.BASE_IMPOSTO_ESPELHO > Val((Strextract(wtotal,'<vBC>','</vBC>',1))) + &xImpTolerancia

					nValorBaseIcms = BASE_IMPOSTO_ESPELHO

					Locate For ID_IMPOSTO = 2
					If Found()
						nValorBaseIcms = nValorBaseIcms - VALOR_IMPOSTO_ESPELHO
					Endif

					If nValorBaseIcms < Val((Strextract(wtotal,'<vBC>','</vBC>',1))) - &xImpTolerancia Or ;
							nValorBaseIcms > Val((Strextract(wtotal,'<vBC>','</vBC>',1))) + &xImpTolerancia
						xReturn = &xParamReturn
						cMsg = cMsg + 'BASE ICMS%13%'

					Endif
				Endif

				Locate For ID_IMPOSTO = 1

				If v_entradas_00_imposto_total.VALOR_IMPOSTO_ESPELHO < Val((Strextract(wtotal,'<vICMS>','</vICMS>',1))) - &xImpTolerancia Or ;
						v_entradas_00_imposto_total.VALOR_IMPOSTO_ESPELHO > Val((Strextract(wtotal,'<vICMS>','</vICMS>',1))) + &xImpTolerancia

					Select ID_IMPOSTO, TAXA_IMPOSTO_ESPELHO, Sum(BASE_IMPOSTO_ESPELHO) As BASE_IMPOSTO_ESPELHO, Sum(VALOR_IMPOSTO_ESPELHO) As VALOR_IMPOSTO_ESPELHO ;
						FROM V_ENTRADAS_00_IMPOSTO_CFOP_TOTAL With (Buffering = .T.) ;
						WHERE Inlist(ID_IMPOSTO,2,1) ;
						group By ID_IMPOSTO, TAXA_IMPOSTO_ESPELHO ;
						Into Cursor curValidaImpostosXML

					Select curValidaImpostosXML

					Sum VALOR_IMPOSTO_ESPELHO For ID_IMPOSTO = 2 To nValorImpostoIPI
					Sum BASE_IMPOSTO_ESPELHO For ID_IMPOSTO = 1 To nBaseImpostoICMS

					Locate For ID_IMPOSTO=1
					nBaseImpostoICMS = nBaseImpostoICMS - nValorImpostoIPI
					nValorICMS = nBaseImpostoICMS * (TAXA_IMPOSTO_ESPELHO/100)
					
					If  nValorICMS < Val((Strextract(wtotal,'<vICMS>','</vICMS>',1))) - &xImpTolerancia Or ;
							nValorICMS > Val((Strextract(wtotal,'<vICMS>','</vICMS>',1))) + &xImpTolerancia
						xReturn = &xParamReturn
						cMsg = cMsg + 'VALOR ICMS%13%'
					Endif

					If Used ('curValidaImpostosXML')
						Use In curValidaImpostosXML
					Endif
				Endif

				** IPI - TRAVA SALVAR COM TOLERANCIA
			Case ID_IMPOSTO = 2 And xTransacao != 'o_005109' And xValidaImposto
				If v_entradas_00_imposto_total.VALOR_IMPOSTO_ESPELHO < Val((Strextract(wtotal,'<vIPI>','</vIPI>',1))) - &xImpTolerancia Or ;
						v_entradas_00_imposto_total.VALOR_IMPOSTO_ESPELHO > Val((Strextract(wtotal,'<vIPI>','</vIPI>',1))) + &xImpTolerancia
					xReturn = &xParamReturn
					cMsg = cMsg + 'VALOR IPI%13%'
				Endif

				** I_IMPORT - TRAVA SALVAR COM TOLERANCIA
			Case ID_IMPOSTO = 7 And xValidaImposto
				If v_entradas_00_imposto_total.VALOR_IMPOSTO_ESPELHO <> Val((Strextract(wtotal,'<vII>','</vII>',1)))
					xReturn = &xParamReturn
					cMsg = cMsg + 'VALOR IMPOSTO IMPORTAÇÃO%13%'
				Endif

				** ICMS-ST - TRAVA SALVAR COM TOLERANCIA
			Case ID_IMPOSTO = 12 And xTransacao != 'o_005109' And xValidaImposto
				If v_entradas_00_imposto_total.BASE_IMPOSTO_ESPELHO < Val((Strextract(wtotal,'<vBCST>','</vBCST>',1))) - &xImpTolerancia Or ;
						v_entradas_00_imposto_total.BASE_IMPOSTO_ESPELHO > Val((Strextract(wtotal,'<vBCST>','</vBCST>',1))) + &xImpTolerancia
					xReturn = &xParamReturn
					cMsg = cMsg + 'BASE ICMS-ST%13%'
				Endif

				If v_entradas_00_imposto_total.VALOR_IMPOSTO_ESPELHO < Val((Strextract(wtotal,'<vST>','</vST>',1))) - &xImpTolerancia Or ;
						v_entradas_00_imposto_total.VALOR_IMPOSTO_ESPELHO > Val((Strextract(wtotal,'<vST>','</vST>',1))) + &xImpTolerancia
					xReturn = &xParamReturn
					cMsg = cMsg + 'VALOR ICMS-ST%13%'
				Endif

			Endcase
		Endscan
		*--FIM:IMPOSTOS- CABEÇALHO 2--*

		*--INI:GRUPO ITENS--*
		nQtde_Total = 0
		nQtde_Item  = 0

		Select v_Entradas_00_Itens
		Sum Qtde_Item To nQtde_Total For ( ! Nao_Soma_Valor )

		N=1
		For i =1 To 999
			If Strextract(cArquivo,'<det nItem="','">',N)=Alltrim(Str(N))
				wProd = ''
				wProd = (Strextract(cArquivo,'<prod>','</prod>',N))
				nQtde_Item = nQtde_Item + Val((Strextract(wProd,'<qCom>','</qCom>',1)))
				N=N+1
			Else
				N=999
				Exit
			Endif
		Endfor

		** QUANTIDADE ITEM - TRAVA SALVAR
		If nQtde_Total <> nQtde_Item
			xReturn = &xParamReturn
			cMsg = cMsg + 'QUANTIDADE ITEM%13%'
		Endif
		*--FIM:GRUPO ITENS--*

	Endif

	Wait Clear

	If ! f_vazio(cMsg)
		If !xReturn
			cMsg = 'Nota Fiscal possui valores divergentes do XML nos Campos.%13%%13%'+cMsg+'%13%Verifique!'
			cMsg = Strtran(cMsg,'%13%',Chr(13))
			Messagebox.Show(cMsg,0+48,"Atenção")
			*Select(nOldSele)
			Return .F.
		Else
			cMsg = 'Nota Fiscal possui valores divergentes do XML nos Campos.%13%%13%'+cMsg+'%13%Deseja continuar salvando?'
			cMsg = Strtran(cMsg,'%13%',Chr(13))
			If Messagebox.Show(cMsg,4+48,"Atenção")=6
				Return .T.
				Select(nOldSele)
			Else
				*Select(nOldSele)
				Return .F.
			Endi
		Endif
	Else
		Return .T.
		Select(nOldSele)
	Endif

	** Fim da Função **
	Endfunc

	** Fim da classe **
Enddefine
