* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar                                                                                     *
* DATA...........:  14/02/2010                                                                                      *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Inclusao campo Filial Estoque em funcao das entradas RBX/TRIMIX
*TRATAMENTO PARA FATURAMENTO RBX/TRIMIX E MOVIMENTACAO ESTOQUE ATAACDO/ESTOQUE CENTRAL						                    *
********************************************************************************************************************* 
******************************************************
*- Programa Base de Criação de Objeto de Entrada
********************************************************************
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos 
*******************************************************************************
*- Existem 2 parametros que influem nos objetos de Entrada:  
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execução para facilitar o desenvolvimento
*********************************************************************************
 

*********************************************************************************
* - Atencao !!!!!!!!!!!														   -*
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP -*
*********************************************************************************

*
*                 Abaixo segue Programa objeto sem Codigo 
*
*
*- Definindo a classe do objeto de entrada que sera criado na Form.
PUBLIC xConf, xTRAVA, xbloqueio	

define class obj_entrada as custom
	*- Nome do metodo/função que os objetos linx vão chamar.
	procedure metodo_usuario
		*- Parametros do metodo:
		*- Xmetodo= nome do metodo
		*- Xobjeto= variavel com a referencia ao objeto
		*- Xnome_obj  = nome do objeto
		lparam xmetodo, xobjeto ,xnome_obj
		
******************** Metodos chamados pelo FORMSET
		*	USR_INIT  												=> NA INICIALIZACAO DA TELA 
		*	USR_ALTER_BEFORE  -> Return .f. Para o Metodo 			=> ANTES DA ALTERACAO ,AO CLICKAR ANTES DE LIBERAR OS CAMPOS
		*	USR_ALTER_AFTER 										=> APOS LIBERAR OS CAMPOS PARA INCLUSAO   
		*	USR_INCLUDE_AFTER 										=> APOS LIBERAR OS CAMPOS PARA INCLUSAO
		*	USR_SEARCH_BEFORE -> Return .f. Para o Metodo PESQUISA	=> ANTES DE FAZER A PESQUISA NO BANCO
		*	USR_SEARCH_AFTER										=> APOS FAZER A PESQUISA NO BANCO
		*	USR_CLEAN_AFTER 										=> APOS LIMPAR A TELA 
		*	USR_REFRESH                                             => 
		*	USR_SAVE_BEFORE   -> Return .f. Para o Metodo 			=> SALVAR ANTES DE JOGAR INFORMACOES NO BANCO
		*	USR_SAVE_AFTER                                          => APOS SALVAR AS INFORMACOES    NO BANCO
		*	USR_ITEN_DELETE_BEFORE -> Return .f. Para o Metodo 		=> ANTES DE EXCLUIR ITEN NA TABELA FILHA '+'
		*	USR_ITEN_DELETE_AFTER                                   => APOS DELETAR UM ITEM NA TABELA FILHA '-' 
		*	USR_ITEN_INCLUDE_BEFORE -> Return .f. Para o Metodo 	=> ANTES DE INCLUIR ITEM NA TABELA FILHA
		*	USR_ITEN_INCLUDE_AFTER									=> APOS INCLUIR ITEM NA TABELA FILHA 
		*
		***************** Metodos que ocorrem dentro da Transaction do Banco de Dados
		*	USR_TRIGGER_AFTER ->Return .f. Para o Salvamento e da Rollback ANTES DE EXECUTAR UMA TRIGGER
		*	USR_TRIGGER_BEFORE ->Return .f. Para o Salvamento e da Rollback


		******************** Metodo chamado pelos Objetos na Validação
		*   USR_VALID -> Return .f. Não deixa o Usuario sair do objeto.

		******************** Metodo chamado pelos PageFrames
		*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

		*- Inicio dos procedimentos do Usuario
		*- Testando qual o metodo que esta chamando o metodo entrada
		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
		do case
			*- metodo do inicio da form
			
      
				case UPPER(xmetodo) == 'USR_INIT' 
				
					xalias=alias()
					
						*** BLOQUEIO CONSUMO - LUCAS MIRANDA - 22/03/2017
						PUBLIC xOldConsumo, xOldPorcConsumo, xPorcClick,xMinPorc,xMaxPorc, xParamProdLacre, xMsgEstampa, xbloqueio					
						xPorcClick=0
						xParamProdLacre = 0
						xbloqueio=0
						xMsgEstampa=''
						***
			     	 	
			     	 	with thisformset.lx_form1.PgPrincipal.page1.lx_PAGEFRAME1.page2.LX_PAGEFRAME1.page2
							.addobject("lb_alterado_por","lb_alterado_por")
							.addobject("Tx_alterado_por","Tx_alterado_por") 
						endwith	

						*** Bloqueio ficha tecnica**
						Sele v_produtos_00
						xalias_pai=alias()
						oCur = getcursoradapter(xalias_pai)
						oCur.addbufferfield("SPACE(3)  AS TEC_FINALIZADO" 	    , "C(3)" ,.T., "Tec Final."      , "TEC_FINALIZADO")
						oCur.addbufferfield("SPACE(25) AS DATA_FINALIZA_TEC"    , "C(25)",.T., "Data Final. Tec" , "DATA_FINALIZA_TEC")
						oCur.addbufferfield("0         AS QTDE_FINALIZADA_TEC"  , "N"    ,.T., "Qtde Final. Tec" , "QTDE_FINALIZADA_TEC")
						
						oCur.addbufferfield("SPACE(3)  AS AV_FINALIZADO"        , "C(3)" ,.T., "Av Final."       , "AV_FINALIZADO")
						oCur.addbufferfield("SPACE(25) AS DATA_FINALIZA_AV"     , "C(25)",.T., "Data Final. Av"  , "DATA_FINALIZA_AV")
						oCur.addbufferfield("0  	   AS QTDE_FINALIZADA_AV"   , "N"    ,.T., "Qtde Final. Av"  , "QTDE_FINALIZADA_AV")
						
						oCur.addbufferfield("SPACE(3)  AS MOST_FINALIZADO"      , "C(3)" ,.T., "Most Final."     , "MOST_FINALIZADO")
						oCur.addbufferfield("SPACE(25) AS DATA_FINALIZA_MOST"   , "C(25)",.T., "Data Final. Most", "DATA_FINALIZA_MOST")						
						oCur.addbufferfield("0         AS QTDE_FINALIZADA_MOST" , "N"    ,.T., "Qtde Final. Most", "QTDE_FINALIZADA_MOST")
						
						oCur.addbufferfield("SPACE(3)  AS IMP_FINALIZADO" 	    , "C(3)" ,.T., "Imp. Final."      , "IMP_FINALIZADO")
						oCur.addbufferfield("SPACE(25) AS DATA_FINALIZA_IMP"    , "C(25)",.T., "Data Final. Imp" , "DATA_FINALIZA_IMP")
						oCur.addbufferfield("0         AS QTDE_FINALIZADA_IMP"  , "N"    ,.T., "Qtde Final. Imp" , "QTDE_FINALIZADA_IMP")
						
						oCur.confirmstructurechanges()	
						Thisformset.l_limpa()
					
						with thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1
							.AddObject("btn_anm_finaliza_most","btn_anm_finaliza_most")
							.addobject("Tx_data_final_most","Tx_data_final_most") 
							.Tx_data_final_most.controlsource="v_produtos_00.DATA_FINALIZA_MOST"
							.addobject("Tx_qtd_final_most","Tx_qtd_final_most") 
							.Tx_qtd_final_most.controlsource="v_produtos_00.QTDE_FINALIZADA_MOST"
							
							.AddObject("btn_anm_finaliza_pan","btn_anm_finaliza_pan")
							.addobject("Tx_data_final_pan","Tx_data_final_pan") 
							.Tx_data_final_pan.controlsource="v_produtos_00.DATA_FINALIZA_TEC"
							.addobject("Tx_qtd_final_pan","Tx_qtd_final_pan") 
							.Tx_qtd_final_pan.controlsource="v_produtos_00.QTDE_FINALIZADA_TEC"
							
							.AddObject("btn_anm_finaliza_av","btn_anm_finaliza_av")
							.addobject("Tx_data_final_av","Tx_data_final_av") 
							.Tx_data_final_av.controlsource="v_produtos_00.DATA_FINALIZA_AV"
							.addobject("Tx_qtd_final_av","Tx_qtd_final_av") 
							.Tx_qtd_final_av.controlsource="v_produtos_00.QTDE_FINALIZADA_AV"
							
							.AddObject("btn_anm_finaliza_imp","btn_anm_finaliza_imp")
							.addobject("Tx_data_final_imp","Tx_data_final_imp") 
							.Tx_data_final_imp.controlsource="v_produtos_00.DATA_FINALIZA_IMP"
							.addobject("Tx_qtd_final_imp","Tx_qtd_final_imp") 
							.Tx_qtd_final_imp.controlsource="v_produtos_00.QTDE_FINALIZADA_IMP"
							
							.lx_grid_filha1.Height 	= 315
					    	.lx_grid_filha1.Top 	= 53
							.lx_grid_filha1.Anchor	= 10 &&Mudo antes para 10 e volto para 15 pois não estava gravando a posição
							.lx_grid_filha1.Anchor	= 15
						endwith

						* Inicio Views Exclusivas **
						f_select("select * from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_VERIFICA_FIN_FT_PA')","ppRL_ANM_VERIFICA_FIN_FT_PA")
						f_select("select * from materiais_tipo","CurMaterialTipo")
						f_select("select * from FX_ANM_PARAMETROS_REDE_LOJAS('gs_tipo_material_porc')","ppgs_tipo_material_porc")
						f_select("select * from FX_ANM_PARAMETROS_REDE_LOJAS('gs_libera_lacre_rl')","ppgs_libera_lacre_rl")
						
						TEXT TO xVerParmPorcCons NOSHOW TEXTMERGE
								
								DECLARE @VALOR_ATUAL_PARAM VARCHAR(100)
								SELECT @VALOR_ATUAL_PARAM = CASE WHEN RTRIM(ISNULL(B.VALOR_ATUAL_USER,A.VALOR_ATUAL)) = '.T.' THEN '0'
																		     WHEN RTRIM(ISNULL(B.VALOR_ATUAL_USER,A.VALOR_ATUAL)) = '.F.' THEN '1'
																        ELSE RTRIM(ISNULL(B.VALOR_ATUAL_USER,A.VALOR_ATUAL)) END
											FROM PARAMETROS A 
												LEFT JOIN ( SELECT A.* FROM PARAMETROS_USERS A
															JOIN USERS B ON A.USUARIO = B.USUARIO
															WHERE LX_SYSTEM_USER = SYSTEM_USER  ) B
												ON A.PARAMETRO = B.PARAMETRO	            
											WHERE A.PARAMETRO = 'GS_PORC_MIN_MAX_CONS'
								SELECT REPLACE(LEFT(ltrim(valores),2),'.','') as VALOR_MIN,
											      REPLACE(SUBSTRING(valores,CHARINDEX('.',valores,1)+1,LEN(valores)),'.','') AS VALOR_MAX
											FROM FXANM_ConsultaVarString(@VALOR_ATUAL_PARAM)

								ENDTEXT				
								F_SELECT(xVerParmPorcCons, 'CUR_VERPARAMPORCCONS')
								
								xMinPorc=CUR_VERPARAMPORCCONS.valor_min
								xMaxPorc=CUR_VERPARAMPORCCONS.valor_max 
						
						 * Inclui Nova Procedure na Classe da Tela >> Dentro de Activate da Guia Materiais
				 		Bindevent(thisformset.LX_FORM1.pgPrincipal.page1.lx_pageframe1.page2, "Activate", This, "ANM_USR_ACTIVATE_PAG2", 1)
						
						*** Bloqueio ficha tecnica**
						
						*** Inclusão do CheckBox Rota de Conserto ***
						*** Lucas Miranda 16/03/2016 ***
						sele V_PRODUTOS_TAB_OPERACOES_00
						xalias_pai=alias()
						
		  				oCur = getcursoradapter(xalias_pai)
						oCur.addbufferfield("ROTA_CONSERTO", "L",.T., "ROTA_CONSERTO", "PRODUTOS_TAB_OPERACOES.ROTA_CONSERTO")	
						oCur.confirmstructurechanges()
						
						Thisformset.LX_FORM1.PGPrincipal.Page5.Lx_pageframe1.PAge2.AddObject("ck_anm_rota_conserto","ck_anm_rota_conserto")
						*** Fim Inclusão do CheckBox Rota de Conserto ***
					
				    if	!f_vazio(xalias)	
					  sele &xalias 
				    ENDIF

				 ****** Bloqueio de alocação de recursos - Silvio Luiz - 27042016 ***********************			    
				 case upper(xmetodo) == 'USR_WHEN' AND upper(xnome_obj) == 'TX_CUSTO_SUGERIDO'  
				 
				 						
					IF THISFORMSET.pp_ANM_BLOQUEIO_RECURSO=.T.
						
						SELECT v_Produto_Operacoes_00_Rotas
						
						TEXT TO XFASE NOSHOW TEXTMERGE
							SELECT FASE_PRODUCAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_FASE
							WHERE PROPRIEDADE='00210'
							AND FASE_PRODUCAO=?v_Produto_Operacoes_00_Rotas.Fase_Producao
						ENDTEXT
						
						F_SELECT(XFASE, 'CUR_FASE')
						
						TEXT TO XPRODUTO NOSHOW TEXTMERGE
							SELECT PRODUTO, VALOR_PROPRIEDADE FROM PROP_PRODUTOS
							WHERE PROPRIEDADE='50016'
							AND PRODUTO=?v_Produto_Operacoes_00_Rotas.tabela_operacoes
						ENDTEXT
						
						F_SELECT(XPRODUTO, 'CUR_PRODUTO')
					
					
						SELECT CUR_FASE
						SELECT CUR_PRODUTO
						
							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' AND CUR_PRODUTO.VALOR_PROPRIEDADE='INTERNO'   
								MESSAGEBOX("O USUÁRIO NÃO TEM PERMISSÃO PARA ALTERAR O CUSTO DESTA FASE!!",48) 
				    			thisform.LX_FORM1.PGPrincipal.PAGe5.LX_pageframe1.PAge2.LX_pageframe1.PAge2.LX_GRID_FILHA2.col_tx_CUSTO_SUGERIDO.tx_CUSTO_SUGERIDO.Enabled= .F.
				    			RETURN .f.
							ENDIF
					ENDIF
					
				
				case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TV_RECURSO_PRODUTIVO'
				
				**** Lucas Miranda - 16/03/2017 - Bloqueia Programação *****
					TEXT TO xBloqProg NOSHOW TEXTMERGE
						SELECT A.*
						FROM PRODUCAO_RECURSOS (nolock) A
						JOIN CADASTRO_CLI_FOR (nolock) B
						ON A.NOME_CLIFOR = B.NOME_CLIFOR
						JOIN PROP_FORNECEDORES (nolock) C
						ON B.NOME_CLIFOR = C.FORNECEDOR
						AND PROPRIEDADE = '00465'
						WHERE C.VALOR_PROPRIEDADE = 'SIM' 
						AND	A.RECURSO_PRODUTIVO = ?v_Produto_Operacoes_00_Rotas.recurso_produtivo 
					ENDTEXT
					F_SELECT(xBloqProg,"Cur_BloqProd")
					Sele Cur_BloqProd
					 
					If !F_Vazio(Cur_BloqProd.recurso_produtivo)
						TEXT TO XDADOSANTERIOR NOSHOW TEXTMERGE
							select A.RECURSO_PRODUTIVO, B.DESC_RECURSO, A.SEQUENCIA_PRODUTIVA 
							from PRODUTO_OPERACOES_ROTAS (nolock) A
							JOIN PRODUCAO_RECURSOS (nolock) B
							ON A.RECURSO_PRODUTIVO=B.RECURSO_PRODUTIVO 
							where A.TABELA_OPERACOES=?v_Produto_Operacoes_00_Rotas.tabela_operacoes
							and A.SEQUENCIA_PRODUTIVA=?v_Produto_Operacoes_00_Rotas.SEQUENCIA_PRODUTIVA
						ENDTEXT
									
						F_SELECT(XDADOSANTERIOR, 'CUR_DADO_ANTERIOR_BD')

						sele v_Produto_Operacoes_00_Rotas
						replace recurso_produtivo WITH IIF(F_VAZIO(CUR_DADO_ANTERIOR_BD.recurso_produtivo),'22264',CUR_DADO_ANTERIOR_BD.recurso_produtivo)
						replace desc_recurso WITH IIF(F_VAZIO(CUR_DADO_ANTERIOR_BD.desc_recurso),'INDEFINIDO',CUR_DADO_ANTERIOR_BD.desc_recurso)
						*o_040001.LX_FORM1.PGPrincipal.PAGe5.LX_pageframe1.PAge2.LX_pageframe1.PAge2.LX_GRID_FILHA2.col_tv_RECURSO_PRODUTIVO.SetFocus()
						MESSAGEBOX("Fornecedor bloqueado programação !!",0+16,"Bloqueia Programação")
						USE IN Cur_BloqProd
						USE IN CUR_DADO_ANTERIOR_BD
						RETURN .F.
					Endif
				**** Bloqueia Programação *****
						
					IF THISFORMSET.pp_ANM_BLOQUEIO_RECURSO=.T.
						
						SELECT v_Produto_Operacoes_00_Rotas
						
						SELECT tabela_operacoes, fase_producao, sequencia_produtiva, recurso_produtivo, desc_recurso FROM v_Produto_Operacoes_00_Rotas INTO CURSOR  vtmp_Produto_Operacoes_00_Rotas
						
						SELECT vtmp_Produto_Operacoes_00_Rotas

							TEXT TO XDADOS NOSHOW TEXTMERGE
								select A.RECURSO_PRODUTIVO, B.DESC_RECURSO, A.SEQUENCIA_PRODUTIVA 
								from PRODUTO_OPERACOES_ROTAS A
								JOIN PRODUCAO_RECURSOS B
								ON A.RECURSO_PRODUTIVO=B.RECURSO_PRODUTIVO 
								where A.TABELA_OPERACOES=?vtmp_Produto_Operacoes_00_Rotas.tabela_operacoes
								and A.SEQUENCIA_PRODUTIVA=?v_Produto_Operacoes_00_Rotas.SEQUENCIA_PRODUTIVA
							ENDTEXT
							
						F_SELECT(XDADOS, 'CUR_DADO_ANTERIOR')
						
						TEXT TO XFASE NOSHOW TEXTMERGE
							SELECT FASE_PRODUCAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_FASE
							WHERE PROPRIEDADE='00210'
							AND FASE_PRODUCAO=?v_Produto_Operacoes_00_Rotas.Fase_Producao
						ENDTEXT
						
						F_SELECT(XFASE, 'CUR_FASE')
						
						TEXT TO XPRODUTO NOSHOW TEXTMERGE
							SELECT PRODUTO, VALOR_PROPRIEDADE FROM PROP_PRODUTOS
							WHERE PROPRIEDADE='50016'
							AND PRODUTO=?v_Produto_Operacoes_00_Rotas.tabela_operacoes
						ENDTEXT
						
						F_SELECT(XPRODUTO, 'CUR_PRODUTO')
					
					
						SELECT CUR_FASE
						SELECT CUR_PRODUTO
						SELECT CUR_DADO_ANTERIOR

						
							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' AND CUR_PRODUTO.VALOR_PROPRIEDADE='INTERNO'  
								SELECT v_Produto_Operacoes_00_Rotas
										MESSAGEBOX("O USUÁRIO NÃO TEM PERMISSÃO PARA ALTERAR O RECURSO NESTA FASE!!",48) 
										thisform.LX_FORM1.PGPrincipal.PAGe5.LX_pageframe1.PAge2.LX_pageframe1.PAge2.LX_GRID_FILHA2.col_tv_RECURSO_PRODUTIVO.tv_RECURSO_PRODUTIVO.Enabled= .F.
										REPLACE recurso_produtivo WITH CUR_DADO_ANTERIOR.RECURSO_PRODUTIVO
										REPLACE desc_recurso WITH CUR_DADO_ANTERIOR.DESC_RECURSO
							ENDIF                                                       
					ENDIF		
					
					
					case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TV_FASE_PRODUCAO'
				
					IF THISFORMSET.pp_ANM_BLOQUEIO_RECURSO=.T.
						
						SELECT v_Produto_Operacoes_00_Rotas
						
						TEXT TO XFASE NOSHOW TEXTMERGE
							SELECT FASE_PRODUCAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_FASE
							WHERE PROPRIEDADE='00210'
							AND FASE_PRODUCAO=?v_Produto_Operacoes_00_Rotas.Fase_Producao
						ENDTEXT
						
						F_SELECT(XFASE, 'CUR_FASE')
						
						TEXT TO XPRODUTO NOSHOW TEXTMERGE
							SELECT PRODUTO, VALOR_PROPRIEDADE FROM PROP_PRODUTOS
							WHERE PROPRIEDADE='50016'
							AND PRODUTO=?v_Produto_Operacoes_00_Rotas.tabela_operacoes
						ENDTEXT
						
						F_SELECT(XPRODUTO, 'CUR_PRODUTO')
					
					
						SELECT CUR_FASE
						SELECT CUR_PRODUTO

							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' AND CUR_PRODUTO.VALOR_PROPRIEDADE='INTERNO'  
								SELECT v_Produto_Operacoes_00_Rotas
										MESSAGEBOX("O USUÁRIO TEM PERMISSÃO PARA INCLUIR NESTA FASE SOMENTE O RECURSO '99' - 'AGUARDANDO DEFINIÇAO'!!",48) 
										REPLACE recurso_produtivo WITH '99'
										REPLACE desc_recurso WITH 'AGUARDANDO DEFINIÇAO'
										thisform.LX_FORM1.PGPrincipal.PAGe5.LX_pageframe1.PAge2.LX_pageframe1.PAge2.LX_GRID_FILHA2.col_tv_SETOR_PRODUCAO.SetFocus
							ENDIF  
						                                              
					ENDIF		
					
					case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TV_MATERIAL'
						
						xalias=alias() 
							 
							*** Bloqueio ficha tecnica**
							*** Liberar alguns materiais - Lucas Miranda - 31/01/2018
							If USED("CurLacreAmarelo")
								USE IN CurLacreAmarelo
							Endif	

							If USED("CurPermiteLacre")
								USE IN CurPermiteLacre
							Endif
							TEXT TO xsql TEXTMERGE noshow
								set ANSI_NULLS ON 
								SET ANSI_WARNINGS ON
								select * from FX_GS_CONSULTA_LACRE_AMARELO('<<ALLTRIM(v_produtos_00.produto)>>')
							ENDTEXT 
							f_select(xsql,"CurLacreAmarelo",ALIAS())
							
							f_select("select * from GS_TB_MATERIAIS_RECORRENTES where permissao_lacre = 1 and material = ?v_produtos_ficha_01.material","CurPermiteLacre",ALIAS())	
							
							sele ppgs_libera_lacre_rl
							LOCATE FOR REDE_LOJAS = v_produtos_00.rede_lojas
							If FOUND() AND ppgs_libera_lacre_rl.valor_atual = 'SIM'
								xParamProdLacre = 1
							ELSE
								xParamProdLacre = 0
							Endif					
							*** Verifica se encontrou os 2 cursores, se encontrar libera ***
							*** Fim - Liberar alguns materiais - Lucas Miranda - 31/01/2018
															
							Sele CurMaterialTipo
							LOCATE FOR tipo = v_produtos_ficha_01.tipo
								
								If !(Cur_ProgMost_S_OP.Qtde_prog_s_OP > 0 AND v_produtos_00.MOST_FINALIZADO= 'SIM')
									If v_produtos_00.IMP_FINALIZADO = 'SIM' AND !(RECCOUNT("CurLacreAmarelo") > 0 AND RECCOUNT("CurPermiteLacre") > 0)
										TEXT TO xSelMatImp NOSHOW TEXTMERGE
											SELECT MATERIAL
											FROM MATERIAIS (nolock) MATERIAIS
											JOIN (SELECT DISTINCT FORNECEDOR 
													FROM (SELECT FORNECEDOR FROM FORNECEDORES  (nolock) WHERE FORNECEDOR IN (SELECT NOME_CLIFOR FROM CADASTRO_CLI_FOR WHERE UF='EX')
															UNION ALL
														  SELECT FORNECEDOR FROM PROP_FORNECEDORES  (nolock) WHERE PROPRIEDADE = '00510' AND VALOR_PROPRIEDADE = 'SIM') A ) FORNECEDORES
											ON MATERIAIS.FABRICANTE = FORNECEDORES.FORNECEDOR
											WHERE MATERIAIS.MATERIAL = '<<v_Produtos_Ficha_01_Cor.material>>'
										ENDTEXT
										f_select(xSelMatImp,"CurMatImp",ALIAS())
										
										If RECCOUNT("CurMatImp") > 0 
											If CurMaterialTipo.indica_tecido= .T. AND !(RECCOUNT("CurLacreAmarelo") > 0 AND RECCOUNT("CurPermiteLacre") > 0 AND xParamProdLacre = 1)
												USE IN CurMatImp
												 
												Messagebox("Usuário bloqueado para alteração de consumo do Material Importado - TECIDO!!!",0+16,"Bloqueio Ficha Técnica")
												*Return .F. ** Excluo Item **
												ThisFormSet.lx_Form1.pgPrincipal.Page1.lx_PageFrame1.ActivePage = 1
												ThisFormSet.l_desenhista_filhas_exclui_antes 

												select v_Produtos_Ficha_01
  
												if recno()!= 0 and !eof() and !deleted()
													tablerevert()
													if recno() > 0
														delete
													endif
												ENDIF

												ThisFormSet.l_desenhista_filhas_exclui_apos
												Return .t.
											Else
												If CurMaterialTipo.indica_tecido = .F. AND !(RECCOUNT("CurLacreAmarelo") > 0 AND RECCOUNT("CurPermiteLacre") > 0 AND xParamProdLacre = 1)
													Messagebox("Usuário bloqueado para alteração de consumo do Material Importado - Aviamentos!!!",0+16,"Bloqueio Ficha Técnica")
													*Return .F. ** Excluo Item **
													ThisFormSet.lx_Form1.pgPrincipal.Page1.lx_PageFrame1.ActivePage = 1
													ThisFormSet.l_desenhista_filhas_exclui_antes 

													select v_Produtos_Ficha_01

													if recno()!= 0 and !eof() and !deleted()
														tablerevert()
														if recno() > 0
															delete
														endif
													ENDIF

													ThisFormSet.l_desenhista_filhas_exclui_apos
													Return .t.
												Endif
											Endif
										Endif									
									Endif
								
									If CurMaterialTipo.indica_tecido= .T. AND v_produtos_00.TEC_FINALIZADO = 'SIM' AND !(RECCOUNT("CurLacreAmarelo") > 0 AND RECCOUNT("CurPermiteLacre") > 0 AND xParamProdLacre = 1)
									** thisformset.pp_ANM_ALT_CONS_PAN = .F. ** Para alterar precisa liberar
									
										Messagebox("Usuário bloqueado para alteração de consumo do Tipo Panos!!!",0+16,"Bloqueio Ficha Técnica")
										*Return .F. ** Excluo Item **
											ThisFormSet.lx_Form1.pgPrincipal.Page1.lx_PageFrame1.ActivePage = 1
											ThisFormSet.l_desenhista_filhas_exclui_antes 

											select v_Produtos_Ficha_01

											if recno()!= 0 and !eof() and !deleted()
												tablerevert()
												if recno() > 0
													delete
												endif
											ENDIF

											ThisFormSet.l_desenhista_filhas_exclui_apos
											Return .t.
									Else
										If CurMaterialTipo.indica_tecido = .F. AND v_produtos_00.AV_FINALIZADO= 'SIM' AND !(RECCOUNT("CurLacreAmarelo") > 0 AND RECCOUNT("CurPermiteLacre") > 0 AND xParamProdLacre = 1)
											** AND thisformset.pp_ANM_ALT_CONS_PAN = .F. ** Para alterar precisa liberar
											
											Messagebox("Usuário bloqueado para alteração de consumo do Tipo Aviamentos!!!",0+16,"Bloqueio Ficha Técnica")
											*Return .F. ** Excluo Item **
											ThisFormSet.lx_Form1.pgPrincipal.Page1.lx_PageFrame1.ActivePage = 1
											ThisFormSet.l_desenhista_filhas_exclui_antes 

											select v_Produtos_Ficha_01

											if recno()!= 0 and !eof() and !deleted()
												tablerevert()
												if recno() > 0
													delete
												endif
											ENDIF

											ThisFormSet.l_desenhista_filhas_exclui_apos
											Return .t.
										Endif
									Endif
								Else
									Messagebox("Usuário bloqueado para alteração."+CHR(13)+"OP de mostruário não emitida!!!",0+16,"Bloqueio Ficha Técnica")
									*Return .F. ** Excluo Item **
									ThisFormSet.lx_Form1.pgPrincipal.Page1.lx_PageFrame1.ActivePage = 1
									ThisFormSet.l_desenhista_filhas_exclui_antes 

									select v_Produtos_Ficha_01

									if recno()!= 0 and !eof() and !deleted()
										tablerevert()
										if recno() > 0
											delete
										endif
									ENDIF

									ThisFormSet.l_desenhista_filhas_exclui_apos
									Return .t.
								Endif
								*** Bloqueio ficha tecnica**
								
							***LUCAS MIRANDA - BLOQUEIA ALTERACAO PORCENTAGEM DE CONSUMO ***
							If Thisformset.pp_gs_verifica_porc_consumo = .T.	
								xOldConsumo = v_produtos_ficha_01_cor.consumo_aux
								xOldPorcConsumo = v_produtos_ficha_01_cor.porcentagem_consumo
								
								f_select("select produto, rede_lojas from produtos where produto=?v_produtos_00.produto","CurProdutoRede")
								Sele CurProdutoRede						

								f_select("select REDE_LOJAS, CAST(VALOR_ATUAL AS NUMERIC(8,2)) AS VALOR_ATUAL from FX_ANM_PARAMETROS_REDE_LOJAS('GS_VALOR_MEDIO_CONS_MARCA')","CurValorMed")
								SELECT CurValorMed
								SET FILTER TO CurValorMed.rede_lojas = CurProdutoRede.rede_lojas 						 

								f_select("select a.material, cor_material, b.custo_a_vista from materiais a join materiais_cores b on a.material = b.material where a.material=?v_produtos_ficha_01_cor.material and cor_material=?v_produtos_ficha_01_cor.cor_material","CurCustoMaterial")
								Sele CurCustoMaterial		
								
								f_select("select PRODUTO, MATERIAL, COR_MATERIAL FROM PRODUTO_VERSAO_MATERIAL_COR where produto=?v_produtos_00.produto and material=?v_produtos_ficha_01_cor.material and cor_material=?v_produtos_ficha_01_cor.cor_material","CurExisteMat")
								Sele CurExisteMat							
								
								f_select("SELECT MATERIAL, GS_PORCENTAGEM_CONSUMO_FT FROM MATERIAIS WHERE ISNULL(GS_PORCENTAGEM_CONSUMO_FT,0) > 0 AND material=?v_produtos_ficha_01_cor.material","CurMatForaPadrao")
								Sele CurMatForaPadrao
								
								If !F_VAZIO(CurMatForaPadrao.GS_PORCENTAGEM_CONSUMO_FT) 
									Sele v_produtos_ficha_01_cor
									Scan 
										replace v_produtos_ficha_01_cor.porcentagem_consumo with CurMatForaPadrao.GS_PORCENTAGEM_CONSUMO_FT
										thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Refresh()
										thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Col_porc_consumo.Tx_porc_consumo.L_desenhista_recalculo()
										Sele v_produtos_ficha_01_cor
									EndScan	
										thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Refresh()
								Else 	
									Sele v_produtos_ficha_01
									SET FILTER TO  ALLTRIM(tipo) = ALLTRIM(ppgs_tipo_material_porc.valor_atual)
									If FOUND()
										If !F_Vazio(CurCustoMaterial.material)		
											If !F_Vazio(CurValorMed.valor_atual)
												If CurCustoMaterial.custo_a_vista < CurValorMed.valor_atual											 
													If F_Vazio(CurExisteMat.material)				
														Sele v_produtos_ficha_01_cor
														Scan 
															replace v_produtos_ficha_01_cor.porcentagem_consumo with Thisformset.pp_gs_porc_cons_padrao
															thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Refresh()
															thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Col_porc_consumo.Tx_porc_consumo.L_desenhista_recalculo()
															Sele v_produtos_ficha_01_cor
														EndScan	
															thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Refresh()
													Endif	
												Endif
											Endif						
										Endif
									Endif
								Endif
							Endif	
						  
						***LUCAS MIRANDA - BLOQUEIA ALTERACAO PORCENTAGEM DE CONSUMO ***		
						IF !f_vazio(xalias)	
						  sele &xalias 
					    ENDIF
				
				***LUCAS MIRANDA - BLOQUEIA ALTERACAO PORCENTAGEM DE CONSUMO ***
											
				case upper(xmetodo) == 'USR_VALID' AND ( upper(xnome_obj) == 'TX_CONSUMO_AUX' OR upper(xnome_obj) == 'TX_PORC_CONSUMO' OR upper(xnome_obj) == 'TX_PORCENTAGEM_CONSUMO')
				 
				xalias=alias()
					
					If Thisformset.pp_gs_verifica_porc_consumo = .T.	
						xPorcClick=0
						 
						f_select("select produto, rede_lojas from produtos where produto=?v_produtos_00.produto","CurProdutoRede")
						Sele CurProdutoRede						

						f_select("select REDE_LOJAS, CAST(VALOR_ATUAL AS NUMERIC(8,2)) AS VALOR_ATUAL from FX_ANM_PARAMETROS_REDE_LOJAS('GS_VALOR_MEDIO_CONS_MARCA')","CurValorMed")
						SELECT CurValorMed
						SET FILTER TO CurValorMed.rede_lojas = CurProdutoRede.rede_lojas 						 
						
						f_select("select TIPO from materiais where material=?v_produtos_ficha_01_cor.material","CurTipoMaterial")
						Sele CurTipoMaterial
						
						f_select("select a.material, cor_material, b.custo_a_vista from materiais a join materiais_cores b on a.material = b.material where a.material=?v_produtos_ficha_01_cor.material and cor_material=?v_produtos_ficha_01_cor.cor_material and a.tipo like '%aviamen%'","CurCustoMaterial")
						Sele CurCustoMaterial		
						
						f_select("select PRODUTO, MATERIAL, COR_MATERIAL FROM PRODUTO_VERSAO_MATERIAL_COR where produto=?v_produtos_00.produto and material=?v_produtos_ficha_01_cor.material and cor_material=?v_produtos_ficha_01_cor.cor_material","CurExisteMat")
						Sele CurExisteMat
						
						f_select("SELECT MATERIAL, GS_PORCENTAGEM_CONSUMO_FT FROM MATERIAIS WHERE ISNULL(GS_PORCENTAGEM_CONSUMO_FT,0) > 0 AND material=?v_produtos_ficha_01_cor.material","CurMatForaPadrao")
						Sele CurMatForaPadrao
						
						If !F_VAZIO(CurMatForaPadrao.GS_PORCENTAGEM_CONSUMO_FT) 
							If ( v_produtos_ficha_01_cor.consumo_aux > 0 OR v_produtos_ficha_01_cor.porcentagem_consumo > 0 ) 
								Sele v_produtos_ficha_01_cor
								replace v_produtos_ficha_01_cor.porcentagem_consumo with CurMatForaPadrao.GS_PORCENTAGEM_CONSUMO_FT
								xPorcClick=1
								thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Refresh()
								thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Col_porc_consumo.Tx_porc_consumo.L_desenhista_recalculo()
								thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Refresh()
							Endif	
						ELSE 	
							Sele ppgs_tipo_material_porc
							Go Top
							SCAN
								If ALLTRIM(CurTipoMaterial.tipo) $ ALLTRIM(ppgs_tipo_material_porc.valor_atual)
									If !F_Vazio(CurCustoMaterial.material)
										If !F_Vazio(CurValorMed.valor_atual)
											If CurCustoMaterial.custo_a_vista < CurValorMed.valor_atual
												 If Thisformset.pp_gs_bloq_valor_med_porc = .T. AND ( v_produtos_ficha_01_cor.consumo_aux > 0 OR v_produtos_ficha_01_cor.porcentagem_consumo > 0 )
													If !F_Vazio(CurExisteMat.material)			
														replace v_produtos_ficha_01_cor.porcentagem_consumo with Thisformset.pp_gs_porc_cons_padrao
														xPorcClick=1	
														thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Refresh()
														thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Col_porc_consumo.Tx_porc_consumo.L_desenhista_recalculo()
														thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Refresh()
														MESSAGEBOX("Não será possível alterar, custo do material abaixo do valor médio !!!"+CHR(13)+"Porcentagem inserida por padrão !",0+16,"Bloqueio Porc. Consumo")																										
													Else	
														Sele v_produtos_ficha_01_cor
														
														replace v_produtos_ficha_01_cor.porcentagem_consumo with Thisformset.pp_gs_porc_cons_padrao
														xPorcClick=1
														thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Refresh()
														thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Col_porc_consumo.Tx_porc_consumo.L_desenhista_recalculo()
														thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Refresh()
														MESSAGEBOX("Não será possível alterar, custo do material abaixo do valor médio !!!"+CHR(13)+"Porcentagem inserida por padrão !",0+16,"Bloqueio Porc. Consumo")
														
													Endif	
												Endif
											Endif
										Endif						
									Endif
								 Endif
							Sele ppgs_tipo_material_porc
							EndSCAN	
								*SET STEP ON
								If xPorcClick=0						
									*xVerPorcConsumo=100+((v_produtos_ficha_01_cor.consumo_aux / Evaluate([v_produtos_ficha_01.c]+Alltrim(Str(o_040001.Px_tamanho_base_cor))))-1)*100
									xVerPorcConsumo=v_produtos_ficha_01_cor.porcentagem_consumo
									If xVerPorcConsumo > 0 AND ((xVerPorcConsumo < VAL(xMinPorc)) OR (xVerPorcConsumo  > VAL(xMaxPorc))) AND Thisformset.pp_GS_BLOQ_CONS_MIN_MAX = .T.
										Sele v_produtos_ficha_01_cor
										replace v_produtos_ficha_01_cor.consumo_aux with xOldConsumo
										replace v_produtos_ficha_01_cor.porcentagem_consumo with xOldPorcConsumo 

										Thisformset.lx_form1.PgPrincipal.page1.lx_pageframe1.page2.lx_pageframe1.page1.lx_grid_filha3.Refresh()
										MESSAGEBOX("Não será possível incluir o consumo digitado !!!"+CHR(13)+"Ultrapassado o Limite Mínimo de "+ALLTRIM(xMinPorc)+"% e o Máximo de "+ALLTRIM(xMaxPorc)+"%",0+16,"Bloqueio Porc. Consumo")
										
									Endif
							Endif
						Endif
					Endif

				IF !f_vazio(xalias)	
				  sele &xalias 
			    ENDIF
				***LUCAS MIRANDA - BLOQUEIA ALTERACAO PORCENTAGEM DE CONSUMO ***
				
				*** AO INCLUIR O PACOTE ESTAVA INCLUINDO UMA LINHA EM BRANCO
				*** FORCANDO PARA EXCLUIR
				case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TV_PACOTE_MATERIAIS'
				
					Thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.ActivePage=1
					
					Select V_produtos_ficha_01
					Go top 
					*- Como foi adicionada uma linha em branco no momento da inclusao, apago esta linha
					Locate for Alltrim(material) == ''
					
					If !Eof()
						Delete
					EndIf 
					Go top 
					This.Parent.tv_MATERIAL.Refresh()
					This.Parent.tx_DESC_MATERIAL.Refresh()
					This.Parent.tx_DESC_USO_MATERIAL.Refresh()
					This.Parent.tX_DESC_PACOTE_MATERIAIS.Refresh()
					
					Thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.ActivePage=2
				
				*** Bloqueio ficha tecnica**				
				case upper(xmetodo) == 'USR_WHEN'  AND (upper(xnome_obj) == 'TX_C1' OR upper(xnome_obj) == 'TX_1' OR upper(xnome_obj) == 'TX_2' OR ;
													   upper(xnome_obj) == 'TX_3'  OR upper(xnome_obj) == 'TX_4' OR upper(xnome_obj) == 'TX_5' OR ;
													   upper(xnome_obj) == 'TX_CONSUMO_AUX' OR upper(xnome_obj) == 'TX_PORC_CONSUMO' OR upper(xnome_obj) == 'TX_PORCENTAGEM_CONSUMO')	
						xalias=alias()
						
						*** Liberar alguns materiais - Lucas Miranda - 31/01/2018
						If USED("CurLacreAmarelo")
							USE IN CurLacreAmarelo
						Endif	

						If USED("CurPermiteLacre")
							USE IN CurPermiteLacre
						Endif
						
						f_select("select * from FX_GS_CONSULTA_LACRE_AMARELO(?v_produtos_00.produto)","CurLacreAmarelo",ALIAS())
						f_select("select * from GS_TB_MATERIAIS_RECORRENTES where permissao_lacre = 1 and material = ?v_produtos_ficha_01.material","CurPermiteLacre",ALIAS())	
						
						sele ppgs_libera_lacre_rl
						LOCATE FOR REDE_LOJAS = v_produtos_00.rede_lojas
						If FOUND() AND ppgs_libera_lacre_rl.valor_atual = 'SIM'
							xParamProdLacre = 1
						ELSE
							xParamProdLacre = 0
						Endif						
						*** Verifica se encontrou os 2 cursores, se encontrar libera ***
						*** Fim - Liberar alguns materiais - Lucas Miranda - 31/01/2018
						
						
						Sele CurMaterialTipo
						LOCATE FOR tipo = v_produtos_ficha_01.tipo
							
							If !(Cur_ProgMost_S_OP.Qtde_prog_s_OP > 0 AND v_produtos_00.MOST_FINALIZADO= 'SIM')
							
								If v_produtos_00.IMP_FINALIZADO = 'SIM' 
									TEXT TO xSelMatImp NOSHOW TEXTMERGE
										SELECT MATERIAL
										FROM MATERIAIS (nolock) MATERIAIS
										JOIN (SELECT DISTINCT FORNECEDOR 
												FROM (SELECT FORNECEDOR FROM FORNECEDORES  (nolock) WHERE FORNECEDOR IN (SELECT NOME_CLIFOR FROM CADASTRO_CLI_FOR WHERE UF='EX')
														UNION ALL
													  SELECT FORNECEDOR FROM PROP_FORNECEDORES  (nolock) WHERE PROPRIEDADE = '00510' AND VALOR_PROPRIEDADE = 'SIM') A ) FORNECEDORES
										ON MATERIAIS.FABRICANTE = FORNECEDORES.FORNECEDOR
										WHERE MATERIAIS.MATERIAL = '<<v_Produtos_Ficha_01_Cor.material>>'
									ENDTEXT
									f_select(xSelMatImp,"CurMatImp",ALIAS())
									
									If RECCOUNT("CurMatImp") > 0 
									**AND thisformset.pp_GS_ALT_CONS_IMP= .F.
										If CurMaterialTipo.indica_tecido 
											If thisformset.pp_ANM_ALT_CONS_PAN= .F. AND !(RECCOUNT("CurLacreAmarelo") > 0 AND RECCOUNT("CurPermiteLacre") > 0 AND xParamProdLacre = 1)
												USE IN CurMatImp
												
												RETURN .f.
											Endif	
										Else
											IF "'"+ALLTRIM(v_produtos_ficha_01.tipo)+"'" $ o_040001.pp_ANM_TIPO_MATERIAL_FT_PA
												IF thisformset.pp_ANM_ALT_CONS_PAN= .F. AND !(RECCOUNT("CurLacreAmarelo") > 0 AND RECCOUNT("CurPermiteLacre") > 0 AND xParamProdLacre = 1)
													USE IN CurMatImp
													
													Return .F.
												ENDIF
											ELSE
												IF thisformset.pp_ANM_ALT_CONS_AV= .F. AND !(RECCOUNT("CurLacreAmarelo") > 0 AND RECCOUNT("CurPermiteLacre") > 0 AND xParamProdLacre = 1)
													USE IN CurMatImp
													
													Return .F.
												ENDIF
											ENDIF
										Endif	
									Endif									
								Endif
								 
								
								If CurMaterialTipo.indica_tecido
									
									IF v_produtos_00.TEC_FINALIZADO= 'SIM' AND thisformset.pp_ANM_ALT_CONS_PAN= .F. AND !(RECCOUNT("CurLacreAmarelo") > 0 AND RECCOUNT("CurPermiteLacre") > 0 AND xParamProdLacre = 1)
										Return .F.
									ENDIF
								Else	
									IF "'"+ALLTRIM(v_produtos_ficha_01.tipo)+"'" $ o_040001.pp_ANM_TIPO_MATERIAL_FT_PA
										
										IF v_produtos_00.AV_FINALIZADO = 'SIM' AND thisformset.pp_ANM_ALT_CONS_PAN= .F. AND !(RECCOUNT("CurLacreAmarelo") > 0 AND RECCOUNT("CurPermiteLacre") > 0 AND xParamProdLacre = 1)
											Return .F.
										ENDIF
									ELSE
										IF v_produtos_00.AV_FINALIZADO = 'SIM' AND thisformset.pp_ANM_ALT_CONS_AV= .F. AND !(RECCOUNT("CurLacreAmarelo") > 0 AND RECCOUNT("CurPermiteLacre") > 0 AND xParamProdLacre = 1)
											Return .F.
										ENDIF
									ENDIF
								Endif	
							
							Else
								Return .F.
							Endif	
					
						***LUCAS MIRANDA - BLOQUEIA ALTERACAO PORCENTAGEM DE CONSUMO ***
						Sele v_produtos_ficha_01_cor
						xOldConsumo = v_produtos_ficha_01_cor.consumo_aux
						xOldPorcConsumo = v_produtos_ficha_01_cor.porcentagem_consumo
						***LUCAS MIRANDA - BLOQUEIA ALTERACAO PORCENTAGEM DE CONSUMO ***
					
					If !f_vazio(xalias)	
					  sele &xalias 
				    Endif
				*** Bloqueio ficha tecnica**
				
				CASE UPPER(xmetodo) == 'USR_SAVE_BEFORE'
				
					TEXT TO xTRAVA TEXTMERGE noshow
						SELECT CASE WHEN BT_FINALIZA_AVIAMENTOS = 1 THEN 'FIN. AVIA.' +CHAR(13) ELSE '' END +
							   CASE WHEN BT_FINALIZA_PANOS      = 1 THEN 'FIN. PANOS.'+CHAR(13) ELSE '' END +
							   CASE WHEN BT_FT_MOST_PRONTO      = 1 THEN 'FIN. MOST.' +CHAR(13) ELSE '' END +
							   CASE WHEN BT_FINALIZA_IMP        = 1 THEN 'FIN. IMP.'  +CHAR(13) ELSE '' END  AS BOTOES,
							   1 AS TEM_BLOQUEIO 
						FROM ANM_TB_BLOQ_FICHA_TECNICA_PA (NOLOCK)
						WHERE (BT_FINALIZA_AVIAMENTOS=1 OR BT_FINALIZA_IMP=1 OR BT_FINALIZA_PANOS=1 OR BT_FT_MOST_PRONTO=1)
						AND PRODUTO = LTRIM(RTRIM('<<v_produtos_00.produto>>'))
					ENDTEXT
					
					f_select(xTrava,"vtmp_trava")
					IF vtmp_trava.tem_bloqueio = 1
						IF MESSAGEBOX("Os seguintes botões serão bloqueados após salvar:"+CHR(13)+ALLTRIM(vtmp_trava.BOTOES)+CHR(13)+"Deseja salvar?",4+32,"Bloqueio Sem contar na meta") = 6 
							TEXT TO xConf TEXTMERGE noshow
								SELECT anm_tb_bloq_ficha_tecnica_pa.BT_FINALIZA_PANOS FROM anm_tb_bloq_ficha_tecnica_pa (NOLOCK) WHERE produto = LTRIM(RTRIM('<<v_produtos_00.produto>>'))
							ENDTEXT
						
							f_select(xConf,"vtmp_conf")
							IF vtmp_conf.BT_FINALIZA_PANOS  
							xbloqueio=1
								thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.Click()
								
							ENDIF
							
							TEXT TO xConf TEXTMERGE noshow
								SELECT anm_tb_bloq_ficha_tecnica_pa.BT_FINALIZA_AVIAMENTOS FROM anm_tb_bloq_ficha_tecnica_pa (NOLOCK) WHERE produto = LTRIM(RTRIM('<<v_produtos_00.produto>>'))
							ENDTEXT
							f_select(xConf,"vtmp_conf")
							IF vtmp_conf.BT_FINALIZA_AVIAMENTOS 
							xbloqueio=1
								thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.Click()
								
								
							ENDIF
							
							TEXT TO xConf TEXTMERGE noshow
								SELECT anm_tb_bloq_ficha_tecnica_pa.BT_FT_MOST_PRONTO FROM anm_tb_bloq_ficha_tecnica_pa (NOLOCK) WHERE produto = LTRIM(RTRIM('<<v_produtos_00.produto>>'))
							ENDTEXT
							f_select(xConf,"vtmp_conf")
							IF vtmp_conf.BT_FT_MOST_PRONTO 
							xbloqueio=1 
								thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.Click()
								
								
							ENDIF
									
							TEXT TO xConf TEXTMERGE noshow
								SELECT anm_tb_bloq_ficha_tecnica_pa.BT_FINALIZA_IMP FROM anm_tb_bloq_ficha_tecnica_pa (NOLOCK) WHERE produto = LTRIM(RTRIM('<<v_produtos_00.produto>>'))
							ENDTEXT
							f_select(xConf,"vtmp_conf")
							IF vtmp_conf.BT_FINALIZA_IMP 
							xbloqueio=1 
								thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_imp.Click()
							ENDIF
						ELSE
						
							RETURN .f.
							
						ENDIF
					ENDIF
					
					*--Início Aviso de existencia de material de composição - Perla - 09112018
					
						TEXT TO xsql NOSHOW TEXTMERGE
								SELECT P.PRODUTO,P.TIPO_PRODUTO, PF.MATERIAL
								FROM PRODUTOS AS P
								LEFT JOIN PRODUTOS_FICHA AS PF ON P.PRODUTO = PF.PRODUTO 
								WHERE  P.TIPO_PRODUTO like '%produto acabado%' AND P.PRODUTO = '<<v_produtos_00.produto>>' 
								AND PF.MATERIAL IN (SELECT MATERIAL FROM PROP_MATERIAIS WHERE PROPRIEDADE ='00649' 
								AND VALOR_PROPRIEDADE='SIM')	
						ENDTEXT 
					f_select(xsql, 'cur_material')
					SELECT cur_material
					IF !f_vazio(cur_material.material)
						xConf = ''
							SCAN 
								xConf = xConf + cur_material.material + ','
							ENDSCAN
						MESSAGEBOX("Existem Materiais de Composição Cadastrados, Material: " + LEFT(xConf ,LEN(xConf )-1), 0+64,"Atenção")
					ENDIF 	
									
					
					*--Fim Aviso de existencia de material de composição - Perla - 09112018
					
					
					
				case UPPER(xmetodo) == 'USR_REFRESH' 
					xalias=alias()
						IF Thisformset.P_tool_status = 'P'
							If type('thisformset.lx_form1.PgPrincipal.page1.lx_PAGEFRAME1.page2.LX_PAGEFRAME1.page2.Tx_alterado_por')<>'U'
							
								Text To xSelLogFicha TextMerge Noshow
																	
									Select top 1 USUARIO 
									from MIT_LOG_FICHA_TECNICA 
									where produto =	LTRIM(RTRIM('<<v_produtos_00.produto>>'))
									order by data_hora desc
									 	
								Endtext
								f_select(xSelLogFicha,"xLogFicha")
								
								thisformset.lx_form1.PgPrincipal.page1.lx_PAGEFRAME1.page2.LX_PAGEFRAME1.page2.Tx_alterado_por.Value       = UPPER(ALLTRIM(xLogFicha.USUARIO)) 
								thisformset.lx_form1.PgPrincipal.page1.lx_PAGEFRAME1.page2.LX_PAGEFRAME1.page2.Tx_alterado_por.ToolTipText = UPPER(ALLTRIM(xLogFicha.USUARIO)) 
								
							Endif

						ENDIF	
						
							
						*** Bloqueio ficha tecnica**	
						If type('thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan')<>'U'		
							
							If Thisformset.P_tool_status $ 'PA'					
										
										TEXT TO xSelProgSemOP TEXTMERGE NOSHOW
								
											Select count(*) Qtde_prog_s_OP 
											from producao_prog_prod a
												join prop_producao_programa b on a.PROGRAMACAO = b.PROGRAMACAO and b.PROPRIEDADE = '00038'

											WHERE B.VALOR_PROPRIEDADE = 'MOSTRUARIO' and 
												  a.QTDE_SALDO_EMITIR_OP > 0 and a.ANM_MATAR_SALDO = 0 and
												  a.PRODUTO = LTRIM(RTRIM('<<v_produtos_00.produto>>')) 
										ENDTEXT
										f_select(xSelProgSemOP,"Cur_ProgMost_S_OP",ALIAS()) && PRODUTO COM OP DE MOSTRUÁRIO PENDENTE EMISSÃO
										
										f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

										sele v_produtos_00
										replace  DATA_FINALIZA_TEC 		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS,xFinFichaMost.DATA_FINAL_PANOS,''),'')
										replace	 TEC_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS,'SIM','NAO'),'')
										replace  QTDE_FINALIZADA_TEC 	With NVL(xFinFichaMost.QTDE_FINALIZADA_PANOS,0)
										
										replace  DATA_FINALIZA_AV 		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS,xFinFichaMost.DATA_FINAL_AV,''),'')
										replace	 AV_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS,'SIM','NAO'),'')
										replace  QTDE_FINALIZADA_AV 	With NVL(xFinFichaMost.QTDE_FINALIZADA_AVIAMENTOS,0)
										
										replace  DATA_FINALIZA_MOST 	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO,xFinFichaMost.DATA_FINAL_MOST,''),'')
										replace	 MOST_FINALIZADO    	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO,'SIM','NAO'),'')
										replace  QTDE_FINALIZADA_MOST 	With NVL(xFinFichaMost.QTDE_FINALIZADA_MOST,0)
										
										replace  DATA_FINALIZA_IMP 		With NVL(IIF(xFinFichaMost.FINALIZA_IMP,xFinFichaMost.DATA_FINAL_IMP,''),'')
										replace	 IMP_FINALIZADO    	With NVL(IIF(xFinFichaMost.FINALIZA_IMP,'SIM','NAO'),'')
										replace  QTDE_FINALIZADA_IMP 	With NVL(xFinFichaMost.QTDE_FINALIZADA_IMP,0)
								
									**SET STEP on
									
										With thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan
											.BackColor 		= Iif(v_produtos_00.TEC_FINALIZADO='SIM', RGB(0,255,0)      , RGB(255,0,0) )
											.ToolTipText 	= Iif(v_produtos_00.TEC_FINALIZADO='SIM', "Liberar FT Panos", "Finalizar FT Panos" )
											.Caption 		= Iif(v_produtos_00.TEC_FINALIZADO='SIM', "Lib. Panos"      , "Fin. Panos" )
										EndWith

										With thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av
											.BackColor 		= Iif(v_produtos_00.AV_FINALIZADO='SIM', RGB(0,255,0)           , RGB(255,0,0) )
											.ToolTipText 	= Iif(v_produtos_00.AV_FINALIZADO='SIM', "Liberar FT Aviamentos", "Finalizar FT Aviamentos" )
											.Caption 		= Iif(v_produtos_00.AV_FINALIZADO='SIM', "Lib. Avia."           , "Fin. Avia." )
										EndWith

										With thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most
											.BackColor 		= Iif(v_produtos_00.MOST_FINALIZADO='SIM', RGB(0,255,0)        , RGB(255,0,0) )
											.BackColor 		= Iif(v_produtos_00.MOST_FINALIZADO='SIM' and Cur_ProgMost_S_OP.Qtde_prog_s_OP>0,RGB(255,255,0),.BackColor)
											.ToolTipText 	= Iif(v_produtos_00.MOST_FINALIZADO='SIM', "Liberar Mostruario", "Finalizar Mostruario" )
											.Caption 		= Iif(v_produtos_00.MOST_FINALIZADO='SIM', "Lib. Mostr."       , "Fin. Mostr." )
										EndWith
										
										With thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_imp
											.BackColor 		= Iif(v_produtos_00.IMP_FINALIZADO='SIM', RGB(0,255,0)        , RGB(255,0,0) )
											.BackColor 		= Iif(v_produtos_00.IMP_FINALIZADO='SIM' and Cur_ProgMost_S_OP.Qtde_prog_s_OP>0,RGB(255,255,0),.BackColor)
											.ToolTipText 	= Iif(v_produtos_00.IMP_FINALIZADO='SIM', "Liberar Importado", "Finalizar Importado" )
											.Caption 		= Iif(v_produtos_00.IMP_FINALIZADO='SIM', "Lib. Imp."       , "Fin. Imp." )
										EndWith
							Else
								With thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1
									.btn_anm_finaliza_pan.BackColor = RGB(171,92,84) 			
									.btn_anm_finaliza_pan.Caption   = "F\L Panos"	
								
									.btn_anm_finaliza_av.BackColor = RGB(171,92,84) 			
									.btn_anm_finaliza_av.Caption   = "F\L Avia."
								
									.btn_anm_finaliza_most.BackColor = RGB(171,92,84) 			
									.btn_anm_finaliza_most.Caption   = "F\L Mostr."
									
									.btn_anm_finaliza_imp.BackColor = RGB(171,92,84) 			
									.btn_anm_finaliza_imp.Caption   = "F\L Import."
								EndWith
							Endif		

						Endif
						*** Bloqueio ficha tecnica**
						
				    if	!f_vazio(xalias)	
					  sele &xalias 
				    ENDIF
					
			
					case upper(xmetodo) == 'USR_ITEN_DELETE_BEFORE' 
						
						xalias=alias()
							
							*** Bloqueio ficha tecnica**
							If Thisformset.lX_FORM1.OptBarra.value = 1
								If Thisformset.lx_Form1.pgPrincipal.Page1.lx_PageFrame1.ActivePage =1
								
									*** Verifica material nos pedidos
									F_Select("SELECT DISTINCT 1 AS EXISTE FROM PRODUTO_VERSAO_MATERIAL WHERE PRODUTO = ?v_produtos_00.produto","xMatFicha")
									Sele xMatFicha

									If !F_Vazio(xMatFicha.existe)
										MESSAGEBOX("Não é possível excluir, favor zerar o consumo !!!",0+16)
										USE IN xMatFicha
										** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
											Local xFiltro
			
											Select v_Produtos_Ficha_01_Cor

											xFiltro = Set("Filter")
											Set Filter To 
											Go top 

											REPLACE All APAGADO WITH 0 For Item = v_Produtos_Ficha_01.Item
											Set Filter To &xFiltro
											Go top 
											Thisformset.lx_Form1.LockScreen = .F.
											Thisformset.l_desenhista_filhas_exclui_apos()
											** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
											
											Thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.SetFocus()
											Return .F.
									Endif
										*** Fim Verifica material nos pedidos
									
									
									*** Liberar alguns materiais - Lucas Miranda - 31/01/2018
									If USED("CurLacreAmarelo")
										USE IN CurLacreAmarelo
									Endif	

									If USED("CurPermiteLacre")
										USE IN CurPermiteLacre
									Endif

									f_select("select * from FX_GS_CONSULTA_LACRE_AMARELO(?v_produtos_00.produto)","CurLacreAmarelo",ALIAS())
									f_select("select * from GS_TB_MATERIAIS_RECORRENTES where permissao_lacre = 1 and material = ?v_produtos_ficha_01.material","CurPermiteLacre",ALIAS())					
									*** Verifica se encontrou os 2 cursores, se encontrar libera ***
									*** Fim - Liberar alguns materiais - Lucas Miranda - 31/01/2018
									
									sele ppRL_ANM_VERIFICA_FIN_FT_PA
									LOCATE FOR REDE_LOJAS = v_produtos_00.rede_lojas
									If FOUND() AND ppRL_ANM_VERIFICA_FIN_FT_PA.valor_atual = 'SIM'
										
										If !(Cur_ProgMost_S_OP.Qtde_prog_s_OP > 0 AND v_produtos_00.MOST_FINALIZADO= 'SIM')
													
												If v_produtos_00.IMP_FINALIZADO = 'SIM' 
													TEXT TO xSelMatImp NOSHOW TEXTMERGE
														SELECT MATERIAL
														FROM MATERIAIS (nolock) MATERIAIS
														JOIN (SELECT DISTINCT FORNECEDOR 
																FROM (SELECT FORNECEDOR FROM FORNECEDORES  (nolock) WHERE FORNECEDOR IN (SELECT NOME_CLIFOR FROM CADASTRO_CLI_FOR WHERE UF='EX')
																		UNION ALL
																	  SELECT FORNECEDOR FROM PROP_FORNECEDORES  (nolock) WHERE PROPRIEDADE = '00510' AND VALOR_PROPRIEDADE = 'SIM') A ) FORNECEDORES
														ON MATERIAIS.FABRICANTE = FORNECEDORES.FORNECEDOR
														WHERE MATERIAIS.MATERIAL = '<<v_Produtos_Ficha_01_Cor.material>>'
													ENDTEXT
													f_select(xSelMatImp,"CurMatImp",ALIAS())
													If RECCOUNT("CurMatImp") > 0 AND !(RECCOUNT("CurLacreAmarelo") > 0 AND RECCOUNT("CurPermiteLacre") > 0)
														USE IN CurMatImp
														
														MESSAGEBOX("Material Importado Finalizado !"+CHR(13)+"Você não tem permissão para excluir esse item.",0+16,"Bloqueio Ficha Técnica")
													
														** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
														Local xFiltro
					
														Select v_Produtos_Ficha_01_Cor

														xFiltro = Set("Filter")
														Set Filter To 
														Go top 

														REPLACE All APAGADO WITH 0 For Item = v_Produtos_Ficha_01.Item
														Set Filter To &xFiltro
														Go top 
														Thisformset.lx_Form1.LockScreen = .F.
														Thisformset.l_desenhista_filhas_exclui_apos()
														** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
														
														Thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.SetFocus()
														Return .F.
													Endif
												Endif
											
												Sele CurMaterialTipo
												LOCATE FOR tipo = v_produtos_ficha_01.tipo
											
												If v_produtos_00.TEC_FINALIZADO = 'SIM' AND CurMaterialTipo.indica_tecido AND !(RECCOUNT("CurLacreAmarelo") > 0 AND RECCOUNT("CurPermiteLacre") > 0)
												**AND !Thisformset.pp_ANM_ALT_CONS_PAN ** Para excluir item somente liberando
												
													MESSAGEBOX("Tecido Finalizado !"+CHR(13)+"Você não tem permissão para excluir esse item.",0+16,"Bloqueio Ficha Técnica")
													
													** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
													Local xFiltro
					
													Select v_Produtos_Ficha_01_Cor

													xFiltro = Set("Filter")
													Set Filter To 
													Go top 

													REPLACE All APAGADO WITH 0 For Item = v_Produtos_Ficha_01.Item
													Set Filter To &xFiltro
													Go top 
													Thisformset.lx_Form1.LockScreen = .F.
													Thisformset.l_desenhista_filhas_exclui_apos()
													** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
													
													Thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.SetFocus()
													Return .F.
												Endif
									
												If v_produtos_00.AV_FINALIZADO = 'SIM' AND !CurMaterialTipo.indica_tecido AND !(RECCOUNT("CurLacreAmarelo") > 0 AND RECCOUNT("CurPermiteLacre") > 0)
												**AND !Thisformset.pp_ANM_ALT_CONS_AV ** Para excluir item somente liberando
												
													MESSAGEBOX("Aviamento Finalizado !"+CHR(13)+"Você não tem permissão para excluir esse item.",0+16,"Bloqueio Ficha Técnica")
													
													** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
													Local xFiltro
					
													Select v_Produtos_Ficha_01_Cor

													xFiltro = Set("Filter")
													Set Filter To 
													Go top 

													REPLACE All APAGADO WITH 0 For Item = v_Produtos_Ficha_01.Item
													Set Filter To &xFiltro
													Go top 
													Thisformset.lx_Form1.LockScreen = .F.
													Thisformset.l_desenhista_filhas_exclui_apos()
													** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
													
													Thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.SetFocus()
													Return .F.
												Endif
										Else
											MESSAGEBOX("OP de mostruário não emitida!"+CHR(13)+"Você não tem permissão para excluir este item.",0+16,"Bloqueio Ficha Técnica")
													
											** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
											Local xFiltro
			
											Select v_Produtos_Ficha_01_Cor

											xFiltro = Set("Filter")
											Set Filter To 
											Go top 

											REPLACE All APAGADO WITH 0 For Item = v_Produtos_Ficha_01.Item
											Set Filter To &xFiltro
											Go top 
											Thisformset.lx_Form1.LockScreen = .F.
											Thisformset.l_desenhista_filhas_exclui_apos()
											** Desfaz tudo que a Linx executa do l_desenhista_filha_antes **
										
											Return .F.
										Endif
									Endif
								Endif
							Endif
							*** Bloqueio ficha tecnica**
								
						if	!f_vazio(xalias)	
						  sele &xalias 
					    endif
					
					case UPPER(xmetodo) == 'USR_SAVE_BEFORE' 
					
						xalias=alias()
						
						** Projeto Check de Consistência na FT Etiqueta - Lucas Miranda - Solicitante: Flavia Pinho
						If Thisformset.pp_GS_BLOQUEIA_ETIQ_GRADE_FT = .t.
							xGradeMaterial=''

							if used("curGrade") 
								USE IN curGrade
							endif

							if used("vtmp_gs_grade_ft_mat_prod") 
								USE IN vtmp_gs_grade_ft_mat_prod
							endif
													
							if used("CurFTProduto") 
								USE IN CurFTProduto 
							ENDIF
												
							CREATE CURSOR CurFTProduto(PRODUTO C(12),MATERIAL C(11), LARGURA_MATERIAL C(10))

							select v_produtos_ficha_01
							GO TOP
							Scan
								If (consumo_p_tamanho = .t. and v_produtos_ficha_01.grupo ='ETIQUETAS' AND ;
																   (v_produtos_ficha_01.c1 > 0 OR v_produtos_ficha_01.c2 > 0 OR v_produtos_ficha_01.c3 > 0 OR ;
																	v_produtos_ficha_01.c4 > 0 OR v_produtos_ficha_01.c5 > 0 OR v_produtos_ficha_01.c6 > 0 OR ;
																	v_produtos_ficha_01.c7 > 0 OR v_produtos_ficha_01.c7 > 0 OR v_produtos_ficha_01.c8 > 0 OR ;
																	v_produtos_ficha_01.c9 > 0 OR v_produtos_ficha_01.c10 > 0 OR v_produtos_ficha_01.c11 > 0))
									INSERT INTO CurFTProduto(PRODUTO, MATERIAL, LARGURA_MATERIAL) VALUES (v_produtos_00.produto,v_produtos_ficha_01.material, v_produtos_ficha_01.largura_material)

								Endif									
								Sele v_produtos_ficha_01									
							Endscan

							Sele CurFTProduto 
													
							f_select("select a.produto,b.* from produtos a join produtos_tamanhos b on a.grade = b.grade where a.produto=?v_produtos_00.produto","curGrade")

							
							Select distinct GRADE_FT_PROD.produto, GRADE_FT_PROD.material, GRADE_FT_PROD.grade_material, GRADE_FT_PROD.grade_produto, ;
									IIF(SUM(tam_1+tam_2+tam_3+tam_4+tam_5+tam_6+tam_7+tam_8+tam_9+tam_10+tam_11+tam_12+tam_13+tam_14+tam_15+tam_16+tam_17+tam_18)=0,'ERRO','OK') as STATUS_GRADE ;
							 FROM ; 
								(SELECT a.produto, a.material, a.largura_material as grade_material, b.grade as grade_produto, ;
								   IIF(b.tamanho_1 = a.largura_material,1,0) as tam_1, ;
								   IIF(b.tamanho_2 = a.largura_material,1,0) as tam_2, ;
							   	   IIF(b.tamanho_3 = a.largura_material,1,0) as tam_3, ;
							   	   IIF(b.tamanho_4 = a.largura_material,1,0) as tam_4, ;
							   	   IIF(b.tamanho_5 = a.largura_material,1,0) as tam_5, ;
							   	   IIF(b.tamanho_6 = a.largura_material,1,0) as tam_6, ;
							   	   IIF(b.tamanho_7 = a.largura_material,1,0) as tam_7, ;
							   	   IIF(b.tamanho_8 = a.largura_material,1,0) as tam_8, ;
							   	   IIF(b.tamanho_9 = a.largura_material,1,0) as tam_9, ;
							   	   IIF(b.tamanho_10 = a.largura_material,1,0) as tam_10, ;
							   	   IIF(b.tamanho_11 = a.largura_material,1,0) as tam_11, ;
							   	   IIF(b.tamanho_12 = a.largura_material,1,0) as tam_12, ;
							   	   IIF(b.tamanho_13 = a.largura_material,1,0) as tam_13, ;
							   	   IIF(b.tamanho_14 = a.largura_material,1,0) as tam_14, ;
							   	   IIF(b.tamanho_15 = a.largura_material,1,0) as tam_15, ;
							   	   IIF(b.tamanho_16 = a.largura_material,1,0) as tam_16, ;
							   	   IIF(b.tamanho_17 = a.largura_material,1,0) as tam_17, ;
							   	   IIF(b.tamanho_18 = a.largura_material,1,0) as tam_18 ;
							 FROM CurFTProduto a ;
							join curGrade b ON a.produto = b.produto ) GRADE_FT_PROD ;
							GROUP BY GRADE_FT_PROD.produto, GRADE_FT_PROD.material, GRADE_FT_PROD.grade_material, GRADE_FT_PROD.grade_produto ;
							HAVING SUM(tam_1+tam_2+tam_3+tam_4+tam_5+tam_6+tam_7+tam_8+tam_9+tam_10+tam_11+tam_12+tam_13+tam_14+tam_15+tam_16+tam_17+tam_18)=0 ;
							INTO CURSOR  vtmp_gs_grade_ft_mat_prod
							If RECCOUNT() > 0
								Sele vtmp_gs_grade_ft_mat_prod
								Go Top
								Scan
									If !ALLTRIM(vtmp_gs_grade_ft_mat_prod.material) $ xGradeMaterial
										xGradeMaterial = xGradeMaterial + ALLTRIM(vtmp_gs_grade_ft_mat_prod.material) + ' / ' 
									Endif                 
								Sele vtmp_gs_grade_ft_mat_prod
								Endscan
							Endif

							If !F_VAZIO(xGradeMaterial)
								MESSAGEBOX('Grade do Material diferente da grade do Produto !!!'+ CHR(13) + 'Material: ' + LEFT(xGradeMaterial,LEN(xGradeMaterial)-2) + CHR(13) + CHR(13) + 'FAVOR VERIFICAR !!!',0+16,"ERRO GRADE")
								Return .F.
							Endif 
						Endif
						** Fim - Projeto Check de Consistência na FT Etiqueta
						
						if	!f_vazio(xalias)	
						  sele &xalias 
					    endif
						
					case upper(xmetodo) == 'USR_SAVE_AFTER'
					
					
					      ************** AJUSTANDO A RESTRIÇÃO DE LAVAGEM DO PRODUTO, IGUALANDO À RESTRIÇÃO DE LAVAGEM DO MATERIAL PRINCIPAL ***************

				
					xAlias=Alias()
					TEXT TO xProp_lacre TEXTMERGE noshow
						SELECT DISTINCT PRODUTOS.PRODUTO, PROPRIEDADE_VALIDA.VALOR_PROPRIEDADE
						FROM PRODUTOS
						JOIN PRODUTOS_STATUS ON PRODUTOS_STATUS.STATUS_PRODUTO = PRODUTOS.STATUS_PRODUTO
						LEFT JOIN PROPRIEDADE_VALIDA ON PROPRIEDADE_VALIDA.VALOR_PROPRIEDADE = PRODUTOS_STATUS.DESC_STATUS_PRODUTO
						WHERE PRODUTOS_STATUS.DESC_STATUS_PRODUTO IN (SELECT VALOR_PROPRIEDADE AS STATUS_PRODUTO FROM PROPRIEDADE_VALIDA WHERE PROPRIEDADE = '00629')
						AND PRODUTOS.PRODUTO =  ('<<ALLTRIM(v_produtos_00.PRODUTO)>>')
					endtext
					f_select(xProp_lacre,'cur_Prop_lacre')
					SELECT cur_prop_lacre
					
						
					IF F_VAZIO(cur_Prop_lacre.valor_propriedade)
									SELECT v_produtos_ficha_01
								TEXT TO xAjustaRestLavagem NOSHOW TEXTMERGE
										
										UPDATE PRODUTOS
										SET PRODUTOS.RESTRICAO_LAVAGEM = MATERIAIS.RESTRICAO_LAVAGEM
										FROM PRODUTOS (NOLOCK)
										JOIN PRODUTO_VERSAO_MATERIAL (NOLOCK) ON PRODUTOS.PRODUTO = PRODUTO_VERSAO_MATERIAL.PRODUTO
										JOIN MATERIAIS (NOLOCK) ON MATERIAIS.MATERIAL = PRODUTO_VERSAO_MATERIAL.MATERIAL
										WHERE PRODUTOS.PRODUTO = '<<ALLTRIM(v_produtos_ficha_01.produto)>>'
										AND PRODUTO_VERSAO_MATERIAL.MATERIAL_PRINCIPAL = '1'
										AND MATERIAIS.RESTRICAO_LAVAGEM IS NOT NULL

								ENDTEXT				
							F_SELECT(xAjustaRestLavagem, 'Cursorv_produtos_ficha_01')	
				
					ENDIF	
					
				
				    if	!f_vazio(xAlias)	
					  sele &xAlias 
				    ENDIF
      ************************** FIM DO AJUSTE DE RESTRIÇÃO DE LAVAGEM       **************************
					
					
					
					
					
					
						xalias=alias()
						** Projeto Check de Consistência na FT Etiqueta - Lucas Miranda - Solicitante: Flavia Pinho
						If Thisformset.pp_GS_BLOQUEIA_ETIQ_GRADE_FT = .F.
							Sele v_produtos_ficha_01
							Set Filter To v_produtos_ficha_01.varia_material_tamanho = .t.
							if RECCOUNT()>0
								MESSAGEBOX("Favor conferir se as etiquetas estão de"+CHR(13)+ "acordo com a grade do produto !!!!",0+16)
							endif
						Endif
						** Fim - Projeto Check de Consistência na FT Etiqueta
						
						if	!f_vazio(xalias)	
						  sele &xalias 
					    endif				
			otherwise
			return .t.				
		endcase
	endproc
	
	* Cria Procedure para chamar métódo no activate da Pag2
	*** Bloqueio ficha tecnica**
	Procedure ANM_USR_ACTIVATE_PAG2 
		
		IF o_040001.p_tool_status = 'A'
		
			IF !f_vazio(v_produtos_ficha_01.material)	
				thisformset.LX_FORM1.pgPrincipal.page1.lx_pageframe1.page2.Lx_pageframe1.page1.Tv_MATERIAL.Enabled = .F. 
			ELSE
				thisformset.LX_FORM1.pgPrincipal.page1.lx_pageframe1.page2.Lx_pageframe1.page1.Tv_MATERIAL.Enabled = .T. 	
			ENDIF	

		ENDIF
		
	Endproc
	*** Bloqueio ficha tecnica**
	
	 	Procedure GS_Confere_status_material
		LOCAL xdestrava
		xdestrava = 0
		
		IF o_040001.p_tool_status $ 'A,I'
			SELECT v_produtos_ficha_01
			GO TOP
			Scan
				IF !v_produtos_ficha_01.GS_STATUS_ESTAMPA = 'Aprovado' OR ;
				   !v_produtos_ficha_01.GS_STATUS_ESTAMPA = 'Aprovado Produção' OR;
				   !v_produtos_ficha_01.GS_STATUS_ESTAMPA = 'Aprovado Prazo'	
					xdestrava = 1
							
				ENDIF	
			ENDSCAN
			
			if xdestrava = 1
				RETURN .f.
			ELSE
				RETURN .t.
			ENDif
		ENDIF
		
		Endproc
enddefine

**************************************************
*-- Class:        lb_alterado_por(c:\pastas\anm_class\lb_conferido_por.vcx)
*-- ParentClass:  label
*-- BaseClass:    label
*-- Time Stamp:   03/07/14 10:37:02 AM
*
DEFINE CLASS lb_alterado_por AS lx_label


	FontName = "Tahoma"
	FontSize = 8
	BackStyle = 0
	Caption = "Modificado por:"
	Visible = .t.
	Height = 14
	Left = 291
	Top = 30
	Width = 71
	Name = "lb_alterado_por"


ENDDEFINE
*
*-- EndDefine: lb_alterado_por
**************************************************

**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS tx_alterado_por AS lx_textbox_base 


	FontName = "Tahoma"
	FontSize = 8
	Visible = .t.
	Enabled = .F.
	Height = 19
	Left = 370
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 29
	Width = 140
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "tx_alterado_por"


ENDDEFINE
*
*-- EndDefine: tx_alterado_por
**************************************************
**************************************************
*-- Class:        ck_anm_rota_conserto (c:\linx desenv\classes lucas\ck_anm_rota_conserto.vcx)
*-- ParentClass:  lx_checkbox (c:\linx spk novo lucas\linx\exclusivos\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   03/16/16 04:54:11 PM
*
DEFINE CLASS ck_anm_rota_conserto AS lx_checkbox

 
	Top = 120
	Left = 550
	Width = 116
	FontBold = .T.
	Alignment = 0
	Caption = "Rota de Conserto"
	ControlSource = "V_produtos_tab_operacoes_00.ROTA_CONSERTO"
	Name = "CK_ANM_ROTA_CONSERTO"
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: ck_anm_rota_conserto
**************************************************

**************************************************
*-- Class:        btn_anm_finaliza_pan (c:\users\lucas.miranda\desktop\projetos\desenvolvimento\2016\produção\ft\btn_anm_finaliza_pan.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/16/16 10:07:13 AM
*
DEFINE CLASS btn_anm_finaliza_pan AS commandbutton


	Top = 32
	Left = 200
	Height = 20
	Width = 62
	FontSize = 7
	Caption = "F\L Panos"
	BackColor = RGB(171,92,84)
	Visible = .T.
	Name = "btn_anm_finaliza_pan"


	PROCEDURE Click
	
		If (Thisformset.p_tool_status = 'P') OR (Thisformset.p_tool_status = 'A' AND xbloqueio=1)
			
			**** VALIDA APROVAÇÃO DO MATERIAL ****
			xMsgEstampa = ''
			IF xbloqueio = 0 && Não travar o que já estava bloqueado
				TEXT TO xSql TEXTMERGE NOSHOW 
					SELECT DISTINCT RTRIM(A.MATERIAL)+' / '+RTRIM(A.COR_MATERIAL)+': '+RTRIM(E.GS_STATUS_ESTAMPA) AS RETORNO_ESTAMPA
					FROM PRODUTOS_FICHA_COR (NOLOCK) A 
					   JOIN PRODUTOS (NOLOCK) P ON A.PRODUTO = P.PRODUTO
					   JOIN DBO.FXANM_ConsultaVarString(DBO.FX_ANM_PARAMETRO_USER('ANM_VALIDA_ESTAMPA_FT')) R ON P.REDE_LOJAS = R.Valores
					   JOIN MATERIAIS (NOLOCK) B ON A.MATERIAL = B.MATERIAL
					   LEFT JOIN DBO.FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_MATERIAL_FT_PA') D ON B.TIPO = REPLACE(D.VALOR_ATUAL,CHAR(39),'') 
					   JOIN MATERIAIS_CORES (NOLOCK) E ON A.MATERIAL = E.MATERIAL AND A.COR_MATERIAL = E.COR_MATERIAL AND ISNULL(E.GS_STATUS_ESTAMPA,'')<>''
					   LEFT JOIN (SELECT VALORES AS VALOR_ATUAL 
									FROM DBO.FXANM_ConsultaVarString((SELECT VALOR_ATUAL FROM PARAMETROS (NOLOCK) WHERE PARAMETRO = 'ANM_ESTAMPA_LIBERADA')) )  F 
					   ON E.GS_STATUS_ESTAMPA = F.VALOR_ATUAL	
					WHERE  A.PRODUTO = '<<v_produtos_00.produto>>' AND F.VALOR_ATUAL IS NULL 
				ENDTEXT 
				f_select(xSql,"xCurBloqueiaMat")

				Sele xCurBloqueiaMat
				GO TOP
				IF RECCOUNT()>0 
					SCAN 
						xMsgEstampa = xMsgEstampa + CHR(13)+ ALLTRIM(xCurBloqueiaMat.RETORNO_ESTAMPA)
						
						Sele xCurBloqueiaMat
					ENDSCAN
				ENDIF
			ENDIF
								sele ppRL_ANM_VERIFICA_FIN_FT_PA
								LOCATE FOR REDE_LOJAS = v_produtos_00.rede_lojas
								If FOUND() AND ppRL_ANM_VERIFICA_FIN_FT_PA.valor_atual = 'SIM'

						
									If v_produtos_00.TEC_FINALIZADO = 'NAO'
											
											If Thisformset.pp_anm_bloq_ft_pa
												
												xPerg = 0
												IF xbloqueio = 0
													xPerg = Messagebox("Deseja Finalizar a Ficha Técnica do tipo Panos?",4+32,"Bloqueio Ficha Técnica")
												ENDIF
														
											If xPerg = 6 OR xbloqueio = 1
												
												IF f_vazio(xMsgEstampa)
															
															TEXT TO xVerDataProg NOSHOW textmerge
																SELECT distinct TOP 1 A.PROGRAMACAO, A.PRODUTO, A.ENTREGA_INICIAL, 
																MONTH(A.ENTREGA_INICIAL) AS MES_ENTREGA_INICIAL, YEAR(A.ENTREGA_INICIAL) AS  ANO_ENTREGA_INICIAL,
																c.data_panos as data_panos, convert(date,getdate(),103) as data_atual,
																DATEDIFF(DAY,convert(date,c.data_panos,103), convert(date,getdate(),103)) as ultrapassou,
																case when MONTH(A.ENTREGA_INICIAL) = 1 then 'JANEIRO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 2 then 'FEVEREIRO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 3 then 'MARÇO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 4 then 'ABRIL' 
																	 when MONTH(A.ENTREGA_INICIAL) = 5 then 'MAIO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 6 then 'JUNHO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 7 then 'JULHO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 8 then 'AGOSTO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 9 then 'SETEMBRO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 10 then 'OUTUBRO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 11 then 'NOVEMBRO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 12 then 'DEZEMBRO' 
																end as MESES
																
																from producao_prog_prod (nolock) a
																JOIN PROP_PRODUCAO_PROGRAMA (nolock) B
																ON A.PROGRAMACAO = B.PROGRAMACAO
																AND B.PROPRIEDADE = '00038'
																join (select DISTINCT CODIGO_MARCA, a.canal, b.TIPO_PROGRAMACAO, MARCA, COLECAO, MES, ANO, A.QUINZENA,
																		DATA_PROGRAMACAO, DATA_PANOS
																		from GS_CALENDARIOS_REPROGRAMACAO (nolock) a 
																		join WGS_CANAL_CALENDARIO b
																		on a.CANAL = b.CANAL) c
																on MONTH(A.ENTREGA_INICIAL) = c.mes
																and year(A.ENTREGA_INICIAL) = c.ano
																AND CASE WHEN DAY(a.ENTREGA_INICIAL) >= 1 AND DAY(a.ENTREGA_INICIAL) <= 14 THEN '1' ELSE '2' END = C.QUINZENA
																and B.VALOR_PROPRIEDADE = c.TIPO_PROGRAMACAO
																and codigo_marca = ?v_produtos_00.rede_lojas
																where produto = ?V_PRODUTOS_00.PRODUTO
																and b.VALOR_PROPRIEDADE not in (select VALOR_ATUAL from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_PROG_MOSTR'))
																and a.QTDE_PROGRAMADA > 0
																and	DATEDIFF(DAY,convert(date,c.data_panos,103), convert(date,getdate(),103)) > 0
																order by ENTREGA_INICIAL desc
															ENDTEXT 
															F_SELECT(xVerDataProg, 'CUR_VERDATAPROG')

															SELECT CUR_VERDATAPROG 														
															
															TEXT TO XPEDIDO NOSHOW TEXTMERGE
																SELECT PRODUTO	FROM 
																(SELECT PRODUTO FROM COMPRAS_PRODUTO A
																JOIN COMPRAS B
																ON A.PEDIDO = B.PEDIDO
																AND B.TIPO_COMPRA NOT LIKE '%CONSERT%'
																JOIN PROP_PRODUCAO_PROGRAMA C
																ON B.PROGRAMACAO = C.PROGRAMACAO
																AND C.PROPRIEDADE = '00038'
																WHERE A.QTDE_ENTREGAR > 0
																AND C.VALOR_PROPRIEDADE not in (select VALOR_ATUAL from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_PROG_MOSTR'))
																UNION
																SELECT PRODUTO FROM PRODUCAO_ORDEM A
																JOIN PROP_PRODUCAO_PROGRAMA C
																ON A.PROGRAMACAO = C.PROGRAMACAO
																AND C.PROPRIEDADE = '00038'
																WHERE TIPO_PROCESSO = 0
																AND STATUS <> 'E'
																AND C.VALOR_PROPRIEDADE not in (select VALOR_ATUAL from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_PROG_MOSTR'))
																) A
																WHERE A.PRODUTO = ?V_PRODUTOS_00.PRODUTO
															ENDTEXT
															F_SELECT(XPEDIDO, 'CUR_PEDIDO')
															
															Sele CUR_PEDIDO
															
															IF xbloqueio=0
															
																If !f_vazio(CUR_VERDATAPROG.ultrapassou)
																	IF !F_Vazio(CUR_PEDIDO.produto) AND V_PRODUTOS_00.qtde_finalizada_tec > 0															   			
																		MESSAGEBOX('Atenção, Calendário Panos!'+CHR(13)+'Data Panos: '+DTOC(CUR_VERDATAPROG.data_panos)+CHR(13)+'Essa data é limite para o mês de '+ALLTRIM(CUR_VERDATAPROG.meses)+ ' e para os meses anteriores !'+CHR(13)+CHR(13)+'Data Atual: '+DTOC(DATE())+CHR(13)+'Ultrapassada a data Calendário !!!'+CHR(13)+CHR(13)+'Verificar se deve recalcular os Materiais na O.P./Pedido',0+48,'CALENDÁRIO PANOS')
																	Else	
																		MESSAGEBOX('Atenção, Calendário Panos!'+CHR(13)+'Data Panos: '+DTOC(CUR_VERDATAPROG.data_panos)+CHR(13)+'Essa data é limite para o mês de '+ALLTRIM(CUR_VERDATAPROG.meses)+ ' e para os meses anteriores !'+CHR(13)+CHR(13)+'Data Atual: '+DTOC(DATE())+CHR(13)+'Ultrapassada a data Calendário !!!',0+48,'CALENDÁRIO AVIAMENTOS')
																	Endif																
																	
																ELSE 
																	If !F_Vazio(CUR_PEDIDO.produto) AND V_PRODUTOS_00.qtde_finalizada_tec > 0
																		*!*f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_panos=1, bt_finaliza_panos = 0, data_final_panos=CONVERT(VARCHAR(10),getdate(),112) where produto=?v_produtos_00.produto")
																		thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.BackColor = RGB(0,255,0)
																		thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.ToolTipText = "Liberar FT Panos"
																		thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.Caption = 'Lib. Panos'																	
																		Messagebox('Finalizada Com Sucesso !'+CHR(13)+CHR(13)+'Verificar se deve recalcular os Materiais na O.P./Pedido',0+64,'Bloqueio Ficha Técnica')
																	ELSE 
																		*!*f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_panos=1, bt_finaliza_panos = 0, data_final_panos=CONVERT(VARCHAR(10),getdate(),112) where produto=?v_produtos_00.produto")
																		thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.BackColor = RGB(0,255,0)
																		thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.ToolTipText = "Liberar FT Panos"
																		thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.Caption = 'Lib. Panos'																	
																		Messagebox('Finalizada Com Sucesso !',0+64,"Bloqueio Ficha Técnica")
																	Endif
																Endif	
															ENDIF
															f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_panos=1, bt_finaliza_panos = 0, data_final_panos=CONVERT(VARCHAR(10),getdate(),112) where produto=?v_produtos_00.produto")
														USE IN CUR_PEDIDO
														USE IN CUR_VERDATAPROG
																												
														f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

														sele v_produtos_00
														replace  DATA_FINALIZA_TEC 		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS= .T.,xFinFichaMost.DATA_FINAL_PANOS,''),'')
														replace	 TEC_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS= .T.,'SIM','NAO'),'')
														replace  QTDE_FINALIZADA_TEC 	With NVL(xFinFichaMost.QTDE_FINALIZADA_PANOS,0)
													
														Thisformset.Refresh()
													ELSE
														MESSAGEBOX('Operação não concluída,algum pano ainda não está aprovado.'+CHR(13)+CHR(13)+xMsgEstampa, 64+0,"Atenção!")
														RETURN .f.
													endif	
												Else
													Return .F.
												ENDIF
												xbloqueio=0
											Else		
												MESSAGEBOX('Operação não concluída,algum pano ainda não está aprovado.'+CHR(13)+CHR(13)+xMsgEstampa,64+0,"Atenção!")
												Return .F.
											Endif
									
									Else
											If Thisformset.pp_anm_desbloq_ft_pa	
												If Messagebox("Deseja Liberar Panos ?",4+32,"Bloqueio Ficha Técnica") = 6
							
													 IF THISFORMSET.PP_GS_DESBLOQ_FICHA_TEC
														IF MESSAGEBOX("Deseja NÃO contabilizar o log de desbloqueio?", 4+32,"Bloqueio Ficha Técnica") = 6
															f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_panos = 0, BT_FINALIZA_PANOS = 1 where produto = ?v_produtos_00.produto")
															Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")	
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.BackColor = RGB(255,0,0)
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.ToolTipText = "Finalizar FT Panos"	
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.Caption = 'Fin. Panos'	

															f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

															sele v_produtos_00
															replace  DATA_FINALIZA_TEC 		With ''
															replace	 TEC_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS= .T.,'SIM','NAO'),'')
															replace  QTDE_FINALIZADA_TEC 	With NVL(xFinFichaMost.QTDE_FINALIZADA_PANOS,0)
														
															Thisformset.Refresh()
														ELSE
															f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_panos = 0 where produto = ?v_produtos_00.produto")
															Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")	
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.BackColor = RGB(255,0,0)
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.ToolTipText = "Finalizar FT Panos"	
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.Caption = 'Fin. Panos'	

															f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

															sele v_produtos_00
															replace  DATA_FINALIZA_TEC 		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS= .T.,xFinFichaMost.DATA_FINAL_PANOS,''),'')
															replace	 TEC_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS= .T.,'SIM','NAO'),'')
															replace  QTDE_FINALIZADA_TEC 	With NVL(xFinFichaMost.QTDE_FINALIZADA_PANOS,0)
														
															Thisformset.Refresh()
														ENDIF
													ELSE 
															f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_panos = 0 where produto = ?v_produtos_00.produto")
															Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")	
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.BackColor = RGB(255,0,0)
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.ToolTipText = "Finalizar FT Panos"	
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_pan.Caption = 'Fin. Panos'	

															f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

															sele v_produtos_00
															replace  DATA_FINALIZA_TEC 		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS= .T.,xFinFichaMost.DATA_FINAL_PANOS,''),'')
															replace	 TEC_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_PANOS= .T.,'SIM','NAO'),'')
															replace  QTDE_FINALIZADA_TEC 	With NVL(xFinFichaMost.QTDE_FINALIZADA_PANOS,0)
														
													endif	
												Else
													Return .F.
												Endif
											Else
												MESSAGEBOX("Você não tem permissão para liberar Tecido na Ficha Técnica!",0+16,"Bloqueio Ficha Técnica")
												Return .F.
											Endif
									Endif
							Else
								MESSAGEBOX("Rede Loja não habilitada !!!",0+16,"Bloqueio Ficha Técnica")
								Return .F.
		
						ENDIF
			endif

		
		
	ENDPROC


ENDDEFINE
*
*-- EndDefine: btn_anm_finaliza_pan
**************************************************

**************************************************
*-- Class:        btn_anm_finaliza_av(c:\users\lucas.miranda\desktop\projetos\desenvolvimento\2016\produção\ft\btn_anm_finaliza_av.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/16/16 10:07:13 AM
*
DEFINE CLASS btn_anm_finaliza_av AS commandbutton


	Top = 32
	Left = 365
	Height = 20
	Width = 62
	FontSize = 7
	Caption = "F\L Avia."
	BackColor = RGB(171,92,84)
	Visible = .T.
	Name = "btn_anm_finaliza_av"


	PROCEDURE Click
	
		If (Thisformset.p_tool_status = 'P') OR (Thisformset.p_tool_status = 'A' AND xbloqueio=1)
			
			***** VALIDA APROVAÇÃO DO MATERIAL *****
			xMsgEstampa = ''
			IF xbloqueio=0 && Não travar o que já estava bloqueado
				TEXT TO xSql TEXTMERGE NOSHOW 
					SELECT DISTINCT RTRIM(A.MATERIAL)+' / '+RTRIM(A.COR_MATERIAL)+': '+RTRIM(E.GS_STATUS_ESTAMPA) AS RETORNO_ESTAMPA
					FROM PRODUTOS_FICHA_COR (NOLOCK) A 
					   JOIN PRODUTOS (NOLOCK) P ON A.PRODUTO = P.PRODUTO
					   JOIN DBO.FXANM_ConsultaVarString(DBO.FX_ANM_PARAMETRO_USER('ANM_VALIDA_ESTAMPA_FT')) R ON P.REDE_LOJAS = R.Valores
					   JOIN MATERIAIS (NOLOCK) B ON A.MATERIAL = B.MATERIAL
					   LEFT JOIN DBO.FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_MATERIAL_FT_PA') D ON B.TIPO = REPLACE(D.VALOR_ATUAL,CHAR(39),'') 
					   JOIN MATERIAIS_CORES (NOLOCK) E ON A.MATERIAL = E.MATERIAL AND A.COR_MATERIAL = E.COR_MATERIAL AND ISNULL(E.GS_STATUS_ESTAMPA,'')<>''
					   LEFT JOIN (SELECT VALORES AS VALOR_ATUAL 
									FROM DBO.FXANM_ConsultaVarString((SELECT VALOR_ATUAL FROM PARAMETROS (NOLOCK) WHERE PARAMETRO = 'ANM_ESTAMPA_LIBERADA')) )  F 
					   ON E.GS_STATUS_ESTAMPA = F.VALOR_ATUAL	
					WHERE  A.PRODUTO = '<<v_produtos_00.produto>>' AND D.VALOR_ATUAL IS NULL AND F.VALOR_ATUAL IS NULL 
				ENDTEXT 
				f_select(xSql, "xCurBloqueiaMat")
				
				Sele xCurBloqueiaMat
				GO TOP
				IF RECCOUNT()>0 
					SCAN 
						xMsgEstampa = xMsgEstampa + CHR(13)+ ALLTRIM(xCurBloqueiaMat.RETORNO_ESTAMPA)
						
						Sele xCurBloqueiaMat
					ENDSCAN
				ENDIF
			ENDIF
						sele ppRL_ANM_VERIFICA_FIN_FT_PA
						LOCATE FOR REDE_LOJAS = v_produtos_00.rede_lojas
						If FOUND() AND ppRL_ANM_VERIFICA_FIN_FT_PA.valor_atual = 'SIM'
									
									If v_produtos_00.AV_FINALIZADO = 'NAO'
											
											If Thisformset.pp_anm_bloq_ft_av	
												
												xPerg = 0
												IF xbloqueio = 0
													xPerg = Messagebox("Deseja Finalizar a Ficha Técnica do tipo Aviamentos?",4+32,"Bloqueio Ficha Técnica")
												ENDIF
														
											If xPerg = 6 OR xbloqueio = 1

												IF f_vazio(xMsgEstampa)
												
														
															TEXT TO xVerDataProg NOSHOW textmerge
																select distinct TOP 1 A.PROGRAMACAO, A.PRODUTO, A.ENTREGA_INICIAL, 
																MONTH(A.ENTREGA_INICIAL) AS MES_ENTREGA_INICIAL, YEAR(A.ENTREGA_INICIAL) AS  ANO_ENTREGA_INICIAL,
																c.data_aviamentos as data_aviamentos, convert(date,getdate(),103) as data_atual,
																DATEDIFF(DAY,convert(date,c.data_aviamentos,103), convert(date,getdate(),103)) as ultrapassou,
																case when MONTH(A.ENTREGA_INICIAL) = 1 then 'JANEIRO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 2 then 'FEVEREIRO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 3 then 'MARÇO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 4 then 'ABRIL' 
																	 when MONTH(A.ENTREGA_INICIAL) = 5 then 'MAIO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 6 then 'JUNHO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 7 then 'JULHO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 8 then 'AGOSTO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 9 then 'SETEMBRO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 10 then 'OUTUBRO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 11 then 'NOVEMBRO' 
																	 when MONTH(A.ENTREGA_INICIAL) = 12 then 'DEZEMBRO' 
																end as MESES
																   
																from producao_prog_prod (nolock) a
																JOIN PROP_PRODUCAO_PROGRAMA (nolock) B
																ON A.PROGRAMACAO = B.PROGRAMACAO
																AND B.PROPRIEDADE = '00038'
																join (select DISTINCT CODIGO_MARCA, a.canal, b.TIPO_PROGRAMACAO, MARCA, COLECAO, MES, ANO, A.QUINZENA, 
																		DATA_PROGRAMACAO, DATA_AVIAMENTOS
																		from GS_CALENDARIOS_REPROGRAMACAO (nolock) a 
																		join WGS_CANAL_CALENDARIO b
																		on a.CANAL = b.CANAL) c
																on MONTH(A.ENTREGA_INICIAL) = c.mes
																and year(A.ENTREGA_INICIAL) = c.ano
																AND CASE WHEN DAY(a.ENTREGA_INICIAL) >= 1 AND DAY(a.ENTREGA_INICIAL) <= 14 THEN '1' ELSE '2' END = C.QUINZENA
																and B.VALOR_PROPRIEDADE = c.TIPO_PROGRAMACAO
																and codigo_marca = ?v_produtos_00.rede_lojas
																where produto = ?V_PRODUTOS_00.PRODUTO
																and b.VALOR_PROPRIEDADE not in (select VALOR_ATUAL from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_PROG_MOSTR'))
																and a.QTDE_PROGRAMADA > 0
																and	DATEDIFF(DAY,convert(date,c.data_aviamentos,103), convert(date,getdate(),103)) > 0
																order by ENTREGA_INICIAL desc
															ENDTEXT 
															F_SELECT(xVerDataProg, 'CUR_VERDATAPROG')

															SELECT CUR_VERDATAPROG 
															
															
															TEXT TO XPEDIDO NOSHOW TEXTMERGE
																SELECT PRODUTO	FROM 
																(SELECT PRODUTO FROM COMPRAS_PRODUTO A
																JOIN COMPRAS B
																ON A.PEDIDO = B.PEDIDO
																AND B.TIPO_COMPRA NOT LIKE '%CONSERT%'
																JOIN PROP_PRODUCAO_PROGRAMA C
																ON B.PROGRAMACAO = C.PROGRAMACAO
																AND C.PROPRIEDADE = '00038'
																WHERE A.QTDE_ENTREGAR > 0
																AND C.VALOR_PROPRIEDADE not in (select VALOR_ATUAL from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_PROG_MOSTR'))
																UNION
																SELECT PRODUTO FROM PRODUCAO_ORDEM A
																JOIN PROP_PRODUCAO_PROGRAMA C
																ON A.PROGRAMACAO = C.PROGRAMACAO
																AND C.PROPRIEDADE = '00038'
																WHERE TIPO_PROCESSO = 0
																AND STATUS <> 'E'
																AND C.VALOR_PROPRIEDADE not in (select VALOR_ATUAL from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_PROG_MOSTR'))
																) A
																WHERE A.PRODUTO = ?V_PRODUTOS_00.PRODUTO
															ENDTEXT
															F_SELECT(XPEDIDO, 'CUR_PEDIDO')
															
															Sele CUR_PEDIDO
															
															IF xbloqueio=0
																
																If !f_vazio(CUR_VERDATAPROG.ultrapassou)
																	IF !F_Vazio(CUR_PEDIDO.produto) AND V_PRODUTOS_00.qtde_finalizada_av > 0															   			
																		MESSAGEBOX('Atenção, Calendário Aviamentos !'+CHR(13)+'Data Aviamentos: '+DTOC(CUR_VERDATAPROG.data_aviamentos)+CHR(13)+'Essa data é limite para o mês de '+ALLTRIM(CUR_VERDATAPROG.meses)+ ' e para os meses anteriores !'+CHR(13)+CHR(13)+'Data Atual: '+DTOC(DATE())+CHR(13)+'Ultrapassada a data Calendário !!!'+CHR(13)+CHR(13)+'Verificar se deve recalcular os Materiais na O.P./Pedido',0+48,'CALENDÁRIO AVIAMENTOS')
																	Else	
																		MESSAGEBOX('Atenção, Calendário Aviamentos !'+CHR(13)+'Data Aviamentos: '+DTOC(CUR_VERDATAPROG.data_aviamentos)+CHR(13)+'Essa data é limite para o mês de '+ALLTRIM(CUR_VERDATAPROG.meses)+ ' e para os meses anteriores !'+CHR(13)+CHR(13)+'Data Atual: '+DTOC(DATE())+CHR(13)+'Ultrapassada a data Calendário !!!',0+48,'CALENDÁRIO AVIAMENTOS')
																	Endif																
																	
																ELSE 
																	If !F_Vazio(CUR_PEDIDO.produto) AND V_PRODUTOS_00.qtde_finalizada_av > 0	
																		*!*f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_aviamentos=1,bt_finaliza_aviamentos=0, data_final_av=CONVERT(VARCHAR(10),getdate(),112) where produto=?v_produtos_00.produto")
																		thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.BackColor = RGB(0,255,0)
																		thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.ToolTipText = "Liberar FT Aviamentos"
																		thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.Caption = 'Lib. Avia.'
																		Messagebox('Finalizada Com Sucesso !'+CHR(13)+CHR(13)+'Verificar se deve recalcular os Materiais na O.P./Pedido',0+64,'Bloqueio Ficha Técnica')
																	ELSE
																	    *!*f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_aviamentos=1,bt_finaliza_aviamentos=0, data_final_av=CONVERT(VARCHAR(10),getdate(),112) where produto=?v_produtos_00.produto")
																		thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.BackColor = RGB(0,255,0)
																		thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.ToolTipText = "Liberar FT Aviamentos"
																		thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.Caption = 'Lib. Avia.'
																		Messagebox('Finalizada Com Sucesso !',0+64,"Bloqueio Ficha Técnica")
																	Endif
																Endif
															ENDIF
														f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_aviamentos=1,bt_finaliza_aviamentos=0, data_final_av=CONVERT(VARCHAR(10),getdate(),112) where produto=?v_produtos_00.produto")

														
														f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

														sele v_produtos_00
														replace  DATA_FINALIZA_AV 		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS= .T.,xFinFichaMost.DATA_FINAL_AV,''),'')
														replace	 AV_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS= .T.,'SIM','NAO'),'')
														replace  QTDE_FINALIZADA_AV 	With NVL(xFinFichaMost.QTDE_FINALIZADA_AVIAMENTOS,0)
														
														
														USE IN CUR_PEDIDO
														USE IN CUR_VERDATAPROG
													
														Thisformset.Refresh()
													ELSE
														MESSAGEBOX('Operação não concluída,algum aviamento ainda não está aprovado.'+CHR(13)+CHR(13)+xMsgEstampa,64+0,"Atenção!")
														RETURN .f.
													endif	
												Else
													Return .F.
												ENDIF
												xbloqueio=0
											Else		
												MESSAGEBOX("Você não tem permissão para finalizar Aviam. na Ficha Técnica!",0+16,"Bloqueio Ficha Técnica")
												Return .F.
											Endif
									Else
											If Thisformset.pp_anm_desbloq_ft_av
												If Messagebox("Deseja Liberar Aviamentos ?",4+32,"Bloqueio Ficha Técnica") = 6
													IF thisformset.PP_GS_DESBLOQ_FICHA_TEC
														IF MESSAGEBOX("Deseja NÃO contabilizar o log de desbloqueio?", 4+32,"Bloqueio Ficha Técnica") = 6
															f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_aviamentos = 0, BT_FINALIZA_AVIAMENTOS = 1 where produto = ?v_produtos_00.produto")
															Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")	
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.BackColor = RGB(255,0,0)
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.ToolTipText = "Finalizar FT Aviamentos"	
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.Caption = 'Fin. Avia.'	
															
															f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

															sele v_produtos_00
															replace  DATA_FINALIZA_AV 		With ''
															replace	 AV_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS= .T.,'SIM','NAO'),'')
															replace  QTDE_FINALIZADA_AV 	With NVL(xFinFichaMost.QTDE_FINALIZADA_AVIAMENTOS,0)
															
															Thisformset.Refresh()
														ELSE
															f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_aviamentos = 0 where produto = ?v_produtos_00.produto")
															Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")	
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.BackColor = RGB(255,0,0)
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.ToolTipText = "Finalizar FT Aviamentos"	
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.Caption = 'Fin. Avia.'	
															
															f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

															sele v_produtos_00
															replace  DATA_FINALIZA_AV 		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS= .T.,xFinFichaMost.DATA_FINAL_AV,''),'')
															replace	 AV_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS= .T.,'SIM','NAO'),'')
															replace  QTDE_FINALIZADA_AV 	With NVL(xFinFichaMost.QTDE_FINALIZADA_AVIAMENTOS,0)
															
															Thisformset.Refresh()	
														ENDIF
													ELSE
															f_update("update anm_tb_bloq_ficha_tecnica_pa set finaliza_aviamentos = 0 where produto = ?v_produtos_00.produto")	
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.BackColor = RGB(255,0,0)
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.ToolTipText = "Finalizar FT Aviamentos"	
															thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_av.Caption = 'Fin. Avia.'	
															Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")
															
															f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

															sele v_produtos_00
															replace  DATA_FINALIZA_AV 		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS= .T.,xFinFichaMost.DATA_FINAL_AV,''),'')
															replace	 AV_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_AVIAMENTOS= .T.,'SIM','NAO'),'')
															replace  QTDE_FINALIZADA_AV 	With NVL(xFinFichaMost.QTDE_FINALIZADA_AVIAMENTOS,0)
															
													endif	
												Else
													Return .F.
												Endif
											Else

												MESSAGEBOX("Você não tem permissão para liberar Aviam. na Ficha Técnica!",0+16,"Bloqueio Ficha Técnica")
												Return .F.
											Endif
									Endif
						Else
							MESSAGEBOX("Rede Loja não habilitada !!!",0+16,"Bloqueio Ficha Técnica")
							Return .F.
						Endif
				ENDIF

		
	ENDPROC


ENDDEFINE
*
*-- EndDefine: btn_anm_finaliza_av
**************************************************

**************************************************
*-- Class:        btn_anm_finaliza_most(c:\users\lucas.miranda\desktop\projetos\desenvolvimento\2016\produção\ft\btn_anm_finaliza_most.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/16/16 10:07:13 AM
*
DEFINE CLASS btn_anm_finaliza_most AS commandbutton


	Top = 32
	Left = 35
	Height = 20
	Width = 62
	FontSize = 7
	Caption = "F\L Mostr."
	BackColor = RGB(171,92,84)
	Visible = .T.
	Name = "btn_anm_finaliza_most"

	PROCEDURE Click
	
	
		If (Thisformset.p_tool_status = 'P') OR (Thisformset.p_tool_status = 'A' AND xbloqueio=1)
			
			*!* Verifica se o produto é um PA, se for, não valida ROTA
			xSel = "SELECT REVENDA  FROM PRODUTOS WHERE PRODUTO = '"+ALLTRIM(v_produtos_00.produto)+"'"
			f_select(xSel, "xValidaPA")
			
			IF !xValidaPA.REVENDA 
				*** Verifica se existe rota cadastrada para o produto *****
				xSel = "SELECT COUNT(*) AS ROTA_OK FROM PRODUTO_OPERACOES_ROTAS (NOLOCK) A "+;
				       "JOIN PRODUTOS (NOLOCK) B ON A.TABELA_OPERACOES = B.TABELA_OPERACOES WHERE PRODUTO = '"+ALLTRIM(v_produtos_00.produto)+"'"
				f_select(xSel,"xValidaRota")
				IF xValidaRota.ROTA_OK = 0
					MESSAGEBOX("Produto sem rota cadastrada!"+CHR(13)+"Impossível finalizar.",16,"Atenção")
					RETURN .F.
				ENDIF
				USE IN xValidaRota
			ENDIF

			
						sele ppRL_ANM_VERIFICA_FIN_FT_PA
						LOCATE FOR REDE_LOJAS = v_produtos_00.rede_lojas
						If FOUND() AND ppRL_ANM_VERIFICA_FIN_FT_PA.valor_atual = 'SIM'
									
									If v_produtos_00.MOST_FINALIZADO = 'NAO'
										
										If Thisformset.pp_ANM_BLOQ_FT_MOST	
											
											xPerg = 0
											IF xbloqueio = 0
												xPerg = Messagebox("Deseja Finalizar o Mostruário ?",4+32,"Bloqueio Ficha Técnica")
											ENDIF
														
											If xPerg = 6 OR xbloqueio = 1
											
													
													TEXT TO xVerDataProg NOSHOW textmerge
															select TOP 1 A.PROGRAMACAO, A.PRODUTO, A.ENTREGA_FINAL, 
															MONTH(A.ENTREGA_FINAL) AS MES_ENTREGA_FINAL, YEAR(A.ENTREGA_FINAL) AS  ANO_ENTREGA_FINAL,
															c.data_mostruario as data_mostruario, convert(date,getdate(),103) as data_atual,
															DATEDIFF(DAY,convert(date,c.data_mostruario,103), convert(date,getdate(),103)) as ultrapassou,
															case when MONTH(A.ENTREGA_FINAL) = 1 then 'JANEIRO' 
																 when MONTH(A.ENTREGA_FINAL) = 2 then 'FEVEREIRO' 
																 when MONTH(A.ENTREGA_FINAL) = 3 then 'MARÇO' 
																 when MONTH(A.ENTREGA_FINAL) = 4 then 'ABRIL' 
																 when MONTH(A.ENTREGA_FINAL) = 5 then 'MAIO' 
																 when MONTH(A.ENTREGA_FINAL) = 6 then 'JUNHO' 
																 when MONTH(A.ENTREGA_FINAL) = 7 then 'JULHO' 
																 when MONTH(A.ENTREGA_FINAL) = 8 then 'AGOSTO' 
																 when MONTH(A.ENTREGA_FINAL) = 9 then 'SETEMBRO' 
																 when MONTH(A.ENTREGA_FINAL) = 10 then 'OUTUBRO' 
																 when MONTH(A.ENTREGA_FINAL) = 11 then 'NOVEMBRO' 
																 when MONTH(A.ENTREGA_FINAL) = 12 then 'DEZEMBRO' 
															end as MESES
															
															from producao_prog_prod a
															JOIN PROP_PRODUCAO_PROGRAMA B
															ON A.PROGRAMACAO = B.PROGRAMACAO
															AND B.PROPRIEDADE = '00038'
															join GS_CALENDARIOS_REPROG_MOST c
															on MONTH(A.ENTREGA_FINAL) = c.mes
															and year(A.ENTREGA_FINAL) = c.ano
															and codigo_marca = ?v_produtos_00.rede_lojas
															where produto = ?V_PRODUTOS_00.PRODUTO
															and b.VALOR_PROPRIEDADE in (select VALOR_ATUAL from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_PROG_MOSTR'))
															and	DATEDIFF(DAY,convert(date,c.data_mostruario,103), convert(date,getdate(),103)) > 0
															order by entrega_final desc
														ENDTEXT 
														F_SELECT(xVerDataProg, 'CUR_VERDATAPROG')

														SELECT CUR_VERDATAPROG 
														
														
														TEXT TO XPEDIDO NOSHOW TEXTMERGE
															SELECT PRODUTO	FROM 
															(SELECT PRODUTO FROM COMPRAS_PRODUTO A
															JOIN COMPRAS B
															ON A.PEDIDO = B.PEDIDO
															AND B.TIPO_COMPRA NOT LIKE '%CONSERT%'
															JOIN PROP_PRODUCAO_PROGRAMA C
															ON B.PROGRAMACAO = C.PROGRAMACAO
															AND C.PROPRIEDADE = '00038'
															WHERE A.QTDE_ENTREGAR > 0
															AND C.VALOR_PROPRIEDADE in (select VALOR_ATUAL from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_PROG_MOSTR'))
															UNION
															SELECT PRODUTO FROM PRODUCAO_ORDEM A
															JOIN PROP_PRODUCAO_PROGRAMA C
															ON A.PROGRAMACAO = C.PROGRAMACAO
															AND C.PROPRIEDADE = '00038'
															WHERE TIPO_PROCESSO = 0
															AND STATUS <> 'E'
															AND C.VALOR_PROPRIEDADE in (select VALOR_ATUAL from FX_ANM_PARAMETROS_REDE_LOJAS('ANM_TIPO_PROG_MOSTR'))
															) A
															WHERE A.PRODUTO = ?V_PRODUTOS_00.PRODUTO
														ENDTEXT
														F_SELECT(XPEDIDO, 'CUR_PEDIDO')
														
														Sele CUR_PEDIDO
														
														f_select("select * from GS_MESES_MINI_COLECAO_MOST where rede_lojas=?v_produtos_00.rede_lojas ","xMiniMeses")
														sele xMiniMeses
														Locate For CUR_VERDATAPROG.mes_entrega_final >= Inicio_Mes  and CUR_VERDATAPROG.mes_entrega_final <= Fim_Mes	
														xCodigoMini=xMiniMeses.codigo_mini_col 
														
														IF xbloqueio=0
															
															If !f_vazio(CUR_VERDATAPROG.ultrapassou)
																IF !F_Vazio(CUR_PEDIDO.produto) AND V_PRODUTOS_00.qtde_finalizada_most > 0															   			
																	MESSAGEBOX('Atenção, Calendário Mostruário !'+CHR(13)+'Data Mostruário: '+DTOC(CUR_VERDATAPROG.data_mostruario)+CHR(13)+CHR(13)+'Essa data era limite para o mês de '+ALLTRIM(CUR_VERDATAPROG.meses)+'('+xCodigoMini+')'+' e para os meses anteriores !'+CHR(13)+CHR(13)+'Data Atual: '+DTOC(DATE())+CHR(13)+'Ultrapassada a data Calendário !!!'+CHR(13)+CHR(13)+'Verificar se deve recalcular os Materiais na O.P./Pedido',0+48,'CALENDÁRIO MOSTRUÁRIO')
																Else	
																	MESSAGEBOX('Atenção, Calendário Mostruário !'+CHR(13)+'Data Mostruário: '+DTOC(CUR_VERDATAPROG.data_mostruario)+CHR(13)+CHR(13)+'Essa data era limite para o mês de '+ALLTRIM(CUR_VERDATAPROG.meses)+'('+xCodigoMini+')'+' e para os meses anteriores !'+CHR(13)+CHR(13)+'Data Atual: '+DTOC(DATE())+CHR(13)+'Ultrapassada a data Calendário !!!',0+48,'CALENDÁRIO MOSTRUÁRIO')
																Endif																
																
															ELSE 
																If !F_Vazio(CUR_PEDIDO.produto) AND V_PRODUTOS_00.qtde_finalizada_most > 0	
																	*!*f_update("update anm_tb_bloq_ficha_tecnica_pa set FT_MOST_PRONTO=1,bt_ft_most_pronto=0, data_final_most=CONVERT(VARCHAR(10),getdate(),112) where produto=?v_produtos_00.produto")
																	thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.BackColor = Iif(Cur_ProgMost_S_OP.Qtde_prog_s_OP>0,RGB(255,255,0),RGB(0,255,0))
																	thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.ToolTipText = "Liberar Mostruario"
																	thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.Caption = 'Lib. Mostr.'
																	Messagebox('Finalizada Com Sucesso !'+CHR(13)+CHR(13)+'Verificar se deve recalcular os Materiais na O.P./Pedido',0+64,'Bloqueio Ficha Técnica')
																ELSE
																	*!*f_update("update anm_tb_bloq_ficha_tecnica_pa set FT_MOST_PRONTO=1,bt_ft_most_pronto=0, data_final_most=CONVERT(VARCHAR(10),getdate(),112) where produto=?v_produtos_00.produto")
																	thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.BackColor = Iif(Cur_ProgMost_S_OP.Qtde_prog_s_OP>0,RGB(255,255,0),RGB(0,255,0))
																	thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.ToolTipText = "Liberar Mostruario"
																	thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.Caption = 'Lib. Mostr.'
																	Messagebox('Finalizada Com Sucesso !',0+64,"Bloqueio Ficha Técnica")
																Endif
															Endif
														ENDIF
													
														f_update("update anm_tb_bloq_ficha_tecnica_pa set FT_MOST_PRONTO=1,bt_ft_most_pronto=0, data_final_most=CONVERT(VARCHAR(10),getdate(),112) where produto=?v_produtos_00.produto")
													
													
													
													TEXT TO xSelProgSemOP TEXTMERGE NOSHOW
								
														Select count(*) Qtde_prog_s_OP 
														from producao_prog_prod a
															join prop_producao_programa b on a.PROGRAMACAO = b.PROGRAMACAO and b.PROPRIEDADE = '00038'

														WHERE B.VALOR_PROPRIEDADE = 'MOSTRUARIO' and 
															  a.QTDE_SALDO_EMITIR_OP > 0 and a.ANM_MATAR_SALDO = 0 and
															  a.PRODUTO = LTRIM(RTRIM('<<v_produtos_00.produto>>')) 
													ENDTEXT
													f_select(xSelProgSemOP,"Cur_ProgMost_S_OP",ALIAS()) && PRODUTO COM OP DE MOSTRUÁRIO PENDENTE EMISSÃO
													

													
													f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

													sele v_produtos_00
													replace  DATA_FINALIZA_MOST 	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO = .T.,xFinFichaMost.DATA_FINAL_MOST,''),'')
													replace	 MOST_FINALIZADO    	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO = .T.,'SIM','NAO'),'')
													replace  QTDE_FINALIZADA_MOST 	With NVL(xFinFichaMost.QTDE_FINALIZADA_MOST,0)
													
															 											
													USE IN CUR_PEDIDO
													USE IN CUR_VERDATAPROG
													
													*** Projeto: Automação para emissão de Pedidos PCP. ***
													*** Gerar O.P. Mostruário ***
													*** Lucas Miranda - 10/05/2018 ***
													xLoteOkOP = 0
													xLoteOkPA = 0
													xRec = 0
													xProc = 0
													xStop = 0
													xMsgBoxOP = ''
													xGerouLoteOP = ''

													if used("cur_LoteOP") 
														USE IN cur_LoteOP
													ENDIF	

													if used("cur_LotePA") 
														USE IN cur_LotePA
													ENDIF	

													if USED("v_geracao_op_ped_00")
														USE IN v_geracao_op_ped_00
													ENdif

													TEXT TO xProg TEXTMERGE NOSHOW
														SELECT PRODUTOS.REDE_LOJAS, PRODUCAO_PROG_PROD.PRODUTO, PRODUTOS.DESC_PRODUTO, PRODUCAO_PROG_PROD.COR_PRODUTO, PRODUTO_CORES.DESC_COR_PRODUTO, 		PRODUCAO_PROGRAMA.FILIAL, PRODUCAO_PROGRAMA.PROGRAMACAO, PRODUCAO_PROG_PROD.QTDE_EM_OP, PRODUTOS.REVENDA 
														FROM PRODUCAO_PROGRAMA PRODUCAO_PROGRAMA
														JOIN (SELECT PROGRAMACAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_PROGRAMA WHERE PROPRIEDADE = '00038' AND VALOR_PROPRIEDADE ='MOSTRUARIO') PROP_PRODUCAO_PROGRAMA
														ON PRODUCAO_PROGRAMA.PROGRAMACAO = PROP_PRODUCAO_PROGRAMA.PROGRAMACAO
														JOIN (SELECT PROGRAMACAO, PRODUTO, COR_PRODUTO, QTDE_PROGRAMADA, QTDE_EM_OP, ENTREGA_INICIAL 
															  FROM PRODUCAO_PROG_PROD (NOLOCK) 
														   WHERE QTDE_SALDO_EMITIR_OP > 0 AND QTDE_PROGRAMADA > 0 AND MATAR_SALDO_PROGRAMACAO = 0) PRODUCAO_PROG_PROD
														ON PROP_PRODUCAO_PROGRAMA.PROGRAMACAO = PRODUCAO_PROG_PROD.PROGRAMACAO
														JOIN PRODUTO_CORES (NOLOCK) PRODUTO_CORES
														ON PRODUCAO_PROG_PROD.PRODUTO = PRODUTO_CORES.PRODUTO
														AND PRODUCAO_PROG_PROD.COR_PRODUTO = PRODUTO_CORES.COR_PRODUTO
														JOIN PRODUTOS (NOLOCK) PRODUTOS
														ON PRODUTO_CORES.PRODUTO = PRODUTOS.PRODUTO
														JOIN PRODUTOS_STATUS PRODUTOS_STATUS
														ON PRODUTOS.STATUS_PRODUTO = PRODUTOS_STATUS.STATUS_PRODUTO
														JOIN ANM_TB_BLOQ_FICHA_TECNICA_PA (NOLOCK) ANM_TB_BLOQ_FICHA_TECNICA_PA
														ON PRODUTOS.PRODUTO = ANM_TB_BLOQ_FICHA_TECNICA_PA.PRODUTO
														WHERE ANM_TB_BLOQ_FICHA_TECNICA_PA.FT_MOST_PRONTO = 1 AND PRODUTOS_STATUS.DESC_STATUS_PRODUTO NOT IN ('CANCELADO COM ESTOQUE') AND PRODUTOS.TIPO_STATUS_PRODUTO = 3 
														and PRODUCAO_PROG_PROD.produto='<<v_produtos_00.produto>>'
													ENDTEXT
													f_select(xProg,"v_geracao_op_ped_00",ALIAS())

													If RECCOUNT("v_geracao_op_ped_00") > 0
														Sele v_geracao_op_ped_00
														GO TOP

														SCAN 
														** Produção **
														IF v_geracao_op_ped_00.revenda = .F.
															IF xLoteOkOP = 0
																F_select("LX_ANM_GERA_OP_LOTE","cur_LoteOP",ALIAS())
																xLoteOkOP = 1
																
																f_wait("Gerando lote OP: "+ALLTRIM(STR(cur_LoteOP.LOTE))+CHR(13)+"Aguarde ...")
															ENDIF
															
															f_update("EXEC LX_GS_GERA_PA_OP_AUTO ?v_geracao_op_ped_00.programacao,?v_geracao_op_ped_00.produto,0,?cur_LoteOP.LOTE,?v_geracao_op_ped_00.filial")
															f_select("select 'OK' AS RETORNO from producao_ordem(nolock) where programacao=?v_geracao_op_ped_00.programacao and produto=?v_geracao_op_ped_00.produto","xCurRetornoProcOP",ALIAS())	
															
															*IF !f_select("EXEC LX_GS_GERA_PA_OP_AUTO ?v_geracao_op_ped_00.programacao,?v_geracao_op_ped_00.produto,0,?cur_LoteOP.LOTE,?v_geracao_op_ped_00.filial","xCurRetornoProcOP",alias())
															IF f_vazio(xCurRetornoProcOP.RETORNO)
																MESSAGEBOX("Não Foi Possível gerar pedido para o produto: "+ALLTRIM(v_geracao_op_ped_00.PRODUTO))
															
															ELSE			
																IF ALLTRIM(xCurRetornoProcOP.RETORNO) = 'OK'
																	xProc = xProc + 1				
																ENDIF 
															ENDIF
															
															IF USED("curVerGerOP")
																USE IN curVerGerOP
															Endif	
															
															f_wait("Gerando OPs do Lote: "+ALLTRIM(STR(cur_LoteOP.LOTE))+CHR(13)+"Aguarde ...")
															f_select("select produto from producao_ordem (nolock) where programacao=?v_geracao_op_ped_00.programacao and produto=?v_geracao_op_ped_00.produto","curVerGerOP",ALIAS())		
															
															IF f_vazio(curVerGerOP.produto)				
																xMsgBoxOP = xMsgBoxOP + 'PRODUTO: '+ALLTRIM(v_geracao_op_ped_00.produto)+;
																			  ' | COR: '+ALLTRIM(v_geracao_op_ped_00.cor_produto)+;
																			  ' | PROGRAMACAO: '+ALLTRIM(v_geracao_op_ped_00.programacao)+CHR(13)
															Endif	
														ENDIF														 
														
														Sele v_geracao_op_ped_00	
														ENDSCAN
														 
														GO TOP
														f_wait()
														
														IF !f_vazio(xMsgBoxOP)
															_CLIPTEXT = xMsgBoxOP
															MESSAGEBOX("Alguns pedidos não foram gerados, Favor verificar!"+CHR(13)+CHR(13)+xMsgBoxOP,64,"Erro OP! (CTRL+C)")
														ENDIF

														f_select("Select count(*) as 'ok' from producao_ordem(nolock) where gs_lote_op = ?cur_LoteOP.LOTE","xOPGerado",ALIAS())

														IF xOPGerado.ok > 0		
															xGerouLoteOP = ALLTRIM(STR(cur_LoteOP.LOTE))			
														ENDIF
														
														
														If !F_VAZIO(xGerouLoteOP)
															MESSAGEBOX("OP Gerada ! "+CHR(13)+CHR(13)+"Lote OP: "+xGerouLoteOP+;
																		CHR(13)+ALLTRIM(STR(xRec))+ " Linhas Selecionadas | "+ALLTRIM(STR(xProc))+" Processada com sucesso.",0+64,"Lote OP")	
															o_toolbar.botao_refresh.Click()
														Endif															
													ENDIF
	
														
													Thisformset.Refresh()
													o_toolbar.botao_refresh.Click()
											Else
												Return .F.
											ENDIF
											xbloqueio=0
										Else		
											MESSAGEBOX("Você não tem permissão para finalizar Most. na Ficha Técnica!",0+16,"Bloqueio Ficha Técnica")
											Return .F.
										Endif
									Else
										If Thisformset.pp_ANM_DESBLOQ_FT_MOST	
											If Messagebox("Deseja Liberar Mostruário ?",4+32,"Bloqueio Ficha Técnica") = 6
										   		IF thisformset.PP_GS_DESBLOQ_FICHA_TEC
													IF MESSAGEBOX("Deseja NÃO contabilizar o log de desbloqueio?", 4+32,"Bloqueio Ficha Técnica") = 6
														f_update("update anm_tb_bloq_ficha_tecnica_pa set ft_most_pronto = 0, BT_FT_MOST_PRONTO = 1 where produto = ?v_produtos_00.produto")
														Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")	
														thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.BackColor = RGB(255,0,0)
														thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.ToolTipText = "Finalizar Mostruário"	
														thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.Caption = 'Fin. Mostr.'	
														
														f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

														sele v_produtos_00
														replace  DATA_FINALIZA_MOST 	With  ''
														replace	 MOST_FINALIZADO    	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO = .T.,'SIM','NAO'),'')
														replace  QTDE_FINALIZADA_MOST 	With NVL(xFinFichaMost.QTDE_FINALIZADA_MOST,0)
													
														Thisformset.Refresh()	
													ELSE
														f_update("update anm_tb_bloq_ficha_tecnica_pa set ft_most_pronto = 0 where produto = ?v_produtos_00.produto")
														Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")	
														thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.BackColor = RGB(255,0,0)
														thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.ToolTipText = "Finalizar Mostruário"	
														thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.Caption = 'Fin. Mostr.'	
														
														f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

														sele v_produtos_00
														replace  DATA_FINALIZA_MOST 	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO = .T.,xFinFichaMost.DATA_FINAL_MOST,''),'')
														replace	 MOST_FINALIZADO    	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO = .T.,'SIM','NAO'),'')
														replace  QTDE_FINALIZADA_MOST 	With NVL(xFinFichaMost.QTDE_FINALIZADA_MOST,0)
													ENDIF
													
												ELSE
														f_update("update anm_tb_bloq_ficha_tecnica_pa set ft_most_pronto = 0 where produto = ?v_produtos_00.produto")
														Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")	
														thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.BackColor = RGB(255,0,0)
														thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.ToolTipText = "Finalizar Mostruário"	
														thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_most.Caption = 'Fin. Mostr.'	
														
														f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

														sele v_produtos_00
														replace  DATA_FINALIZA_MOST 	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO = .T.,xFinFichaMost.DATA_FINAL_MOST,''),'')
														replace	 MOST_FINALIZADO    	With NVL(IIF(xFinFichaMost.FT_MOST_PRONTO = .T.,'SIM','NAO'),'')
														replace  QTDE_FINALIZADA_MOST 	With NVL(xFinFichaMost.QTDE_FINALIZADA_MOST,0)
												ENDIF
												Else
													Return .F.
												Endif
											Else

											MESSAGEBOX("Você não tem permissão para liberar Most. na Ficha Técnica!",0+16,"Bloqueio Ficha Técnica")
											Return .F.
										Endif
									Endif
							Else
								MESSAGEBOX("Rede Loja não habilitada !!!",0+16,"Bloqueio Ficha Técnica")
								Return .F.
							Endif
				ENDIF

	ENDPROC


ENDDEFINE
*
*-- EndDefine: btn_anm_finaliza_most
**************************************************

**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_data_final_most AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .T.
	Enabled = .F.
	Height = 19
	Left = 100
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 32
	Width = 65
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_data_final_most"


ENDDEFINE
*
*-- EndDefine: Tx_data_final_most
**************************************************
**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_qtd_final_most AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .T.
	Enabled = .F.
	Height = 19
	Left = 165
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 32
	Width = 23
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_qtd_final_most"


ENDDEFINE
*
*-- EndDefine: Tx_qtd_final_most
**************************************************

**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_data_final_pan AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .T.
	Enabled = .F.
	Height = 19
	Left = 265
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 32
	Width = 65
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_data_final_pan"


ENDDEFINE
*
*-- EndDefine: Tx_data_final_pan
**************************************************
**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_qtd_final_pan AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .T.
	Enabled = .F.
	Height = 19
	Left = 330
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 32
	Width = 23
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_qtd_final_pan"


ENDDEFINE
*
*-- EndDefine: Tx_qtd_final_pan
**************************************************

**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_data_final_av AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .T.
	Enabled = .F.
	Height = 19
	Left = 430
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 32
	Width = 65
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_data_final_av"


ENDDEFINE
*
*-- EndDefine: Tx_data_final_av
**************************************************
**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_qtd_final_av AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .T.
	Enabled = .F.
	Height = 19
	Left = 495
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 32
	Width = 23
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_qtd_final_av"


ENDDEFINE
*
*-- EndDefine: Tx_qtd_final_av
**************************************************
**************************************************
*-- Class:        btn_anm_finaliza_imp (c:\users\lucas.miranda\desktop\projetos\desenvolvimento\2016\produção\ft\btn_anm_finaliza_imp.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/16/16 10:07:13 AM
*
DEFINE CLASS btn_anm_finaliza_imp AS commandbutton


	Top = 32
	Left = 530
	Height = 20
	Width = 62
	FontSize = 7
	Caption = "F\L Import."
	BackColor = RGB(171,92,84)
	Visible = .T.
	Name = "btn_anm_finaliza_imp"


	PROCEDURE Click
	
	
	
		If (Thisformset.p_tool_status = 'P') OR (Thisformset.p_tool_status = 'A' AND xbloqueio=1)
		

								sele ppRL_ANM_VERIFICA_FIN_FT_PA
								LOCATE FOR REDE_LOJAS = v_produtos_00.rede_lojas
								If FOUND() AND ppRL_ANM_VERIFICA_FIN_FT_PA.valor_atual = 'SIM'
									
									If v_produtos_00.IMP_FINALIZADO = 'NAO'
											
											If Thisformset.pp_anm_bloq_ft_imp
												
												xPerg = 0
												IF xbloqueio = 0
													xPerg = Messagebox("Deseja Finalizar a Ficha Técnica do Material Importado?",4+32,"Bloqueio Ficha Técnica")
												ENDIF
															
												If xPerg = 6 OR xbloqueio = 1
												
													f_update("update anm_tb_bloq_ficha_tecnica_pa set FINALIZA_IMP=1,bt_finaliza_imp=0, DATA_FINAL_IMP=CONVERT(VARCHAR(10),getdate(),112) where produto=?v_produtos_00.produto")

													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_imp.BackColor = RGB(0,255,0)
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_imp.ToolTipText = "Liberar Importado"
													thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_imp.Caption = 'Lib. Imp.'
													
													f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

													sele v_produtos_00
													replace  DATA_FINALIZA_IMP 		With NVL(IIF(xFinFichaMost.FINALIZA_IMP= .T.,xFinFichaMost.DATA_FINAL_IMP,''),'')
													replace	 IMP_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_IMP= .T.,'SIM','NAO'),'')
													replace  QTDE_FINALIZADA_IMP 	With NVL(xFinFichaMost.QTDE_FINALIZADA_IMP,0)
												
													Thisformset.Refresh()
												Else
													Return .F.
												ENDIF
												xbloqueio=0
											Else		
												MESSAGEBOX("Você não tem permissão para finalizar Material Importado na Ficha Técnica!",0+16,"Bloqueio Ficha Técnica")
												Return .F.
											ENDIF
											
									
									ELSE
									
											If Thisformset.pp_anm_desbloq_ft_imp	
													If Messagebox("Deseja Liberar Importado ?",4+32,"Bloqueio Ficha Técnica") = 6
														 IF THISFORMSET.PP_GS_DESBLOQ_FICHA_TEC
															IF MESSAGEBOX("Deseja NÃO contabilizar o log de desbloqueio?", 4+32,"Bloqueio Ficha Técnica") = 6
																f_update("update anm_tb_bloq_ficha_tecnica_pa set FINALIZA_IMP = 0, BT_FINALIZA_IMP = 1 where produto = ?v_produtos_00.produto")
																Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")	
																thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_imp.BackColor = RGB(255,0,0)
																thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_imp.ToolTipText = "Finalizar Importado"	
																thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_imp.Caption = 'Fin. Imp.'	

																f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

																sele v_produtos_00
																replace  DATA_FINALIZA_IMP 		With ''
																replace	 IMP_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_IMP= .T.,'SIM','NAO'),'')
																replace  QTDE_FINALIZADA_IMP 	With NVL(xFinFichaMost.QTDE_FINALIZADA_IMP,0)
																
																Thisformset.Refresh()
															ELSE
																f_update("update anm_tb_bloq_ficha_tecnica_pa set FINALIZA_IMP = 0 where produto = ?v_produtos_00.produto")
																Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")	
																thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_imp.BackColor = RGB(255,0,0)
																thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_imp.ToolTipText = "Finalizar Importado"	
																thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_imp.Caption = 'Fin. Imp.'	

																f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

																sele v_produtos_00
																replace  DATA_FINALIZA_IMP 		With NVL(IIF(xFinFichaMost.FINALIZA_IMP= .T.,xFinFichaMost.DATA_FINAL_IMP,''),'')
																replace	 IMP_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_IMP= .T.,'SIM','NAO'),'')
																replace  QTDE_FINALIZADA_IMP 	With NVL(xFinFichaMost.QTDE_FINALIZADA_IMP,0)
																
																Thisformset.Refresh()				
													
											
													ENDIF
														
												ELSE
																f_update("update anm_tb_bloq_ficha_tecnica_pa set FINALIZA_IMP = 0 where produto = ?v_produtos_00.produto")
																Messagebox("Liberada Com Sucesso !",0+64,"Bloqueio Ficha Técnica")	
																thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_imp.BackColor = RGB(255,0,0)
																thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_imp.ToolTipText = "Finalizar Importado"	
																thisformset.lx_form1.pgPrincipal.page1.lx_pageframe1.page1.btn_anm_finaliza_imp.Caption = 'Fin. Imp.'	

																f_select("Select * from WANM_TB_BLOQ_FICHA_TECNICA_PA Where produto = ?v_produtos_00.produto","xFinFichaMost",ALIAS())

																sele v_produtos_00
																replace  DATA_FINALIZA_IMP 		With NVL(IIF(xFinFichaMost.FINALIZA_IMP= .T.,xFinFichaMost.DATA_FINAL_IMP,''),'')
																replace	 IMP_FINALIZADO    		With NVL(IIF(xFinFichaMost.FINALIZA_IMP= .T.,'SIM','NAO'),'')
																replace  QTDE_FINALIZADA_IMP 	With NVL(xFinFichaMost.QTDE_FINALIZADA_IMP,0)
																
																Thisformset.Refresh()				
													
													endif	
												Else
														Return .F.
												Endif
												
											Else
												MESSAGEBOX("Você não tem permissão para liberar Material Importado na Ficha Técnica!",0+16,"Bloqueio Ficha Técnica")
												Return .F.
											Endif
									Endif
							Else
								MESSAGEBOX("Rede Loja não habilitada !!!",0+16,"Bloqueio Ficha Técnica")
								Return .F.
							Endif
				ENDIF

		
	ENDPROC


ENDDEFINE
*
*-- EndDefine: btn_anm_finaliza_imp
**************************************************
**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_data_final_imp AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .T.
	Enabled = .F.
	Height = 19
	Left = 595
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 32
	Width = 65
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_data_final_imp"


ENDDEFINE
*
*-- EndDefine: Tx_data_final_imp
**************************************************
**************************************************
*-- Class:        tx_alterado_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS Tx_qtd_final_imp AS lx_textbox_base 
 

	FontName = "Tahoma"
	FontSize = 8
	Visible = .T.
	Enabled = .F.
	Height = 19
	Left = 660
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 32
	Width = 23
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_qtd_final_imp"


ENDDEFINE
*
*-- EndDefine: Tx_qtd_final_imp
**************************************************