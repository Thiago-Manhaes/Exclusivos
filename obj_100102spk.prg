**
**
*-- Marco Banaggia - 01/06/2018 --*
**
**

define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
		*- OBJETIVO: IMPORTACAO DE ITENS FISCAIS RELLINX --IMPORTACAO ITENS FISCAIS NOTAS NFE FILIALS FORA MATRIZES
		*- Existem 2 parametros que influem nos objetos de Entrada:  
		*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos
		*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execucao para facilitar o desenvolvimento
		*!*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
		do case
			*- metodo do inicio da form
			case UPPER(xmetodo) == 'USR_INIT' 
				** Tiago Carvalho (SS) - 13/10/2016 - Cria o botao para criacao de Nota Fiscal em lote importado via excel na tela SS0065
				thisformset.lx_FORM1.addobject("Btn_Gerar_Notas_Fiscais","Btn_Gerar_Notas_Fiscais")
				thisformset.lx_form1.addobject("btn_selpedido","btn_selpedido")
				thisformset.lx_form1.lx_pageframe1.page1.lx_pageframe1.page_NFe.addobject("btn_cancela","btn_cancela")
				
				IF TYPE("Thisformset.PP_SS_PERMITE_GERAR_NF_EXCEL") <> "U" AND Thisformset.PP_SS_PERMITE_GERAR_NF_EXCEL
					thisformset.lx_FORM1.Btn_Gerar_Notas_Fiscais.Enabled = .T.
					thisformset.lx_FORM1.Btn_Gerar_Notas_Fiscais.Visible = .T.
				ELSE
					thisformset.lx_FORM1.Btn_Gerar_Notas_Fiscais.Enabled = .F.
					thisformset.lx_FORM1.Btn_Gerar_Notas_Fiscais.Visible = .F.
				ENDIF
				*!* Mostra ou nao de acordor como parametro do usuario
				thisformset.lx_form1.btn_selpedido.visible = thisformset.pp_gs_selpedido_meleva
				
				** BRUNO SILVA (SS) - 23/01/2017 - adicionado variaval xSSPedidos - (utilizado na geracao de notas de royalties)						
				public curNfeSp,xImporCaixa ,curItensImport, xImportFabDist,curItensImportFabrica,xTempFilial,xFiltro,xRegINI,xRegFIM,xSsPedidos
				curNfeSp=''
				xImporNfe=0
				curItensImport='' 
				xImportFabDist=0
				curItensImportFabrica=''
				xImporCaixa = 0
				xRegINI = 0
				xRegFIM = 0
				xSsPedidos =''
				
				if type("thisformset.lx_FORM1.lx_pageframe1.page3.Import_Item_transf")="U" AND ;	  
				   type("thisformset.lx_form1.lx_PAGEFRAME1.page1.lx_PAGEFRAME1") !="U"
					
					xalias=alias()
					thisformset.lx_form1.lx_PAGEFRAME1.page1.lx_PAGEFRAME1.page1.label_emissao.top=-1000
					thisformset.lx_form1.lx_PAGEFRAME1.page1.lx_PAGEFRAME1.page1.label_emissao.Visible=.f.
					thisformset.lx_form1.lx_PAGEFRAME1.page1.lx_PAGEFRAME1.page1.addobject("label_emissao2","label_emissao2")
					thisformset.lx_FORM1.lx_pageframe1.page3.addobject("Import_Item","Import_Item")
					thisformset.lx_FORM1.lx_pageframe1.page3.Import_Item.Enabled = Thisformset.pp_anm_permit_import_cons
					

					
					thisformset.lx_FORM1.lx_pageframe1.page3.addobject("Import_caixa_fabrica","Import_caixa_fabrica")
					*thisformset.lx_FORM1.lx_pageframe1.page3.addobject("Import_Item_fabrica","Import_Item_fabrica")  				
					TEXT TO xSelParam TEXTMERGE NOSHOW
						select isnull(valor_atual_user,valor_atual) as S_OU_N
						from PARAMETROS a left join 
						(select * from PARAMETROS_USERS where USUARIO = ?WUSUARIO ) b 
						on a.PARAMETRO = b.PARAMETRO
						where a.PARAMETRO = 'ANM_PER_PROD_MAT_CONSUMI'
					ENDTEXT
					f_select(xSelParam,"CurParametro",ALIAS())
					xValorPram = CurParametro.S_OU_N
					with thisformset.lx_FORM1.lx_pageframe1.page3.Lx_container1
						.Ck_materiais.Visible = &xValorPram
						.Ck_produtos.Visible  = &xValorPram
						.Ck_ativos.Visible    = &xValorPram	
					endwith		
					
					if	!f_vazio(xalias)
						sele &xalias			
					endif	
				endif		
				

			case UPPER(xmetodo) == 'USR_CLEAN_AFTER' 
				if type("curNfeSp") != 'U'
					xImporNfe=0 
					curNfeSp=''				
				endif	

				if type("curItensImport") != 'U'
					curItensImport='' 
					xImportFabDist=0
				ENDIF
				
				if type("curItensImportFabrica") != 'U'
					curItensImportFabrica='' 
				endif	

			case UPPER(xmetodo) == 'USR_INCLUDE_AFTER' 
				xFiltro = "''"
				xImporCaixa = 0
				if type("curNfeSp") != 'U'
					xImporNfe=0 
					curNfeSp=''				
				endif					

				if type("curItensImport") != 'U'
					curItensImport='' 
					xImportFabDist=0
				ENDIF
				
				if type("curItensImportFabrica") != 'U'
					curItensImportFabrica='' 
				endif	
				
			case UPPER(xmetodo) == 'USR_ALTER_BEFORE' 
				xalias=alias()	
				if type("curNfeSp") != 'U'
					xImporNfe=0 
					curNfeSp=''				
				endif		

				if type("curItensImport") != 'U'
					curItensImport='' 
					xImportFabDist=0
				endif	
					
				if type("curItensImportFabrica") != 'U'
					curItensImportFabrica='' 
				endif	
				
				TEXT TO xVerifBaixa TEXTMERGE NOSHOW
					SELECT LANCAMENTO FROM CTB_AVISO_LANCAMENTO_MOV 
					WHERE LANCAMENTO_MOV = REPLACE('<<V_FATURAMENTO_05.CTB_LANCAMENTO>>','...','')
				ENDTEXT
					
				f_select(xVerifBaixa,"VerifBaixa",ALIAS())
				SELECT VerifBaixa
				GO top
				IF	RECCOUNT() > 0	
					MESSAGEBOX("Impossivel Cancelar, Favor Solicitar ao Financeiro Cancelamento da Baixa: "+ALLTRIM(STR(VerifBaixa.LANCAMENTO)),0+48)
					RETURN .F.
				ENDIF
				
				if	!f_vazio(xalias)
					sele &xalias			
				endif	
				

			case UPPER(xmetodo) == 'USR_VALID' 
				
				if upper(xnome_obj)='TV_FILIAL' 
					f_select("select clifor from cadastro_cli_for where nome_clifor=?v_faturamento_05.filial","curClifor",alias())
					thisformset.LX_FORM1.LX_pageframe1.Page1.Lx_pageframe1.Page1.TV_rateio_filial.Value = curClifor.clifor
					thisformset.LX_FORM1.LX_pageframe1.Page1.Lx_pageframe1.Page1.TV_rateio_filial.l_desenhista_recalculo()
				endif	
						
				if upper(xnome_obj)='TX_CODIGO_ITEM'
					If v_faturamento_05_item.origem_item = 'M'
						Sele v_faturamento_05_item
						f_select("select top 1 material, CUSTO_REPOSICAO, CUSTO_A_VISTA from materiais_cores where custo_reposicao > 0 and material = ?v_faturamento_05_item.codigo_item","xCustoMP")
						Sele xCustoMP
						If RECCOUNT() > 0
							Replace v_faturamento_05_item.preco_unitario with xCustoMP.Custo_Reposicao
							Thisformset.lx_form1.lx_pageframe1.page3.LX_GRID_FILHA1.Col_tx_PRECO_UNITARIO.Tx_PRECO_UNITARIO.l_desenhista_recalculo
						Endif
					Endif
	 
					If v_faturamento_05_item.origem_item = 'P'
						Sele v_faturamento_05_item
						xCodigoTabPreco=ALLTRIM(Thisformset.pp_anm_custo_cons_pa)
						f_select("select preco1 from produtos_precos where produto = ?v_faturamento_05_item.codigo_item and codigo_tab_preco = ?xCodigoTabPreco","xCustoPA")
						Sele xCustoPA
						If RECCOUNT() > 0
							Replace v_faturamento_05_item.preco_unitario with xCustoPA.preco1
							Thisformset.lx_form1.lx_pageframe1.page3.LX_GRID_FILHA1.Col_tx_PRECO_UNITARIO.Tx_PRECO_UNITARIO.l_desenhista_recalculo
						Endif
						Sele v_faturamento_05_item
					Endif
				endif
			  
			    IF THISFORMSET.p_tool_status = 'I' AND (upper(xnome_obj)=='TV_FILIAL' OR upper(xnome_obj)=='TV_NOME_CLIFOR')
					
					xalias=alias()
			        
			        thisformset.lx_FORM1.tv_filial.refresh()			        
	                thisformset.lx_FORM1.lx_pageframe1.page1.Lx_pageframe1.Page1.tv_transportadora.Value = THISFORMSET.lx_FORM1.tv_filial.Value 
				    thisformset.lx_FORM1.lx_pageframe1.page1.Lx_pageframe1.Page1.tv_transp_redespacho.value = THISFORMSET.lx_FORM1.tv_filial.Value   
		
				    SELE v_faturamento_05
					
					THISFORMSET.lx_FORM1.Tv_cod_filial.refresh()									
	     		    thisformset.lx_FORM1.lx_pageframe1.page1.Lx_pageframe1.Page1.Tv_RATEIO_FILIAL.Value = THISFORMSET.lx_FORM1.Tv_cod_filial.VALUE	
				    f_select("select desc_rateio_filial from CTB_FILIAL_RATEIO where rateio_filial=?v_faturamento_05.rateio_filial","curRATEIO",alias())
				    thisformset.lx_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tx_desc_RATEIO_FILIAL.Value = curRATEIO.desc_rateio_filial
					
					* Valida filial rbx dist e gx dist como estoque central e atacado respectivamente no campo filial	
					** Tiago Carvalho(SS) - 14/06/2018 - Alterado para nao trocar a filial de for processo de geracao via excel, as notas sao controladas por matriz fiscal e nao pode fixar a filial
					IF type("lcStrNomeArquivo") == 'U'				
						THISFORMSET.lx_FORM1.Tv_cod_filial.refresh()
						IF thisformset.lx_FORM1.TV_COD_FILIAL.value = '000991' 
						   thisformset.lx_FORM1.TV_COD_FILIAL.value = '000999'
						   thisformset.lx_FORM1.TV_FILIAL.VALUE = 'ESTOQUE CENTRAL'
						ELSE
							IF thisformset.lx_FORM1.TV_COD_FILIAL.value = '000988'
							   thisformset.lx_FORM1.TV_COD_FILIAL.value = '000017' 	  
							   thisformset.lx_FORM1.TV_FILIAL.VALUE = 'ATACADO'
							ENDIF
						ENDIF		 	
						
						* Valida filial rbx dist e gx dist como estoque central e atacado respectivamente no campo cliente
						THISFORMSET.lx_FORM1.Tv_clifor.refresh()
						IF thisformset.lx_FORM1.Tv_clifor.value = '000991'
						   thisformset.lx_FORM1.Tv_clifor.value = '000999'
						   thisformset.lx_FORM1.Tv_nome_clifor.VALUE = 'ESTOQUE CENTRAL'
						ELSE
							IF thisformset.lx_FORM1.Tv_clifor.value = '000988'
							   thisformset.lx_FORM1.Tv_clifor.value = '000017' 	  
							   thisformset.lx_FORM1.Tv_nome_clifor.VALUE = 'ATACADO'
							ENDIF
						ENDIF
					ENDIF
					
				    if	!f_vazio(xalias)	
						sele &xalias 
				    endif
			    ENDIF
			
				
				 IF THISFORMSET.p_tool_status = 'I' AND (upper(xnome_obj)=='TV_NOME_CLIFOR' OR upper(xnome_obj)=='TV_FILIAL') AND v_faturamento_05.natureza_saida = '123.01' AND type("lcStrNomeArquivo") == 'U'		
				 
						xalias=alias()
							
							IF USED("xValidaMatriz")
								SELECT xValidaMatriz
								USE
							ENDIF	
							
							IF USED("xValidaRedeLj")
								SELECT xValidaRedeLj
								USE
							ENDIF
							
							f_select("SELECT REDE_LOJAS FROM FILIAIS WHERE FILIAL =?v_faturamento_05.filial","xValidaRedeLj",ALIAS())
							
							IF xValidaRedeLj.REDE_LOJAS = '04'
								f_select("SELECT MATRIZ FROM FILIAIS WHERE FILIAL =?v_faturamento_05.nome_clifor","xValidaMatriz",ALIAS())
								xValidaDestino = v_faturamento_05.filial
							ELSE
								f_select("SELECT MATRIZ FROM FILIAIS WHERE FILIAL =?v_faturamento_05.filial","xValidaMatriz",ALIAS())
								xValidaDestino = v_faturamento_05.nome_clifor
							ENDIF	
								
								IF ALLTRIM(xValidaMatriz.Matriz) == ALLTRIM(xValidaDestino)
								
									thisformset.lx_FORM1.lx_pageframe1.page3.Import_caixa_fabrica.enabled = .T.
								
								ELSE
					
									thisformset.lx_FORM1.lx_pageframe1.page3.Import_caixa_fabrica.enabled = .F.
									
								ENDIF
							
						if	!f_vazio(xalias)	
						  sele &xalias 
					    endif	
					  	
				ELSE
					thisformset.lx_FORM1.lx_pageframe1.page3.Import_caixa_fabrica.enabled = .F.	
				ENDIF
				
			
			case UPPER(xmetodo) == 'USR_SAVE_BEFORE'
				xalias=alias()
				thisformset.LX_FORM1.Lx_pageframe1.Page7.Ck_conferido.value	= .T.
				thisformset.LX_FORM1.Lx_pageframe1.Page7.Ck_conferido.l_desenhista_recalculo()			
				
				*****BLOQUEIA SALVAR FATURAMENTO SEM O PREENCHIMENTO DO PESO BRUTO >>> JULIO - 18/07, PARA SEGURANCA NO GKO*****
				IF thisformset.lx_FORM1.lx_pageframe1.page1.Lx_pageframe1.Page1.Tx_peso_bruto.Value > 0
					return .t.
				ELSE
					MESSAGEBOX("NAO E PERMITIDO SALVAR NOTA SEM O PESO BRUTO",48,"Atencao!!!")
					return .f.
				ENDIF
				*****BLOQUEIA SALVAR FATURAMENTO SEM O PREENCHIMENTO DO PESO BRUTO >>> JULIO - 18/07 PARA SEGURANCA NO GKO*****
			
			if	!f_vazio(xalias)
				sele &xalias			
			endif
			
			
			case UPPER(xmetodo) == 'USR_SAVE_AFTER' 
				
				SET STEP ON 
			
				If type("lcStrNomeArquivo") != 'U'
					** Tiago Carvalho (SS) - 14/06/2018 - Alterado a chave para atualizar o arquivo porque a animale tem um desenvolvimento novo que fixa a filial e fica diferente do arquivo.
					** Tiago Carvalho (SS) - 13/10/2016 - Se tiver gerando nota via excel salvo o numero da nota na tabela importada pelo excel
					TEXT TO lcSql TEXTMERGE noshow
						UPDATE A
								SET A.NF_SAIDA ='<<v_faturamento_05.nf_saida>>',
									A.SERIE_NF ='<<v_faturamento_05.serie_nf>>',
									A.FILIAL ='<<v_faturamento_05.filial>>'
								FROM SS_FATURAMENTO_AUTOMATICO_EXCEL A(NOLOCK)
								INNER JOIN PRODUTOS B(NOLOCK)
									ON A.REFERENCIA = B.PRODUTO 
								INNER JOIN FILIAIS ORIGEM (NOLOCK)
									ON A.FILIAL_ORIGEM = ORIGEM.FILIAL 
								INNER JOIN FILIAIS DESTINO (NOLOCK)
									ON A.FILIAL_DESTINO = DESTINO.FILIAL 
								INNER JOIN NATUREZAS_SAIDAS (NOLOCK)
									ON A.NATUREZA_SAIDA = NATUREZAS_SAIDAS.NATUREZA_SAIDA 
								WHERE ORIGEM.MATRIZ_FISCAL = '<<lcStrMatrizFiscal>>'
									and A.FILIAL_DESTINO = '<<lcStrFilialDestino>>'
									and a.NOME_ARQUIVO = '<<lcStrNomeArquivo>>'
									and A.ID_NOTA = '<<lcIntIdNota>>'
									and A.NATUREZA_SAIDA='<<lcStrNatureza>>'
									and A.NF_SAIDA is null
					ENDTEXT 
					f_execute (lcSql )
					RELEASE lcStrNomeArquivo , lcIntIdNota, lcStrNatureza, lcStrFilialOrigem, lcStrFilialDestino, lcStrMatrizFiscal
				endif
				
				If type("curNfeSp") != 'U'
					if xImporCaixa=1 
						TEXT TO xUpdCaixa TEXTMERGE NOSHOW
							UPDATE FATURAMENTO_CAIXAS 
							SET ANM_FATURA_FAB = '1' 
							WHERE CAIXA IN (<<xFiltro>>)
						ENDTEXT
						f_update(xUpdCaixa)
						xImporCaixa = 0
					endif	
				Endif	



				If type("curItensImport") != 'U'
					
					if xImportFabDist=1 

						sele curItensImport	
						go top	

						text to	xupdt1 noshow textmerge
							UPDATE RS_DADOS_NOTAS SET NOTA_FISCAL ='<<v_faturamento_05.nf_saida>>',DATA_EMISSAO='<<v_faturamento_05.EMISSAO>>' 
							WHERE TIPO=<<curItensImport.TIPO>> AND CASE WHEN FILIAL_ORIGEM='RBX DISTRIBUIDORA' THEN 'ESTOQUE CENTRAL' ELSE FILIAL_ORIGEM END='<<curItensImport.FILIAL_ORIGEM>>' 
							AND ID_REGISTRO BETWEEN <<curItensImport.REGISTRO_INICIAL>> AND <<curItensImport.REGISTRO_FINAL>>
							AND NOTA_FISCAL IS NULL 
						endtext
					
						if !f_update(xupdt1)
							messagebox("Nao Foi Possivel Marcar Item como Processado!",48,"Atencao!")
							retu .f.
						endif
					
					endif
					
					if xImportFabDist=2 

						sele curItensImport	
						go top	

						text to	xupdtRG noshow textmerge
							UPDATE TMP_NOTAS_RET_GX_RBX SET PROC_RBX = 1 
							WHERE SEQ BETWEEN '<<xRegINI>>' AND '<<xRegFIM>>'
						endtext
						
						if !f_update(xupdtRG)
							messagebox("Nao Foi Possivel Marcar Item como Processado!",48,"Atencao!")
							retu .f.
						endif
					
					endif	

				ENDIF
				
				** Bruno Silva (SS) - 23/01/2017 - Se variavel tiver preenchida marca os pedidos como processados
				IF !EMPTY(xSsPedidos)
					TEXT TO lcSql TEXTMERGE noshow
						UPDATE 	A SET A.NF_FATURAMENTO = '<<v_faturamento_05.nf_saida>>',
								A. SERIE_FATURAMENTO ='<<v_faturamento_05.serie_nf>>',
								A.FILIAL_FATURAMENTO ='<<v_faturamento_05.filial>>'
						FROM SS_VENDAS_LICENCIADOS A
						INNER JOIN PRODUTOS B
							ON A.PRODUTO = B.PRODUTO 
						WHERE PEDIDO in (<<xSsPedidos>>)
						AND FABRICANTE = '<<v_faturamento_05.nome_clifor>>'
						AND TIPO_NOTA = 'F'
							
					ENDTEXT
					
					if !f_update(lcSql )
						messagebox("Nao Foi Possivel Marcar Item como Processado!",48,"Atencao!")
						retu .f.
					endif
					
				ENDIF

				otherwise
					return .t.				
		endcase
	endproc
enddefine


**************************************************
*-- Class:        Importa_Consumiveis 
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS Import_Item AS commandbutton


	Top = 63
	Left = 495
	Height = 20
	Width = 200
	Caption = "Importa Itens Fiscais"
	Name = "Import_Item"
	Visible=.t.
	Enabled = .t.
	FontBold=.t.
	Fontsize=8
	tooltiptext="Importa Itens Fiscais Gerados pelo RelLinx"
	PROCEDURE Click	
		
		*thisformset.lx_FORM1.lx_PAGEFRAME1.page1.lx_PAGEFRAME1.page2.Container2.TX_VALOR_TEMPO.Value = 100.00
		
		IF ! Thisformset.p_tool_status $ 'IA'
			RETURN .f.
		ENDIF	
		
		IF MESSAGEBOX("Deseja importar os Itens Fiscais ?",4+32+256,"Atencao!!!")=6
			
			strcaminho = getfile("xls?","Importar Arquivo","Importar",0,"Importar Arquivo")

					if empty(NVL(strcaminho,''))
						messagebox("Operacao Cancelada!",0+64,"Arquivo Invalido!")
						return .f.
					endif

					F_wait("Importando as informacoes, Aguarde...")

					if used("CurItensImport")
						use in CurItensImport
					endif

					CREATE CURSOR CurItensImport(CODIGO_ITEM C(50), QTDE_ITEM N(9,3), PRECO_UNITARIO N(15,5))

 
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

						IF upper(alltrim(objsheet.cells(1,1).text)) <> "CODIGO_ITEM" OR upper(alltrim(objsheet.cells(1,2).text))<> "QTDE_ITEM" OR upper(alltrim(objsheet.cells(1,3).text))<> "PRECO_UNITARIO"
							MESSAGEBOX("O Layout do Arquivo e Invalido, O Cabecalho deve Conter as Seguintes Informacoes:"+CHR(10)+CHR(10)+"Celula A: CODIGO_ITEM"+CHR(10)+"Celula B: QTDE_ITEM"+CHR(10)+"Celula C: PRECO_UNITARIO",0+16,"Layout Invalido")
							return .f.
							*GO to oexception
						ENDIF

						IF f_vazio(alltrim(objsheet.cells(iPermitido,1).text)) 
							objsheetRange   = objsheet.range(objsheet.cells(iImatrizIni,1),objsheet.cells(iImatrizFim,5)).value
							SELECT CurItensImport
							APPEND FROM array objsheetRange   
						ELSE 
							DO WHILE iPercorrer >= iPercorrido      

								objsheetRange   = objsheet.range(objsheet.cells(iImatrizIni,1),objsheet.cells(iImatrizFim,5)).value

								SELECT CurItensImport
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
			
			SELECT curItensImport
			DELETE FROM curItensImport WHERE f_vazio(CODIGO_ITEM)
			************

*!*				IF 	RECCOUNT() > 400
*!*					MESSAGEBOX("Somente e permitido um maximo de 400 itens por nota fiscal, Favor Corrigir !!!",0+64,"Erro ao Importar")
*!*					RETURN .F.
*!*				ENDIF	
			
			
			
			SELECT curItensImport
			GO TOP 
			
			COUNT TO xRcount FOR !DELETED()
			xRecno = 0
			SCAN 
				
				xRecno = xRecno+1
				f_prog_bar("Importando Itens Fiscais... ",xRecno,xRcount)
				
				*thisformset.lX_FORM1.lx_PAGEFRAME1.page3.Lx_container1.Ck_produtos.Value = .T.
				o_toolbar.Botao_filhas_inserir.Click()			
				sele V_FATURAMENTO_05_ITEM 
				repla CODIGO_ITEM with curItensImport.CODIGO_ITEM 
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_CODIGO_ITEM.tx_CODIGO_ITEM.l_desenhista_recalculo()	
				
				sele V_FATURAMENTO_05_ITEM 		
				repla PRECO_UNITARIO with curItensImport.PRECO_UNITARIO 
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_PRECO_UNITARIO.tx_PRECO_UNITARIO.l_desenhista_recalculo()	
				
				sele V_FATURAMENTO_05_ITEM 
				repla QTDE_ITEM with curItensImport.QTDE_ITEM 
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_QTDE_ITEM.tx_QTDE_ITEM.l_desenhista_recalculo()			
				
				SELECT curItensImport
			ENDSCAN 
			
			f_prog_bar()	
				
			SELECT V_FATURAMENTO_05_ITEM 
			GO TOP 			
			
		ENDIF 
			
	ENDPROC


ENDDEFINE
*
*-- EndDefine: Importa_Consumiveis 
**************************************************




**************************************************
*-- Class:        Import_Item_Transf 
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS Import_caixa_fabrica AS commandbutton


	*Top = 60
	*Left = 277
	*Height = 20
	*Width = 220
	
	Top = 63
	Left = 477
	Height = 20
	Width = 220
	Caption = "caixa Estoque x Fabrica"
	Enabled = .t.
	Visible= .f.
	FontBold=.t.
	Fontsize=8
	tooltiptext="Importa caixa EC x Fabrica"
	
	PROCEDURE Click	
		
		IF thisformset.p_tool_status!='I' and thisformset.p_tool_status!='A'  
			
			text to	xselNotaspendentes noshow textmerge	
					select distinct 
					a.caixa,a.filial,a.nome_clifor from 
					vendas_prod_embalado a
					join faturamento_caixas b
					on a.caixa = b.caixa
					where b.anm_tipo_faturamento = 'FABRICA'
					and b.anm_fatura_fab = '0'
					order by caixa
			endtext
			
			f_select(xselNotaspendentes,"curNotasPendentes" )
			brow normal noedit title  'Caixas Pendentes - Tecle Esc p/ Sair' in screen

		ELSE 		
					
				text to xselNfeSp noshow textmerge
					select distinct 
					convert(varchar(1),'') as marca,a.caixa,a.nome_clifor from 
					faturamento_caixas a
					join vendas_prod_embalado b
					on a.caixa = b.caixa
					where b.filial='<<v_faturamento_05.filial>>'
					and a.anm_tipo_faturamento = 'FABRICA'
					and a.anm_fatura_fab = '0'
					and a.caixa not in (<<xFiltro>>)
					order by caixa
				endtext 
				
				f_select(xselNfeSp,"curNfeSp" )

				brow normal title  'Digite x nas caixas que deseja Processar - Tecle Esc p/ Sair' in screen
				*SELECIONA NOTAS PARA FATURAR
				thisformset.lX_FORM1.lx_PAGEFRAME1.page3.Lx_container1.Ck_produtos.Value = .T.
				thisformset.lX_FORM1.lx_pageframe1.page3.lx_container1.Tv_CODIGO_TAB_PRECO.Value = 'VO'
				thisformset.lX_FORM1.lx_pageframe1.page3.lx_container1.Tv_CODIGO_TAB_PRECO.REFRESH()
				*INSERE FATURAMENTO ITENS SELECIONADOS
				Sele curNfeSp 
				Scan for UPPER(marca)='X'
					
					f_prog_bar("Importando Itens Fiscais... ",RECNO(),RECCOUNT())
					
					xFiltro = xFiltro+",'"+curNfeSp.caixa+"'"
					
					text to xselItemNfeSp noshow textmerge	
						
						select a.produto,a.preco1,a.qtde_embalada 
						from vendas_prod_embalado a
						join faturamento_caixas b
						on a.caixa = b.caixa
						where a.caixa = '<<curNfeSp.caixa>>'
						and b.anm_tipo_faturamento = 'FABRICA'
						and b.anm_fatura_fab = '0'
					
					endtext
					
					f_select(xselItemNfeSp,"curItensNfeSp")

					sele curItensNfeSp
					go top
					scan	 
						
						o_toolbar.Botao_filhas_inserir.Click()			
						sele v_faturamento_05_item 

						repla codigo_item with curItensNfeSp.produto 
						thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_CODIGO_ITEM.tx_CODIGO_ITEM.l_desenhista_recalculo()
						
						repla qtde_item with curItensNfeSp.qtde_embalada
						thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_QTDE_ITEM.tx_QTDE_ITEM.l_desenhista_recalculo()
						
					endscan 

				Endscan	 
				
				xImporCaixa=1
					
				f_prog_bar()					

				sele v_faturamento_05_item
				go top	
				
				sele v_faturamento_05
				
					REPLACE condicao_pgto WITH "999"
					REPLACE peso_bruto    WITH 0.001
					REPLACE volumes       WITH 1		
		
		ENDIF 	
			
	ENDPROC


ENDDEFINE
*
*-- EndDefine: Import_Item_Transf
**************************************************




**************************************************
*-- Class:        label_emissao (c:\temp\label_emissao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/09/09 12:19:07 PM
*
DEFINE CLASS label_emissao2 AS lx_label


	Name = "label_emissao2"
	Visible=.t.
	Enabled=.t.	
	Caption = "Emissao"
	Top=5
	Left=360
	height=15
	Alignment=1


	PROCEDURE DblClick
		DODEFAULT()

		xdata=inputbox("Digite a Data","Digite a Data Correta",dtoc(v_faturamento_05.emissao))

		text to xupdt noshow	textmerge
			update faturamento SET emissao='<<DTOS(CTOD(xdata))>>',data_saida='<<DTOS(CTOD(xdata))>>' 
			where nf_saida='<<v_faturamento_05.nf_saida>>' and serie_nf='<<v_faturamento_05.serie_nf>>' 
			and filial='<<v_faturamento_05.filial>>' 
		endtext	 

		if !f_update(xupdt) 

			messagebox("Nao foi possivel Alterar a Data do Faturamento",48,"Atencao!")
			retu .f.

		endif

		thisformset.Refresh() 

		o_toolbar.Botao_refresh.Click()

	ENDPROC


ENDDEFINE
*
*-- EndDefine: label_emissao
**************************************************


**************************************************
*-- Class:        Importa_Consumiveis 
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS Import_Item_fabrica AS commandbutton


	Top = 60
	Left = 115
	Height = 20
	Width = 165
	Caption = "Itens Fiscais Fabrica x Loja"
	Name = "Import_Item_fabrica"
	Visible=.f.
	Enabled = .t.
	FontBold=.t.
	Fontsize=8
	tooltiptext="Importa Itens Fiscais da Fabrica para Loja"
	PROCEDURE Click	
		
			
		IF MESSAGEBOX("Deseja importar os Itens Fiscais ?",4+32+256,"Atencao!!!")=6
						
			IF LTRIM(RTRIM(thisformset.lx_FORM1.Tv_filial.Value))  == 'GX NORTE FABRICA'
				xTempFilial= 'GX NORTE DISTRIBUIDORA'
			
			thisformset.lx_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tv_tipo_faturamento.Value = 'SAIDA FABRICA'
			thisformset.lx_FORM1.lx_PAGEFRAME1.page1.lx_PAGEFRAME1.page2.Container2.TX_VALOR_TEMPO.Value = 100.00
			thisformset.lX_FORM1.lx_PAGEFRAME1.page3.Lx_container1.Ck_produtos.Value = .T.	
				
			TEXT TO XSEL_ITENS NOSHOW TEXTMERGE 
					
					select top 400 a.codigo_item as PRODUTO,A.QTDE,isnull(b.preco_fat,0) as PRECO
					from 
					(select distinct b.codigo_item,CONVERT(NUMERIC(14,2),1) AS QTDE
					from faturamento a
					join faturamento_item b
					on a.nf_saida=b.nf_saida
					and a.filial=b.filial
					and a.serie_nf=b.serie_nf
					where a.filial='<<v_faturamento_05.filial>>'
					and a.nome_clifor= '<<xTempFilial>>'
					and a.emissao between '20110101' and convert(datetime,convert(char(13),getdate(),112))-1) a
					left join (select produto,convert(numeric(14,2),(preco1*0.4762)) as preco_fat from produtos_precos where codigo_tab_preco='VO' ) b
					on convert(char(12),a.codigo_item)=convert(char(12),b.produto)
					
					left join

					(select distinct b.codigo_item
					from faturamento a
					join faturamento_item b
					on a.nf_saida=b.nf_saida
					and a.filial=b.filial
					and a.serie_nf=b.serie_nf
					where a.filial='<<v_faturamento_05.filial>>'
					and a.nome_clifor in (SELECT FILIAL FROM FILIAIS WHERE TIPO_FILIAL = 'LOJA VAREJO')
					and a.emissao between '20110101' and convert(datetime,convert(char(13),getdate(),112))) c
					on a.codigo_item=c.codigo_item
					where c.codigo_item is null
				
			ENDTEXT 
			
			f_select(XSEL_ITENS ,"curItensImportFabrica")	
			
			SELECT curItensImportFabrica
			GO TOP 
			SCAN 
				
				f_prog_bar("Importando Itens Fiscais... ",RECNO(),RECCOUNT())

				o_toolbar.Botao_filhas_inserir.Click()			
				sele V_FATURAMENTO_05_ITEM 

				repla CODIGO_ITEM with curItensImportFabrica.produto 
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_CODIGO_ITEM.tx_CODIGO_ITEM.l_desenhista_recalculo()
				
				repla PRECO_UNITARIO with curItensImportFabrica.preco
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_PRECO_UNITARIO.tx_PRECO_UNITARIO.l_desenhista_recalculo()		
				
				repla QTDE_ITEM with curItensImportFabrica.qtde
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_QTDE_ITEM.tx_QTDE_ITEM.l_desenhista_recalculo()
	
			ENDSCAN
			
			f_prog_bar()	
			
			RETU .f.
				
			SELECT V_FATURAMENTO_05_ITEM 
			GO TOP 	
			 
			ENDIF
			
			
			
			IF LTRIM(RTRIM(thisformset.lx_FORM1.Tv_filial.Value)) == 'RBX FABRICA'
				xTempFilial= 'RBX DISTRIBUIDORA'
				
			thisformset.lx_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tv_tipo_faturamento.Value = 'SAIDA FABRICA'	
			thisformset.lx_FORM1.lx_PAGEFRAME1.page1.lx_PAGEFRAME1.page2.Container2.TX_VALOR_TEMPO.Value = 100.00
			thisformset.lX_FORM1.lx_PAGEFRAME1.page3.Lx_container1.Ck_produtos.Value = .T.	
				
			TEXT TO XSEL_ITENS NOSHOW TEXTMERGE 
					
					select top 400 a.codigo_item as PRODUTO,A.QTDE,isnull(b.preco_fat,0) as PRECO
					from 
					(select distinct b.codigo_item,CONVERT(NUMERIC(14,2),1) AS QTDE
					from faturamento a
					join faturamento_item b
					on a.nf_saida=b.nf_saida
					and a.filial=b.filial
					and a.serie_nf=b.serie_nf
					where a.filial='<<v_faturamento_05.filial>>'
					and a.nome_clifor= '<<xTempFilial>>'
					and a.emissao between '20110101' and convert(datetime,convert(char(13),getdate(),112))-1) a
					left join (select produto,convert(numeric(14,2),(preco1*0.7)) as preco_fat from produtos_precos where codigo_tab_preco='VO' ) b
					on convert(char(12),a.codigo_item)=convert(char(12),b.produto)
					
					left join

					(select distinct b.codigo_item
					from faturamento a
					join faturamento_item b
					on a.nf_saida=b.nf_saida
					and a.filial=b.filial
					and a.serie_nf=b.serie_nf
					where a.filial='<<v_faturamento_05.filial>>'
					and a.nome_clifor in (SELECT FILIAL FROM FILIAIS WHERE TIPO_FILIAL = 'LOJA VAREJO')
					and a.emissao between '20110101' and convert(datetime,convert(char(13),getdate(),112))) c
					on a.codigo_item=c.codigo_item
					where c.codigo_item is null
				
			ENDTEXT 
			
			f_select(XSEL_ITENS ,"curItensImportFabrica")	
			
			SELECT curItensImportFabrica
			GO TOP 
			SCAN 
				
				f_prog_bar("Importando Itens Fiscais... ",RECNO(),RECCOUNT())

				o_toolbar.Botao_filhas_inserir.Click()			
				sele V_FATURAMENTO_05_ITEM 

				repla CODIGO_ITEM with curItensImportFabrica.produto 
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_CODIGO_ITEM.tx_CODIGO_ITEM.l_desenhista_recalculo()
				
				repla PRECO_UNITARIO with curItensImportFabrica.preco
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_PRECO_UNITARIO.tx_PRECO_UNITARIO.l_desenhista_recalculo()		
				
				repla QTDE_ITEM with curItensImportFabrica.qtde
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_QTDE_ITEM.tx_QTDE_ITEM.l_desenhista_recalculo()

				
			ENDSCAN 
			
			f_prog_bar()	
			
			RETU .f.
				
			SELECT V_FATURAMENTO_05_ITEM 
			GO TOP 	
			
			ENDIF
			
				
			
		ENDIF 
			
	ENDPROC


ENDDEFINE
*
*-- EndDefine: Importa_Consumiveis 
**************************************************

** Tiago Carvalho (SS) 13/10/2016 - criado o botao para gerar as notas fiscais com base em uma importacao de Excel da tela SS0065
*-- BeginDefine: Btn_Gerar_Notas_Fiscais 
**************************************************
DEFINE CLASS Btn_Gerar_Notas_Fiscais AS commandbutton
	
	
	Top = 20
	Left = 330
	Height = 21
	Width = 102
	Caption = "Gerar NFs Excel"
	Name = "Btn_Gerar_Notas_Fiscais"
	FontBold=.F.
	Fontsize=9
	tooltiptext="Gerar notas para excel importados na tela SS0065SS"
	
	PROCEDURE Click	
		** Tiago Carvalho (SS) 13/10/2016 - criado o botao para gerar as notas fiscais com base em uma importacao de Excel da tela SS0065
		dtDataHoraInicio = DATETIME()

		TEXT TO lcSql TEXTMERGE NOSHOW 
			SELECT	A.NATUREZA_SAIDA,
						A.FILIAL_ORIGEM,
						A.FILIAL_DESTINO,
						A.REFERENCIA,
						A.QTDE,
						A.CUSTO,
						NOME_ARQUIVO = CONVERT(VARCHAR(100),A.NOME_ARQUIVO),
						MENSAGEM_ERRO = CONVERT(VARCHAR(240),
										CASE WHEN B.PRODUTO IS NULL THEN 'PROD NAO CADASTRADO | '+CHAR(10) ELSE '' END +
										CASE WHEN B.PRODUTO IS NULL THEN 'PROD INATIVO | '+CHAR(10) ELSE '' END +
										CASE WHEN ORIGEM.FILIAL IS NULL THEN 'FILIAL ORIGEM NAO CADASTRADA | ' ELSE '' END+
										CASE WHEN DESTINO.FILIAL IS NULL THEN 'FILIAL DESTINO NAO CADASTRADA | ' ELSE '' END+
										CASE WHEN NATUREZAS_SAIDAS.NATUREZA_SAIDA IS NULL AND NATUREZAS_ENTRADAS.NATUREZA IS NULL  THEN 'NATUREZA NAO CADASTRADA | ' ELSE '' END+        
										CASE WHEN QTDE  <= 0 THEN 'QTDE MENOR IGUAL A ZERO | ' ELSE '' END+
										CASE WHEN CUSTO <= 0 THEN 'CUSTO MENOR IGUAL A ZERO | ' ELSE '' END +
										CASE WHEN CLASSIF_FISCAL.CLASSIF_FISCAL like '0000%' THEN 'CLASSIF FISCAL ' + LTRIm(RTRIM(ISNULL(CLASSIF_FISCAL.CLASSIF_FISCAL,''))) + ' | ' ELSE '' END +
										CASE WHEN CLASSIF_FISCAL.INATIVO =1 THEN 'CLASSIF FISCAL INATIVA  ' + ' | ' ELSE '' END +
										CASE WHEN NATUREZAS_FILIAIS_BLOQUEADAS.FILIAL IS NOT NULL THEN 'NATUREZA BLOQUEADA PARA A FILIAL | ' ELSE '' END +
										CASE WHEN CLIENTES_ATACADO.BLOQUEIO_FATURAMENTO IS NOT NULL THEN 'DESTINO BLOQUEADO PARA FATURAMENTO | ' ELSE '' END )
										
					FROM SS_FATURAMENTO_AUTOMATICO_EXCEL A(NOLOCK)
					LEFT JOIN PRODUTOS B(NOLOCK)
						ON A.REFERENCIA = B.PRODUTO 
					LEFT JOIN CLASSIF_FISCAL (NOLOCK)
						ON CLASSIF_FISCAL.CLASSIF_FISCAL = B.CLASSIF_FISCAL 
					LEFT JOIN FILIAIS ORIGEM (NOLOCK)
						ON A.FILIAL_ORIGEM = ORIGEM.FILIAL 
					LEFT JOIN FILIAIS DESTINO (NOLOCK)
						ON A.FILIAL_DESTINO = DESTINO.FILIAL 
					LEFT JOIN NATUREZAS_SAIDAS (NOLOCK)
						ON A.NATUREZA_SAIDA = NATUREZAS_SAIDAS.NATUREZA_SAIDA 
					LEFT JOIN NATUREZAS_ENTRADAS (NOLOCK)    
						ON A.NATUREZA_SAIDA = NATUREZAS_ENTRADAS.NATUREZA    
					LEFT JOIN NATUREZAS_FILIAIS_BLOQUEADAS(NOLOCK)
						ON ORIGEM.MATRIZ_FISCAL = NATUREZAS_FILIAIS_BLOQUEADAS.FILIAL AND A.NATUREZA_SAIDA = NATUREZAS_FILIAIS_BLOQUEADAS.NATUREZA_SAIDA 
					LEFT JOIN CLIENTES_ATACADO (NOLOCK)
						ON A.FILIAL_DESTINO = CLIENTES_ATACADO.CLIENTE_ATACADO 
					WHERE A.NF_SAIDA IS NULL 
						and (B.PRODUTO IS NULL			or						
							 ORIGEM.FILIAL IS NULL		or						
							 DESTINO.FILIAL IS NULL		or				
							 ISNULL(NATUREZAS_SAIDAS.NATUREZA_SAIDA ,NATUREZAS_ENTRADAS.NATUREZA) IS NULL	or		
							 QTDE  <= 0				or						
							 CUSTO <= 0				or						
							 CLASSIF_FISCAL.CLASSIF_FISCAL like '0000%'	or	
							 CLASSIF_FISCAL.INATIVO = 1 OR 				
							 B.INATIVO = 1 OR 				
							 NATUREZAS_FILIAIS_BLOQUEADAS.FILIAL IS NOT NULL	or
							 CLIENTES_ATACADO.BLOQUEIO_FATURAMENTO IS NOT NULL 
							)	

		ENDTEXT

		f_select (lcSql ,"CurErros")

		IF RECCOUNT("CurErros") > 0
			IF MESSAGEBOX("Existem inconsistencias nos arquivos importados." + chr(10) + "Deseja Exportar a validacao com os Erros?",4+16,"Exportar Erros")==6

				strcaminho = PUTFILE("Nome:","Relatorio de Erros.xls","xls")

				if empty(NVL(strcaminho,''))
					messagebox("Operacao Cancelada!",0+64,"Caminho Invalido!")
					return .f.
				endif
				
				SELECT CurErros
				GO top
					
				COPY TO (strcaminho) XLS 
			ENDIF
			messagebox("Erros no Arquivo, Geracao da Nota Fiscal Cancelada!",0+16,"Verifique os Erros gerados!")
			
			RETURN .F.
		ENDIF

		** Crio um id para agrupar as notas a cada 400 itens para enviar que o XMl fique grande e o sefaz recuse a nota fiscal
		TEXT TO lcSql TEXTMERGE NOSHOW 
			IF ISNULL(OBJECT_ID('TEMPDB..#TMPIDNOTA') ,0) > 0 
			BEGIN
				DROP TABLE #TMPIDNOTA
			END

			SELECT ID , ID_NOTA = ROW_NUMBER () OVER(PARTITION BY NOME_ARQUIVO,FILIAL_ORIGEM , FILIAL_DESTINO ,ORIGEM.MATRIZ_FISCAL ORDER BY NOME_ARQUIVO,FILIAL_ORIGEM , FILIAL_DESTINO ,ORIGEM.MATRIZ_FISCAL	 DESC) /400
			INTO #TMPIDNOTA
			FROM SS_FATURAMENTO_AUTOMATICO_EXCEL A(NOLOCK)
			INNER JOIN FILIAIS ORIGEM (NOLOCK)
				ON A.FILIAL_ORIGEM = ORIGEM.FILIAL 
			INNER JOIN FILIAIS DESTINO (NOLOCK)
				ON A.FILIAL_DESTINO = DESTINO.FILIAL 
			WHERE A.ID_NOTA IS NULL
			ORDER BY NOME_ARQUIVO,FILIAL_ORIGEM , FILIAL_DESTINO ,ORIGEM.MATRIZ_FISCAL	
				
			UPDATE A
				SET A.ID_NOTA = B.ID_NOTA
			FROM SS_FATURAMENTO_AUTOMATICO_EXCEL A
			INNER JOIN #TMPIDNOTA B
				ON A.ID = B.ID 
		ENDTEXT 

		f_execute (lcSql )

		IF USED("CurErros")
			USE IN "CurErros"
		ENDIF

		TEXT TO lcSql TEXTMERGE NOSHOW 
			SELECT	A.NATUREZA_SAIDA,
					A.FILIAL_ORIGEM,
					A.FILIAL_DESTINO,
					ORIGEM.MATRIZ_FISCAL,
					ORIGEM.COD_FILIAL,
					NOME_ARQUIVO = convert(varchar(200),LTRIM(RTRIM(A.NOME_ARQUIVO))),
					QTDE = COUNT(distinct REFERENCIA ),
					ID_NOTA  
				FROM SS_FATURAMENTO_AUTOMATICO_EXCEL A(NOLOCK)
				INNER JOIN PRODUTOS B(NOLOCK)
					ON A.REFERENCIA = B.PRODUTO 
				INNER JOIN FILIAIS ORIGEM (NOLOCK)
					ON A.FILIAL_ORIGEM = ORIGEM.FILIAL 
				INNER JOIN FILIAIS DESTINO (NOLOCK)
					ON A.FILIAL_DESTINO = DESTINO.FILIAL 
				INNER JOIN NATUREZAS_SAIDAS (NOLOCK)
					ON A.NATUREZA_SAIDA = NATUREZAS_SAIDAS.NATUREZA_SAIDA 
				WHERE A.NF_SAIDA IS NULL
				GROUP BY A.NATUREZA_SAIDA, A.FILIAL_ORIGEM, A.FILIAL_DESTINO, A.NOME_ARQUIVO,ORIGEM.MATRIZ_FISCAL,ORIGEM.COD_FILIAL,ID_NOTA  
				order by QTDE ,  NOME_ARQUIVO,FILIAL_ORIGEM , FILIAL_DESTINO ,ORIGEM.MATRIZ_FISCAL
		ENDTEXT

		f_select (lcSql ,"CurFiliaisNotas")

		SELECT CurFiliaisNotas
		GO TOP 
		SCAN
			** Tiago Carvalho SS - Criado as variaveis para utilizar no save_after, a chave utilizada anteriomente nao funciona mais porque eles mudam a filial de forma fixa no codigo.
			PUBLIC lcStrNomeArquivo , lcIntIdNota, lcStrNatureza, lcStrFilialOrigem, lcStrFilialDestino, lcStrMatrizFiscal
			
			lcStrNatureza 		= ALLTRIM(CurFiliaisNotas.NATUREZA_SAIDA)
			lcStrFilialOrigem 	= ALLTRIM(CurFiliaisNotas.FILIAL_ORIGEM)
			lcStrFilialDestino 	= ALLTRIM(CurFiliaisNotas.FILIAL_DESTINO)
			lcStrMatrizFiscal 	= ALLTRIM(CurFiliaisNotas.MATRIZ_FISCAL)
			lcStrNomeArquivo	= ALLTRIM(CurFiliaisNotas.NOME_ARQUIVO)
			lcStrCodFilial		= ALLTRIM(CurFiliaisNotas.cod_filial)
			lcIntIdNota			= CurFiliaisNotas.ID_NOTA  
			
			WAIT windows "Gerando Nota Fiscal da Filial:" + lcStrFilialOrigem +" Destino:" + lcStrFilialDestino + " Natureza:" + lcStrNatureza  nowait
			
			IF thisformset.p_tool_status == "I"
				m.o_toolbar.BOtao_cancela.Click()
				m.o_toolbar.BOTAO_Limpa.Click()
			ELSE
				m.o_toolbar.BOTAO_Limpa.Click()
			ENDIF
				
			m.o_toolbar.botao_inclui.Click()

			thisform.tv_natureza_saida.Value = lcStrNatureza 
			thisform.tv_natureza_saida.Valid()
			thisform.tv_natureza_saida.LostFocus()

			thisform.tv_serie_nf.SetFocus()
			thisform.tv_serie_nf.Value = '12'
			thisform.tv_serie_nf.InteractiveChange()
			thisform.tv_serie_nf.Valid()
			thisform.tv_serie_nf.LostFocus()

			thisform.tv_filial.SetFocus()
			thisform.tv_filial.Value = lcStrMatrizFiscal 
			thisform.tv_filial.InteractiveChange()
			thisform.tv_filial.Valid()
			thisform.tv_filial.LostFocus()
					
			thisform.tv_nome_clifor.SetFocus()
			thisform.tv_nome_clifor.Value =lcStrFilialDestino  
			thisform.tv_nome_clifor.LostFocus()
			thisform.tv_nome_clifor.Valid()
			
			IF EMPTY(thisform.tx_nf_saida.Value)
				TEXT TO lcSql TEXTMERGE NOSHOW 
					IF NOT EXISTS (SELECT * FROM FATURAMENTO_SEQUENCIAIS WHERE SERIE_NF ='12' AND FILIAL =?lcStrMatrizFiscal)
					BEGIN
						INSERT INTO FATURAMENTO_SEQUENCIAIS (SERIE_NF,FILIAL,SEQUENCIAL,TIPO_SERIE,DATA_PARA_TRANSFERENCIA,INATIVA,LX_STATUS_SEQUENCIAL)
						VALUES ('12',?lcStrMatrizFiscal,'000000000',NULL,GETDATE() , 0 ,3) 
					END

					SELECT SEQUENCIAL = CONVERT(INT,SEQUENCIAL) FROM FATURAMENTO_SEQUENCIAIS WHERE FILIAL =?lcStrMatrizFiscal AND SERIE_NF ='12'
				ENDTEXT 
				
				f_select (lcSql, "CurSequencial")
				IF RECCOUNT("CurSequencial") > 0 AND CurSequencial.SEQUENCIAL == 0 
					thisform.tx_nf_saida.SetFocus()
					thisform.tx_nf_saida.value ='000000001'
					thisform.tx_nf_saida.LostFocus()
					f_execute ("UPDATE FATURAMENTO_SEQUENCIAIS SET SEQUENCIAL = '000000001' WHERE FILIAL =?lcStrMatrizFiscal   AND SERIE_NF ='12'")
				ENDIF
			ENDIF
			
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_condicao_pgto.SetFocus()
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_condicao_pgto.Value='01'
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_condicao_pgto.LostFocus()

			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_transportadora.SetFocus()
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_transportadora.Value='CORREIOS'
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_transportadora.LostFocus()

			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_transp_redespacho.SetFocus()
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_transp_redespacho.Value ='CORREIOS'
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_transp_redespacho.LostFocus()
			
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_tipo_frete.SetFocus()
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_tipo_frete.Value ='02'
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_tipo_frete.LostFocus()
			
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.TX_VOlumes.SetFocus()
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.TX_VOlumes.Value ='1'
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.TX_VOlumes.LostFocus()
			
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_rateio_filial.SetFocus()
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_rateio_filial.Value = lcStrCodFilial
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_rateio_filial.InteractiveChange()
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_rateio_filial.Valid()
			thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_rateio_filial.LostFocus()
			
			*-- Marco Banaggia - 01/06/2018
			*thisformSET.LX_FORM1..lx_pageframe1.page1.lx_pageframe1.page1.tv_info_pgto.SetFocus()
			thisformSET.LX_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tv_info_pgto.Value='99'
			thisformSET.LX_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tv_info_pgto.InteractiveChange()
			thisformSET.LX_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tv_info_pgto.Valid()
			*thisformSET.LX_FORM1..lx_pageframe1.page1.lx_pageframe1.page1.tv_info_pgto.LostFocus()
			*-- Marco Banaggia - 01/06/2018
			*SET STEP ON
			
			
			
			IF f_vazio (thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_rateio_centro_custo.Value )
				f_select("SELECT VALOR_ATUAL  FROM PARAMETROS WHERE PARAMETRO ='CENTRO_CUSTO_PADRAO'","curCentroCusto")
				thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_rateio_centro_custo.SetFocus()
				thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_rateio_centro_custo.Value = ALLTRIM(curCentroCusto.VALOR_ATUAL)
				thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_rateio_centro_custo.InteractiveChange()
				thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_rateio_centro_custo.Valid()
				thisform.lx_pageframe1.page1.lx_pageframe1.page1.tv_rateio_centro_custo.LostFocus()
			ENDIF
				
			thisform.lx_pageframe1.ActivePage=2

			THISFORM.LX_PAgeframe1.PAge3.Lx_container1.Ck_produtos.Value = .T.
			THISFORM.LX_PAgeframe1.PAge3.Lx_container1.Ck_produtos.LostFocus()
			
			THISFORM.LX_PAgeframe1.PAge3.Lx_container1.ck_materiais.Value = .F.
			THISFORM.LX_PAgeframe1.PAge3.Lx_container1.ck_materiais.LostFocus()
			
			THISFORM.LX_PAgeframe1.PAge3.Lx_container1.CK_itens_fiscais.Value = .F.
			THISFORM.LX_PAgeframe1.PAge3.Lx_container1.CK_itens_fiscais.LostFocus()

			THISFORM.LX_PAgeframe1.PAge3.Lx_container1.CK_ativos.Value = .F.
			THISFORM.LX_PAgeframe1.PAge3.Lx_container1.CK_ativos.LostFocus()
			
			TEXT TO lcSql TEXTMERGE NOSHOW 
				SELECT	A.NATUREZA_SAIDA,
						A.FILIAL_ORIGEM,
						A.FILIAL_DESTINO,
						ORIGEM.MATRIZ_FISCAL,
						A.REFERENCIA,
						NOME_ARQUIVO = convert(varchar(200),LTRIM(RTRIM(A.NOME_ARQUIVO))),
						QTDE = SUM(A.QTDE),	
						CUSTO = MAX(A.CUSTO),
						PESO = ISNULL(B.PESO ,0)
					FROM SS_FATURAMENTO_AUTOMATICO_EXCEL A(NOLOCK)
					INNER JOIN PRODUTOS B(NOLOCK)
						ON A.REFERENCIA = B.PRODUTO 
					INNER JOIN FILIAIS ORIGEM (NOLOCK)
						ON A.FILIAL_ORIGEM = ORIGEM.FILIAL 
					INNER JOIN FILIAIS DESTINO (NOLOCK)
						ON A.FILIAL_DESTINO = DESTINO.FILIAL 
					INNER JOIN NATUREZAS_SAIDAS (NOLOCK)
						ON A.NATUREZA_SAIDA = NATUREZAS_SAIDAS.NATUREZA_SAIDA 
					WHERE A.NF_SAIDA IS NULL
						and A.NATUREZA_SAIDA		= '<<lcStrNatureza>>' 		
						and A.FILIAL_ORIGEM			= '<<lcStrFilialOrigem>>'
						and A.FILIAL_DESTINO		= '<<lcStrFilialDestino>>'
						and ORIGEM.MATRIZ_FISCAL	= '<<lcStrMatrizFiscal>>'
						and a.NOME_ARQUIVO			= '<<lcStrNomeArquivo>>'
						and A.ID_NOTA 				= '<<lcIntIdNota>>'
					GROUP BY A.NATUREZA_SAIDA, A.FILIAL_ORIGEM, A.FILIAL_DESTINO, A.REFERENCIA, A.NOME_ARQUIVO,ORIGEM.MATRIZ_FISCAL,B.PESO 
					order by NOME_ARQUIVO,FILIAL_ORIGEM , FILIAL_DESTINO ,ORIGEM.MATRIZ_FISCAL
			ENDTEXT

			f_select (lcSql ,"CurDadosNotasFiscais")

			SELECT CurDadosNotasFiscais
			GO top
			SCAN 
			
				lcStrReferencia = ALLTRIM(CurDadosNotasFiscais.referencia)
				lcQtde  = CurDadosNotasFiscais.qtde
				lcCusto = CurDadosNotasFiscais.CUSTO
				lcPeso  = CurDadosNotasFiscais.peso
				
				thisformset.lx_FORM1.lx_pageframe1.page1.Lx_pageframe1.Page1.Tx_peso_bruto.Value = thisformset.lx_FORM1.lx_pageframe1.page1.Lx_pageframe1.Page1.Tx_peso_bruto.Value + lcPeso  
				
				M.o_toolbar.botao_filhas_inserir.Click()

				SELECT V_FATURAMENTO_05_ITEM

				THISFORM.LX_PAgeframe1.PAge3.LX_grid_filha1.COL_TX_CODIGO_ITEM.TX_CODIGO_ITEM.SetFocus()
				THISFORM.LX_PAgeframe1.PAge3.LX_grid_filha1.COL_TX_CODIGO_ITEM.TX_CODIGO_ITEM.Value = lcStrReferencia 
				THISFORM.LX_PAgeframe1.PAge3.LX_grid_filha1.COL_TX_CODIGO_ITEM.TX_CODIGO_ITEM.LostFocus()
				THISFORM.LX_PAgeframe1.PAge3.LX_grid_filha1.COL_TX_CODIGO_ITEM.TX_CODIGO_ITEM.Valid()
				THISFORM.LX_PAgeframe1.PAge3.LX_grid_filha1.COL_TX_CODIGO_ITEM.TX_CODIGO_ITEM.L_DEsenhista_recalculo ()

				THISFORM.LX_PAgeframe1.PAge3.LX_grid_filha1.COL_TX_QTDE_ITEM.TX_QTDE_ITEM.SetFocus()
				THISFORM.LX_PAgeframe1.PAge3.LX_grid_filha1.COL_TX_QTDE_ITEM.TX_QTDE_ITEM.Value = lcQtde  
				THISFORM.LX_PAgeframe1.PAge3.LX_grid_filha1.COL_TX_QTDE_ITEM.TX_QTDE_ITEM.LostFocus()

				THISFORM.LX_PAgeframe1.PAge3.LX_grid_filha1.COL_TX_PRECO_UNITARIO.TX_PRECO_UNITARIO.SetFocus()
				THISFORM.LX_PAgeframe1.PAge3.LX_grid_filha1.COL_TX_PRECO_UNITARIO.TX_PRECO_UNITARIO.Value = lcCusto 
				THISFORM.LX_PAgeframe1.PAge3.LX_grid_filha1.COL_TX_PRECO_UNITARIO.TX_PRECO_UNITARIO.Valid()
				THISFORM.LX_PAgeframe1.PAge3.LX_grid_filha1.COL_TX_PRECO_UNITARIO.TX_PRECO_UNITARIO.L_DEsenhista_recalculo ()
				
				THISFORM.LX_PAgeframe1.PAge3.LX_grid_filha1.COL_TX_PESO.TX_PESO.SetFocus()
				THISFORM.LX_PAgeframe1.PAge3.LX_grid_filha1.COL_TX_PESO.TX_PESO.Value = lcPeso  
				THISFORM.LX_PAgeframe1.PAge3.LX_grid_filha1.COL_TX_PESO.TX_PESO.LostFocus()

				SELECT CurDadosNotasFiscais
				
			ENDSCAN
			
			IF USED("CurDadosNotasFiscais")
				USE IN CurDadosNotasFiscais
			ENDIF
			
			IF thisformset.lx_FORM1.lx_pageframe1.page1.Lx_pageframe1.Page1.Tx_peso_bruto.Value <= 0
				thisformset.lx_FORM1.lx_pageframe1.page1.Lx_pageframe1.Page1.Tx_peso_bruto.Value = 1
			ENDIF
			
			m.o_toolbar.botao_salva.Click()
			
			SELECT CurFiliaisNotas

		ENDSCAN

		strMinutos = ALLTRIM(STR((DATETIME() - dtDataHoraInicio) / 60))
		strSegundos = ALLTRIM(STR(MOD((DATETIME() - dtDataHoraInicio), 60)))

		MESSAGEBOX('Tempo total: ' + strMinutos + ' minuto(s) e ' + strSegundos + ' segundo(s).',0+64,"Importacao Concuida")
	ENDPROC
ENDDEFINE
*-- endDefine: Btn_Gerar_Notas_Fiscais 
**************************************************

**************************************************
*-- Class:        btn_selpedido (c:\temp\botao.vcx)
*-- ParentClass:  botao (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/04/18 05:41:05 PM
*
DEFINE CLASS btn_selpedido AS botao


	Top = 45
	Left = 350
	Height = 20
	Width = 66
	Anchor = 3
	Caption = "Sel. Pedido"
	Name = "CMD"
	tooltiptext="Busca as informacoes basicas do pedido"


	PROCEDURE Click
		PUBLIC xPedido, xSql, xValorComissao

		IF THISFORMSET.lx_form1.tv_natureza_saida.value = '102.01' AND thisformset.lx_form1.tv_serie_nf.value = '92' AND thisformset.p_tool_status ='I'

			xPedido = INPUTBOX("Digite o numero do Pedido","Pedido",'')

			IF f_vazio(xPedido)
				RETURN .f.
			ENDIF
			this.LostFocus()
			xValorComissao = 0.00
			
			TEXT TO xSql TEXTMERGE NOSHOW 

				SELECT 
					CLIENTES_ATACADO.CLIFOR,
					VENDAS.CLIENTE_ATACADO, 
					VENDAS.TIPO, 
					VENDAS.REPRESENTANTE, 
					VENDAS.COMISSAO
				FROM
					VENDAS (nolock)
					INNER JOIN CLIENTES_ATACADO (NOLOCK) ON VENDAS.CLIENTE_ATACADO=CLIENTES_ATACADO.CLIENTE_ATACADO
				WHERE
					PEDIDO = '<<xPedido>>'

			ENDTEXT 

			f_select(xSql,"vtmp_pedido")
			SELECT vtmp_pedido
			IF RECCOUNT() > 0
				IF vtmp_pedido.comissao = 0
					TEXT TO xComissao TEXTMERGE NOSHOW
						SELECT COMISSAO FROM REPRESENTANTES WHERE REPRESENTANTE='<<vtmp_pedido.representante>>'
					ENDTEXT
					F_SELECT(xComissao, "vtmp_comissao")
					IF vtmp_comissao.comissao = 0
						MESSAGEBOX("Representante sem comissao cadastrada, Verifique!",16,"Atencao")
						thisformset.l_cancela
						thisformset.l_limpa
						thisformset.refresh()
						RETURN .f.
					ELSE
						xValorComissao = vtmp_comissao.comissao
					ENDIF
				ELSE
					xValorComissao = vtmp_pedido.comissao
				ENDIF 



				SELECT v_faturamento_05
				replace v_faturamento_05.nome_clifor with vtmp_pedido.cliente_atacado
				replace v_faturamento_05.tipo_faturamento WITH vtmp_pedido.tipo
				replace v_faturamento_05.representante WITH vtmp_pedido.representante
				replace v_faturamento_05.comissao WITH xValorComissao 

				thisformset.lx_forM1.tv_cliente_varejo.Value = vtmp_pedido.cliente_atacado
				thisformset.lx_forM1.tv_nome_clifor.Value = vtmp_pedido.cliente_atacado
				o_100102.lx_forM1.tv_nome_clifor.setfocus()
				keyboard(chr(13))
				thisformset.lx_forM1.lx_pageframe1.page1.lx_pageframe1.page1.tv_representante.Value = vtmp_pedido.representante
				thisformset.lx_forM1.lx_pageframe1.page1.lx_pageframe1.page1.tx_comissao.Value = xValorComissao 
				thisformset.lx_forM1.lx_pageframe1.page1.lx_pageframe1.page1.tv_tipo_faturamento.value = vtmp_pedido.tipo
				thisformset.lx_fORM1.lx_paGEFRAME1.page7.ed_OBS.Value = "Pedido: " + xPedido
			ELSE
				MESSAGEBOX("Pedido nao localizado, Verifique!",16,"Atencao")
			ENDIF 
			IF USED("vtmp_pedido")
				USE IN vtmp_pedido
			ENDIF 
		ELSE
			MESSAGEBOX("Para utilizar este botao, verifique a Natureza e/ou Serie.",16,"Atencao")
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: btn_selpedido
**************************************************

DEFINE CLASS btn_cancela AS botao
	Top = 100
	Left = 320
	Height = 20
	Width = 66
	Anchor = 3
	Caption = "Cancela NF"
	Name = "CMD"
	tooltiptext="Cancela NF Servico"


	PROCEDURE Click
		IF THISFORMSET.lx_form1.tv_natureza_saida.value = '102.01' AND thisformset.lx_form1.tv_serie_nf.value = '92'

			IF 6 = MESSAGEBOX('Deseja cancelar a nota fiscal?', 36, wusuario)

				TEXT TO VLC_Command TEXTMERGE NOSHOW 
					BEGIN TRANSACTION
					DELETE FROM ctb_lancamento_item WHERE lancamento = <<ALLTRIM(STR(V_FATURAMENTO_05.ctb_lancamento))>>
					
					exec lx_cancela_doc_nfe  '<<V_FATURAMENTO_05.nf_saida>>', '<<V_FATURAMENTO_05.serie_nf>>', '<<V_FATURAMENTO_05.filial>>', 'F'
					commit
				ENDTEXT 
				
				IF f_execute(VLC_Command)
					MESSAGEBOX('Processo concluido! Nota cancelada com sucesso!', 64, wusuario)
					thisformset.l_limpa()
				ENDIF
			ENDIF
		ENDIF
	ENDPROC
	
	PROCEDURE refresh
		DODEFAULT()
		
		this.Visible = thisformset.p_tool_status = 'P' and ALLTRIM(V_FATURAMENTO_05.serie_nf) = '92'
	endproc

ENDDEFINE
