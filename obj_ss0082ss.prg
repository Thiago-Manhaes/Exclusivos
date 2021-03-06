define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
		
		** 17/05/2017 - Bruno Silva (SS) - De / Para: Preenchimento automatico de caixa, esta��o, marca e colecao.
			
		DO CASE
	
			CASE UPPER(xmetodo) == 'USR_INIT'
				WAIT WINDOW 'OBJ-SS' NOWAIT
				
			CASE UPPER(xmetodo) == 'USR_VALID' AND UPPER(ALLTRIM(xnome_obj)) = 'TV_PRODUTO' AND !F_VAZIO(THISFORM.TV_PRODUTO.VALUE) AND ALLTRIM(thisformset.p_tool_status) == 'I'
				
				lcProduto = ALLTRIM(THISFORM.TV_PRODUTO.VALUE)
				
				TEXT TO lcSql TEXTMERGE noshow
					SELECT COLECAO, REDE_LOJAS FROM PRODUTOS WHERE  PRODUTO  = ?lcProduto 
				ENDTEXT 
				
				IF !f_select(lcSql, 'temp_ss_cur_produto')
					MESSAGEBOX("N�o foi possivel buscar as informa��es do Produto.",0+16,"Aten��o")
					RETURN .f.
				endif
				
				IF RECCOUNT('temp_ss_cur_produto') > 0
					THISFORM.tv_id_caixa.value = '101'
					THISFORM.tv_id_caixa.p_editado_valor = .t.
					thisform.tv_id_caixa.valid(.f.)	
					
					DO CASE
						CASE ALLTRIM(temp_ss_cur_produto.rede_lojas) == '1'
							THISFORM.tv_id_marca.value = '1024699'
							THISFORM.tv_id_marca.p_editado_valor = .t.
							THISFORM.tv_id_marca.valid(.f.)	
							
							DO CASE  
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'OFF'
									THISFORM.tv_id_estacao.value = '3965729'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)	
									
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'VER17'
									THISFORM.tv_id_estacao.value = '3412085'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)	
								
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'VER18'
									THISFORM.tv_id_estacao.value = '4994792'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)	
								
								
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'INV16'
									THISFORM.tv_id_estacao.value = '2653538'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)		
								
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'INV17'
									THISFORM.tv_id_estacao.value = '3965729'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)						

							ENDCASE

						
						CASE ALLTRIM(temp_ss_cur_produto.rede_lojas) == '2'
							THISFORM.tv_id_marca.value = '935349'	
							THISFORM.tv_id_marca.p_editado_valor = .t.
							THISFORM.tv_id_marca.valid(.f.)
							
							DO CASE  
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'VER17'
									THISFORM.tv_id_estacao.value = '3412085'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)	
									
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'VER18'
									THISFORM.tv_id_estacao.value = '4994792'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)	
								
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'AV17'
									THISFORM.tv_id_estacao.value = '3412085'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)	
								
								
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'AV18'
									THISFORM.tv_id_estacao.value = '4994792'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)		
								
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'ADAV17'
									THISFORM.tv_id_estacao.value = '3412085'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)	
								
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'ADAV18'
									THISFORM.tv_id_estacao.value = '4994792'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)
								
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'ADDV17'
									THISFORM.tv_id_estacao.value = '3412085'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)						
						
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'ADDV18'
									THISFORM.tv_id_estacao.value = '4994792'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)
								
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'HS17'
									THISFORM.tv_id_estacao.value = '3412085'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)	
								
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'ETEV17'
									THISFORM.tv_id_estacao.value = '3412085'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)		
								
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'OFFV17'
									THISFORM.tv_id_estacao.value = '3412085'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)			
	

							ENDCASE
						
						CASE ALLTRIM(temp_ss_cur_produto.rede_lojas) == '3'
							THISFORM.tv_id_marca.value = '4712589'	
							THISFORM.tv_id_marca.p_editado_valor = .t.
							THISFORM.tv_id_marca.valid(.f.)		
							
							DO CASE  
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'VER18'
									THISFORM.tv_id_estacao.value = '4994792'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)	
									
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'AB V17'
									THISFORM.tv_id_estacao.value = '3412085'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)	
								
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'AB V18'
									THISFORM.tv_id_estacao.value = '4994792'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)	
								
								
								CASE ALLTRIM(temp_ss_cur_produto.COLECAO) == 'AB I17'
									THISFORM.tv_id_estacao.value = '3965729'
									THISFORM.tv_id_estacao.p_editado_valor = .t.
									THISFORM.tv_id_estacao.valid(.f.)		
									
							ENDCASE

					ENDCASE
					
					THISFORM.tv_id_colecao.value = '127559'
					THISFORM.tv_id_colecao.p_editado_valor = .t.
					thisform.tv_id_colecao.valid(.f.)	
					
				endif
				
						
			OTHERWISE			
				RETURN .T.
			
		ENDCASE
	ENDPROC	
ENDDEFINE
