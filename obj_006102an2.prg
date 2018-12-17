* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                        *
* OBJETIVO.: Bloquear botoes de busca ultimo preco compra e alteracao de custo de produto com entrada no estoque                                                                                                     *
* OBJETIVO.: Bloquear Alteracoes apos fases de producao
* OBJETIVO.: Recalculo de Custos
* OBJETIVO.: Recalculo de preco atacado automatico
********************************************************************************************************************* 

* Alteração ********************************************************************************************************* 
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                                        *
* OBJETIVO.:                                                                                                        *
********************************************************************************************************************* 


********************************************************************************************************************* 
*- Programa Base de Criação de Objeto de Entrada                                                                    *
********************************************************************************************************************* 
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela                                      *
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos                                            *
********************************************************************************************************************* 
*- Existem 2 parametros que influem nos objetos de Entrada:                                                         *
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos                       *
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execução para facilitar o desenvolvimento *
********************************************************************************************************************* 
* - Atencao !!!!!!!!!!!														                                        *
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP                                      *
********************************************************************************************************************* 

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
		
			case UPPER(xmetodo) == 'USR_INIT'
				xalias=ALIAS()
				
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
				
				 *Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_estoque_sai_mat_00   
					sele v_estoque_sai_mat_00   
					xalias_pai=alias()
				
					oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("ESTOQUE_SAI_MAT.ANM_STATUS_ALMOX", "C(25)",.T., "ANM_STATUS_ALMOX", "ESTOQUE_SAI_MAT.ANM_STATUS_ALMOX")
					oCur.addbufferfield("'' AS DATA_COLETA", "C(25)",.T., "DATA_COLETA", "DATA_COLETA")
					oCur.addbufferfield("'' AS USUARIO_TECIDO", "C(25)",.T., "USUARIO_TECIDO", "USUARIO_TECIDO")
					oCur.addbufferfield("'' AS USUARIO_AVIAMENTO", "C(25)",.T., "USUARIO_AVIAMENTO", "USUARIO_AVIAMENTO")			
					oCur.confirmstructurechanges() 	
					
					Thisformset.L_limpa()
					
					public xstatus_entrada,xreq_material,xfilial
					f_select("select convert(varchar(25),valor_propriedade) as anm_status_almox from propriedade_valida where propriedade='00059'","xstatus_entrada")
					
				
					store '' to	xordem_servico,xreq_material,xfilial
					
					with thisformset.lx_form1
					.addobject("lb_status_entrada","lb_status_entrada")
					.addobject("cmb_status_entrada","cmb_status_entrada")
					.addobject("lb_data_coletado","lb_data_coletado")					
					endwith
					
					with thisformset.lx_form1
						.cmb_status_entrada.RowSource="xstatus_entrada"
						.cmb_status_entrada.ControlSource="v_estoque_sai_mat_00.ANM_STATUS_ALMOX"
					endwith		

					if !f_vazio(xalias)
						sele &xalias
					endif	

				
				*thisformset.lx_FORM1.lb_status_entrada.left =16


				case upper(xmetodo) == 'USR_INCLUDE_AFTER' 
				
					xalias=alias()
						
						thisformset.lx_form1.cmb_status_entrada.value = "1-COLETA PENDENTE"
						

					if !f_vazio(xalias)
						sele &xalias
					endif				
									

				case upper(xmetodo) == 'USR_REFRESH' 
				
					xalias=alias()
					
					
					if type("thisformset.lx_FORM1.lb_status_entrada")<>"U"		
						if thisformset.p_tool_status = "I" or thisformset.p_tool_status = "L" 
							thisformset.lx_FORM1.cmb_status_entrada.enabled=.T.
						else	
							thisformset.lx_FORM1.cmb_status_entrada.enabled=.F.	
						endif				
							
						if ALLTRIM(v_estoque_sai_mat_00.anm_status_almox)=="2-COLETADO" 
							f_select("select (convert(varchar(10),TIMESTAMP,103)+' '+convert(varchar(10),TIMESTAMP,108)) as data_coleta from ANM_STATUS_SAI_MAT_MOV where REQ_MATERIAL=?v_estoque_sai_mat_00.req_material","xdata_coletado",ALIAS())
							thisformset.lx_FORM1.lb_data_coletado.caption=xdata_coletado.data_coleta		
						else
							thisformset.lx_FORM1.lb_data_coletado.caption=""
						endif						
					endif
					
					IF UPPER(thisformset.p_tool_status) $ 'IA'
					
						thisformset.lx_form1.cmb_status_entrada.enabled = .f.	
					
					ENDIF
					
					if !f_vazio(xalias)
						sele &xalias
					endif					
					
				case upper(xmetodo) == 'USR_SEARCH_AFTER' 
				
					xalias=alias()
					
					
					SELE V_ESTOQUE_SAI_MAT_00
					GO TOP
					SCAN
						
						TEXT TO XSEL TEXTMERGE NOSHOW
						
							SELECT A.REQ_MATERIAL,
							(convert(varchar(10),TIMESTAMP,103)+' '+convert(varchar(10),TIMESTAMP,108)) AS DATA_COLETA,
							ISNULL(convert(varchar(25),B.VALOR_PROPRIEDADE),'') AS USUARIO_AVIAMENTO,
							ISNULL(convert(varchar(25),C.VALOR_PROPRIEDADE),'') AS USUARIO_TECIDO
							FROM ANM_STATUS_SAI_MAT_MOV A 
							LEFT JOIN PROP_ESTOQUE_SAI_MAT B
							ON A.REQ_MATERIAL = B.REQ_MATERIAL
							AND B.PROPRIEDADE = '00066'
							LEFT JOIN PROP_ESTOQUE_SAI_MAT C
							ON A.REQ_MATERIAL = C.REQ_MATERIAL
							AND C.PROPRIEDADE = '00067'
							WHERE A.REQ_MATERIAL = '<<v_estoque_sai_mat_00.req_material>>'
							
						ENDTEXT

						f_select(xsel,"xTempSelect",ALIAS())
						
						sele V_ESTOQUE_SAI_MAT_00
						
						replace data_coleta       WITH xTempSelect.data_coleta
						replace usuario_aviamento WITH xTempSelect.usuario_aviamento
						replace usuario_tecido    WITH xTempSelect.usuario_tecido
						
					ENDSCAN	
					
					SELE V_ESTOQUE_SAI_MAT_00
					GO TOP
					
					if !f_vazio(xalias)
						sele &xalias
					endif												
					
			case UPPER(xmetodo) == 'USR_SAVE_AFTER'
				
				xalias=alias()
					
						TEXT TO xsel1 TEXTMERGE NOSHOW
						
							SELECT COUNT(*) AS FINALIZADO FROM VENDAS (NOLOCK) 
							WHERE PEDIDO = '<<V_ESTOQUE_SAI_MAT_00.PEDIDO>>'
							AND TOT_QTDE_ENTREGAR <= 0
						
						ENDTEXT
						
						f_select(xsel1,"xVerifFin",ALIAS())
						
						SELE xVerifFin
						IF xVerifFin.FINALIZADO > 0
							
							F_update("UPDATE VENDAS SET STATUS = 'B' WHERE PEDIDO = ?V_ESTOQUE_SAI_MAT_00.PEDIDO")
						
						ELSE	
							
							F_update("UPDATE VENDAS SET STATUS = 'D' WHERE PEDIDO = ?V_ESTOQUE_SAI_MAT_00.PEDIDO")
							
						ENDIF	
					
					TEXT TO xupd1 TEXTMERGE NOSHOW
										
						UPDATE A SET A.QTDE_ENTREGUE=(C.QTDE),QTDE_RESERVADA=0,
						QTDE_ENTREGAR=(QTDE_ORIGINAL-C.QTDE) FROM VENDAS_MATERIAL (NOLOCK) A
						JOIN (SELECT C.PEDIDO,C.MATERIAL,C.COR_MATERIAL,SUM(QTDE) AS QTDE
						FROM ESTOQUE_SAI1_MAT (NOLOCK) C
						WHERE C.PEDIDO = '<<V_ESTOQUE_SAI_MAT_00.PEDIDO>>'
						GROUP BY C.PEDIDO,C.MATERIAL,C.COR_MATERIAL) C
						ON A.MATERIAL = C.MATERIAL
						AND A.COR_MATERIAL = C.COR_MATERIAL
						AND A.PEDIDO = C.PEDIDO
					
					ENDTEXT
					
					f_update(xupd1)
					
					TEXT TO xupd2 TEXTMERGE NOSHOW
					
						UPDATE A SET TOT_QTDE_ENTREGUE = B.QTDE_TOTAL,TOT_QTDE_ENTREGAR = (TOT_QTDE_ORIGINAL -B.QTDE_TOTAL)
						FROM VENDAS A
						JOIN (SELECT C.PEDIDO,SUM(C.QTDE) AS QTDE_TOTAL 
						FROM ESTOQUE_SAI1_MAT (NOLOCK) C
						WHERE C.PEDIDO = '<<V_ESTOQUE_SAI_MAT_00.PEDIDO>>'
						GROUP BY C.PEDIDO) B
						ON A.PEDIDO = B.PEDIDO
					
					ENDTEXT
					
					f_update(xupd2)
					
					
					TEXT TO XUPDGRIFFE TEXTMERGE NOSHOW
					
						update a set a.requisitante = b.anm_griffe 
						from estoque_sai_mat a
						join vendas b
						on a.pedido = b.pedido
						where a.req_material = '<<V_ESTOQUE_SAI_MAT_00.req_material>>'
					
					ENDTEXT
					
					f_update(XUPDGRIFFE)
					
				if !f_vazio(xalias)
					sele &xalias
				endif
			
			
			
			case upper(xmetodo) == 'USR_TRIGGER_BEFORE' 
					
						xalias=alias()
							
							*** Busca Paramêtros ***********************************************************************************
								*f_select("SELECT VALOR_ATUAL FROM PARAMETROS WHERE PARAMETRO  = 'ANM_FILIAL_ARMAZEM'","xFILDEP") 
								xPed = v_estoque_sai_mat_00.pedido
								xCli = v_estoque_sai_mat_00.nome_clifor
								f_select("select filial_digitacao as VALOR_ATUAL from vendas where Pedido = ?xPed and cliente_atacado = ?xCli","xFILDEP")
								f_select("SELECT VALOR_ATUAL FROM PARAMETROS WHERE PARAMETRO  = 'ANM_FILIAL_DEST_ARMAZEM'","xFILDEST")
								f_select("SELECT VALOR_ATUAL FROM PARAMETROS WHERE PARAMETRO  = 'ANM_FILIAL_PILOTAGEM'","xFILPILOT")
							********************************************************************************************************	
							
							IF thisformset.p_tool_status == 'A'
								
								*MESSAGEBOX('Não é permitido Alterar Saída'+CHR(13)+'Tranferência de estoque já esta encerrada'+CHR(13)+'Excluir e Refazer.',64)
								*RETURN .F.									
								
								if f_vazio(V_ESTOQUE_SAI_MAT_00.cm_operacao)
									Sele V_ESTOQUE_SAI_MAT_00
									Replace cm_operacao With Thisformset.pp_anm_item_comp_cm_pilot	
								endif
									
							ENDIF	
							
							IF thisformset.p_tool_status == 'I'
								
								Sele V_ESTOQUE_SAI_MAT_00
								Replace cm_operacao With Thisformset.pp_anm_item_comp_cm_pilot
								
								***** Calcula Custos dos materiais **** Tela não esta fazendo ****								
								Sele v_estoque_sai_mat_00_materiais
								GO TOP
								Scan
									Thisformset.lx_atualiza_custo()
								EndScan	
								GO TOP 
								******************************************************************
								
								***** Passa os Parameetros para variável ***********							
								xFilial        = ALLTRIM(xFILDEP.VALOR_ATUAL) 
								*xFilialDestino = ALLTRIM(xFILDEST.VALOR_ATUAL) 
								xFilialDestino = v_estoque_sai_mat_00.FILIAL
								****************************************************
								
								******* Loop para Pilotagem **************
*!*									IF  ALLTRIM(v_estoque_sai_mat_00.FILIAL) == ALLTRIM(xFILDEST.VALOR_ATUAL)
*!*										xExec = 1
*!*									ELSE
*!*										IF ALLTRIM(v_estoque_sai_mat_00.FILIAL) == ALLTRIM(xFILPILOT.VALOR_ATUAL)
*!*											xExec = 0
*!*										ELSE
*!*											xExec = 2 	
*!*										ENDIF	
*!*									ENDIF	
								xExec = 1
								DO WHILE xExec < 2
								
								
									IF ALLTRIM(UPPER(xFilial)) <> ALLTRIM(UPPER(xFilialDestino))								
									**********************************************
									**** Insere Tabela Pai ***********************
									TEXT TO xInsertPai TEXTMERGE NOSHOW
														
										INSERT INTO ESTOQUE_SAI_MAT 
										(	REQ_MATERIAL,FILIAL,TIPO_MOVIMENTACAO,EMISSAO,CENTRO_CUSTO,SAIDA_POR_PECA,RESPONSAVEL,REQUISITANTE,DESTINO,
											NF_ENTRADA,NOME_CLIFOR,FILIAL_FATURAMENTO,SERIE_NF,NF_SAIDA,ORDEM_SERVICO,FORNECEDOR,FASE_PRODUCAO,FILIAL_DESTINO,
											REQ_MATERIAL_DESTINO,PEDIDO,OBS,NUMERO_EMBALAGEM,PESO_LIQUIDO,PESO_BRUTO,DIMENSOES_EMBALAGEM,MOEDA,CAMBIO_NA_DATA,
											DATA_DIGITACAO,NF_PENDENTE,NAO_VALIDAR_ENTRADA,SERIE_NF_ENTRADA,RATEIO_FILIAL,RATEIO_CENTRO_CUSTO,CONTA_CONTABIL,
											CM_OPERACAO,ANM_STATUS_ALMOX 
										)	VALUES
														
										(	'<<v_estoque_sai_mat_00.REQ_MATERIAL>>','<<xFilial>>','C','<<dtos(v_estoque_sai_mat_00.EMISSAO)>>',null,0,
											'<<v_estoque_sai_mat_00.RESPONSAVEL>>','<<v_estoque_sai_mat_00.REQUISITANTE>>',NULL,'','<<xFilialDestino>>',NULL,
											NULL,NULL,NULL,'','','<<xFilialDestino>>',NULL,NULL,'','<<v_estoque_sai_mat_00.NUMERO_EMBALAGEM>>',
											'<<v_estoque_sai_mat_00.PESO_LIQUIDO>>','<<v_estoque_sai_mat_00.PESO_BRUTO>>','<<v_estoque_sai_mat_00.DIMENSOES_EMBALAGEM>>',
											'R$',NULL,'<<dtos(v_estoque_sai_mat_00.DATA_DIGITACAO)>>',1,1,NULL,NULL,NULL,NULL,'012',NULL
										)
											
									ENDTEXT

									IF !f_insert(xInsertPai)
										MESSAGEBOX('Erro na movimentação automática de Estoque',64)
										RETURN .F.
									ENDIF
									**** FIM - Insere Tabela Pai ***********************
									****************************************************
									
									
									***************************************
									**** Insere Tabela Filha Materiais ****
									SELE v_estoque_sai_mat_00_materiais
									GO TOP
					
									SCAN

										TEXT TO xInsertFilha TEXTMERGE NOSHOW
															
											INSERT INTO ESTOQUE_SAI1_MAT 
											( 	REQ_MATERIAL,FILIAL,MATERIAL,COR_MATERIAL,ITEM,ORDEM_PRODUCAO,QTDE,QTDE_AUX,CUSTO,DATA_CUSTO,MATAR_SALDO_RESERVA,
												FILIAL_FATURAMENTO,SERIE_NF,NF_SAIDA,ICMS,IPI,DESCONTO_ITEM,PRECO,VALOR,FATOR_CONVERSAO_UNIDADE,UNIDADE_FATURAMENTO,
												VALOR_BRUTO,ENTREGA,PEDIDO,RESERVA_AUTOMATICA,PERDA,TRANSF_ORDEM_PRODUCAO,PRECO_SERVICO,PRECO_MATERIAL_EMPREGADO,
												OF_FATURAR,CODIGO_FISCAL_OPERACAO,ITEM_IMPRESSAO,CONTA_CONTABIL,RATEIO_FILIAL,RATEIO_CENTRO_CUSTO 
											)	VALUES
															
											(	
												'<<v_estoque_sai_mat_00.REQ_MATERIAL>>','<<xFilial>>','<<v_estoque_sai_mat_00_materiais.MATERIAL>>','<<v_estoque_sai_mat_00_materiais.COR_MATERIAL>>',
												'<<v_estoque_sai_mat_00_materiais.ITEM>>',NULL,<<v_estoque_sai_mat_00_materiais.QTDE>>+<<v_estoque_sai_mat_00_materiais.PERDA>>,
												<<v_estoque_sai_mat_00_materiais.QTDE_AUX>>,<<v_estoque_sai_mat_00_materiais.CUSTO>>,'<<dtos(v_estoque_sai_mat_00_materiais.DATA_CUSTO)>>',
												0,NULL,NULL,NULL,NULL,NULL,<<v_estoque_sai_mat_00_materiais.DESCONTO_ITEM>>,
												<<v_estoque_sai_mat_00_materiais.PRECO>>,<<v_estoque_sai_mat_00_materiais.VALOR>>,'<<v_estoque_sai_mat_00_materiais.FATOR_CONVERSAO_UNIDADE>>',
												'<<v_estoque_sai_mat_00_materiais.UNIDADE_FATURAMENTO>>',<<v_estoque_sai_mat_00_materiais.VALOR_BRUTO>>,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL				
											)
												
										ENDTEXT
									
										IF !f_insert(xInsertFilha)
											MESSAGEBOX('Erro na movimentação automática de Estoque',64)
											RETURN .F.
										ENDIF
										
										
											***********************************
											**** Insere Tabela Filha Pecas ****
											Thisformset.lx_FORM1.LX_pageframe1.Page3.SetFocus()
											Thisformset.lx_FORM1.LX_pageframe1.Page3.refresh()
											SELE v_estoque_sai_mat_00_pecas
											GO TOP
											
											SCAN
											
												TEXT TO xInsertPecas TEXTMERGE NOSHOW
																	
													INSERT INTO ESTOQUE_SAI_PECA
													(	REQ_MATERIAL,FILIAL,MATERIAL,PECA,PARTIDA,COR_MATERIAL,ITEM,QTDE,QTDE_AUX,
														PERDA,PERDA_REQ_MATERIAL,FRACIONAMENTO,PECA_ORIGINAL,PARTIDA_ORIGINAL
													) VALUES				
																					
													(	
														'<<v_estoque_sai_mat_00.REQ_MATERIAL>>','<<xFilial>>','<<v_estoque_sai_mat_00_pecas.MATERIAL>>',
														'<<v_estoque_sai_mat_00_pecas.PECA>>','<<v_estoque_sai_mat_00_pecas.PARTIDA>>','<<v_estoque_sai_mat_00_pecas.COR_MATERIAL>>',
														'<<v_estoque_sai_mat_00_pecas.ITEM>>',<<v_estoque_sai_mat_00_pecas.QTDE>>,<<v_estoque_sai_mat_00_pecas.QTDE_AUX>>,
														<<v_estoque_sai_mat_00_pecas.PERDA>>,NULL,'<<v_estoque_sai_mat_00_pecas.FRACIONAMENTO>>',NULL,NULL
													)
														
												ENDTEXT
												
												IF RECCOUNT()>0
													IF !f_insert(xInsertPecas)
														MESSAGEBOX('Erro na movimentação automática de Estoque',64)
														RETURN .F.
													ENDIF
												ENDIF

												SELE v_estoque_sai_mat_00_pecas

											ENDSCAN
											**** FIM - Insere Tabela Filha Pecas ****
											*****************************************
										
										
										SELE v_estoque_sai_mat_00_materiais

									ENDSCAN
									**** FIM - Insere Tabela Filha Materiais ****
									*********************************************
								
								
									********************************************************************************
									**** Updates necessário para executar as Trigges que movimentam o estoque ******
									TEXT TO xUpdateEnt TEXTMERGE NOSHOW
										
										
										UPDATE SEQUENCIAIS SET SEQUENCIA = RIGHT(100000000+SEQUENCIA+1,TAMANHO) WHERE TABELA_COLUNA='ESTOQUE_RET_MAT.REQ_MATERIAL' 
														
										UPDATE ESTOQUE_SAI_MAT SET REQ_MATERIAL_DESTINO = 'T'+
										(SELECT RTRIM(LTRIM(SEQUENCIA)) FROM SEQUENCIAIS WHERE TABELA_COLUNA='ESTOQUE_RET_MAT.REQ_MATERIAL') 
										WHERE REQ_MATERIAL = '<<v_estoque_sai_mat_00.REQ_MATERIAL>>' AND 
										FILIAL = '<<xFilial>>' AND FILIAL_DESTINO = '<<xFilialDestino>>'
										
										UPDATE ESTOQUE_SAI_PECA SET QTDE_AUX = 0
										WHERE REQ_MATERIAL = '<<v_estoque_sai_mat_00.REQ_MATERIAL>>' AND 
										FILIAL = '<<xFilial>>'
											
									ENDTEXT


									IF !f_update(xUpdateEnt)
										MESSAGEBOX('Erro na movimentação automática de Estoque',64)
										RETURN .F.
									ENDIF

								ENDIF
								****** Parametros pra loop de pilotagem *****
								xFilial        = ALLTRIM(xFILDEST.VALOR_ATUAL)
								xFilialDestino = ALLTRIM(xFILPILOT.VALOR_ATUAL)
								**********************************************
									
								xExec = xExec + 1
								
								ENDDO
							***** FIM - CUSTOMIZAÇÃO *****
							******************************
							ENDIF
							
													
						if !f_vazio(xalias)
							sele &xalias
						endif	
			
			
			
			
			
			case UPPER(xmetodo) == 'USR_TRIGGER_AFTER' 
				
				
				IF THISFORMSET.P_TOOL_STATUS == 'E'
			
					xalias=alias()
					
						**** Deleta as trasnferencias vinculadas na movimentação *****
						TEXT TO xDelTran TEXTMERGE NOSHOW
						
							DELETE ESTOQUE_SAI_MAT 
							WHERE REQ_MATERIAL = '<<V_ESTOQUE_SAI_MAT_00.REQ_MATERIAL>>' AND
								  FILIAL = '<<ALLTRIM(xFILDEST.VALOR_ATUAL)>>'	
							
							
							DELETE ESTOQUE_SAI_MAT 
							WHERE REQ_MATERIAL = '<<V_ESTOQUE_SAI_MAT_00.REQ_MATERIAL>>' AND
								  FILIAL = '<<ALLTRIM(xFILDEP.VALOR_ATUAL)>>'
							
						
						ENDTEXT
											
						f_update(xDelTran)
						**** FIM - Deleta as trasnferencias vinculadas na movimentação *****	
	
						TEXT TO xselex1 TEXTMERGE NOSHOW
											
							SELECT C.PEDIDO,C.MATERIAL,C.COR_MATERIAL,SUM(QTDE) AS QTDE
							FROM ESTOQUE_SAI1_MAT (NOLOCK) C
							WHERE C.PEDIDO = '<<V_ESTOQUE_SAI_MAT_00.PEDIDO>>'
							GROUP BY C.PEDIDO,C.MATERIAL,C.COR_MATERIAL
						
						ENDTEXT
						
						f_select(xselex1,"xVerifExclusao",ALIAS())
					
					SELE xVerifExclusao
					IF RECCOUNT() = 0
						
						TEXT TO xupd10 TEXTMERGE NOSHOW
											
							UPDATE A SET A.QTDE_ENTREGUE=(ISNULL(C.QTDE,0)),QTDE_RESERVADA=0,
							QTDE_ENTREGAR=(QTDE_ORIGINAL-ISNULL(C.QTDE,0)) FROM VENDAS_MATERIAL A
							LEFT JOIN (SELECT C.PEDIDO,C.MATERIAL,C.COR_MATERIAL,SUM(QTDE) AS QTDE
							FROM ESTOQUE_SAI1_MAT (NOLOCK) C
							WHERE C.PEDIDO = '<<V_ESTOQUE_SAI_MAT_00.PEDIDO>>'
							GROUP BY C.PEDIDO,C.MATERIAL,C.COR_MATERIAL) C
							ON A.MATERIAL = C.MATERIAL
							AND A.COR_MATERIAL = C.COR_MATERIAL
							AND A.PEDIDO = C.PEDIDO
							WHERE A.PEDIDO = '<<V_ESTOQUE_SAI_MAT_00.PEDIDO>>'
							
						ENDTEXT
						
						f_update(xupd10)
						
						TEXT TO xupd20 TEXTMERGE NOSHOW
						
							UPDATE A SET TOT_QTDE_ENTREGUE = ISNULL(B.QTDE_TOTAL,0),
							TOT_QTDE_ENTREGAR = (TOT_QTDE_ORIGINAL-ISNULL(B.QTDE_TOTAL,0))
							FROM VENDAS A
							LEFT JOIN (SELECT C.PEDIDO,SUM(C.QTDE) AS QTDE_TOTAL 
							FROM ESTOQUE_SAI1_MAT (NOLOCK) C
							WHERE C.PEDIDO = '<<V_ESTOQUE_SAI_MAT_00.PEDIDO>>'
							GROUP BY C.PEDIDO) B
							ON A.PEDIDO = B.PEDIDO
							WHERE A.PEDIDO = '<<V_ESTOQUE_SAI_MAT_00.PEDIDO>>'
							
						ENDTEXT
						
						f_update(xupd20)
					
					ELSE
						
						TEXT TO xupd1 TEXTMERGE NOSHOW
											
							UPDATE A SET A.QTDE_ENTREGUE=(C.QTDE),QTDE_RESERVADA=0,
							QTDE_ENTREGAR=(QTDE_ORIGINAL-C.QTDE) FROM VENDAS_MATERIAL A
							JOIN (SELECT C.PEDIDO,C.MATERIAL,C.COR_MATERIAL,SUM(QTDE) AS QTDE
							FROM ESTOQUE_SAI1_MAT (NOLOCK) C
							WHERE C.PEDIDO = '<<V_ESTOQUE_SAI_MAT_00.PEDIDO>>'
							GROUP BY C.PEDIDO,C.MATERIAL,C.COR_MATERIAL) C
							ON A.MATERIAL = C.MATERIAL
							AND A.COR_MATERIAL = C.COR_MATERIAL
							AND A.PEDIDO = C.PEDIDO
						
						ENDTEXT
						
						f_update(xupd1)
						
						TEXT TO xupd2 TEXTMERGE NOSHOW
						
							UPDATE A SET TOT_QTDE_ENTREGUE = B.QTDE_TOTAL,TOT_QTDE_ENTREGAR = (TOT_QTDE_ORIGINAL -B.QTDE_TOTAL)
							FROM VENDAS A
							JOIN (SELECT C.PEDIDO,SUM(C.QTDE) AS QTDE_TOTAL 
							FROM ESTOQUE_SAI1_MAT (NOLOCK) C
							WHERE C.PEDIDO = '<<V_ESTOQUE_SAI_MAT_00.PEDIDO>>'
							GROUP BY C.PEDIDO) B
							ON A.PEDIDO = B.PEDIDO
						
						ENDTEXT
						
						f_update(xupd2)
						
					ENDIF	
					
					
					
						TEXT TO xsel1 TEXTMERGE NOSHOW
						
							SELECT 1 AS FINALIZADO FROM VENDAS (NOLOCK)
							WHERE PEDIDO = '<<V_ESTOQUE_SAI_MAT_00.PEDIDO>>'
							AND TOT_QTDE_ENTREGAR <= 0
						
						ENDTEXT
						
						f_select(xsel1,"xVerifFin",ALIAS())
						
						SELE xVerifFin
						IF RECCOUNT() = 0
							
							TEXT TO xupd3 TEXTMERGE NOSHOW
							
								UPDATE VENDAS SET STATUS = 'A'
								WHERE PEDIDO = '<<V_ESTOQUE_SAI_MAT_00.PEDIDO>>'
							
							ENDTEXT
							
							f_update(xupd3)
							
						ENDIF	
					
					if !f_vazio(xalias)
						sele &xalias
					endif
				
				ENDIF
			
			
			otherwise
				return .t.				
		endcase
	endproc
ENDDEFINE


**************************************************
*-- Class:        lb_data_coletado (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_data_coletado AS lx_label


	Caption = ""
	Height = 15
	Left = 360
	Top = 100
	Width = 20
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	Name = "lb_data_coletado"
	Visible = .F.
	Anchor = 0
	Fontbold=.t.


ENDDEFINE
*
*-- EndDefine: lb_data_coletado 
**************************************************


**************************************************
*-- Class:        lb_status_entrada (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_status_entrada AS lx_label


	Caption = "Status Saida"
	Height = 15
	Left = 200
	Top = 100
	Width = 22
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	Name = "lb_status_entrada"
	Visible = .t.
	Anchor = 0

	PROCEDURE DblClick	
		

		If thisformset.p_tool_status="P" and (v_estoque_sai_mat_00.anm_status_almox <>"2-COLETADO" or f_vazio(v_estoque_sai_mat_00.anm_status_almox))  
			if messagebox("Deseja Alterar o Status da Saida de Material?",4+32+256,"Atenção!")=6	
				thisformset.lx_form1.cmb_status_entrada.enabled=.T.
			endif	
		Endif

	ENDPROC 

ENDDEFINE
*
*-- EndDefine: lb_status_entrada 
**************************************************



**************************************************
*-- Class:        cmb_status_entrada (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_status_entrada AS lx_combobox


	RowSource = ""
	ControlSource = ""
	Height = 22
	Left = 225
	TabIndex = 1
	Top = 96
	Width = 147
	ZOrderSet = 5
	Name = "cmb_status_entrada"
	Visible = .t.
	Enabled = .t.
	Anchor = 0

	PROCEDURE Valid	
	
	IF THISFORMSET.P_TOOL_STATUS="P"

		If v_estoque_sai_mat_00.anm_status_almox="2-COLETADO" 
			
			*text to xselUser noshow textmerge	
			*	SELECT * FROM PROPRIEDADE_VALIDA 
			*	WHERE PROPRIEDADE='00058' 
			*	AND LTRIM(RTRIM(VALOR_PROPRIEDADE))= '<<WUSUARIO>>'
			*endtext	
			
			*f_select(xselUser,"curUserFimOs",alias())
			
			*if f_vazio(curUserFimOs.valor_propriedade)
			*	messagebox("Você Não tem Permissão para Marcar esta OS como Recebido no Almoxarifado",48,"Atenção!!!")
			*	retu .f.	
			*endif	
			
			if messagebox("Deseja Marcar esta Saida como Coletada?",4+32+256,"Atenção!")=6	


				xreq_material=v_estoque_sai_mat_00.req_material
				xfilial      =v_estoque_sai_mat_00.filial
				*REQ_MATERIAL,FILIAL,ANM_STATUS_ALMOX,DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP
				text to	xinsert1 noshow textmerge	

					UPDATE ESTOQUE_SAI_MAT SET ANM_STATUS_ALMOX='2-COLETADO'	
					WHERE req_material='<<xreq_material>>'  
					and   filial='<<xfilial>>'
				
					INSERT INTO ANM_STATUS_SAI_MAT_MOV
					(REQ_MATERIAL,FILIAL,ANM_STATUS_ALMOX,
					DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP)
					SELECT 
					'<<xreq_material>>','<<xfilial>>',
					'<<v_estoque_sai_mat_00.ANM_STATUS_ALMOX>>','<<DTOS(WDATA)>>','<<WUSUARIO>>','<<SYSTEM.NetUserName>>',
					'<<SYSTEM.NetComputerName>>',(SELECT GETDATE())
					where '<<xreq_material>>'+'<<xfilial>>'+'<<v_estoque_sai_mat_00.ANM_STATUS_ALMOX>>' 
					not in 
					(select  req_material+filial+anm_status_ALMOX
					 from ANM_STATUS_SAI_MAT_MOV)	

				endtext


				if !f_insert(xinsert1) 
					messagebox("Não foi possível Alterar o Status da Saida de Material",48,"Atenção_8!")
					retu .f.
				endif

				o_toolbar.Botao_refresh.Click()

			endif
						
		
		Else
		
			
			if messagebox("Deseja Alterar o Status desta Saida de Material para "+chr(13)+allt(v_estoque_sai_mat_00.anm_status_almox)+" ?",4+32+256,"Atenção!")=6
			

				xreq_material=v_estoque_sai_mat_00.req_material
				xfilial      =v_estoque_sai_mat_00.filial
				*REQ_MATERIAL,FILIAL,ANM_STATUS_ALMOX,DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP
				text to	xinsert1 noshow textmerge	

					UPDATE ESTOQUE_SAI_MAT SET ANM_STATUS_ALMOX='<<v_estoque_sai_mat_00.anm_status_almox>>'
					WHERE req_material='<<xreq_material>>'  
					and   filial='<<xfilial>>'
									
					INSERT INTO ANM_STATUS_SAI_MAT_MOV
					(REQ_MATERIAL,FILIAL,ANM_STATUS_ALMOX,
					DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP)
					SELECT 
					'<<xreq_material>>','<<xfilial>>',
					'<<v_estoque_sai_mat_00.ANM_STATUS_ALMOX>>','<<DTOS(WDATA)>>','<<WUSUARIO>>','<<SYSTEM.NetUserName>>',
					'<<SYSTEM.NetComputerName>>',(SELECT GETDATE())
					where '<<xreq_material>>'+'<<xfilial>>'+'<<v_estoque_sai_mat_00.ANM_STATUS_ALMOX>>' 
					not in 
					(select  req_material+filial+anm_status_ALMOX
					 from ANM_STATUS_SAI_MAT_MOV)	

				endtext	
				
				
				if !f_insert(xinsert1) 
					messagebox("Não foi possível Alterar o Status da Saida de Material",48,"Atenção_8!")
					retu .f.
				endif

				o_toolbar.Botao_refresh.Click()
							
			endif	
	
		Endif	
	
	ENDIF 
	
	ENDPROC 
	

ENDDEFINE

*
*-- EndDefine: cmb_status_entrada
**************************************************
