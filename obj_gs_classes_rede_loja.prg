Define Class obj_gs_classes_rede_loja As Custom
	*!* Criar Função e chamar no Obj de entrada *!*

	** Função abaixo criada para executar em todos os metodos da tela **
	Function l_ver_rede_loja_prod String

		Lparam xTransacao, xmetodo, xobjeto ,xnome_obj,xToolStatus
		*!* Aqui escrever o código a ser executado pela função *!*
		Public xProdutoSaida, xMsgProduto, xSaveBefErroClass
			xProdutoSaida = ''
			xMsgProduto = '' 
			xSaveBefErroClass = 0
		
		** Tela Saída de Produto Acabado Por Transferência	
		If xTransacao = 'o_120027' 
			If Upper(xmetodo) == 'USR_SAVE_BEFORE' AND xToolStatus $ 'I,A'		
								
				If Used("VTMP_ESTOQUE_PROD_SAI_RL")
					Use In VTMP_ESTOQUE_PROD_SAI_RL
				Endif
				create cursor VTMP_ESTOQUE_PROD_SAI_RL(PRODUTO C(12))

				If Used("VTMP_DISTINCT_PROD_SAIDA")
					Use In VTMP_DISTINCT_PROD_SAIDA
				Endif
                
                If Used("CurFilialDest")
                	Use In CurFilialDest
                Endif	
                
                If Used("VerPropDS")
                	Use In VerPropDS
                Endif	
                
				Sele v_estoque_prod_sai_00_produtos
				Go Top
				Scan
					xProdutoSaida = v_estoque_prod_sai_00_produtos.produto
					insert into VTMP_ESTOQUE_PROD_SAI_RL(PRODUTO) values (xProdutoSaida)
				EndScan
				select distinct produto from VTMP_ESTOQUE_PROD_SAI_RL into cursor VTMP_DISTINCT_PROD_SAIDA
				 
				TEXT TO xVerPropDS NOSHOW textmerge
					select filial 
					from prop_filiais (nolock) 
					where propriedade='01036' 
					and filial='<<v_estoque_prod_sai_00.filial_destino>>'			
				ENDTEXT 
				f_select(xVerPropDS,"VerPropDS")
				Sele VerPropDS
				 
				If !F_Vazio(VerPropDS.filial)	
					Sele VTMP_DISTINCT_PROD_SAIDA
					Go Top
					Scan
						f_select("select produto, rede_lojas from produtos (nolock) where produto =?vtmp_distinct_prod_saida.produto","CurRedeLJ")
						TEXT TO xFilialDest NOSHOW textmerge
							select valor_propriedade
							from prop_filiais (nolock)
							where propriedade = '01036' -- propriedade rede lojas datasync
							and filial ='<<v_estoque_prod_sai_00.filial_destino>>' -- filial destino
							and valor_propriedade = '<<CurRedeLJ.rede_lojas>>'
						Endtext
						F_select(xFilialDest,"CurFilialDest")

						Sele CurFilialDest
						If f_Vazio(CurFilialDest.valor_propriedade)
							xMsgProduto = xMsgProduto + alltrim(CurRedeLJ.produto) +' , '
						Endif
						
						Sele VTMP_DISTINCT_PROD_SAIDA
					EndScan
					If !F_Vazio(xMsgProduto)
						MESSAGEBOX('Rede Loja do Produto diferente da Filial Destino !'+CHR(13)+CHR(13)+"Produto(s): "+LEFT(xMsgProduto,LEN(xMsgProduto)-2),0+16,"Bloqueia Produto")
						Use In VTMP_ESTOQUE_PROD_SAI_RL
						Use In VTMP_DISTINCT_PROD_SAIDA
						Use In CurFilialDest
						xSaveBefErroClass = 1
						Return .F.
					Endif
				Endif
			Endif
		Endif	
		
		** Tela Mov. Saídas de Produto Acabado nas Lojas Varejo
		If xTransacao = 'o_120010' 
			If Upper(xmetodo) == 'USR_SAVE_BEFORE' AND xToolStatus $ 'I,A'		
								
				If Used("VTMP_ESTOQUE_PROD_SAI_RL")
					Use In VTMP_ESTOQUE_PROD_SAI_RL
				Endif
				create cursor VTMP_ESTOQUE_PROD_SAI_RL(PRODUTO C(12))

				If Used("VTMP_DISTINCT_PROD_SAIDA")
					Use In VTMP_DISTINCT_PROD_SAIDA
				Endif
                
                If Used("CurFilialDest")
                	Use In CurFilialDest
                Endif	
                
                If Used("VerPropDS")
                	Use In VerPropDS
                Endif
                
				Sele v_loja_saidas_00_produtos
				Go Top
				Scan
					xProdutoSaida = v_loja_saidas_00_produtos.produto
					insert into VTMP_ESTOQUE_PROD_SAI_RL(PRODUTO) values (xProdutoSaida)
				EndScan
				select distinct produto from VTMP_ESTOQUE_PROD_SAI_RL into cursor VTMP_DISTINCT_PROD_SAIDA
				

				TEXT TO xVerPropDS NOSHOW textmerge
					select filial 
					from prop_filiais (nolock) 
					where propriedade='01036' 
					and filial='<<v_loja_saidas_00.filial_destino>>'			
				ENDTEXT 
				f_select(xVerPropDS,"VerPropDS")
				Sele VerPropDS
				
				If !F_Vazio(VerPropDS.filial)	
					Sele VTMP_DISTINCT_PROD_SAIDA
					Go Top
					Scan
						f_select("select produto, rede_lojas from produtos (nolock) where produto =?vtmp_distinct_prod_saida.produto","CurRedeLJ")
						TEXT TO xFilialDest NOSHOW textmerge
							select valor_propriedade
							from prop_filiais (nolock)
							where propriedade = '01036' -- propriedade rede lojas datasync
							and filial ='<<v_loja_saidas_00.filial_destino>>' -- filial destino
							and VALOR_PROPRIEDADE = '<<CurRedeLJ.rede_lojas>>'
						Endtext
						F_select(xFilialDest,"CurFilialDest")
						Sele CurFilialDest
						If f_Vazio(CurFilialDest.valor_propriedade)
							xMsgProduto = xMsgProduto + alltrim(CurRedeLJ.produto) +' , '
						Endif
											
						Sele VTMP_DISTINCT_PROD_SAIDA
					EndScan
					
					If !F_Vazio(xMsgProduto)
						MESSAGEBOX('Rede Loja do Produto diferente da Filial Destino !'+CHR(13)+CHR(13)+"Produto(s): "+LEFT(xMsgProduto,LEN(xMsgProduto)-2),0+16,"Bloqueia Produto")
						Use In VTMP_ESTOQUE_PROD_SAI_RL
						Use In VTMP_DISTINCT_PROD_SAIDA
						Use In CurFilialDest
						xSaveBefErroClass = 1
						Return .F.
					Endif
				Endif
			Endif
		Endif	 
		
		** Tela Mov. Entradas de Produto Acabado nas Lojas Varejo
		If xTransacao = 'o_120009' 
			If Upper(xmetodo) == 'USR_SAVE_BEFORE' AND xToolStatus $ 'I,A'		
								
				If Used("VTMP_ESTOQUE_PROD_SAI_RL")
					Use In VTMP_ESTOQUE_PROD_SAI_RL
				Endif
				create cursor VTMP_ESTOQUE_PROD_SAI_RL(PRODUTO C(12))

				If Used("VTMP_DISTINCT_PROD_SAIDA")
					Use In VTMP_DISTINCT_PROD_SAIDA
				Endif
                
                If Used("CurFilialDest")
                	Use In CurFilialDest
                Endif	
                
                If Used("VerPropDS")
                	Use In VerPropDS
                Endif
                
				Sele v_loja_entradas_00_produtos
				Go Top
				Scan
					xProdutoSaida = v_loja_entradas_00_produtos.produto
					insert into VTMP_ESTOQUE_PROD_SAI_RL(PRODUTO) values (xProdutoSaida)
				EndScan
				select distinct produto from VTMP_ESTOQUE_PROD_SAI_RL into cursor VTMP_DISTINCT_PROD_SAIDA
				

				TEXT TO xVerPropDS NOSHOW textmerge
					select filial 
					from prop_filiais (nolock) 
					where propriedade='01036' 
					and filial='<<v_loja_entradas_00.filial>>'			
				ENDTEXT 
				f_select(xVerPropDS,"VerPropDS")
				Sele VerPropDS
				   
				If !F_Vazio(VerPropDS.filial)	
					Sele VTMP_DISTINCT_PROD_SAIDA
					Go Top
					Scan
						f_select("select produto, rede_lojas from produtos (nolock) where produto =?vtmp_distinct_prod_saida.produto","CurRedeLJ")
						TEXT TO xFilialDest NOSHOW textmerge
							select valor_propriedade
							from prop_filiais (nolock)
							where propriedade = '01036' -- propriedade rede lojas datasync
							and filial ='<<v_loja_entradas_00.filial>>' -- filial destino
							and VALOR_PROPRIEDADE = '<<CurRedeLJ.rede_lojas>>'
						Endtext
						F_select(xFilialDest,"CurFilialDest")
						Sele CurFilialDest
						If f_Vazio(CurFilialDest.valor_propriedade)
							xMsgProduto = xMsgProduto + alltrim(CurRedeLJ.produto) +' , '
						Endif
										
						Sele VTMP_DISTINCT_PROD_SAIDA
					EndScan
					
					If !F_Vazio(xMsgProduto)
						MESSAGEBOX('Rede Loja do Produto diferente da Filial Destino !'+CHR(13)+CHR(13)+"Produto(s): "+LEFT(xMsgProduto,LEN(xMsgProduto)-2),0+16,"Bloqueia Produto")
						Use In VTMP_ESTOQUE_PROD_SAI_RL
						Use In VTMP_DISTINCT_PROD_SAIDA
						Use In CurFilialDest
						xSaveBefErroClass = 1
						Return .F.
					Endif
				Endif
			Endif
		Endif

		** Tela Reserva de Produto Acabado Via Código de Barra
		If xTransacao = 'o_150011' 
			If Upper(xmetodo) == 'USR_SAVE_BEFORE' AND xToolStatus $ 'I,A'		
							 	
				If Used("VTMP_ESTOQUE_PROD_SAI_RL")
					Use In VTMP_ESTOQUE_PROD_SAI_RL
				Endif
				create cursor VTMP_ESTOQUE_PROD_SAI_RL(PRODUTO C(12))

				If Used("VTMP_DISTINCT_PROD_SAIDA")
					Use In VTMP_DISTINCT_PROD_SAIDA
				Endif
                
                If Used("CurFilialDest")
                	Use In CurFilialDest
                Endif	
                
                If Used("VerPropDS")
                	Use In VerPropDS
                Endif
                
				Sele v_faturamento_caixas_00_embalados
				Go Top
				Scan
					xProdutoSaida = v_faturamento_caixas_00_embalados.produto
					insert into VTMP_ESTOQUE_PROD_SAI_RL(PRODUTO) values (xProdutoSaida)
				EndScan
				select distinct produto from VTMP_ESTOQUE_PROD_SAI_RL into cursor VTMP_DISTINCT_PROD_SAIDA
				

				TEXT TO xVerPropDS NOSHOW textmerge
					select filial 
					from prop_filiais (nolock) 
					where propriedade='01036' 
					and filial='<<v_faturamento_caixas_00.nome_clifor>>'			
				ENDTEXT 
				f_select(xVerPropDS,"VerPropDS")
				Sele VerPropDS
				   
				If !F_Vazio(VerPropDS.filial)	
					Sele VTMP_DISTINCT_PROD_SAIDA
					Go Top
					Scan
						f_select("select produto, rede_lojas from produtos (nolock) where produto =?vtmp_distinct_prod_saida.produto","CurRedeLJ")
						TEXT TO xFilialDest NOSHOW textmerge
							select valor_propriedade
							from prop_filiais (nolock)
							where propriedade = '01036' -- propriedade rede lojas datasync
							and filial ='<<v_faturamento_caixas_00.nome_clifor>>' -- filial destino
							and VALOR_PROPRIEDADE = '<<CurRedeLJ.rede_lojas>>'
						Endtext
						F_select(xFilialDest,"CurFilialDest")
						Sele CurFilialDest
						If f_Vazio(CurFilialDest.valor_propriedade)
							xMsgProduto = xMsgProduto + alltrim(CurRedeLJ.produto) +' , '
						Endif
											
						Sele VTMP_DISTINCT_PROD_SAIDA
					EndScan
					
					If !F_Vazio(xMsgProduto)
						MESSAGEBOX('Rede Loja do Produto diferente da Filial Destino !'+CHR(13)+CHR(13)+"Produto(s): "+LEFT(xMsgProduto,LEN(xMsgProduto)-2),0+16,"Bloqueia Produto")
						Use In VTMP_ESTOQUE_PROD_SAI_RL
						Use In VTMP_DISTINCT_PROD_SAIDA
						Use In CurFilialDest
						xSaveBefErroClass = 1
						Return .F.
					Endif
				Endif
			Endif
		Endif			
		
		** Tela Faturamento de Produto Acabado
		If xTransacao = 'o_100101' 
			If Upper(xmetodo) == 'USR_SAVE_BEFORE' AND xToolStatus $ 'I,A'		
			 	  	
				If Used("VTMP_ESTOQUE_PROD_SAI_RL")
					Use In VTMP_ESTOQUE_PROD_SAI_RL
				Endif
				create cursor VTMP_ESTOQUE_PROD_SAI_RL(PRODUTO C(12))

				If Used("VTMP_DISTINCT_PROD_SAIDA")
					Use In VTMP_DISTINCT_PROD_SAIDA
				Endif
                
                If Used("CurFilialDest")
                	Use In CurFilialDest
                Endif	
                
                If Used("VerPropDS")
                	Use In VerPropDS
                Endif
                
				Sele v_faturamento_05_prod
				Go Top
				Scan
					xProdutoSaida = v_faturamento_05_prod.produto
					insert into VTMP_ESTOQUE_PROD_SAI_RL(PRODUTO) values (xProdutoSaida)
				EndScan
				select distinct produto from VTMP_ESTOQUE_PROD_SAI_RL into cursor VTMP_DISTINCT_PROD_SAIDA
				

				TEXT TO xVerPropDS NOSHOW textmerge
					select filial 
					from prop_filiais (nolock) 
					where propriedade='01036' 
					and filial='<<v_faturamento_05.nome_clifor>>'			
				ENDTEXT 
				f_select(xVerPropDS,"VerPropDS")
				Sele VerPropDS
				   
				If !F_Vazio(VerPropDS.filial)	
					Sele VTMP_DISTINCT_PROD_SAIDA
					Go Top
					Scan
						f_select("select produto, rede_lojas from produtos (nolock) where produto =?vtmp_distinct_prod_saida.produto","CurRedeLJ")
						TEXT TO xFilialDest NOSHOW textmerge
							select valor_propriedade
							from prop_filiais (nolock)
							where propriedade = '01036' -- propriedade rede lojas datasync
							and filial ='<<v_faturamento_05.nome_clifor>>' -- filial destino
							and VALOR_PROPRIEDADE = '<<CurRedeLJ.rede_lojas>>'
						Endtext
						F_select(xFilialDest,"CurFilialDest")
						Sele CurFilialDest
						If f_Vazio(CurFilialDest.valor_propriedade)
							xMsgProduto = xMsgProduto + alltrim(CurRedeLJ.produto) +' , '
						Endif
											
						Sele VTMP_DISTINCT_PROD_SAIDA
					EndScan
					
					If !F_Vazio(xMsgProduto)
						MESSAGEBOX('Rede Loja do Produto diferente da Filial Destino !'+CHR(13)+CHR(13)+"Produto(s): "+LEFT(xMsgProduto,LEN(xMsgProduto)-2),0+16,"Bloqueia Produto")
						Use In VTMP_ESTOQUE_PROD_SAI_RL
						Use In VTMP_DISTINCT_PROD_SAIDA
						Use In CurFilialDest
						xSaveBefErroClass = 1
						Return .F.
					Endif
				Endif
			Endif
		Endif	
	
	Endfunc
	** Fim da Função ***************************************************
	
	  
	** Fim da classe **
Enddefine
