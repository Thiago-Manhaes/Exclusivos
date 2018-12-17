* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  26/02/2009                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Ajuste layout propriedades clientes varejo					                    *
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

		* =messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

			do case				
					
					
					case upper(xmetodo) == 'USR_TRIGGER_BEFORE' 
					
						xalias=alias()
							

							*** Busca Paramêtros ***********************************************************************************
								f_select("SELECT DBO.FX_ANM_PARAMETRO_USER('ANM_FILIAL_ARMAZEM') AS VALOR_ATUAL","xFILDEP") 
								f_select("SELECT DBO.FX_ANM_PARAMETRO_USER('ANM_FILIAL_DEST_ARMAZEM') AS VALOR_ATUAL","xFILDEST")
								f_select("SELECT DBO.FX_ANM_PARAMETRO_USER('ANM_FILIAL_PILOTAGEM') AS VALOR_ATUAL","xFILPILOT")
							********************************************************************************************************	
							
							IF thisformset.p_tool_status == 'A'
								
								MESSAGEBOX('Não é permitido Alterar Saída'+CHR(13)+'Tranferência de estoque já esta encerrada'+CHR(13)+'Excluir e Refazer.',64)
								RETURN .F.
									
							ENDIF	
							
							IF thisformset.p_tool_status == 'I'
								
								
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
								xFilialDestino = ALLTRIM(xFILDEST.VALOR_ATUAL) 
								****************************************************
								
								******* Loop para Pilotagem **************
								IF  ALLTRIM(v_estoque_sai_mat_00.FILIAL) == ALLTRIM(xFILDEST.VALOR_ATUAL)
									xExec = 1
								ELSE
									IF ALLTRIM(v_estoque_sai_mat_00.FILIAL) == ALLTRIM(xFILPILOT.VALOR_ATUAL)
										xExec = 0
									ELSE
										xExec = 2 	
									ENDIF	
								ENDIF	
								
								DO WHILE xExec < 2
								
								*** INCLUI ESSA CLAUSULA ABAIXO --- 26-01-2015 ***
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
											'R$',NULL,'<<dtos(v_estoque_sai_mat_00.DATA_DIGITACAO)>>',1,1,NULL,NULL,NULL,NULL,NULL,NULL
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
					
				  xalias=alias()				
					
					IF THISFORMSET.P_TOOL_STATUS == 'E'
				
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
			
				   ENDIF
				
				if !f_vazio(xalias)
					sele &xalias
				endif			
					
					
								
																
				otherwise
				return .t.				
			endcase

	endproc


ENDDEFINE
