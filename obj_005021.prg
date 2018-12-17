define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
		
		do case
			case UPPER(xmetodo) == 'USR_INIT' 
				* 21/05/2014 - Leandro Rocha: Adicionar campo com a quantidade localizada e o número da caixa
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
				
				* Tira acesso de alteração e redimenciona os campos
				thisformset.p_acesso_alterar = .f.
				thisformset.lx_FORM1.lx_GRID_FILHA1.col_tx_grade.Width = 45
				thisformset.lx_FORM1.lx_GRID_FILHA1.col_tx_desc_localizacao.Width = 230
				
				* Adiciona campo com a quantidade localizada no cursor
				objCursor = getcursoradapter('V_LOCALIZACOES_PRODUTO_01_LOCALIZACOES')
				objCursor.addbufferfield("PRODUTOS_LOCALIZACAO.QTDE", "I", .T., "QTDE", "PRODUTOS_LOCALIZACAO.QTDE")
				objCursor.confirmstructurechanges()
				
				* Adiciona campo caixa no cursor
				objCursor = getcursoradapter('V_LOCALIZACOES_PRODUTO_01_LOCALIZACOES')
				objCursor.addbufferfield("PRODUTOS_LOCALIZACAO.CAIXA", "C(20)", .T., "QTDE", "PRODUTOS_LOCALIZACAO.CAIXA")
				objCursor.confirmstructurechanges()
				
				* Altera o campo campacidade para quantidade na grid
				thisformset.LX_FORM1.LX_Grid_filha1.COL_tx_CAPACIDADE.ControlSource = 'V_LOCALIZACOES_PRODUTO_01_LOCALIZACOES.QTDE'
				thisformset.LX_FORM1.LX_Grid_filha1.COL_tx_CAPACIDADE.H_tx_CAPACIDADE.Caption = 'Qtde'
				thisformset.LX_FORM1.LX_Grid_filha1.COL_tx_CAPACIDADE.ColumnOrder = 5
								
				* Altera o campo Sequencia separacao para caixa na grid
				thisformset.LX_FORM1.LX_Grid_filha1.COL_tx_ORDEM_ATENDIMENTO.ControlSource = 'V_LOCALIZACOES_PRODUTO_01_LOCALIZACOES.CAIXA'
				thisformset.LX_FORM1.LX_Grid_filha1.COL_tx_ORDEM_ATENDIMENTO.H_tx_ORDEM_ATENDIMENTO.Caption = 'Caixa'
				thisformset.LX_FORM1.LX_Grid_filha1.COL_tx_ORDEM_ATENDIMENTO.H_tx_ORDEM_ATENDIMENTO.WordWrap = .F.
				thisformset.lx_FORM1.lx_GRID_FILHA1.COL_tx_ORDEM_ATENDIMENTO.TX_ORDEM_ATENDIMENTO.InputMask = ''
				thisformset.lx_FORM1.lx_GRID_FILHA1.col_tx_ordem_atendimento.Width = 80
				
			OTHERWISE 
				RETURN .t.				
		ENDCASE 
	ENDPROC
ENDDEFINE