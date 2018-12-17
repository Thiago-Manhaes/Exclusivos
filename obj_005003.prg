define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
		
do case
	* Sintese Soluções - Tiago Carvalho - CRIADO OBJETO PARA IMPRIMIR ETIQUETA DE LOCALIZAÇÃO DE MATÉRIA PRIMA
	Case UPPER(ALLT(xmetodo)) == 'USR_INIT'
		WAIT WINDOW 'OBJ-SS 1.0' NOWAIT
		with thisformset.LX_FORM1.LX_GRID_FILHA1
		
			.col_tx_descricao.width = 260
			.col_tx_depto.width = 130
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
			
			lcColumnCount = .columncount 
			lcColumnCount = lcColumnCount + 1 
		    .addcolumn(lcColumnCount )
			.columns[lcColumnCount].name = 'col_etiqueta_peca'
			.col_etiqueta_peca.width = 70
			.col_etiqueta_peca.BackColor = 15399423
			.col_etiqueta_peca.columnorder = 2
			.col_etiqueta_peca.header1.caption = 'Etiqueta'
			.col_etiqueta_peca.header1.alignment = 2
			.col_etiqueta_peca.header1.FONTSIZE = 8
			.col_etiqueta_peca.addobject('bt_etiqueta_peca','bt_etiqueta_peca')
			.col_etiqueta_peca.currentcontrol = 'bt_etiqueta_peca'
			.col_etiqueta_peca.removeobject('text1')
			.col_etiqueta_peca.currentcontrol = 'bt_etiqueta_peca'
			.col_etiqueta_peca.sparse = .F.
			.col_etiqueta_peca.refresh()
	ENDWITH
Otherwise
	return .t.				
endcase
endproc
enddefine

DEFINE CLASS bt_etiqueta_peca AS commandbutton
	Height = 25
	Width = 85
	FontBold = .F.
	FontName = "Arial"
	FontSize = 8
    Caption = "Etiqueta Peça"
	Name = "bt_etiqueta_peca"
	autosize = .T.
	visible = .T.
	enabled = .T.
		
	PROCEDURE Click

		IF !(THISFORMSET.P_TOOL_STATUS == "P")
			MESSAGEBOX("Etiqueta só dispoível em modo de pesquisa!",0+64,"Obj-Etiqueta Somente Pesquisa")
		else
			nAntArea = select()
			
			TEXT TO lcSql TEXTMERGE noshow
				SELECT 	A.MATERIAL,
						B.DESC_MATERIAL,
						A.PECA,
						A.LOCALIZACAO,
						B.DESC_COMPOSICAO,
						B.UNID_ESTOQUE,
						A.LARGURA,
						A.COR_MATERIAL,
						B.COLECAO,
						C.DESC_COR_MATERIAL,
						B.FABRICANTE,
						A.QTDE,
						A.PARTIDA,
						RECEITA = ISNULL(A.RECEITA,''),
						NF_ENTRADA = (SELECT TOP 1 AA.NF_ENTRADA FROM ESTOQUE_RET_PECA BB,ESTOQUE_RET_MAT AA WHERE AA.REQ_MATERIAL = BB.REQ_MATERIAL AND AA.FILIAL = BB.FILIAL AND LTRIM(RTRIM(ISNULL(AA.NF_ENTRADA,'')))<>'' AND BB.PECA = A.PECA AND BB.PARTIDA = A.PARTIDA AND BB.PECA <>'AJUSTE' ORDER BY EMISSAO ASC),
						NOME_CLIFOR = (SELECT TOP 1 AA.NOME_CLIFOR FROM ESTOQUE_RET_PECA BB,ESTOQUE_RET_MAT AA WHERE AA.REQ_MATERIAL = BB.REQ_MATERIAL AND AA.FILIAL = BB.FILIAL AND LTRIM(RTRIM(ISNULL(AA.NF_ENTRADA,'')))<>'' AND BB.PECA = A.PECA AND BB.PARTIDA = A.PARTIDA AND BB.PECA <>'AJUSTE' ORDER BY EMISSAO ASC)
				FROM ESTOQUE_MAT_PECA A(nolock)
				INNER JOIN MATERIAIS B(nolock)
					ON A.MATERIAL = B.MATERIAL 
				INNER JOIN MATERIAIS_CORES C(nolock)
					ON A.MATERIAL = C.MATERIAL AND A.COR_MATERIAL = C.COR_MATERIAL 
				WHERE A.LOCALIZACAO = ?V_MATERIAIS_LOCALIZA_00.LOCALIZACAO
			ENDTEXT
			
			IF !f_select (lcSql,"CurTmpEstoquePeca")
				MESSAGEBOX("Erro ao consultar o estoque da peça, Tente novamente!",0+16,"Obj-Erro Consulta")
				RETURN .f.
			ENDIF
			
			IF RECCOUNT("CurTmpEstoquePeca") > 0							
				lcQtdeEtiqueta = RECCOUNT("CurTmpEstoquePeca")
				IF (MESSAGEBOX("Você têm certeza que deseja imprimir as "+ALLTRIM(STR(lcQtdeEtiqueta ))+"?",4+32+256,"Obj-Impressao Etiquetas"))==7
					RETURN .f.
				endif
				
				strProc = SET("Procedure")
				Set procedure To \Linx\Report\User\Proc_SS_Etiquetas.prg Additive
				
				SELECT CurTmpEstoquePeca
				GO top
				scan
					* 22/01/2014 - Síntese Soluções - Tiago Carvalho - Alterado para o padrão Sintese Etiquetas
					strPeca 			= ALLTRIM(CurTmpEstoquePeca.PECA)
					strQtde 			= ALLTRIM(str(CurTmpEstoquePeca.QTDE, 7,3))
					strUnidEstoque 		= ALLTRIM(CurTmpEstoquePeca.unid_estoque)
					strLargura 			= ALLTRIM(str(CurTmpEstoquePeca.LARGURA,6,2))
					strPartida			= ALLTRIM(CurTmpEstoquePeca.PARTIDA)
					strLocalizacao 		= ALLTRIM(CurTmpEstoquePeca.localizacao)
					strFabricante 		= ALLTRIM(CurTmpEstoquePeca.fabricante)
					strMaterial 		= ALLTRIM(CurTmpEstoquePeca.material)
					strDescMaterial 	= ALLTRIM(CurTmpEstoquePeca.DESC_MATERIAL)
					strDescComposicao 	= ALLTRIM(CurTmpEstoquePeca.Desc_Composicao)
					strCor 				= ALLTRIM(CurTmpEstoquePeca.cor_material)
					strDescCor 			= ALLTRIM(CurTmpEstoquePeca.desc_cor_material)
					strNFEntrada		= NVL(ALLTRIM(CurTmpEstoquePeca.NF_ENTRADA),'')
					strFornecedor		= NVL(ALLTRIM(CurTmpEstoquePeca.NOME_CLIFOR),'')
					strColecao			= ALLTRIM(CurTmpEstoquePeca.COLECAO)
					strPecaTemp			= ALLTRIM(CurTmpEstoquePeca.RECEITA)
					strSaida			= ""	
									
					wait wind 'IMPRIMINDO ETIQUETAS...' nowait
					IF !DIRECTORY('C:\SINTESE\ETIQUETA')
						MD('C:\SINTESE\ETIQUETA')
					ENDIF
					
					lcNomeArquivo ='C:\SINTESE\ETIQUETA\PECA_MP_'+ALLTRIM(WUSUARIO)+'.ETQ'
					
					IF FILE (lcNomeArquivo)
						DELETE FILE &lcNomeArquivo 
					ENDIF
					
					* 19/12/2013 - Síntese Soluções - Tiago Carvalho - Criado o PRG para centralizar as etiquetas facilitando o manutenção
					* ETIQUETA TERMICA DE PEÇAS DE ESTOQUE - ARGOX
					IF CurTmpEstoquePeca.QTDE > 0 
						intArq = fCreate(lcNomeArquivo, 0)
						if (intArq >= 0)
							fwrite(intArq, Proc_Etiqueta_Peca(strPeca, strQtde, strUnidEstoque, strLargura, strPartida, strLocalizacao, strFabricante, strMaterial, strDescMaterial, strDescComposicao, strCor, strDescCor,strNFEntrada,strFornecedor,strColecao,strPecaTemp,strSaida))
							fClose(intArq)
							!COPY &lcNomeArquivo LPT1
						ENDIF
						wait wind 'IMPRESSÃO CONCLUIDA.' nowait
					endif
				ENDSCAN
				SET PROCEDURE TO &strProc
			ENDIF
			SELECT (nAntArea)
		ENDIF
	EndProc
EndDefine

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
		IF !DIRECTORY([C:\SINTESE\ETIQUETA])
			MKDIR [C:\SINTESE\ETIQUETA]
		ENDIF

		If File('C:\SINTESE\ETIQUETA\LOCALIZACAOMP.ETQ')
			DELETE FILE('C:\SINTESE\ETIQUETA\LOCALIZACAOMP.ETQ')
		ENDIF 

		If !File('C:\SINTESE\ETIQUETA\LOCALIZACAOMP.ETQ')
				nArq = fCreate('C:\SINTESE\ETIQUETA\LOCALIZACAOMP.ETQ', 0)
				If (nArq < 0)
					MessageBox('Impossível criar arquivo C:\SINTESE\ETIQUETA\LOCALIZACAOMP.ETQ!', 0+16, 'Atenção')
				ELSE
				
					cEol= Chr(13) +Chr(10)
					lcCmd = "L" + cEol
					lcCmd = lcCmd + "H20" +cEol
					lcCmd = lcCmd + "N"  + cEol
					lcCmd = lcCmd + "121000003200035" +Left(allTrim(v_materiais_localiza_00.DESCRICAO), 32)  + cEol
					lcCmd = lcCmd + "121000001700035" +Substr(allTrim(v_materiais_localiza_00.DESCRICAO), 33)+ cEol
					lcCmd = lcCmd + "1A5007002000035" +allTrim(v_materiais_localiza_00.LOCALIZACAO) +cEol
					lcCmd = lcCmd + "142200001000020" +allTrim(v_materiais_localiza_00.LOCALIZACAO) +cEol
					lcCmd = lcCmd +	"E" +cEol
					fPuts( nArq, lcCmd)
					fClose(nArq)
				Endif
			ENDIF

			!copy C:\SINTESE\ETIQUETA\LOCALIZACAOMP.ETQ LPT1

			WAIT WINDOW 'ETIQUETA IMPRESSA...' NOWAIT

		RETURN .T. 
	EndProc
EndDefine




