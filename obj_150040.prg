define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
		
		DO CASE
			CASE UPPER(XMETODO) == 'USR_INIT'
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
					
				** Bruno Silva (SS) - Objeto criado para importar porcentagem das distribuições
				thisformset.lx_FORM1.AddObject('btnImportarExcel', 'btnImportarExcel')
				* Crio tag para seek
				SELECT v_giv_planejamento_00_distribuicao
				=TABLEREVERT(.T., "v_giv_planejamento_00_distribuicao")
				=CURSORSETPROP("Buffering",3, "v_giv_planejamento_00_distribuicao")
				INDEX ON ALLTRIM(id_agrupamento) + ALLTRIM(cod_clifor) TAG idxPor
				=CURSORSETPROP("Buffering",5, "v_giv_planejamento_00_distribuicao")
				SET ORDER TO
						
			CASE UPPER(XMETODO) == 'USR_REFRESH'  AND !(TYPE("thisformset.lx_FORM1.btnImportarExcel") == "U")

				thisformset.lx_FORM1.btnImportarExcel.Enabled = (thisformset.p_tool_status == "A")
				
		otherwise
			return .t.				
		endcase
	endproc
ENDDEFINE

** Bruno Silva (SS) - Botão para importar xls
DEFINE CLASS btnImportarExcel AS commandbutton
	Height = 23
	Width = 161
	FontBold = .F.
	FontName = "tahoma"
	FontSize = 8
    Caption = "Importar Porcentagem"
	Name = "btnImportarExcel"
	autosize = .T.
	visible = .T.
	enabled = .F.
	top = 110
		
	PROCEDURE Click
	
		bImporta = .t.
			
		strcaminho = getfile("xls?","Importar Arquivo","Importar",0,"Importar Arquivo")

		if empty(NVL(strcaminho,''))
			messagebox("Operação Cancelada!",0+64,"Arquivo Inválido!")
			return .f.
		endif
		
		F_wait("Importando as informações, Aguarde...")	
			
		if used("CUR_IMPORT")
			use in CUR_IMPORT
		endif
		
		CREATE CURSOR CUR_IMPORT(ID_AGRUPAMENTO C(30), COD_CLIFOR C(6), PORCENTAGEM_QTDE n(5,2))
		
		
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
			
			IF upper(alltrim(objsheet.cells(1,1).text)) <> "ID_AGRUPAMENTO" OR upper(alltrim(objsheet.cells(1,2).text))<> "COD_FILIAL" OR upper(alltrim(objsheet.cells(1,3).text))<> "PORCENTAGEM"
				MESSAGEBOX("O Layout do Arquivo é Inválido, O Cabeçalho deve Conter as Seguintes Informações:"+CHR(10)+"Id_Agrupamento Célula A"+CHR(10)+"Cod_filial Célula B"+CHR(10)+"PORCENTAGEM Célula C",0+16,"Obj - Layout Inválido")
				RETURN .f.
			ENDIF		
			
			IF f_vazio(alltrim(objsheet.cells(iPermitido,1).text)) 
				objsheetRange   = objsheet.range(objsheet.cells(iImatrizIni,1),objsheet.cells(iImatrizFim,5)).value
				SELECT CUR_IMPORT
				APPEND FROM array objsheetRange   
			ELSE 
				DO WHILE iPercorrer >= iPercorrido      
				
					objsheetRange   = objsheet.range(objsheet.cells(iImatrizIni,1),objsheet.cells(iImatrizFim,5)).value
					
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
		
		
		if type("oexception") = "o"
			return(.f.)
		ENDIF
				
		
		SELECT v_giv_planejamento_00_distribuicao
		
		
		xFiltro = SET("Filter")
		SET FILTER TO
		
		_cliptext = xFiltro

		SELECT ID_AGRUPAMENTO , COD_CLIFOR , porcentagem_qtde FROM CUR_IMPORT WHERE !f_vazio(CUR_IMPORT.ID_AGRUPAMENTO);
		ORDER BY ID_AGRUPAMENTO INTO CURSOR curexcelFinal
			
		USE IN CUR_IMPORT
		
		LOCAL xIdAgrupMod
		xIdAgrupMod = SPACE(30)
		
		SELECT curexcelFinal
		GO top
		SCAN
				sele v_giv_planejamento_00
				xCodPlan = v_giv_planejamento_00.cod_planejamento
				xIdAgrup = curexcelFinal.id_agrupamento
				xCodClif = curexcelFinal.cod_clifor
				
				if ALLTRIM(xIdAgrupMod) <> ALLTRIM(xIdAgrup) 
					f_update("EXEC DBO.LX_ANM_INCLUI_FILIAL_GIV_AGRUPAMENTO ?xIdAgrup , ?xCodClif, ?xCodPlan, 1")
					xIdAgrupMod = xIdAgrup 
				endif	 
				
				f_update("EXEC DBO.LX_ANM_INCLUI_FILIAL_GIV_AGRUPAMENTO ?xIdAgrup , ?xCodClif, ?xCodPlan")
		ENDSCAN
		
	thisformset.dataEnvironment.Cursorv_giv_planejamento_00_distribuicao.CursorFill()	
	 
	f_wait("Atualizando o percentual do agrupamento !!!, Aguarde...")
		SELECT curexcelFinal
		GO top
		SCAN
		*** thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA2.col_tx_PORCENTAGEM_QTDE.SetFocus()
		***	thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA2.col_tx_PORCENTAGEM_QTDE.tx_PORCENTAGEM_QTDE.l_desenhista_recalculo()		
		*** #1 - LUCAS MIRANDA - 11/08/2016 - RECALCULAR PORCENTAGEM DO AGRUPAMENTO
			IF  SEEK(ALLTRIM(curexcelFinal.ID_AGRUPAMENTO )+ALLTRIM(curexcelFinal.COD_CLIFOR ),'v_giv_planejamento_00_distribuicao','idxPor')
				SELECT v_giv_planejamento_00_distribuicao
				replace porcentagem_qtde		WITH curexcelFinal.porcentagem_qtde IN v_giv_planejamento_00_distribuicao
				thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA2.col_tx_PORCENTAGEM_QTDE.SetFocus()
				thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA2.col_tx_PORCENTAGEM_QTDE.tx_PORCENTAGEM_QTDE.l_desenhista_recalculo()
			ENDIF
				
		ENDSCAN
	f_wait()	
		
		 
		xFiltro = 'V_GIV_PLANEJAMENTO_00_distribuicao.' + LTRIM(RTRIM(xFiltro))
		
		
		select V_GIV_PLANEJAMENTO_00_distribuicao
		SET FILTER TO &xFiltro 
	
		
	thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA2.Refresh()
	
	EndProc
EndDefine