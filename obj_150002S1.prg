define class obj_entrada as custom
*- Nome do metodo/função que os objetos linx vão chamar.
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
		do case
			case UPPER(xmetodo) == 'USR_INIT'
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
				
				* 12/08/2016 - Leandro Rocha (SS): Desativa Log para agilizar a tela
				thisformset.P_AUDitoria = ''

			otherwise
				return .t.
		endcase
	endproc
enddefine
