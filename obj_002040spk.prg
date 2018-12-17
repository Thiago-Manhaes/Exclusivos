define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
DO CASE
	Case UPPER(ALLT(xmetodo)) == 'USR_INIT'
		xVersao = '01.1'
		f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
		f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
		WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
		* Leandro Rocha (SS) - 27/11/2013: Obejto criado para adicionar o botão de importação automática dos produtos da FCI
		thisformset.lx_FORM1.lx_pageframe.page3.addobject('btnFci', 'clsBtnFci')
		thisformset.lx_FORM1.lx_pageframe.page3.btnFci.Top = thisformset.lx_FORM1.lx_pageframe.page3.bt_Importar.Top
		thisformset.lx_FORM1.lx_pageframe.page3.btnFci.Width = thisformset.lx_FORM1.lx_pageframe.page3.bt_Importar.Width
		thisformset.lx_FORM1.lx_pageframe.page3.btnFci.Height = thisformset.lx_FORM1.lx_pageframe.page3.bt_Importar.Height
		thisformset.lx_FORM1.lx_pageframe.page3.btnFci.ForeColor = thisformset.lx_FORM1.lx_pageframe.page3.bt_Importar.ForeColor

		
OTHERWISE
	RETURN .T.
ENDCASE
ENDPROC
ENDDEFINE

* CLASSE DO BOTÃO 
DEFINE CLASS clsBtnFci AS commandbutton
	FontBold = .F.
	FontName = 'Tahoma'
	fontsize = 8
	Caption = "Importação Automatica FCI"
	Name = "btnFci"
	visible = .T.
	Enable = .T.
	Left = 199
	
	PROCEDURE Click
		if !thisformset.p_tool_status$'I' 
			MESSAGEBOX('Procesos permitido apenas em modo de inclusão!', 16 + 0, 'SS - ATENÇÃO')
			WAIT WINDOW 'Somente em Inclusão!' nowait
			return .f.
		ENDIF

		strAlias = ALIAS()


		f_wait('Recalculando Dados da FCI. Aguarde...')

		IF !F_EXECUTE("EXEC PROC_ATUALIZACAO_FCI", 'curFciPendete')
			MESSAGEBOX('Erro ao recaulcular dados da FCI, acerte o problema e tente novamente!', 16, "SS- ATENÇÃO")
			f_wait()
			RETURN .F.
		ENDIF

		f_wait('Consultando Produtos')

		* Consulta Produtos pendentes de FCI
		TEXT TO strSql TEXTMERGE NOSHOW 
			SELECT A.PRODUTO, '' AS CODIGO_BARRA, CONVERT(VARCHAR(10), A.CUSTO_MAT_IMP) AS VALOR_PARCELA, CONVERT(VARCHAR(10), A.PRECO_HIST_VENDA) AS VALOR_SAIDA, 
					CONVERT(VARCHAR(10), A.PERC_CONT_IMP) AS PERCENTUAL, '' AS CODIGO_FCI, '' AS VALIDACAO
				FROM PRODUTOS A (NOLOCK)
				LEFT JOIN PRODUTOS_FICHA_IMPORTACAO B (NOLOCK)
					ON B.PRODUTO = A.PRODUTO
				WHERE (ISNULL(B.VALOR_SAIDA_MERCADORIA_INTERESTADUAL, 0) <> ISNULL(A.PRECO_HIST_VENDA, 0)
						OR ISNULL(B.VALOR_PARCELA_IMPORTADA_EXTERIOR, 0) <> ISNULL(A.CUSTO_MAT_IMP, 0)
						OR ISNULL(B.CONTEUDO_IMPORTACAO_CI, 0) <> ISNULL(A.PERC_CONT_IMP, 0))
					AND A.PERC_CONT_IMP <= 100
		ENDTEXT

		F_SELECT(strSql, 'curFciPendete')

		* Cria diretório temporário guardar a planilha da FCI
		IF !DIRECTORY('C:\TEMP\FCI') 
			MD('C:\TEMP\FCI')
		ENDIF 

		* Define Nome do arquivo
		strArquivo = 'c:\temp\fci\FCI - ' + Wusuario + ' - ' + TTOC(dateTIME(), 1) + '.XLS'

		* Exclui o arquivo se existir
		IF FILE (strArquivo)
			DELETE FILE (strArquivo)
		ENDIF 

		* Cria Objeto Excel para gerar planilha, não foi usado o copy porque gera a primeira linha com o cabeçalho.
		objExcel = CREATEOBJECT("Excel.Application")
		objWorkBook = objExcel.Application.Workbooks.Add()
		objExcel.DisplayAlerts = .F.
		intLinha = 0
		objExcel.Columns("A").NumberFormat = "@"
		objExcel.Columns("B").NumberFormat = "@"
		objExcel.Columns("C").NumberFormat = "@"
		objExcel.Columns("D").NumberFormat = "@"
		objExcel.Columns("E").NumberFormat = "@"

		SELECT curFciPendete
		GO top
		SCAN 
			f_wait('Gerando registros dos produtos para a FCI (' + ALLTRIM(STR(RECNO('curFciPendete'))) + ' de ' + ALLTRIM(STR(RECCOUNT('curFciPendete'))) + ')')
			intLinha = intLinha + 1
			objExcel.range("A" + ALLTRIM(STR(intLinha))).Value = ALLTRIM(curFciPendete.produto)
			objExcel.range("B" + ALLTRIM(STR(intLinha))).Value = ALLTRIM(curFciPendete.codigo_barra)
			objExcel.range("C" + ALLTRIM(STR(intLinha))).Value = ALLTRIM(curFciPendete.valor_parcela)
			objExcel.range("D" + ALLTRIM(STR(intLinha))).Value = ALLTRIM(curFciPendete.valor_saida)
			objExcel.range("E" + ALLTRIM(STR(intLinha))).Value = ALLTRIM(curFciPendete.percentual)
		ENDSCAN

		f_wait()

		if val(objExcel.Version) > 11
		    objWorkBook.SaveAs(strArquivo, 56)
		else
		    objWorkBook.SaveAs(strArquivo)
		endif

		objExcel.Quit()

		SELECT (strAlias)

		IF FILE (strArquivo)
			* Importa arquivo FCI
			IF Thisformset.lx_importa_arquivo_xls(strArquivo)
				m.o_toolbar.botao_salva.Click()
				m.o_toolbar.botao_salva.Click()
				m.o_toolbar.botao_limpa.Click()
				thisformset.lx_FORM1.ck.Value = 1
				m.o_toolbar.botao_procura.Click()
			ENDIF

			&&DELETE FILE(strArquivo)
		ENDIF 
	ENDPROC
ENDDEFINE
