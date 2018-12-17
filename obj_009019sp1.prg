define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
		
		do case
			case UPPER(xmetodo) == 'USR_INIT' 	
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 		
					
				* 05/01/2014 - Leandro Rocha(SS): Libera a digitação de letras no campo fatura
				thisformset.lx_FORM1.lx_pageframe1.page2.tx_faTURA.InputMask = ''
				thisformset.lx_FORM1.lx_PAGEFRAME1.page1.lx_grid_filha1.col_tx_faTURA.tx_FATURA.InputMask = ''
			otherwise
				return .t.				
		endcase
	endproc
enddefine
