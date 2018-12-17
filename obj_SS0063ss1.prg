define class obj_entrada as custom
*- Nome do metodo/função que os objetos linx vão chamar.
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
		do case
			case UPPER(xmetodo) == 'USR_INIT'
				WAIT WINDOW 'OBJ' nowait
				
				* 26/02/2018 - Desativa abas não usadas no Grupo Soma
				IF TYPE('thisformset.lx_FORM1.lx_pageframe.PAGE_PROPS') == "O"
					thisformset.lx_FORM1.lx_pageframe.PAGE_PROPS.PageOrder = 2
				ENDIF
				thisformset.lx_FORM1.lx_pageframe.page2.Caption = ""
				thisformset.lx_FORM1.lx_pageframe.page3.Caption = ""
				thisformset.lx_FORM1.lx_pageframe.page2.Enabled = .f.
				thisformset.lx_FORM1.lx_pageframe.page3.Enabled = .f.
				
				* 07/12/2018 - Leandro Rocha (SS): Alterado porque para a a FYI a árvore da categoria OFF deixou de chamar SALE e começou a chamar OFF. Solicitado por Mariana 
				* 05/11/2018 - Bruno Silva (SS): Alterado para inserir de/para de cor com as informações de Poduto Cores.
				* 24/09/2018 - Leandro Rocha (SS): Alterado para mudar a regra de mudança automatica de categorias para a Foxton.
				* 17/08/2018 - Leandro Rocha (SS): Alterado para mudar a regra de mudança automatica de categorias para a Farm. Thomas mudou a [arvore de categorias da Farm
				* 13/06/2018 - Leandro Rocha (SS): Cadastra Gênero na tabela do sintalk. Ailsom pediu para cadastrar e não usar direto do cadastro de produtos.
				* 05/07/2017 - Leandro Rocha (SS): Atualiza peso com base no cadastro do produto. Atualiza apenas se não tiver no cadastro do e-commerce.
				f_wait('Atualizando medidas....		')
				
				* Atualiza dados padrões
				TEXT TO strSql TEXTMERGE NOSHOW
					/* Atualiza peso padrão. Solicitado por Ailsom e Arthur */
					UPDATE A	
						SET A.PESO = CONVERT(NUMERIC(15, 2), (ISNULL(B.PESO, 0) * 1000))
						FROM SS_SINTALK_PRODUTOS_ECOMMERCE A
						INNER JOIN PRODUTOS B
							ON B.PRODUTO = A.PRODUTO 
						WHERE ISNULL(A.PESO, 0) <> (ISNULL(B.PESO, 0) * 1000) 
							AND ISNULL(B.PESO, 0) > 0 
							AND CONVERT(NUMERIC(15, 2), ISNULL(A.PESO, 0)) = 0

					/* Atualiza Altura, Largura e Comprimento padrão. Solicitado por Ailsom e Arthur */
					UPDATE A	
						SET A.ALTURA = CASE WHEN ISNULL(A.ALTURA, 0) <> 0 THEN A.ALTURA ELSE 1 END,
							A.LARGURA = CASE WHEN ISNULL(A.LARGURA, 0) <> 0 THEN A.LARGURA ELSE 1 END,
							A.COMPRIMENTO = CASE WHEN ISNULL(A.COMPRIMENTO, 0) <> 0 THEN A.COMPRIMENTO ELSE 1 END
						FROM SS_SINTALK_PRODUTOS_ECOMMERCE A
						WHERE ISNULL(A.ALTURA, 0) = 0 OR ISNULL(A.LARGURA, 0) = 0 OR ISNULL(A.COMPRIMENTO, 0) = 0
					
					/* Insere de para de cores com as mesmas informações do Linx*/
					INSERT INTO SS_SINTALK_PRODUTO_CORES_ECOMMERCE  (PRODUTO,COR_PRODUTO,DESCRICAO_ECOMMERCE,ID_CATEGORIA,ID_CATEGORIA_SIMILAR,ID_APLICACAO,RGB_HEX,DATA_LANCAMENTO)
						SELECT PRODUTO_CORES.PRODUTO, PRODUTO_CORES.COR_PRODUTO, DESCRICAO_ECOMMERCE = PRODUTO_CORES.DESC_COR_PRODUTO, ID_CATEGORIA = NULL, ID_CATEGORIA_SIMILAR = NULL, ID_APLICACAO = SS_SINTALK_PRODUTOS_ECOMMERCE.ID_APLICACAO , RGB_HEX = NULL, DATA_LANCAMENTO = NULL
						FROM PRODUTO_CORES  
						INNER JOIN SS_SINTALK_PRODUTOS_ECOMMERCE
							ON SS_SINTALK_PRODUTOS_ECOMMERCE.PRODUTO = PRODUTO_CORES.PRODUTO
						LEFT JOIN  SS_SINTALK_PRODUTO_CORES_ECOMMERCE
							ON SS_SINTALK_PRODUTO_CORES_ECOMMERCE.ID_APLICACAO = SS_SINTALK_PRODUTOS_ECOMMERCE.ID_APLICACAO
							AND SS_SINTALK_PRODUTO_CORES_ECOMMERCE.PRODUTO = PRODUTO_CORES.PRODUTO
							AND SS_SINTALK_PRODUTO_CORES_ECOMMERCE.COR_PRODUTO = PRODUTO_CORES.COR_PRODUTO
						WHERE SS_SINTALK_PRODUTO_CORES_ECOMMERCE. PRODUTO IS NULL

					
					/* Atualiza categoria apenas rede de lojas FoxTon e produtos ainda não categorizados. Solicitado por Arthur */	
					UPDATE SS_SINTALK_PRODUTOS_ECOMMERCE 
						SET SS_SINTALK_PRODUTOS_ECOMMERCE.ID_CATEGORIA = SS_SINTALK_CATEGORIZACAO_PRODUTOS_ECOMMERCE.Id
						FROM SS_SINTALK_PRODUTOS_ECOMMERCE 
						INNER JOIN PRODUTOS 
							ON SS_SINTALK_PRODUTOS_ECOMMERCE.PRODUTO = PRODUTOS.PRODUTO
						INNER JOIN SS_SINTALK_CATEGORIZACAO_PRODUTOS_ECOMMERCE
							ON SS_SINTALK_CATEGORIZACAO_PRODUTOS_ECOMMERCE.ID_APLICACAO  = SS_SINTALK_PRODUTOS_ECOMMERCE.ID_APLICACAO 
								AND SS_SINTALK_CATEGORIZACAO_PRODUTOS_ECOMMERCE.idSite = CASE LTRIM(RTRIM(PRODUTOS.GRUPO_PRODUTO))
																						WHEN 'ACESSORIOS' THEN 37
																						WHEN 'BERMUDA' THEN 5
																						WHEN 'BERMUDA DE PRAIA' THEN 4
																						WHEN 'CALÇADOS' THEN 42
																						WHEN 'CALÇAS' THEN 6
																						WHEN 'CAMISA MC' THEN 3
																						WHEN 'CAMISA ML' THEN 3
																						WHEN 'CASACO' THEN 8
																						WHEN 'OVERTOP' THEN 8
																						WHEN 'POLO' THEN 45
																						WHEN 'REGATA' THEN 2
																						WHEN 'SHORT' THEN 4
																						WHEN 'T-SHIRT' THEN 2
																						ELSE 1
																					END

						WHERE SS_SINTALK_PRODUTOS_ECOMMERCE.ID_CATEGORIA IS NULL
							AND ISNULL(SS_SINTALK_PRODUTOS_ECOMMERCE.PESO, 0) > 0 
							AND PRODUTOS.REDE_LOJAS = 7
							AND SS_SINTALK_PRODUTOS_ECOMMERCE.ID_APLICACAO = 8 
							
						
				ENDTEXT 
				
				IF !F_EXECUTE(strSql)
					MESSAGEBOX('Erro ao atualizar medidas, consulte novamente.', 16 + 0, 'ATENÇÃO')
					RETURN .F.
				ENDIF
				
				f_wait("Inserindo Gênero dos produtos...")
				TEXT TO strSql TEXTMERGE NOSHOW
					INSERT INTO PROP_SS_SINTALK_PRODUTOS_ECOMMERCE (PROPRIEDADE, ID_APLICACAO, PRODUTO, ITEM_PROPRIEDADE, VALOR_PROPRIEDADE, DATA_PARA_TRANSFERENCIA)
						SELECT  PROPRIEDADE = '00616', 
								A.ID_APLICACAO, 
								A.PRODUTO, 
								ITEM_PROPRIEDADE = 1, 
								VALOR_PROPRIEDADE = CASE B.SEXO_TIPO 
														WHEN 2 THEN 'MASCULINO'
														WHEN 3 THEN 'FEMININO'
														WHEN 4 THEN 'UNISSEX'
													END,
								DATA_PARA_TRANSFERENCIA = GETDATE()
							FROM SS_SINTALK_PRODUTOS_ECOMMERCE A (nolock)
							INNER JOIN PRODUTOS B (nolock)
								ON B.PRODUTO = A.PRODUTO 
							LEFT JOIN PROP_SS_SINTALK_PRODUTOS_ECOMMERCE C (nolock)
								ON C.ID_APLICACAO = A.ID_APLICACAO AND C.PROPRIEDADE = '00616' AND C.PRODUTO = A.PRODUTO AND C.ITEM_PROPRIEDADE = 1
							WHERE C.PRODUTO IS NULL
								AND B.SEXO_TIPO IN (2, 3, 4)
				ENDTEXT 
				
				IF !F_EXECUTE(strSql)
					MESSAGEBOX('Erro ao inserir gênero dos produtos, consulte novamente.', 16 + 0, 'ATENÇÃO')
					RETURN .F.
				ENDIF
				
				* 24/04/208 - Leandro Rocha (SS): Atualia categoria dos produtos para OFF ou NÃO OFF
				f_wait("Atualizando Categoria dos produtos...")
				
				* Preciso alterar essa propriedade para conseguir executar comando via linkedServer
				m.sqlcommand.EnableAutomaticSQLSets=.F.
				
				TEXT TO strSql TEXTMERGE NOSHOW
					IF OBJECT_ID('TEMPDB..#CONFIG_APLICACAO ') IS NOT NULL 
						DROP TABLE #CONFIG_APLICACAO 

					SELECT * 
						INTO #CONFIG_APLICACAO 
						FROM [192.168.9.205].SinTalk.dbo.CONFIG_APLICACAO 
						WHERE NOME_CONFIG = 'ColecaoAtual'
				ENDTEXT 
				
				IF !F_EXECUTE(strSql)
					m.sqlcommand.EnableAutomaticSQLSets=.T.
					MESSAGEBOX('Erro ao atualizar categoria dos produtos, consulte novamente.', 16 + 0, 'ATENÇÃO')
					RETURN .F.
				ENDIF

				m.sqlcommand.EnableAutomaticSQLSets=.T.
				
				TEXT TO strSql TEXTMERGE NOSHOW
					IF OBJECT_ID('TEMPDB..#CATEGORIA_ON_OFF') IS NOT NULL 
						DROP TABLE #CATEGORIA_ON_OFF

					SELECT	ID_APLICACAO = CATEGORIAS_NAO_OFF.ID_APLICACAO, 
							ID_NAO_OFF = CAST(CATEGORIAS_NAO_OFF.ID as varchar(30)),
							NOME_NAO_OFF = CATEGORIAS_NAO_OFF.ARVORE,
							ID_OFF = CAST(CATEGORIAS_OFF.ID as varchar(30)),
							NOME_OFF = CATEGORIAS_OFF.ARVORE
						INTO #CATEGORIA_ON_OFF
						FROM (SELECT	A.ID_APLICACAO, 
										A.ID, ARVORE =	CASE WHEN A.ID_APLICACAO = 24 THEN REPLACE(ARVORE.ARVORE_CATEGORIA, 'MODA FEMININA', '') 
															WHEN  A.ID_APLICACAO = 26 THEN REPLACE(ARVORE.ARVORE_CATEGORIA, '', '') 
															WHEN  A.ID_APLICACAO = 30 THEN REPLACE(ARVORE.ARVORE_CATEGORIA, 'MODA MASCULINA', '') 
															ELSE A.NOME 
														END
									FROM SS_SINTALK_CATEGORIZACAO_PRODUTOS_ECOMMERCE A (NOLOCK)
									INNER JOIN W_SS_SINTALK_ARVORE_CATEGORIAS AS ARVORE (NOLOCK)
										ON ARVORE.ID_APLICACAO = A.ID_APLICACAO AND ARVORE.ID_CATEGORIA = A.Id 
									INNER JOIN SS_SINTALK_CATEGORIZACAO_PRODUTOS_ECOMMERCE B (NOLOCK)
										ON B.ID_APLICACAO = A.ID_APLICACAO AND B.ID = dbo.FUNC_SS_CATEGORIA_PRINCIPAL(A.ID, A.ID_APLICACAO)
										AND (
												(A.ID_APLICACAO = 24 AND B.NOME = 'MODA FEMININA') 
												OR 
												(A.ID_APLICACAO in (22, 23, 27, 27, 29) AND B.NOME <> 'SALE')
												OR
												(A.ID_APLICACAO = 25 AND B.NOME <> 'OFF')
												OR
												(A.ID_APLICACAO in (26, 30) AND B.NOME <> 'BAZAR')
											)
							) AS CATEGORIAS_NAO_OFF
						INNER JOIN (SELECT A.ID_APLICACAO, 
											A.ID, 
											ARVORE =	CASE WHEN A.ID_APLICACAO = 24 THEN REPLACE(ARVORE.ARVORE_CATEGORIA, 'BAZAR FARM', '') 
															WHEN A.ID_APLICACAO = 26 THEN REPLACE(ARVORE.ARVORE_CATEGORIA, 'BAZAR | ', '') 
															WHEN A.ID_APLICACAO = 30 THEN REPLACE(ARVORE.ARVORE_CATEGORIA, 'BAZAR', '') 
															ELSE A.NOME 
														END
										FROM SS_SINTALK_CATEGORIZACAO_PRODUTOS_ECOMMERCE A (NOLOCK)
										INNER JOIN W_SS_SINTALK_ARVORE_CATEGORIAS AS ARVORE (NOLOCK)
											ON ARVORE.ID_APLICACAO = A.ID_APLICACAO AND ARVORE.ID_CATEGORIA = A.Id 
										INNER JOIN SS_SINTALK_CATEGORIZACAO_PRODUTOS_ECOMMERCE B (NOLOCK)
											ON B.ID_APLICACAO = A.ID_APLICACAO AND B.ID = dbo.FUNC_SS_CATEGORIA_PRINCIPAL(A.ID, A.ID_APLICACAO)
											AND (
													(A.ID_APLICACAO = 24 AND B.NOME = 'BAZAR FARM') 
													OR 
													(A.ID_APLICACAO in (22, 23, 27, 27, 29) AND B.NOME = 'SALE')
													OR
													(A.ID_APLICACAO = 25 AND B.NOME = 'OFF')
													OR
													(A.ID_APLICACAO in (26, 30) AND B.NOME = 'BAZAR')
												)
									) AS CATEGORIAS_OFF
							ON CATEGORIAS_OFF.ID_APLICACAO = CATEGORIAS_NAO_OFF.ID_APLICACAO AND CATEGORIAS_OFF.ARVORE = CATEGORIAS_NAO_OFF.ARVORE
						INNER JOIN SS_SINTALK_CONTROLE (NOLOCK)
								ON SS_SINTALK_CONTROLE.ID_APLICACAO = CATEGORIAS_NAO_OFF.ID_APLICACAO AND SS_SINTALK_CONTROLE.PROCESSO = 'SINTALK.NEGOCIO.VTEX.PROCESSOS - CATEGORIA' AND SS_SINTALK_CONTROLE.CHAVE = LTRIM(RTRIM(CONVERT(VARCHAR(10), CATEGORIAS_OFF.ID)))
						WHERE CATEGORIAS_NAO_OFF.ID_APLICACAO NOT IN ('8', '21')

					/*	Indica se o produto é da coleção atual.  Se estiver definido na propriedade do produto, usa o valor dela, caso contrário verifica com base na coleção do produto e a colução da configuração do SinTalk
						Se for coleção atual atualiza a categoria para ON, se não for da coleção atual atualiza para a categoria equivalente (mesmo nome) poré do departamento SALE */
					update SS_SINTALK_PRODUTOS_ECOMMERCE
						SET SS_SINTALK_PRODUTOS_ECOMMERCE.ID_CATEGORIA =	CASE WHEN REPLACE(CASE WHEN ISNULL(PROP_COLECAO_ATUAL.VALOR_PROPRIEDADE, '') <> '' 
																										THEN PROP_COLECAO_ATUAL.VALOR_PROPRIEDADE
																										ELSE CASE WHEN CHARINDEX(';' + LTRIM(RTRIM(ISNULL(PRODUTOS.COLECAO, 'ABC'))) + ';', REPLACE(REPLACE(';' + LTRIM(RTRIM(ISNULL(COLECAO_ATUAL.VALOR_CONFIG, 'AABBCC') COLLATE SQL_Latin1_General_CP1_CI_AS)) + ';', ' ;', ';'), '; ', ';')) > 0 THEN 'SIM' ELSE 'NÃO' END
																									END, 'NAO', 'NÃO') = 'NÃO' AND CATEGORIA_ON_OFF.ID_OFF IS NOT NULL
																				THEN CATEGORIA_ON_OFF.ID_OFF
																				ELSE CATEGORIA_ON_OFF.ID_NAO_OFF
																			END,
							SS_SINTALK_PRODUTOS_ECOMMERCE.ID_CATEGORIA_SIMILAR =	CASE WHEN REPLACE(CASE WHEN ISNULL(PROP_COLECAO_ATUAL.VALOR_PROPRIEDADE, '') <> '' 
																												THEN PROP_COLECAO_ATUAL.VALOR_PROPRIEDADE
																												ELSE CASE WHEN CHARINDEX(';' + LTRIM(RTRIM(ISNULL(PRODUTOS.COLECAO, 'ABC'))) + ';', REPLACE(REPLACE(';' + LTRIM(RTRIM(ISNULL(COLECAO_ATUAL.VALOR_CONFIG, 'AABBCC') COLLATE SQL_Latin1_General_CP1_CI_AS)) + ';', ' ;', ';'), '; ', ';')) > 0 THEN 'SIM' ELSE 'NÃO' END
																											END, 'NAO', 'NÃO') = 'NÃO' AND CATEGORIA_SIMILAR_ON_OFF.ID_OFF IS NOT NULL
																						THEN CATEGORIA_SIMILAR_ON_OFF.ID_OFF
																						ELSE CATEGORIA_SIMILAR_ON_OFF.ID_NAO_OFF							
																					END
							FROM SS_SINTALK_PRODUTOS_ECOMMERCE (NOLOCK)
							INNER JOIN PRODUTOS (NOLOCK)
								ON PRODUTOS.PRODUTO = SS_SINTALK_PRODUTOS_ECOMMERCE.PRODUTO

							/*	CATEGORIAS ON E OFF */
							INNER JOIN #CATEGORIA_ON_OFF AS CATEGORIA_ON_OFF
								ON CATEGORIA_ON_OFF.ID_APLICACAO = SS_SINTALK_PRODUTOS_ECOMMERCE.ID_APLICACAO AND (CATEGORIA_ON_OFF.ID_NAO_OFF = SS_SINTALK_PRODUTOS_ECOMMERCE.ID_CATEGORIA OR CATEGORIA_ON_OFF.ID_OFF = SS_SINTALK_PRODUTOS_ECOMMERCE.ID_CATEGORIA)
								
							/*	CATEGORIAS ON E OFF */
							LEFT JOIN #CATEGORIA_ON_OFF AS CATEGORIA_SIMILAR_ON_OFF
								ON CATEGORIA_SIMILAR_ON_OFF.ID_APLICACAO = SS_SINTALK_PRODUTOS_ECOMMERCE.ID_APLICACAO AND (CATEGORIA_SIMILAR_ON_OFF.ID_NAO_OFF = SS_SINTALK_PRODUTOS_ECOMMERCE.ID_CATEGORIA_SIMILAR	OR CATEGORIA_SIMILAR_ON_OFF.ID_OFF = SS_SINTALK_PRODUTOS_ECOMMERCE.ID_CATEGORIA_SIMILAR)
								
							/*	COLEÇÃO ATUAL */
							LEFT JOIN #CONFIG_APLICACAO AS COLECAO_ATUAL
								ON COLECAO_ATUAL.ID_APLICACAO = SS_SINTALK_PRODUTOS_ECOMMERCE.ID_APLICACAO AND COLECAO_ATUAL.NOME_CONFIG = 'ColecaoAtual'
							LEFT JOIN PROP_SS_SINTALK_PRODUTOS_ECOMMERCE (NOLOCK) AS PROP_COLECAO_ATUAL
								ON PROP_COLECAO_ATUAL.PROPRIEDADE = '00560' AND PROP_COLECAO_ATUAL.ID_APLICACAO = SS_SINTALK_PRODUTOS_ECOMMERCE.ID_APLICACAO AND PROP_COLECAO_ATUAL.PRODUTO = PRODUTOS.PRODUTO AND PROP_COLECAO_ATUAL.ITEM_PROPRIEDADE = '1'

							WHERE ISNULL(SS_SINTALK_PRODUTOS_ECOMMERCE.ID_CATEGORIA, '') <> ''
								AND ISNULL(CATEGORIA_ON_OFF.ID_NAO_OFF, '') <> ''
								AND ISNULL(CATEGORIA_ON_OFF.ID_OFF, '') <> ''
								AND (
										(SS_SINTALK_PRODUTOS_ECOMMERCE.ID_CATEGORIA <> (CASE WHEN REPLACE(CASE WHEN ISNULL(PROP_COLECAO_ATUAL.VALOR_PROPRIEDADE, '') <> '' 
																													THEN PROP_COLECAO_ATUAL.VALOR_PROPRIEDADE
																													ELSE CASE WHEN CHARINDEX(';' + LTRIM(RTRIM(ISNULL(PRODUTOS.COLECAO, 'ABC'))) + ';', REPLACE(REPLACE(';' + LTRIM(RTRIM(ISNULL(COLECAO_ATUAL.VALOR_CONFIG, 'AABBCC') COLLATE SQL_Latin1_General_CP1_CI_AS)) + ';', ' ;', ';'), '; ', ';')) > 0 THEN 'SIM' ELSE 'NÃO' END
																												END, 'NAO', 'NÃO') = 'NÃO' AND CATEGORIA_ON_OFF.ID_OFF IS NOT NULL
																							THEN CATEGORIA_ON_OFF.ID_OFF
																							ELSE CATEGORIA_ON_OFF.ID_NAO_OFF
																						END)
										)
										OR 
										(ISNULL(SS_SINTALK_PRODUTOS_ECOMMERCE.ID_CATEGORIA_SIMILAR, '') <> ISNULL(CASE WHEN REPLACE(CASE WHEN ISNULL(PROP_COLECAO_ATUAL.VALOR_PROPRIEDADE, '') <> '' 
																																				THEN PROP_COLECAO_ATUAL.VALOR_PROPRIEDADE
																																				ELSE CASE WHEN CHARINDEX(';' + LTRIM(RTRIM(ISNULL(PRODUTOS.COLECAO, 'ABC'))) + ';', REPLACE(REPLACE(';' + LTRIM(RTRIM(ISNULL(COLECAO_ATUAL.VALOR_CONFIG, 'AABBCC') COLLATE SQL_Latin1_General_CP1_CI_AS)) + ';', ' ;', ';'), '; ', ';')) > 0 THEN 'SIM' ELSE 'NÃO' END
																																			END, 'NAO', 'NÃO') = 'NÃO' AND CATEGORIA_SIMILAR_ON_OFF.ID_OFF IS NOT NULL
																														THEN CATEGORIA_SIMILAR_ON_OFF.ID_OFF
																														ELSE CATEGORIA_SIMILAR_ON_OFF.ID_NAO_OFF							
																													END, '')
										)
									)
				ENDTEXT 
				
				IF !F_EXECUTE(strSql)
					MESSAGEBOX('Erro ao atualizar categoria dos produtos, consulte novamente.', 16 + 0, 'ATENÇÃO')
					RETURN .F.
				ENDIF
				
				* Cadatra o produto na categoria similar com o mesmo nome da propriedade lookBook. Categoria que está na árvore Looks (Produtos Farm). Solicitado pelo Thomas (Vtex)
				f_wait("Atualizando Categoria Similar Produtos LookBook...")
				TEXT TO strSql TEXTMERGE NOSHOW
					UPDATE C
						SET C.ID_CATEGORIA_SIMILAR = B.ID_CATEGORIA
						FROM PROP_SS_SINTALK_PRODUTOS_ECOMMERCE A
						INNER JOIN W_SS_SINTALK_ARVORE_CATEGORIAS B
							ON B.ID_APLICACAO = A.ID_APLICACAO AND B.ARVORE_CATEGORIA = 'LOOKS | ' + LTRIM(RTRIM(A.VALOR_PROPRIEDADE))
						INNER JOIN SS_SINTALK_PRODUTOS_ECOMMERCE C
							ON C.ID_APLICACAO = A.ID_APLICACAO AND C.PRODUTO = A.PRODUTO
						WHERE A.PROPRIEDADE = '00633' 
							AND A.ID_APLICACAO = 24
							AND C.ID_CATEGORIA IS NOT NULL
							AND ISNULL(C.ID_CATEGORIA_SIMILAR, '0') <> B.ID_CATEGORIA
				ENDTEXT 
				
				IF !F_EXECUTE(strSql)
					MESSAGEBOX('Erro ao atualizar categoria similar dos produtos LookBook.', 16 + 0, 'ATENÇÃO')
					RETURN .F.
				ENDIF				
				
				* 04/05/2018 - Leandro Rocha (SS): Insere serviço de embalagem de presente para todos os produtos. Insere caso tenha uma serviço e valor de serviço com o nome "EMBALAGEM PARA PRESENTE". Solicitado pelo Ailsom.
				TEXT TO strSql TEXTMERGE NOSHOW
					INSERT INTO SS_SINTALK_PRODUTOS_SERVICOS (ID, PRODUTO, NOME, ID_TIPO_SERVICO, ID_VALOR_SERVICO, ATIVO, TEXTO, ID_APLICACAO)
						SELECT	ID = (SELECT MAX(ID) FROM SS_SINTALK_PRODUTOS_SERVICOS (NOLOCK)) + ROW_NUMBER() OVER(ORDER BY A.PRODUTO ASC),
								PRODUTO = A.PRODUTO,
								NOME = B.NOME, 
								ID_TIPO_SERVICO = B.ID, 
								ID_VALOR_SERVICO = C.ID, 
								ATIVO = 1, 
								TEXTO = B.NOME, 
								ID_APLICACAO = A.ID_APLICACAO
							FROM SS_SINTALK_PRODUTOS_ECOMMERCE A (NOLOCK)
							INNER JOIN SS_SINTALK_TIPOS_SERVICOS B (NOLOCK)
								ON B.ID_APLICACAO = A.ID_APLICACAO AND B.NOME = 'Embalagem para presente' AND B.ATIVO = 1
							INNER JOIN SS_SINTALK_VALORES_SERVICOS C (NOLOCK)
								ON C.ID_APLICACAO = A.ID_APLICACAO AND C.ID_TIPO_SERVICO = B.ID AND C.NOME = 'Embalagem para presente'
							LEFT JOIN SS_SINTALK_PRODUTOS_SERVICOS D (NOLOCK)
								ON D.ID_APLICACAO = A.ID_APLICACAO AND D.PRODUTO = A.PRODUTO AND D.NOME = B.NOME
							WHERE A.ID_CATEGORIA IS NOT NULL
								AND D.ID IS NULL
							GROUP BY A.PRODUTO,
								B.NOME, 
								B.ID, 
								C.ID, 
								B.NOME, 
								A.ID_APLICACAO
				ENDTEXT 
				
				IF !F_EXECUTE(strSql)
					MESSAGEBOX('Erro ao inserir serviço de embalagem de presente para os produtos, consulte novamente.', 16 + 0, 'ATENÇÃO')
					RETURN .F.
				ENDIF
				
				f_wait()

				SELECT cur_produtos_ecommerce

			case UPPER(xmetodo) == 'USR_SEARCH_BEFORE'
				* 26/02/2018 - Verifica se o site foi escolhido, não deixa pesquisar sem informar o site, assim tenho como filtar o produto pela rede de lojas
				IF NVL(cur_produtos_ecommerce.id_aplicacao, 0) = 0
					MESSAGEBOX('Selecione uma Aplicação / Site antes de pesquisar.', 16, 'ATENÇÃO')
					RETURN .F.
				ENDIF
			
				strRelojas = ''
				DO CASE 
					* Off Premium
					CASE cur_produtos_ecommerce.id_aplicacao = 21
						strRelojas = ''

					* Foxton
					CASE cur_produtos_ecommerce.id_aplicacao = 8
						strRelojas = "'7'"
					
					* Foxton (Novo Site)
					CASE cur_produtos_ecommerce.id_aplicacao = 30
						strRelojas = "'7'"
					
					* A.Brand
					CASE cur_produtos_ecommerce.id_aplicacao = 22
						strRelojas = "'3'"
					
					* Animale
					CASE cur_produtos_ecommerce.id_aplicacao = 23
						strRelojas = "'1'"
						
					* Farm
					CASE cur_produtos_ecommerce.id_aplicacao = 24
						strRelojas = "'2'"
						
					* F.Y.I
					CASE cur_produtos_ecommerce.id_aplicacao = 25
						strRelojas = "'4'"
						
					* Fabula
					CASE cur_produtos_ecommerce.id_aplicacao = 26
						strRelojas = "'5'"
						
					* Cris Barros
					CASE cur_produtos_ecommerce.id_aplicacao = 27
						strRelojas = "'9'"
												
					OTHERWISE 
						strRelojas = ''
				ENDCASE 				
			
				thisformset.p_pai_filtro = ""
				IF !EMPTY(NVL(strRelojas, ''))
					thisformset.p_pai_filtro = thisformset.p_pai_filtro + iif(EMPTY(NVL(thisformset.p_pai_filtro, '')), '', ' and ') + " (produtos.rede_lojas in (" + strRelojas  +") or ss_sintalk_produtos_ecommerce.id_categoria is not null) "
				ENDIF			
			
				SELECT cur_produtos_ecommerce
			
			case UPPER(xmetodo) == 'USR_SAVE_BEFORE'
			
				strData = ''
				strHora = ''
				
				IF TYPE('thisformset.lx_FORM1.lx_pageframe.PAGE_PROPS') == "O"		
					IF USED('curpropsssintalkprodutosecommerce')
						SELECT curpropsssintalkprodutosecommerce
						GO TOP 
						SCAN FOR curpropsssintalkprodutosecommerce.PROPRIEDADE == '00590'
							strData = LEFT(curpropsssintalkprodutosecommerce.valor_propriedade,AT('-',curpropsssintalkprodutosecommerce.valor_propriedade)-1)
							strHora = SUBSTR(curpropsssintalkprodutosecommerce.valor_propriedade,AT('-',curpropsssintalkprodutosecommerce.valor_propriedade)+1,2)
							strMinutos = SUBSTR(curpropsssintalkprodutosecommerce.valor_propriedade,AT('-',curpropsssintalkprodutosecommerce.valor_propriedade)+4,2)
							dtData = CTOD(strData)
							
							IF EMPTY(dtData)
								MESSAGEBOX('Data De Visibilidade do Produto Inválida. Favor entrar na aba Propriedades e ajustar a data de Visibilidade.', 16, 'ATENÇÃO')
								RETURN .F.
							ENDIF
							
							IF EMPTY(strHora) OR VAL(strHora) > 23
								MESSAGEBOX('Hora De Visibilidade do Produto Inválida. Favor entrar na aba Propriedades e ajustar a Hora de Visibilidade.', 16, 'ATENÇÃO') 
								RETURN .F.
							ENDIF
							
							IF EMPTY(strMinutos ) OR VAL(strMinutos ) > 59	
								MESSAGEBOX('Minutos De Visibilidade do Produto Inválida. Favor entrar na aba Propriedades e ajustar os Minutos de Visibilidade.', 16, 'ATENÇÃO')
								RETURN .F.
							endif
						ENDSCAN
					ENDIF 			
				ENDIF
				
			otherwise
				return .t.
		endcase
	endproc
enddefine
