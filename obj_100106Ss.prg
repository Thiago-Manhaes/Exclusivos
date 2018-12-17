define class obj_entrada as custom
*- Nome do metodo/função que os objetos linx vão chamar.
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
		do case
			case UPPER(xmetodo) == 'USR_SAVE_INIT'
				WAIT WINDOW 'OBJ' NOWAIT
				
			case UPPER(xmetodo) == 'USR_SAVE_BEFORE'
				* 18/01/2017 - Leandro Rocha (SS): quando seleciona a devolução todos os itens_fiscais são deletados e gerados novamente, com isso o item fiscal da view v_faturamento_05_item fica diferente do item fiscal da view v_faturamento_05_ent_dev_mp
				select v_faturamento_05_item
				scan
					replace v_faturamento_05_ent_dev_mp.item_impressao with v_faturamento_05_item.item_impressao for v_faturamento_05_ent_dev_mp.codigo_item = v_faturamento_05_item.codigo_item in v_faturamento_05_ent_dev_mp
				endscan
			otherwise
				return .t.
		endcase
	endproc
enddefine
