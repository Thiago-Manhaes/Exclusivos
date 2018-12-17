define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
		
		do case
			case UPPER(xmetodo) == 'USR_INIT' 				
				* 05/01/2014 - Leandro Rocha(SS): Libera a digitação de letras no campo fatura
				thisformset.lx_FORM1.lx_pageframe1.page2.tx_faTURA.InputMask = ''
				thisformset.lx_FORM1.lx_PAGEFRAME1.page1.lx_grid_filha1.col_tx_faTURA.tx_FATURA.InputMask = ''
			otherwise
				return .t.				
		endcase
	endproc
enddefine
