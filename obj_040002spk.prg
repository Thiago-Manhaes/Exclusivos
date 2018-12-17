define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
		
		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
		DO CASE
			
			case UPPER(xmetodo) == 'USR_INIT' 	
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
					
			CASE UPPER(XMETODO) == 'USR_WHEN'  
				
				xalias=alias()	
										
						
					If upper(xnome_obj) = 'TX_CUSTO_REPOSICAO'
						
						Text To SelConfEnt TextMerge Noshow
						
							SELECT COUNT(*) as QTDE_ENT_NF 
							FROM ESTOQUE_RET1_MAT AS A (NOLOCK)
								    JOIN ESTOQUE_RET_MAT AS B (NOLOCK) 
										ON  A.REQ_MATERIAL = B.REQ_MATERIAL 
										AND A.FILIAL = B.FILIAL
									 JOIN MATERIAIS_CORES AS M (NOLOCK) 
										ON  M.MATERIAL = A.MATERIAL 
										AND A.COR_MATERIAL = M.COR_MATERIAL
								     JOIN ENTRADAS AS C (NOLOCK) 
										ON  C.NOME_CLIFOR = B.NOME_CLIFOR 
										AND C.NF_ENTRADA = B.NF_ENTRADA 
										AND C.SERIE_NF_ENTRADA = B.SERIE_NF_ENTRADA	     
									JOIN (SELECT SUM(QTDE_ESTOQUE) AS QTDE_ESTOQUE,MATERIAL,COR_MATERIAL 
											FROM ESTOQUE_MATERIAIS 
											GROUP BY MATERIAL,COR_MATERIAL 
											HAVING SUM(QTDE_ESTOQUE) > 0 ) D
										ON  M.MATERIAL = D.MATERIAL 
										AND A.COR_MATERIAL = D.COR_MATERIAL	
											JOIN COMPRAS E
											ON A.PEDIDO = E.PEDIDO	
							WHERE A.MATERIAL = '<<V_MATERIAIS_00_CORES.MATERIAL>>' AND A.COR_MATERIAL = '<<V_MATERIAIS_00_CORES.COR_MATERIAL>>'
							  AND TIPO_COMPRA NOT IN  (SELECT * FROM dbo.FXANM_ConsultaVarString(
														(SELECT dbo.FX_ANM_PARAMETRO_USER('ANM_TIPO_COMPRA_MOST'))+','+
														(SELECT dbo.FX_ANM_PARAMETRO_USER('ANM_TIPO_COMPRA_PILOT_AUT')) ) )                           


						Endtext
						
						Sele V_MATERIAIS_00_CORES
						f_select(SelConfEnt,"xConfNfEnt") 
			
						If xConfNfEnt.QTDE_ENT_NF > 0 And V_MATERIAIS_00_CORES.CUSTO_REPOSICAO > 0	
							
							WITH thisformset.lx_FORM1.lx_pageframe1.page3
								.Botao_atualiza.Enabled			= .F.
								.Tx_TAXA_JUROS_CUSTO.Enabled 	= .F.
								.Tx_ICMS_CUSTOS.Enabled			= .F.
								.Cmb_CONDICAO_PGTO.Enabled		= .F.
							EndWith	
				
							RETURN .F.
						Else
							
							WITH thisformset.lx_FORM1.lx_pageframe1.page3
								.Botao_atualiza.Enabled			= .T.
								.Tx_TAXA_JUROS_CUSTO.Enabled 	= .F.
								.Tx_ICMS_CUSTOS.Enabled			= .F.
								.Cmb_CONDICAO_PGTO.Enabled		= .F.
							EndWith	
							
						Endif

					Endif
					** FIM - Julio - 07-03-2014 - Bloqueia alterar preço de materiais com entrada de nota fiscal **
					
				if !f_vazio(xalias)
					sele &xalias
				endif
				
				
				
		otherwise
			return .t.				
		endcase
	endproc
ENDDEFINE
